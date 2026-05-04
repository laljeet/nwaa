# Fetch NWAA data

Low-level HTTP wrapper. Sends a query to the NWAA Data Companion service
and parses the response according to `query$format`. Most users should
use the family wrappers
([`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_hydro`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)),
which validate the request before calling this function.

## Usage

``` r
nwaa_get_data(query, quiet = TRUE, timeout = 300, max_tries = 3)
```

## Arguments

- query:

  A named list of query parameters. Built by the family wrappers via the
  internal `nwaa_build_query()` helper.

- quiet:

  If `FALSE`, prints the request URL and response content type after the
  response arrives.

- timeout:

  Request timeout in seconds. Default 300.

- max_tries:

  Maximum number of attempts including the first. Default 3 (one initial
  try plus up to two retries).

## Value

Parsed response. For `format = "csv"`, a tibble. For `format = "json"`,
a list. For `format = "geojson"`, an `sf` object (requires the `sf`
package).

## Network resilience

Each request enforces a generous timeout (default 300 seconds, since
large HUC12-resolution aggregations on the USGS server can take
minutes), and retries up to two times with exponential backoff for
transient errors (HTTP 429, 500, 502, 503, 504). Permanent errors (4xx
other than 429) abort immediately with the server's response body
included in the message.

## User agent

Each request includes a `User-Agent` header identifying the package and
version. This helps USGS attribute traffic to the package for capacity
planning and would let them reach out if a future API change requires a
coordinated package update.
