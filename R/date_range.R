#' Resolve date range for a model
#'
#' Returns the start and end date strings to send to the NWAA API for a given
#' model and date-range mode. Used internally by \code{\link{nwaa_water_use}}
#' and \code{\link{nwaa_data}}; can also be called directly to inspect what
#' dates a request would use.
#'
#' @param model_id Water Use model id. See \code{\link{nwaa_wu_models}}.
#' @param range One of \code{"recent"}, \code{"historical"}, or \code{"custom"}.
#'   \itemize{
#'     \item \code{"recent"}: returns the model's most recent timepoint.
#'     \item \code{"historical"}: returns the full available period.
#'     \item \code{"custom"}: returns \code{start} and \code{end} as supplied.
#'   }
#' @param temporal Temporal resolution: \code{"monthly"}, \code{"annualwy"},
#'   or \code{"annualcy"}.
#' @param start Optional custom start. Monthly \code{"YYYY-MM"},
#'   annual \code{"YYYY"}. Used only when \code{range = "custom"}.
#' @param end Optional custom end. Same format as \code{start}. Used only when
#'   \code{range = "custom"}.
#'
#' @return A named list with elements \code{startDate} and \code{endDate}.
#'
#' @examples
#' nwaa_resolve_range("wu-irrigation-wd", range = "historical",
#'                    temporal = "annualwy")
#' nwaa_resolve_range("wu-irrigation-wd", range = "recent",
#'                    temporal = "monthly")
#' nwaa_resolve_range("wu-irrigation-wd", range = "custom",
#'                    temporal = "annualwy",
#'                    start = "2010", end = "2020")
#' @export
nwaa_resolve_range <- function(model_id,
                               range = c("recent", "historical", "custom"),
                               temporal = "monthly",
                               start = NULL,
                               end = NULL) {
  range <- match.arg(range)

  cat <- nwaa_catalog()
  row <- cat[cat$model_id == model_id, , drop = FALSE]
  if (nrow(row) != 1) {
    rlang::abort(
      paste0(
        "Unknown model_id: '", model_id, "'. ",
        "See nwaa_catalog() for all available models, ",
        "or nwaa_wu_models() for Water Use models specifically."
      )
    )
  }

  # Warn if user supplied start/end but they will be ignored.
  if (range != "custom" && (!is.null(start) || !is.null(end))) {
    rlang::warn(
      paste0(
        "start/end were supplied but range = '", range, "', so they are ignored. ",
        "Use range = 'custom' to apply them."
      )
    )
  }

  start_ym <- row$start_ym[[1]]
  end_ym <- row$end_ym[[1]]

  is_annual <- temporal %in% c("annualwy", "annualcy")

  if (is_annual) {
    start_year <- substr(start_ym, 1, 4)
    end_year <- substr(end_ym, 1, 4)

    # For water year, if the catalog start month falls in Oct-Dec, the first
    # full water year starts the following calendar year.
    if (temporal == "annualwy") {
      start_month <- as.integer(substr(start_ym, 6, 7))
      if (!is.na(start_month) && start_month <= 9) {
        start_year <- as.character(as.integer(start_year) + 1)
      }
    }

    if (range == "historical") return(list(startDate = start_year, endDate = end_year))
    if (range == "recent") return(list(startDate = end_year, endDate = end_year))
  } else {
    if (range == "historical") return(list(startDate = start_ym, endDate = end_ym))
    if (range == "recent") return(list(startDate = end_ym, endDate = end_ym))
  }

  # range == "custom"
  if (is.null(start) || is.null(end)) {
    rlang::abort("For range = 'custom', provide both start and end.")
  }

  list(startDate = start, endDate = end)
}
