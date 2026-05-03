#' US state codes
#'
#' Convenience tibble of US state names and 2-letter abbreviations, sourced
#' from the base R \code{datasets::state.name} and \code{datasets::state.abb}
#' vectors.
#'
#' @return A tibble with columns \code{state_name} and \code{state_abbr}.
#' @export
#' @examples
#' nwaa_state_codes()
nwaa_state_codes <- function() {
  tibble::tibble(
    state_name = datasets::state.name,
    state_abbr = datasets::state.abb
  )
}

#' Help for finding HUC, state, and county codes
#'
#' Returns a small reference tibble pointing to USGS resources where
#' identifiers used by the NWAA API can be looked up.
#'
#' @return A tibble with columns \code{item}, \code{where}, and \code{link}.
#' @export
#' @examples
#' nwaa_code_help()
nwaa_code_help <- function() {
  tibble::tibble(
    item = c("HUC codes", "State and county dropdowns"),
    where = c(
      "Use USGS hydrologic units resources and map viewers to identify HUC codes.",
      "Use the NWAA Subset and Download Tool dropdowns to confirm codes used by the API."
    ),
    link = c(
      "https://water.usgs.gov/themes/hydrologic-units",
      "https://water.usgs.gov/nwaa-data/subset-download"
    )
  )
}
