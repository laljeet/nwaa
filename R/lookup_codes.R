#' Get US state codes (simple built-in mapping)
#'
#' @return A tibble with state name, abbreviation, and a best-effort FIPS-like code.
#' @export
#' @examples
#' nwaa_state_codes()
nwaa_state_codes <- function() {
  tibble::tibble(
    state_name = state.name,
    state_abbr = state.abb
  )
}

#' Help for finding HUC, state, and county codes
#'
#' @export
#' @examples
#' nwaa_code_help()
nwaa_code_help <- function() {
  tibble::tibble(
    item = c("HUC codes", "State and county dropdowns"),
    where = c(
      "Use USGS hydrologic units resources and map viewers to identify HUC codes.",
      "Use the NWAA Subset & Download Tool dropdowns to confirm codes used by the API."
    ),
    link = c(
      "https://water.usgs.gov/themes/hydrologic-units/#national-water-availability-assessment-snapshot",
      "https://water.usgs.gov/nwaa-data/subset/"
    )
  )
}
