#' State abbreviations for use with location_type = "statecd"
#'
#' The NWAA API uses lowercase 2-letter state abbreviations (example: "ca", "al").
#'
#' @return A tibble with \code{state_name} and \code{statecd}.
#' @export
#' @examples
#' nwaa_statecd()
nwaa_statecd <- function() {
  tibble::tibble(
    state_name = state.name,
    statecd = tolower(state.abb)
  )
}
