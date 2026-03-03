#' Intersection types for polygon selectors
#'
#' Used when \code{location_type} selects a polygon extent (example: \code{"statecd"} or
#' \code{"countycd"}). The API returns HUC12s, and \code{intersection} controls which
#' HUC12s count as "inside".
#'
#' @return A tibble with intersection codes and meanings.
#' @export
#' @examples
#' nwaa_intersection_types()
nwaa_intersection_types <- function() {
  tibble::tibble(
    intersection = c("overlap", "envelop"),
    meaning = c(
      "Include all HUC12s that have any part within the boundary.",
      "Include only HUC12s that are at least 98% within the boundary."
    )
  )
}
