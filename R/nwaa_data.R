#' Download NWAA model output (generic)
#'
#' @param model_id Model ID. See \code{\link{nwaa_models}}.
#' @param variable_ids One or more variable IDs. See \code{\link{nwaa_variables}}.
#' @param location_type One of \code{\link{nwaa_location_types}}$type.
#' @param location_id Identifier for the selected location type.
#' @param time_res "monthly", "annualwy", "annualcy".
#' @param range "recent", "historical", "custom".
#' @param start,end For range = "custom".
#' @param intersection Optional, e.g. "overlap" or "envelop".
#' @param skip Record offset for paging.
#' @param format "csv", "json", or "geojson".
#' @param quiet If FALSE, prints request URL and content type.
#' @export
nwaa_data <- function(model_id,
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
