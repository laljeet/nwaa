#' Build query parameters for the NWAA data endpoint
#'
#' Internal helper used by the family wrappers. Constructs a named list of
#' query parameters that gets passed to \code{httr2::req_url_query()}.
#' Multiple variables are comma-collapsed because the NWAA API accepts them
#' as a single \code{variable=a,b,c} parameter.
#'
#' @param model Model ID.
#' @param variables One or more variable IDs.
#' @param location Location string like \code{"countycd:06029"}.
#' @param format Output format: \code{"csv"}, \code{"json"}, or \code{"geojson"}.
#' @param ... Additional query parameters accepted by the API.
#'
#' @return A named list of query parameters.
#'
#' @keywords internal
#' @noRd
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
