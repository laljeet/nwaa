#' @keywords internal
.nwaa_base_url <- function() {
  "https://api.water.usgs.gov/nwaa-data"
}

#' @keywords internal
.nwaa_data_endpoint <- function() {
  paste0(.nwaa_base_url(), "/data")
}
