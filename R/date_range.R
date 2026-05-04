#' Resolve date range for a model
#'
#' Returns the start and end date strings to send to the NWAA API for a given
#' model and date-range mode. Used internally by the family wrappers
#' (\code{\link{nwaa_water_use}}, \code{\link{nwaa_atmos}},
#' \code{\link{nwaa_hydro}}, \code{\link{nwaa_iwa}}). Can be called directly
#' to inspect what dates a request would use.
#'
#' @section Water year convention:
#' USGS Water Years run from October 1 of one calendar year through
#' September 30 of the following calendar year, and are labeled by their
#' ending calendar year. Water Year 2020 covers October 1, 2019 through
#' September 30, 2020.
#'
#' For a catalog start month of October through December, the catalog start
#' is the first day of WY (start_year + 1). For January through September,
#' the catalog start lies inside WY start_year and the next clean water
#' year begins the following October, also labeled WY (start_year + 1).
#' Either way, the first complete water year in the data is labeled
#' \code{start_year + 1}.
#'
#' For the end of the catalog window, a clean water year ends on September
#' 30. If the catalog end month is September the last complete WY is
#' end_year. Otherwise end_year is partial and the last complete WY is
#' \code{end_year - 1}.
#'
#' @param model_id Any model id from \code{\link{nwaa_catalog}}.
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
        "See nwaa_catalog() for all available models."
      )
    )
  }

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

  if (range == "custom") {
    if (is.null(start) || is.null(end)) {
      rlang::abort("For range = 'custom', provide both start and end.")
    }
    return(list(startDate = start, endDate = end))
  }

  is_annual <- temporal %in% c("annualwy", "annualcy")

  if (!is_annual) {
    # Monthly: use the catalog's YYYY-MM bounds directly.
    if (range == "historical") {
      return(list(startDate = start_ym, endDate = end_ym))
    }
    # range == "recent"
    return(list(startDate = end_ym, endDate = end_ym))
  }

  # Annual paths from here down.
  start_year <- as.integer(substr(start_ym, 1, 4))
  end_year <- as.integer(substr(end_ym, 1, 4))
  start_month <- as.integer(substr(start_ym, 6, 7))
  end_month <- as.integer(substr(end_ym, 6, 7))

  if (temporal == "annualwy") {
    # First complete water year is always start_year + 1, regardless of
    # whether the catalog starts in Oct-Dec (clean WY boundary) or Jan-Sep
    # (mid-WY). The label of a water year is its ending calendar year.
    first_year <- start_year + 1L

    # Last complete water year ends Sep 30. If end_month is September the
    # last complete WY is end_year. Otherwise WY end_year is partial.
    last_year <- if (!is.na(end_month) && end_month >= 9) end_year else end_year - 1L
  } else {
    # annualcy: first complete calendar year is start_year only if catalog
    # starts in January, else start_year + 1. Last complete calendar year
    # is end_year only if catalog ends in December, else end_year - 1.
    first_year <- if (!is.na(start_month) && start_month == 1L) start_year else start_year + 1L
    last_year <- if (!is.na(end_month) && end_month == 12L) end_year else end_year - 1L
  }

  if (last_year < first_year) {
    rlang::abort(
      paste0(
        "Model '", model_id, "' has no complete ",
        if (temporal == "annualwy") "water year" else "calendar year",
        " in its catalog window (", start_ym, " to ", end_ym, ")."
      )
    )
  }

  if (range == "historical") {
    return(list(startDate = as.character(first_year),
                endDate = as.character(last_year)))
  }
  # range == "recent"
  list(startDate = as.character(last_year),
       endDate = as.character(last_year))
}
