# Getting Started with nwaa

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

Every supported model and its variables live in a single tibble:

``` r

nwaa_catalog()
#> # A tibble: 8 × 9
#>   model_id                          model_label     family start_ym end_ym temporal variables variable_name units
#>   <chr>                             <chr>           <chr>  <chr>    <chr>  <list>   <list>    <list>        <lis>
#> 1 wu-irrigation-cu                  Crop Irrigatio… wu     2000-01  2020-… <chr>    <chr [1]> <chr [1]>     <chr>
#> 2 wu-irrigation-wd                  Crop Irrigatio… wu     2000-01  2020-… <chr>    <chr [3]> <chr [3]>     <chr>
#> 3 wu-public-supply-cu               Public Supply … wu     2009-01  2020-… <chr>    <chr [1]> <chr [1]>     <chr>
#> 4 wu-public-supply-wd               Public Supply … wu     2000-01  2020-… <chr>    <chr [3]> <chr [3]>     <chr>
#> 5 wu-thermoelectric                 Thermoelectric… wu     2008-01  2020-… <chr>    <chr [7]> <chr [7]>     <chr>
#> 6 wqn-conus404-ba                   Atmospheric Fo… wqn    1979-10  2021-… <chr>    <chr [1]> <chr [1]>     <chr>
#> 7 wqn-ensemble-conus-nwaa-v1        Hydrologic Mod… wqn    2009-10  2020-… <chr>    <chr [6]> <chr [6]>     <chr>
#> 8 iwa-assessment-outputs-conus-2025 National Water… iwa    2009-10  2020-… <chr>    <chr [4]> <chr [4]>     <chr>
```

To list only the variables for one model:

``` r

catalog <- nwaa_catalog()
catalog$variables[catalog$model_id == "wu-irrigation-conus-nwaa-v1"][[1]]
#> Error in catalog$variables[catalog$model_id == "wu-irrigation-conus-nwaa-v1"][[1]]: subscript out of bounds
```

## A note on locations

NWAA data are published at HUC12 resolution, but the service accepts
queries by HUC of any length, by state, or by county FIPS. The package
resolves these for you:

``` r

nwaa_location_types()
#> # A tibble: 8 × 2
#>   type     notes                                                                                                 
#>   <chr>    <chr>                                                                                                 
#> 1 huc2     Hydrologic unit code (2 digits). Returns HUC12 results within this HUC.                               
#> 2 huc4     Hydrologic unit code (4 digits). Returns HUC12 results within this HUC.                               
#> 3 huc6     Hydrologic unit code (6 digits). Returns HUC12 results within this HUC.                               
#> 4 huc8     Hydrologic unit code (8 digits). Returns HUC12 results within this HUC.                               
#> 5 huc10    Hydrologic unit code (10 digits). Returns HUC12 results within this HUC.                              
#> 6 huc12    Hydrologic unit code (12 digits). Returns results for this HUC12.                                     
#> 7 statecd  State abbreviation (2-letter), lowercase in the API (example: 'ca', 'al').Use intersection to control…
#> 8 countycd County code (5-digit). Use intersection to control which HUC12s get included.
```

State and county codes are searchable:

``` r

head(nwaa_state_codes())
#> # A tibble: 6 × 2
#>   state_name state_abbr
#>   <chr>      <chr>     
#> 1 Alabama    AL        
#> 2 Alaska     AK        
#> 3 Arizona    AZ        
#> 4 Arkansas   AR        
#> 5 California CA        
#> 6 Colorado   CO
```

## One example per family

The three family wrappers below all share the same argument structure:
pick a location, pick variables, pick a date range, optionally pick
`time_res` (`"monthly"`, `"annualwy"`, or `"annualcy"`). Each returns a
tibble.

### Water Use

``` r

wu <- nwaa_water_use(
  model_id     = "wu-irrigation-conus-nwaa-v1",
  variable_ids = "tot_irr",
  location_id  = "18030012",
  range        = "custom",
  start        = "2020-01",
  end          = "2020-12",
  time_res     = "monthly"
)
head(wu)
```

### Water Quantity (atmospheric forcing)

``` r

atmos <- nwaa_atmos(
  variable_ids = "precip",
  location_id  = "18030012",
  range        = "custom",
  start        = "2020-01",
  end          = "2020-12",
  time_res     = "monthly"
)
head(atmos)
```

### Integrated Water Availability

``` r

iwa <- nwaa_iwa(
  variable_ids = c("availab", "consum", "sui"),
  location_id  = "18030012",
  range        = "custom",
  start        = "2020-01",
  end          = "2020-12",
  time_res     = "monthly"
)
head(iwa)
```

## Validation

Every wrapper validates the request before it touches the network.
Invalid model IDs, variables that don’t belong to the model, and
unsupported `time_res` values fail fast with a readable message:

``` r

nwaa_water_use(
  model_id     = "wu-irrigation-conus-nwaa-v1",
  variable_ids = "precip",
  location_id  = "18030012",
  range        = "default"
)
#> Error in match.arg(range): 'arg' should be one of "recent", "historical", "custom"
```

## Where to next

The Water Use family has the most models and the most-developed
examples. See
[`vignette("water-use", package = "nwaa")`](https://laljeet.github.io/nwaa/articles/water-use.md)
for a full walkthrough.
