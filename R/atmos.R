#' Download Atmospheric Forcing model output (WRF CONUS404-BA)
#'
#' Convenience wrapper for the atmospheric forcing model
#' \code{wqn-conus404-ba}. Returns precipitation aggregated to HUC12
#' polygons.
#'
#' This wrapper validates \code{variable_ids} against the model's catalog
#' entry before sending the request, and validates that \code{time_res}
#' is supported by the model.
#'
#' @inheritParams nwaa_water_use
#' @param model_id Model ID. Defaults to \code{"wqn-conus404-ba"}, which is
#'   currently the only atmospheric forcing model in the NWAA catalog;
#'   exposed as a parameter for forward compatibility.
#'
#' @return Parsed data. For \code{format = "csv"}, a tibble.
#'
#' @examples
#' \dontrun{
#' # Monthly precipitation for one HUC12, calendar year 2020
#' df <- nwaa_atmos(
#'   variable_ids = "precip",
#'   location_type = "huc12",
#'   location_id = "180300010602",
#'   time_res = "monthly",
#'   range = "custom",
#'   start = "2020-01",
#'   end = "2020-12",
#'   format = "csv"
#' )
#'
#' # Full historical record for a HUC8
#' df_hist <- nwaa_atmos(
#'   variable_ids = "precip",
#'   location_type = "huc8",
#'   location_id = "18030001",
#'   range = "historical"
#' )
#' }
#'
#' @seealso \code{\link{nwaa_catalog}}, \code{\link{nwaa_water_use}},
#'   \code{\link{nwaa_hydro}}, \code{\link{nwaa_iwa}}
#' @export
nwaa_atmos <- function(variable_ids,
                       location_type,
                       location_id,
                       time_res = "monthly",
                       range = c("recent", "historical", "custom"),
                       start = NULL,
                       end = NULL,
                       intersection = NULL,
                       skip = 0,
                       format = "csv",
                       quiet = TRUE,
                       model_id = "wqn-conus404-ba") {
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
    expected_family = "wqn"
  )
}
