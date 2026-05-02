#' State abbreviations for use with location_type = "statecd"
#'
#' The NWAA API uses lowercase 2-letter state abbreviations
#' (example: \code{"ca"}, \code{"al"}). This helper returns a lookup
#' between full state names and the lowercase abbreviation expected by
#' the API.
#'
#' @return A tibble with columns \code{state_name} and \code{statecd}.
#' @export
#' @examples
#' nwaa_statecd()
nwaa_statecd <- function() {
  tibble::tibble(
    state_name = datasets::state.name,
    statecd = tolower(datasets::state.abb)
  )
}
