#' Download Water Use model output from the NWAA Data Companion
#'
#' This function calls the NWAA Data Companion web service and returns model output.
#' County and state extents act as selectors and return results at HUC12 resolution.
#'
#' Learn options inside the package:
#' - Models: \code{\link{nwaa_wu_models}}
#' - Variables by model: \code{\link{nwaa_wu_variables}}
#' - Location types: \code{\link{nwaa_location_types}}
#'
#' Official tool that generates valid URLs:
#' \href{https://water.usgs.gov/nwaa-data/subset/}{NWAA Subset \& Download Tool}
#'
#' @param model_id Water Use model ID.
#'   Use \code{\link{nwaa_wu_models}} to list available models and their valid date ranges.
#'
#' @param variable_ids One or more variable IDs from the selected model.
#'   Use \code{\link{nwaa_wu_variables}} to list valid variables for a given \code{model_id}.
#'
#' @param location_type Location type used by the API.
#'   Use \code{\link{nwaa_location_types}} to see valid values.
#'   Examples include \code{"huc12"} and \code{"countycd"}.
#'
#' @param location_id Identifier for the selected \code{location_type}.
#'   Common patterns:
#'   \itemize{
#'     \item \code{huc2}, \code{huc4}, ..., \code{huc12}: the HUC code with that number of digits.
#'     \item \code{statecd}: 2-letter state abbreviation (example: \code{"ca"} for California, \code{"al"} for Alabama).
#'     \item \code{countycd}: a 5-digit county code like \code{"06029"}.
#'   }
#'   See \code{\link{nwaa_location_types}} for all supported types.
#'   For HUC codes, use the USGS Hydrologic Units resources:
#'   \href{https://water.usgs.gov/themes/hydrologic-units/#national-water-availability-assessment-snapshot}{USGS hydrologic units page}.
#'
#' @param time_res Temporal resolution used by the API:
#'   \itemize{
#'     \item \code{"monthly"} expects \code{start} and \code{end} like \code{"2020-12"}.
#'     \item \code{"annualwy"} (water year) expects \code{start} and \code{end} like \code{"2020"}.
#'     \item \code{"annualcy"} (calendar year) expects \code{start} and \code{end} like \code{"2020"}.
#'   }
#'
#' @param range Date-range mode:
#'   \itemize{
#'     \item \code{"recent"} uses the model's most recent timepoint.
#'     \item \code{"historical"} uses the model's full available period.
#'     \item \code{"custom"} uses \code{start} and \code{end}.
#'   }
#'
#' @param start For \code{range = "custom"}.
#'   Monthly uses \code{"YYYY-MM"} and annual uses \code{"YYYY"}.
#'
#' @param end For \code{range = "custom"}.
#'   Monthly uses \code{"YYYY-MM"} and annual uses \code{"YYYY"}.
#'
#' @param intersection Optional. Controls how polygon selectors include HUC12s when
#'   \code{location_type} is \code{"statecd"} or \code{"countycd"}.
#'   \itemize{
#'     \item \code{"overlap"}: include any HUC12 that overlaps the polygon (more inclusive).
#'     \item \code{"envelop"}: include only HUC12s that are at least 98% within the polygon (more strict).
#'   }
#'   See \code{\link{nwaa_intersection_types}}.
#'
#' @param skip Record offset for paging. Default \code{0}.
#'
#' @param format Output format: \code{"csv"}, \code{"json"}, or \code{"geojson"}.
#'
#' @param quiet If \code{FALSE}, prints the request URL and response content type.
#'
#' @return Parsed data. For \code{format = "csv"}, this returns a tibble.
#'
#' @examples
#' # Discover models and variables
#' nwaa_wu_models()
#' nwaa_wu_variables("wu-irrigation-wd")
#'
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
#' # HUC12 selector, annual water-year, most recent timepoint
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
#' #' # Same query, stricter polygon selection
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
#'
#' @seealso \code{\link{nwaa_wu_models}} \code{\link{nwaa_wu_variables}}
#'   \code{\link{nwaa_location_types}} \code{\link{nwaa_intersection_types}}
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

