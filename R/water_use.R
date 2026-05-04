#' Internal dispatcher used by all family wrappers.
#'
#' Wraps the common pipeline:
#' validate -> check optional dependencies -> build location -> resolve dates ->
#' build query -> fetch.
#'
#' @keywords internal
#' @noRd
nwaa_dispatch_ <- function(model_id,
                           variable_ids,
                           location_type,
                           location_id,
                           time_res,
                           range,
                           start,
                           end,
                           intersection,
                           skip,
                           format,
                           quiet,
                           expected_family) {
  nwaa_validate_request_(
    model_id = model_id,
    variable_ids = variable_ids,
    time_res = time_res,
    expected_family = expected_family
  )

  # Fail fast on optional dependencies before making any network call.
  # The 'sf' package is only required for format = "geojson" parsing, and
  # is declared in Suggests so users who do not need spatial output do not
  # incur the install cost. Catching the missing dependency here, before
  # the HTTP request, saves the user time and saves a round trip to USGS.
  if (identical(format, "geojson") && !requireNamespace("sf", quietly = TRUE)) {
    rlang::abort(
      paste0(
        "format = \"geojson\" requires the 'sf' package. ",
        "Install it with install.packages(\"sf\") and try again, ",
        "or use format = \"csv\" or format = \"json\"."
      )
    )
  }

  loc <- nwaa_location(location_type, location_id, validate = TRUE)

  dr <- nwaa_resolve_range(
    model_id = model_id,
    range = range,
    temporal = time_res,
    start = start,
    end = end
  )

  q <- nwaa_build_query(
    model = model_id,
    variables = variable_ids,
    location = loc,
    format = format,
    timeRes = time_res,
    startDate = dr$startDate,
    endDate = dr$endDate,
    intersection = intersection,
    skip = skip
  )

  nwaa_get_data(q, quiet = quiet)
}


#' Download Water Use model output from the NWAA Data Companion
#'
#' Convenience wrapper for the Water Use (\code{wu}) family of NWAA models.
#' Validates that \code{model_id}, \code{variable_ids}, and \code{time_res}
#' are valid for this family before sending the request. County and state
#' extents act as polygon selectors and return results at HUC12 resolution.
#'
#' Learn options inside the package:
#' \itemize{
#'   \item Models: \code{\link{nwaa_wu_models}}
#'   \item Variables by model: \code{\link{nwaa_wu_variables}}
#'   \item Location types: \code{\link{nwaa_location_types}}
#' }
#'
#' Official tool that generates valid URLs:
#' \href{https://water.usgs.gov/nwaa-data/subset-download}{NWAA Subset and Download Tool}
#'
#' @param model_id Water Use model ID. See \code{\link{nwaa_wu_models}}.
#' @param variable_ids One or more variable IDs from the selected model.
#'   See \code{\link{nwaa_wu_variables}}.
#' @param location_type Location type used by the API.
#'   See \code{\link{nwaa_location_types}}.
#' @param location_id Identifier for the selected \code{location_type}
#'   (HUC code, lowercase 2-letter state abbreviation, or 5-digit county code).
#' @param time_res Temporal resolution: \code{"monthly"}, \code{"annualwy"}
#'   (water year), or \code{"annualcy"} (calendar year).
#' @param range Date-range mode: \code{"recent"}, \code{"historical"},
#'   or \code{"custom"}.
#' @param start,end For \code{range = "custom"} only.
#'   Monthly uses \code{"YYYY-MM"} and annual uses \code{"YYYY"}.
#' @param intersection Optional. Controls how polygon selectors include HUC12s
#'   when \code{location_type} is \code{"statecd"} or \code{"countycd"}.
#'   See \code{\link{nwaa_intersection_types}}.
#' @param skip Record offset for paging. Default \code{0}.
#' @param format Output format: \code{"csv"}, \code{"json"}, or \code{"geojson"}.
#'   GeoJSON output requires the \code{sf} package.
#' @param quiet If \code{FALSE}, prints the request URL and response content type.
#'
#' @return Parsed data. For \code{format = "csv"}, a tibble. For
#'   \code{format = "json"}, a list. For \code{format = "geojson"}, an
#'   \code{sf} object.
#'
#' @examples
#' # Discover models and variables (offline)
#' nwaa_wu_models()
#' nwaa_wu_variables("wu-irrigation-wd")
#'
#' \dontrun{
#' # County selector, annual water-year, custom range
#' df <- nwaa_water_use(
#'   model_id = "wu-irrigation-wd",
#'   variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
#'   location_type = "countycd",
#'   location_id = "06029",
#'   time_res = "annualwy",
#'   range = "custom",
#'   start = "2001",
#'   end = "2020",
#'   intersection = "overlap",
#'   format = "csv",
#'   quiet = FALSE
#' )
#'
#' # HUC12 selector, most recent timepoint
#' df_recent <- nwaa_water_use(
#'   model_id = "wu-irrigation-wd",
#'   variable_ids = "irrwdtot",
#'   location_type = "huc12",
#'   location_id = "180300010602",
#'   time_res = "annualwy",
#'   range = "recent",
#'   format = "csv"
#' )
#'
#' # Stricter polygon selection
#' df_envelop <- nwaa_water_use(
#'   model_id = "wu-irrigation-wd",
#'   variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
#'   location_type = "countycd",
#'   location_id = "06029",
#'   time_res = "annualwy",
#'   range = "custom",
#'   start = "2001",
#'   end = "2020",
#'   intersection = "envelop",
#'   format = "csv"
#' )
#' }
#'
#' @seealso \code{\link{nwaa_wu_models}}, \code{\link{nwaa_wu_variables}},
#'   \code{\link{nwaa_atmos}}, \code{\link{nwaa_hydro}}, \code{\link{nwaa_iwa}}
#' @export
nwaa_water_use <- function(model_id,
                           variable_ids,
                           location_type,
                           location_id,
                           time_res = "monthly",
                           range = c("recent", "historical", "custom"),
                           start = NULL,
                           end = NULL,
                           intersection = NULL,
                           skip = 0,
                           format = "csv",
                           quiet = TRUE) {
  range <- match.arg(range)
  nwaa_dispatch_(
    model_id = model_id,
    variable_ids = variable_ids,
    location_type = location_type,
    location_id = location_id,
    time_res = time_res,
    range = range,
    start = start,
    end = end,
    intersection = intersection,
    skip = skip,
    format = format,
    quiet = quiet,
    expected_family = "wu"
  )
}
