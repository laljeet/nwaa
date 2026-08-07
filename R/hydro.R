#' Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)
#'
#' Convenience wrapper for the hydrologic models in the \code{wqn} family.
#' Defaults to the ensemble \code{wqn-ensemble-conus-nwaa-v1}, and also
#' serves the two component models via \code{model_id}:
#' \code{wqn-nhmprms-conus-nwaa-v1} (NHM-PRMS) and
#' \code{wqn-wrfhydro-conus-nwaa-v1} (WRF-Hydro). Returns hydrologic flux
#' and state variables (evapotranspiration, baseflow, quickflow, snow
#' water equivalent, soil moisture, runoff, recharge) aggregated to HUC12
#' polygons.
#'
#' This wrapper validates \code{variable_ids} against the model's catalog
#' entry before sending the request, and validates that \code{time_res}
#' is supported by the model.
#'
#' @inheritParams nwaa_water_use
#' @param model_id Model ID. Defaults to \code{"wqn-ensemble-conus-nwaa-v1"}.
#'   Also accepts the component models \code{"wqn-nhmprms-conus-nwaa-v1"} and
#'   \code{"wqn-wrfhydro-conus-nwaa-v1"}. See \code{\link{nwaa_catalog}} for
#'   each model's variables and date range.
#'
#' @return Parsed data. For \code{format = "csv"}, a tibble.
#'
#' @section Available variables:
#' Ensemble (\code{wqn-ensemble-conus-nwaa-v1}):
#' \itemize{
#'   \item \code{actet} - actual evapotranspiration (mm/mo)
#'   \item \code{incbsflow} - incremental baseflow (mm/mo)
#'   \item \code{incqkflow} - incremental quickflow (mm/mo)
#'   \item \code{incrunoff} - incremental runoff (mm/mo)
#'   \item \code{swe} - snow water equivalent (mm)
#'   \item \code{soilmstfr} - soil moisture fraction (unitless)
#' }
#' The component models (\code{wqn-nhmprms-conus-nwaa-v1},
#' \code{wqn-wrfhydro-conus-nwaa-v1}) additionally provide:
#' \itemize{
#'   \item \code{soilmst} - soil moisture (mm)
#'   \item \code{recharge} - recharge (mm/mo)
#' }
#'
#' @examples
#' \donttest{
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
#'
#' # Recharge and soil moisture from the NHM-PRMS component model
#' # (not available from the ensemble)
#' df_recharge <- nwaa_hydro(
#'   model_id = "wqn-nhmprms-conus-nwaa-v1",
#'   variable_ids = c("recharge", "soilmst"),
#'   location_type = "huc12",
#'   location_id = "180300010602",
#'   time_res = "monthly",
#'   range = "custom",
#'   start = "2020-01",
#'   end = "2020-12"
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
