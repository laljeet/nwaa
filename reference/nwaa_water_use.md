# Download Water Use model output from the NWAA Data Companion

Convenience wrapper for the Water Use (`wu`) family of NWAA models.
Validates that `model_id`, `variable_ids`, and `time_res` are valid for
this family before sending the request. County and state extents act as
polygon selectors and return results at HUC12 resolution.

## Usage

``` r
nwaa_water_use(
  model_id,
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
  quiet = TRUE
)
```

## Arguments

- model_id:

  Water Use model ID. See
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

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

## Value

Parsed data. For `format = "csv"`, a tibble. For `format = "json"`, a
list. For `format = "geojson"`, an `sf` object.

## Details

Learn options inside the package:

- Models:
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md)

- Variables by model:
  [`nwaa_wu_variables`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md)

- Location types:
  [`nwaa_location_types`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md)

Official tool that generates valid URLs: [NWAA Subset and Download
Tool](https://water.usgs.gov/nwaa-data/subset-download)

## See also

[`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md),
[`nwaa_wu_variables`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_hydro`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)

## Examples

``` r
# Discover models and variables (offline)
nwaa_wu_models()
#> # A tibble: 5 × 4
#>   model_id            model_label                                start_ym end_ym
#>   <chr>               <chr>                                      <chr>    <chr> 
#> 1 wu-irrigation-cu    Crop Irrigation Consumptive Water-Use Mod… 2000-01  2020-…
#> 2 wu-irrigation-wd    Crop Irrigation Withdrawals Water-Use Mod… 2000-01  2020-…
#> 3 wu-public-supply-cu Public Supply Consumptive Water-Use Model  2009-01  2020-…
#> 4 wu-public-supply-wd Public Supply Withdrawals Water-Use Model  2000-01  2020-…
#> 5 wu-thermoelectric   Thermoelectric Power Water-Use Model       2008-01  2020-…
nwaa_wu_variables("wu-irrigation-wd")
#> # A tibble: 3 × 4
#>   model_id         variable_id unit  variable_name                            
#>   <chr>            <chr>       <chr> <chr>                                    
#> 1 wu-irrigation-wd irrwdtot    mgd   Crop irrigation total withdrawals        
#> 2 wu-irrigation-wd irrwdgw     mgd   Crop irrigation groundwater withdrawals  
#> 3 wu-irrigation-wd irrwdsw     mgd   Crop irrigation surface-water withdrawals

if (FALSE) { # \dontrun{
# County selector, annual water-year, custom range
df <- nwaa_water_use(
  model_id = "wu-irrigation-wd",
  variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
  location_type = "countycd",
  location_id = "06029",
  time_res = "annualwy",
  range = "custom",
  start = "2001",
  end = "2020",
  intersection = "overlap",
  format = "csv",
  quiet = FALSE
)

# HUC12 selector, most recent timepoint
df_recent <- nwaa_water_use(
  model_id = "wu-irrigation-wd",
  variable_ids = "irrwdtot",
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "annualwy",
  range = "recent",
  format = "csv"
)

# Stricter polygon selection
df_envelop <- nwaa_water_use(
  model_id = "wu-irrigation-wd",
  variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
  location_type = "countycd",
  location_id = "06029",
  time_res = "annualwy",
  range = "custom",
  start = "2001",
  end = "2020",
  intersection = "envelop",
  format = "csv"
)
} # }
```
