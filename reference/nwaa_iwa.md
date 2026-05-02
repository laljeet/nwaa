# Download Integrated Water Availability Assessment outputs

Convenience wrapper for the integrated water availability model
`iwa-assessment-outputs-conus-2025`. Returns water-budget results and
the surface water supply and use index (SUI) at HUC12 resolution.

## Usage

``` r
nwaa_iwa(
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
  model_id = "iwa-assessment-outputs-conus-2025"
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

  Output format: `"csv"`, `"json"`, or `"geojson"`.

- quiet:

  If `FALSE`, prints the request URL and response content type.

- model_id:

  Model ID. Defaults to `"iwa-assessment-outputs-conus-2025"`; exposed
  for forward compatibility.

## Value

Parsed data. For `format = "csv"`, a tibble.

## Details

This wrapper validates `variable_ids` against the model's catalog entry
before sending the request, and validates that `time_res` is supported
by the model.

## Available variables

- `sui` - surface water supply and use index (fraction)

- `availab` - total water availability (mm/mo)

- `strflow` - streamflow (mm/mo)

- `consum` - total water consumption (mm/mo)

## See also

[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md),
[`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_hydro`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# All four IWA variables for one HUC12, full historical record
df <- nwaa_iwa(
  variable_ids = c("sui", "availab", "strflow", "consum"),
  location_type = "huc12",
  location_id = "180300010602",
  range = "historical"
)

# SUI only for an entire county
df_sui <- nwaa_iwa(
  variable_ids = "sui",
  location_type = "countycd",
  location_id = "06029",
  time_res = "monthly",
  range = "custom",
  start = "2018-01",
  end = "2020-09",
  intersection = "overlap"
)
} # }
```
