# Getting started with nwaa

## Overview

The `nwaa` package provides an R interface to the USGS National Water
Availability Assessment (NWAA) Data Companion web service
(<https://water.usgs.gov/nwaa-data>). The service publishes model
outputs at HUC12 spatial resolution across three families:

| Family | Models | What it covers |
|----|----|----|
| Water Use (`wu-*`) | 5 | irrigation, public supply, thermoelectric |
| Water Quantity (`wqn-*`) | 2 | atmospheric forcing, hydrologic ensemble |
| Integrated Water Availability (`iwa-*`) | 1 | water budget, surface supply and use index |

``` r

library(nwaa)
```

## The catalog

Every supported model and its variables live in a single tibble. The
catalog is the source of truth for what models, variables, units, and
time resolutions are valid:

``` r

nwaa_catalog()
```

    #> # A tibble: 8 x 9
    #>   model_id                          model_label                                    family start_ym end_ym  temporal  variables variable_name units    
    #>   <chr>                             <chr>                                          <chr>  <chr>    <chr>   <list>    <list>    <list>        <list>   
    #> 1 wu-irrigation-cu                  Crop Irrigation Consumptive Water-Use Model    wu     2000-01  2020-12 <chr [3]> <chr [1]> <chr [1]>     <chr [1]>
    #> 2 wu-irrigation-wd                  Crop Irrigation Withdrawals Water-Use Model    wu     2000-01  2020-12 <chr [3]> <chr [3]> <chr [3]>     <chr [3]>
    #> 3 wu-public-supply-cu               Public Supply Consumptive Water-Use Model      wu     2009-01  2020-12 <chr [3]> <chr [1]> <chr [1]>     <chr [1]>
    #> 4 wu-public-supply-wd               Public Supply Withdrawals Water-Use Model      wu     2000-01  2020-12 <chr [3]> <chr [3]> <chr [3]>     <chr [3]>
    #> 5 wu-thermoelectric                 Thermoelectric Power Water-Use Model           wu     2008-01  2020-12 <chr [3]> <chr [7]> <chr [7]>     <chr [7]>
    #> 6 wqn-conus404-ba                   Atmospheric Forcing Model (WRF CONUS404-BA)    wqn    1979-10  2021-09 <chr [1]> <chr [1]> <chr [1]>     <chr [1]>
    #> 7 wqn-ensemble-conus-nwaa-v1        Hydrologic Model Ensemble (NHM-PRMS and WRF... wqn    2009-10  2020-09 <chr [1]> <chr [6]> <chr [6]>     <chr [6]>
    #> 8 iwa-assessment-outputs-conus-2025 National Water Availability Assessment Outp... iwa    2009-10  2020-09 <chr [1]> <chr [4]> <chr [4]>     <chr [4]>

To inspect the variables for one model, the simplest path is the helper
for the Water Use family:

``` r

nwaa_wu_variables("wu-irrigation-wd")
```

    #> # A tibble: 3 x 4
    #>   model_id         variable_id unit  variable_name                            
    #>   <chr>            <chr>       <chr> <chr>                                    
    #> 1 wu-irrigation-wd irrwdtot    mgd   Crop irrigation total withdrawals        
    #> 2 wu-irrigation-wd irrwdgw     mgd   Crop irrigation groundwater withdrawals  
    #> 3 wu-irrigation-wd irrwdsw     mgd   Crop irrigation surface-water withdrawals

For non-Water-Use models, list-columns from the catalog give the same
information:

``` r

catalog <- nwaa_catalog()
catalog$variables[catalog$model_id == "wqn-conus404-ba"][[1]]
#> [1] "precip"
```

## Locations

NWAA data are published at HUC12 resolution, but the service accepts
queries at any HUC level, by lowercase 2-letter state abbreviation, or
by 5-digit county FIPS code:

``` r

nwaa_location_types()
```

    #> # A tibble: 8 x 2
    #>   type     notes                                                                                                  
    #>   <chr>    <chr>                                                                                                  
    #> 1 huc2     Hydrologic unit code (2 digits). Returns HUC12 results within this HUC.                                
    #> 2 huc4     Hydrologic unit code (4 digits). Returns HUC12 results within this HUC.                                
    #> 3 huc6     Hydrologic unit code (6 digits). Returns HUC12 results within this HUC.                                
    #> 4 huc8     Hydrologic unit code (8 digits). Returns HUC12 results within this HUC.                                
    #> 5 huc10    Hydrologic unit code (10 digits). Returns HUC12 results within this HUC.                               
    #> 6 huc12    Hydrologic unit code (12 digits). Returns results for this HUC12.                                      
    #> 7 statecd  State abbreviation (2-letter), lowercase in the API (example: 'ca', 'al'). Use intersection to control which HUC12s are included.
    #> 8 countycd County code (5-digit FIPS). Use intersection to control which HUC12s are included.

State abbreviations in lowercase are the API’s expected form:

``` r

head(nwaa_statecd())
```

    #> # A tibble: 6 x 2
    #>   state_name statecd
    #>   <chr>      <chr>  
    #> 1 Alabama    al     
    #> 2 Alaska     ak     
    #> 3 Arizona    az     
    #> 4 Arkansas   ar     
    #> 5 California ca     
    #> 6 Colorado   co     

When `location_type` is `"statecd"` or `"countycd"`, the polygon is
converted to a set of HUC12s server-side. The `intersection` argument
controls strictness: `"overlap"` (default) includes any HUC12 that
touches the polygon, `"envelop"` requires the HUC12 to be at least 98%
inside.

## One example per family

The four family wrappers all share the same argument structure: pick a
model, pick variables, pick a location, pick a date range. Each returns
a tibble (or list/sf object for `format = "json"` or `"geojson"`).

### Water Use

``` r

wu <- nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = c("irrwdtot", "irrwdgw", "irrwdsw"),
  location_type = "huc12",
  location_id   = "180300010602",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)
head(wu)
```

### Water Quantity (atmospheric forcing)

``` r

atmos <- nwaa_atmos(
  variable_ids  = "precip",
  location_type = "huc12",
  location_id   = "180300010602",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)
head(atmos)
```

### Hydrologic ensemble

``` r

hydro <- nwaa_hydro(
  variable_ids  = c("actet", "swe"),
  location_type = "huc12",
  location_id   = "180300010602",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)
head(hydro)
```

### Integrated Water Availability

``` r

iwa <- nwaa_iwa(
  variable_ids  = c("availab", "consum", "sui"),
  location_type = "huc12",
  location_id   = "180300010602",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)
head(iwa)
```

## Date ranges

The `range` argument accepts three values:

- `"recent"` returns the most recent timepoint (one row per HUC12).
- `"historical"` returns the full available period of record.
- `"custom"` requires `start` and `end`.

For monthly resolution, `start` and `end` use `"YYYY-MM"` format. For
annual resolution, they use `"YYYY"`. The package picks the right format
based on `time_res`.

## Temporal resolution

Water Use models support `monthly`, `annualcy` (calendar year), and
`annualwy` (water year, October to September, labeled by ending year).
Water Quantity and Integrated Water Availability models are published as
monthly products only. Annual rollups for the latter can be computed
client-side with standard tools:

``` r

library(dplyr)

precip_monthly <- nwaa_atmos(
  variable_ids  = "precip",
  location_type = "huc12",
  location_id   = "180300010602",
  range         = "historical"
)

precip_annual <- precip_monthly |>
  mutate(year = substr(year_month, 1, 4)) |>
  group_by(huc12_id, year) |>
  summarise(precip_mm_yr = sum(`precip_mm/mo`), .groups = "drop")
```

## Validation

Every wrapper validates the request against the catalog before any
network call. Invalid model IDs, variables that don’t belong to the
model, and unsupported `time_res` values fail fast with a readable
message:

``` r

nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = "precip",  # not a valid Water Use variable
  location_type = "huc12",
  location_id   = "180300010602",
  range         = "recent"
)
#> Error: Unknown variable_ids for model 'wu-irrigation-wd': 'precip'.
#> Valid variables: irrwdtot, irrwdgw, irrwdsw.
```

## Multi-county queries

Vector inputs are not yet supported on the `location_id` argument. To
pull the same query across several counties, use
[`purrr::map_dfr()`](https://purrr.tidyverse.org/reference/map_dfr.html)
or a [`lapply()`](https://rdrr.io/r/base/lapply.html) plus
[`dplyr::bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html)
pattern. Native multi-location support is planned for a later release.

``` r

library(purrr)
library(dplyr)

county_fips <- c("06029", "06031", "06107", "06019")  # Kern, Kings, Tulare, Fresno

irrig_sjv <- map_dfr(county_fips, function(fips) {
  nwaa_water_use(
    model_id      = "wu-irrigation-wd",
    variable_ids  = c("irrwdtot", "irrwdgw", "irrwdsw"),
    location_type = "countycd",
    location_id   = fips,
    time_res      = "annualwy",
    range         = "historical"
  ) |>
    mutate(county_fips = fips)
})

head(irrig_sjv)
```

## Where to next

The Water Use family has the most models and the most-developed
examples. See
[`vignette("water-use", package = "nwaa")`](https://laljeet.github.io/nwaa/articles/water-use.md)
for a full walkthrough across all five Water Use models.
