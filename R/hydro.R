#' Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)
#'
#' Convenience wrapper for the hydrologic model ensemble
#' \code{wqn-ensemble-conus-nwaa-v1}. Returns hydrologic flux and state
#' variables (evapotranspiration, baseflow, quickflow, snow water
#' equivalent, soil moisture fraction, runoff) aggregated to HUC12
#' polygons.
#'
#' This wrapper validates \code{variable_ids} against the model's catalog
#' entry before sending the request, and validates that \code{time_res}
#' is supported by the model.
#'
#' @inheritParams nwaa_water_use
#' @param model_id Model ID. Defaults to \code{"wqn-ensemble-conus-nwaa-v1"};
#'   exposed for forward compatibility.
#'
#' @return Parsed data. For \code{format = "csv"}, a tibble.
#'
#' @section Available variables:
#' \itemize{
#'   \item \code{actet} - actual evapotranspiration (mm/mo)
#'   \item \code{incbsflow} - incremental baseflow (mm/mo)
#'   \item \code{incqkflow} - incremental quickflow (mm/mo)
#'   \item \code{incrunoff} - incremental runoff (mm/mo)
#'   \item \code{swe} - snow water equivalent (mm)
#'   \item \code{soilmstfr} - soil moisture fraction (unitless)
#' }
#' Unit suffixes for variables other than \code{actet} are inferred;
#' verify against actual API responses if precision matters.
#'
#' @examples
#' \dontrun{
#' # Monthly evapotranspiration for one HUC12 across the full record
#' df_et <- nwaa_hydro(
#'   variable_ids = "actet",
#'   location_type = "huc12",
#'   location_id = "180300010602",
#'   range = "historical"
#' )
#'
#' # Multiple hydrologic variables for a county
#' df_county <- nwaa_hydro(
#'   variable_ids = c("actet", "incrunoff", "swe"),
#'   location_type = "countycd",
#'   location_id = "06029",
#'   time_res = "monthly",
#'   range = "custom",
#'   start = "2018-01",
#'   end = "2020-12",
#'   intersection = "overlap"
#' )
#' }
#'
#' @seealso \code{\link{nwaa_catalog}}, \code{\link{nwaa_water_use}},
#'   \code{\link{nwaa_atmos}}, \code{\link{nwaa_iwa}}
#' @export
nwaa_hydro <- function(variable_ids,
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
                       model_id = "wqn-ensemble-conus-nwaa-v1") {
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
