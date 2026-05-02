# Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)

Convenience wrapper for the hydrologic model ensemble
`wqn-ensemble-conus-nwaa-v1`. Returns hydrologic flux and state
variables (evapotranspiration, baseflow, quickflow, snow water
equivalent, soil moisture fraction, runoff) aggregated to HUC12
polygons.

## Usage

``` r
nwaa_hydro(
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
  model_id = "wqn-ensemble-conus-nwaa-v1"
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

  Model ID. Defaults to `"wqn-ensemble-conus-nwaa-v1"`; exposed for
  forward compatibility.

## Value

Parsed data. For `format = "csv"`, a tibble.

## Details

This wrapper validates `variable_ids` against the model's catalog entry
before sending the request, and validates that `time_res` is supported
by the model.

## Available variables

- `actet` - actual evapotranspiration (mm/mo)

- `incbsflow` - incremental baseflow (mm/mo)

- `incqkflow` - incremental quickflow (mm/mo)

- `incrunoff` - incremental runoff (mm/mo)

- `swe` - snow water equivalent (mm)

- `soilmstfr` - soil moisture fraction (unitless)

Unit suffixes for variables other than `actet` are inferred; verify
against actual API responses if precision matters.

## See also

[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md),
[`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Monthly evapotranspiration for one HUC12 across the full record
df_et <- nwaa_hydro(
  variable_ids = "actet",
  location_type = "huc12",
  location_id = "180300010602",
  range = "historical"
)

# Multiple hydrologic variables for a county
df_county <- nwaa_hydro(
  variable_ids = c("actet", "incrunoff", "swe"),
  location_type = "countycd",
  location_id = "06029",
  time_res = "monthly",
  range = "custom",
  start = "2018-01",
  end = "2020-12",
  intersection = "overlap"
)
} # }
```
