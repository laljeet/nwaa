#' List valid location types used by the NWAA API
#'
#' Returns the set of \code{location_type} values accepted by the API,
#' along with brief usage notes. The API returns HUC12 results for any
#' selector; HUC2 through HUC12 act as polygon containers, and
#' \code{statecd} and \code{countycd} also act as polygon containers
#' (use the \code{intersection} argument to control inclusion).
#'
#' @return A tibble with columns \code{type} and \code{notes}.
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
      "State abbreviation (2-letter), lowercase in the API (example: 'ca', 'al'). Use intersection to control which HUC12s are included.",
      "County code (5-digit FIPS). Use intersection to control which HUC12s are included."
    )
  )
}

#' Build an NWAA location string
#'
#' Internal helper used by the family wrappers. Combines a location type
#' and identifier into the \code{"type:id"} format the API expects.
#'
#' @param type Location type. See \code{\link{nwaa_location_types}}.
#' @param id Location identifier for that type.
#' @param validate If \code{TRUE}, checks \code{type} against
#'   \code{\link{nwaa_location_types}}.
#'
#' @return A string of the form \code{"type:id"}.
#'
#' @keywords internal
#' @noRd
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
