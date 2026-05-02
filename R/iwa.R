#' Download Integrated Water Availability Assessment outputs
#'
#' Convenience wrapper for the integrated water availability model
#' \code{iwa-assessment-outputs-conus-2025}. Returns water-budget
#' results and the surface water supply and use index (SUI) at HUC12
#' resolution.
#'
#' This wrapper validates \code{variable_ids} against the model's catalog
#' entry before sending the request, and validates that \code{time_res}
#' is supported by the model.
#'
#' @inheritParams nwaa_water_use
#' @param model_id Model ID. Defaults to
#'   \code{"iwa-assessment-outputs-conus-2025"};
#'   exposed for forward compatibility.
#'
#' @return Parsed data. For \code{format = "csv"}, a tibble.
#'
#' @section Available variables:
#' \itemize{
#'   \item \code{sui} - surface water supply and use index (fraction)
#'   \item \code{availab} - total water availability (mm/mo)
#'   \item \code{strflow} - streamflow (mm/mo)
#'   \item \code{consum} - total water consumption (mm/mo)
#' }
#'
#' @examples
#' \dontrun{
#' # All four IWA variables for one HUC12, full historical record
#' df <- nwaa_iwa(
#'   variable_ids = c("sui", "availab", "strflow", "consum"),
#'   location_type = "huc12",
#'   location_id = "180300010602",
#'   range = "historical"
#' )
#'
#' # SUI only for an entire county
#' df_sui <- nwaa_iwa(
#'   variable_ids = "sui",
#'   location_type = "countycd",
#'   location_id = "06029",
#'   time_res = "monthly",
#'   range = "custom",
#'   start = "2018-01",
#'   end = "2020-09",
#'   intersection = "overlap"
#' )
#' }
#'
#' @seealso \code{\link{nwaa_catalog}}, \code{\link{nwaa_water_use}},
#'   \code{\link{nwaa_atmos}}, \code{\link{nwaa_hydro}}
#' @export
nwaa_iwa <- function(variable_ids,
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
                     model_id = "iwa-assessment-outputs-conus-2025") {
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
    expected_family = "iwa"
  )
}
