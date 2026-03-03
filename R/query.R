#' Build query parameters for NWAA data endpoint
#'
#' @param model Model ID.
#' @param variables One or more variable IDs.
#' @param location Location string like "countycd:06029".
#' @param format Output format: "csv", "json", or "geojson".
#' @param ... Additional query parameters accepted by the API.
#' @return Named list of query parameters.
#' @export
nwaa_build_query <- function(model, variables, location,
                             format = c("csv", "json", "geojson"),
                             ...) {
  format <- match.arg(format)

  model <- trimws(as.character(model))
  if (model == "") rlang::abort("model must be non-empty.")

  variables <- trimws(as.character(variables))
  variables <- variables[variables != ""]
  if (length(variables) < 1) rlang::abort("Provide at least one variable ID.")

  location <- trimws(as.character(location))
  if (location == "") rlang::abort("location must be non-empty, like 'countycd:06029'.")

  q <- list(
    model = model,
    location = location,
    format = format,
    variable = paste(variables, collapse = ",")
  )

  extras <- list(...)
  if (length(extras) > 0) {
    extras <- extras[!vapply(extras, is.null, logical(1))]
    q <- c(q, extras)
  }

  q
}
