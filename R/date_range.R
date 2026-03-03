#' Resolve date range for a model
#'
#' @param model_id Water Use model id.
#' @param range "recent", "historical", or "custom".
#' @param temporal "monthly", "annualwy", or "annualcy".
#' @param start Optional custom start (monthly "YYYY-MM", annual "YYYY").
#' @param end Optional custom end (monthly "YYYY-MM", annual "YYYY").
#' @export
nwaa_resolve_range <- function(model_id,
                               range = c("recent", "historical", "custom"),
                               temporal = "monthly",
                               start = NULL,
                               end = NULL) {
  range <- match.arg(range)

  cat <- nwaa_wu_catalog()
  row <- cat[cat$model_id == model_id, , drop = FALSE]
  if (nrow(row) != 1) rlang::abort("Unknown model_id. Use nwaa_wu_models().")

  start_ym <- row$start_ym[[1]]
  end_ym <- row$end_ym[[1]]

  is_annual <- temporal %in% c("annualwy", "annualcy")

  if (is_annual) {
    start_year <- substr(start_ym, 1, 4)
    end_year <- substr(end_ym, 1, 4)

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

  if (is.null(start) || is.null(end)) {
    rlang::abort("For range = 'custom', provide start and end.")
  }

  list(startDate = start, endDate = end)
}
