#' Fetch NWAA data
#'
#' Low-level HTTP wrapper. Sends a query to the NWAA Data Companion service
#' and parses the response according to \code{query$format}. Most users
#' should use the family wrappers (\code{\link{nwaa_water_use}},
#' \code{\link{nwaa_atmos}}, \code{\link{nwaa_hydro}}, \code{\link{nwaa_iwa}}),
#' which validate the request before calling this function.
#'
#' @section Network resilience:
#' Each request enforces a generous timeout (default 300 seconds, since
#' large HUC12-resolution aggregations on the USGS server can take
#' minutes), and retries up to two times with exponential backoff for
#' transient errors (HTTP 429, 500, 502, 503, 504). Permanent errors
#' (4xx other than 429) abort immediately with the server's response
#' body included in the message.
#'
#' @section User agent:
#' Each request includes a \code{User-Agent} header identifying the
#' package and version. This helps USGS attribute traffic to the package
#' for capacity planning and would let them reach out if a future API
#' change requires a coordinated package update.
#'
#' @param query A named list of query parameters. Built by the family
#'   wrappers via the internal \code{nwaa_build_query()} helper.
#' @param quiet If \code{FALSE}, prints the request URL and response
#'   content type after the response arrives.
#' @param timeout Request timeout in seconds. Default 300.
#' @param max_tries Maximum number of attempts including the first.
#'   Default 3 (one initial try plus up to two retries).
#'
#' @return Parsed response. For \code{format = "csv"}, a tibble. For
#'   \code{format = "json"}, a list. For \code{format = "geojson"}, an
#'   \code{sf} object (requires the \code{sf} package).
#'
#' @export
nwaa_get_data <- function(query, quiet = TRUE, timeout = 300, max_tries = 3) {
  stopifnot(is.list(query))

  ua <- paste0(
    "nwaa R package v", utils::packageVersion("nwaa"),
    " (https://github.com/laljeet/nwaa)"
  )

  req <- httr2::request(.nwaa_data_endpoint()) |>
    httr2::req_url_query(!!!query) |>
    httr2::req_user_agent(ua) |>
    httr2::req_timeout(seconds = timeout) |>
    httr2::req_retry(
      max_tries = max_tries,
      is_transient = function(resp) {
        httr2::resp_status(resp) %in% c(429, 500, 502, 503, 504)
      }
    ) |>
    # Don't auto-error on 4xx/5xx so we can build a richer message that
    # includes the server's response body.
    httr2::req_error(is_error = function(resp) FALSE)

  resp <- httr2::req_perform(req)

  status <- httr2::resp_status(resp)

  if (status >= 400) {
    txt <- tryCatch(
      rawToChar(httr2::resp_body_raw(resp)),
      error = function(e) "<no response body>"
    )
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
    on.exit(unlink(tmp), add = TRUE)
    writeBin(raw, tmp)
    return(tibble::as_tibble(readr::read_csv(tmp, show_col_types = FALSE)))
  }

  if (fmt == "json") {
    return(jsonlite::fromJSON(rawToChar(raw), simplifyVector = TRUE))
  }

  if (fmt == "geojson") {
    if (!requireNamespace("sf", quietly = TRUE)) {
      rlang::abort(
        paste0(
          "format = \"geojson\" requires the 'sf' package. ",
          "Install it with install.packages(\"sf\") and try again, ",
          "or use format = \"csv\" or format = \"json\"."
        )
      )
    }
    tmp <- tempfile(fileext = ".geojson")
    on.exit(unlink(tmp), add = TRUE)
    writeBin(raw, tmp)
    return(sf::read_sf(tmp))
  }

  rlang::abort(
    paste0(
      "Unknown format: '", fmt, "'. ",
      "Use 'csv', 'json', or 'geojson'."
    )
  )
}

`%||%` <- function(x, y) if (is.null(x)) y else x
