# Download Atmospheric Forcing model output (WRF CONUS404-BA)

Convenience wrapper for the atmospheric forcing model `wqn-conus404-ba`.
Returns precipitation aggregated to HUC12 polygons.

## Usage

``` r
nwaa_atmos(
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
  quiet = TRUE,
  model_id = "wqn-conus404-ba"
)
```

## Arguments

- variable_ids:

  One or more variable IDs from the selected model. See
  [`nwaa_wu_variables`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md).

- location_type:

  Location type used by the API. See
  [`nwaa_location_types`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md).

- location_id:

  Identifier for the selected `location_type` (HUC code, lowercase
  2-letter state abbreviation, or 5-digit county code).

- time_res:

  Temporal resolution: `"monthly"`, `"annualwy"` (water year), or
  `"annualcy"` (calendar year).

- range:

  Date-range mode: `"recent"`, `"historical"`, or `"custom"`.

- start, end:

  For `range = "custom"` only. Monthly uses `"YYYY-MM"` and annual uses
  `"YYYY"`.

- intersection:

  Optional. Controls how polygon selectors include HUC12s when
  `location_type` is `"statecd"` or `"countycd"`. See
  [`nwaa_intersection_types`](https://laljeet.github.io/nwaa/reference/nwaa_intersection_types.md).

- skip:

  Record offset for paging. Default `0`.

- format:

  Output format: `"csv"`, `"json"`, or `"geojson"`. GeoJSON output
  requires the `sf` package.

- quiet:

  If `FALSE`, prints the request URL and response content type.

- model_id:

  Model ID. Defaults to `"wqn-conus404-ba"`, which is currently the only
  atmospheric forcing model in the NWAA catalog; exposed as a parameter
  for forward compatibility.

## Value

Parsed data. For `format = "csv"`, a tibble.

## Details

This wrapper validates `variable_ids` against the model's catalog entry
before sending the request, and validates that `time_res` is supported
by the model.

## See also

[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md),
[`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_hydro`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Monthly precipitation for one HUC12, calendar year 2020
df <- nwaa_atmos(
  variable_ids = "precip",
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "monthly",
  range = "custom",
  start = "2020-01",
  end = "2020-12",
  format = "csv"
)

# Full historical record for a HUC8
df_hist <- nwaa_atmos(
  variable_ids = "precip",
  location_type = "huc8",
  location_id = "18030001",
  range = "historical"
)
} # }
```
