#' Fetch NWAA data
#'
#' @param query Query list from nwaa_build_query()
#' @param quiet If FALSE, prints URL and content-type
#' @return tibble for csv, list for json, sf object for geojson if sf installed
#' @export
nwaa_get_data <- function(query, quiet = TRUE) {
  stopifnot(is.list(query))

  req <- httr2::request(.nwaa_data_endpoint()) |>
    httr2::req_url_query(!!!query)

  resp <- httr2::req_perform(req)

  status <- httr2::resp_status(resp)

  if (status >= 400) {
    txt <- rawToChar(httr2::resp_body_raw(resp))
    rlang::abort(
      paste0(
        "NWAA request failed (HTTP ", status, ").\n",
        "URL: ", httr2::resp_url(resp), "\n",
        "Response: ", txt
      )
    )
  }
  if (!quiet) {
    message("URL: ", httr2::resp_url(resp))
    message("Content-Type: ", httr2::resp_content_type(resp))
  }

  fmt <- tolower(query$format %||% "")
  raw <- httr2::resp_body_raw(resp)

  if (fmt == "csv") {
    tmp <- tempfile(fileext = ".csv")
    writeBin(raw, tmp)
    return(readr::read_csv(tmp, show_col_types = FALSE) |> tibble::as_tibble())
  }

  if (fmt == "json") {
    return(jsonlite::fromJSON(rawToChar(raw), simplifyVector = TRUE))
  }

  if (fmt == "geojson") {
    if (!requireNamespace("sf", quietly = TRUE)) {
      rlang::abort("Install sf to parse GeoJSON: install.packages('sf')")
    }
    tmp <- tempfile(fileext = ".geojson")
    writeBin(raw, tmp)
    return(sf::read_sf(tmp))
  }

  rlang::abort("Unknown format. Use csv, json, or geojson.")
}

`%||%` <- function(x, y) if (is.null(x)) y else x
