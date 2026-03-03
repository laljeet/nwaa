#' List valid location types used by the NWAA API
#'
#' @return A tibble of location types and notes.
#' @export
#' @examples
#' nwaa_location_types()
nwaa_location_types <- function() {
  tibble::tibble(
    type = c("huc2", "huc4", "huc6", "huc8", "huc10", "huc12", "statecd", "countycd"),
    notes = c(
      "Hydrologic unit code (2 digits). Returns HUC12 results within this HUC.",
      "Hydrologic unit code (4 digits). Returns HUC12 results within this HUC.",
      "Hydrologic unit code (6 digits). Returns HUC12 results within this HUC.",
      "Hydrologic unit code (8 digits). Returns HUC12 results within this HUC.",
      "Hydrologic unit code (10 digits). Returns HUC12 results within this HUC.",
      "Hydrologic unit code (12 digits). Returns results for this HUC12.",
      "State abbreviation (2-letter), lowercase in the API (example: 'ca', 'al').Use intersection to control which HUC12s get included.",
      "County code (5-digit). Use intersection to control which HUC12s get included."
    )
  )
}

#' Build an NWAA location string
#'
#' @param type Location type used by NWAA, see nwaa_location_types().
#' @param id Location identifier for that type.
#' @param validate If TRUE, checks type against nwaa_location_types().
#' @return A string like "type:id".
#' @export
nwaa_location <- function(type, id, validate = TRUE) {
  type <- tolower(trimws(as.character(type)))
  id <- trimws(as.character(id))

  if (type == "" || id == "") {
    rlang::abort("type and id must be non-empty.")
  }

  if (isTRUE(validate)) {
    allowed <- nwaa_location_types()$type
    if (!type %in% allowed) {
      rlang::abort(
        paste0(
          "Unsupported location type: '", type, "'. ",
          "Run nwaa_location_types() to see supported values."
        )
      )
    }
  }

  paste0(type, ":", id)
}
