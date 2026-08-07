# Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)

Convenience wrapper for the hydrologic models in the `wqn` family.
Defaults to the ensemble `wqn-ensemble-conus-nwaa-v1`, and also serves
the two component models via `model_id`: `wqn-nhmprms-conus-nwaa-v1`
(NHM-PRMS) and `wqn-wrfhydro-conus-nwaa-v1` (WRF-Hydro). Returns
hydrologic flux and state variables (evapotranspiration, baseflow,
quickflow, snow water equivalent, soil moisture, runoff, recharge)
aggregated to HUC12 polygons.

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

  Output format: `"csv"`, `"json"`, or `"geojson"`. GeoJSON output
  requires the `sf` package.

- quiet:

  If `FALSE`, prints the request URL and response content type.

- model_id:

  Model ID. Defaults to `"wqn-ensemble-conus-nwaa-v1"`. Also accepts the
  component models `"wqn-nhmprms-conus-nwaa-v1"` and
  `"wqn-wrfhydro-conus-nwaa-v1"`. See
  [`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
  for each model's variables and date range.

## Value

Parsed data. For `format = "csv"`, a tibble.

## Details

This wrapper validates `variable_ids` against the model's catalog entry
before sending the request, and validates that `time_res` is supported
by the model.

## Available variables

Ensemble (`wqn-ensemble-conus-nwaa-v1`):

- `actet` - actual evapotranspiration (mm/mo)

- `incbsflow` - incremental baseflow (mm/mo)

- `incqkflow` - incremental quickflow (mm/mo)

- `incrunoff` - incremental runoff (mm/mo)

- `swe` - snow water equivalent (mm)

- `soilmstfr` - soil moisture fraction (unitless)

The component models (`wqn-nhmprms-conus-nwaa-v1`,
`wqn-wrfhydro-conus-nwaa-v1`) additionally provide:

- `soilmst` - soil moisture (mm)

- `recharge` - recharge (mm/mo)

## See also

[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md),
[`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)

## Examples

``` r
# \donttest{
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

# Recharge and soil moisture from the NHM-PRMS component model
# (not available from the ensemble)
df_recharge <- nwaa_hydro(
  model_id = "wqn-nhmprms-conus-nwaa-v1",
  variable_ids = c("recharge", "soilmst"),
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "monthly",
  range = "custom",
  start = "2020-01",
  end = "2020-12"
)
# }
```
