# Water Use models

``` r

library(nwaa)
```

The Water Use family covers five sectoral models, all returned at HUC12
resolution in millions of gallons per day (`mgd`). The five models cover
three sectors (irrigation, public supply, thermoelectric) split between
water withdrawals and consumptive use.

## The five models

``` r

nwaa_wu_models()
```

    #> # A tibble: 5 x 4
    #>   model_id            model_label                                  start_ym end_ym 
    #>   <chr>               <chr>                                        <chr>    <chr>  
    #> 1 wu-irrigation-cu    Crop Irrigation Consumptive Water-Use Model  2000-01  2020-12
    #> 2 wu-irrigation-wd    Crop Irrigation Withdrawals Water-Use Model  2000-01  2020-12
    #> 3 wu-public-supply-cu Public Supply Consumptive Water-Use Model    2009-01  2020-12
    #> 4 wu-public-supply-wd Public Supply Withdrawals Water-Use Model    2000-01  2020-12
    #> 5 wu-thermoelectric   Thermoelectric Power Water-Use Model         2008-01  2020-12

For each model,
[`nwaa_wu_variables()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md)
returns its variable IDs, units, and human-readable names:

``` r

nwaa_wu_variables("wu-irrigation-wd")
```

    #> # A tibble: 3 x 4
    #>   model_id         variable_id unit  variable_name                            
    #>   <chr>            <chr>       <chr> <chr>                                    
    #> 1 wu-irrigation-wd irrwdtot    mgd   Crop irrigation total withdrawals        
    #> 2 wu-irrigation-wd irrwdgw     mgd   Crop irrigation groundwater withdrawals  
    #> 3 wu-irrigation-wd irrwdsw     mgd   Crop irrigation surface-water withdrawals

``` r

nwaa_wu_variables("wu-thermoelectric")
```

    #> # A tibble: 7 x 4
    #>   model_id          variable_id unit  variable_name                                       
    #>   <chr>             <chr>       <chr> <chr>                                               
    #> 1 wu-thermoelectric tecufgw     mgd   Thermoelectric fresh groundwater consumptive use    
    #> 2 wu-thermoelectric tecufsw     mgd   Thermoelectric fresh surface-water consumptive use  
    #> 3 wu-thermoelectric tecuftot    mgd   Thermoelectric fresh water total consumptive use    
    #> 4 wu-thermoelectric tewdfgw     mgd   Thermoelectric fresh groundwater withdrawals        
    #> 5 wu-thermoelectric tewdfsw     mgd   Thermoelectric fresh surface-water withdrawals      
    #> 6 wu-thermoelectric tewdftot    mgd   Thermoelectric fresh water total withdrawals        
    #> 7 wu-thermoelectric tewdssw     mgd   Thermoelectric saline surface-water withdrawals     

## Common arguments

All five Water Use queries share the same argument structure:

| Argument | Purpose |
|----|----|
| `model_id` | one of the five Water Use model IDs |
| `variable_ids` | character vector of variables for that model |
| `location_type` | `"huc2"`, `"huc4"`, `"huc6"`, `"huc8"`, `"huc10"`, `"huc12"`, `"statecd"`, or `"countycd"` |
| `location_id` | identifier for the chosen `location_type` |
| `time_res` | `"monthly"`, `"annualwy"` (water year), or `"annualcy"` (calendar year) |
| `range` | `"recent"`, `"historical"`, or `"custom"` |
| `start`, `end` | only used with `range = "custom"` |
| `intersection` | `"overlap"` (default) or `"envelop"`, only meaningful for state and county selectors |
| `format` | `"csv"` (default), `"json"`, or `"geojson"` |

## 1. Irrigation withdrawals

``` r

irrwd <- nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = c("irrwdtot", "irrwdgw", "irrwdsw"),
  location_type = "huc8",
  location_id   = "18030001",
  time_res      = "annualwy",
  range         = "custom",
  start         = "2018",
  end           = "2020"
)
head(irrwd)
```

## 2. Irrigation consumptive use

``` r

irrcu <- nwaa_water_use(
  model_id      = "wu-irrigation-cu",
  variable_ids  = "irrcutot",
  location_type = "huc8",
  location_id   = "18030001",
  time_res      = "annualwy",
  range         = "historical"
)
head(irrcu)
```

## 3. Public supply withdrawals

``` r

pswd <- nwaa_water_use(
  model_id      = "wu-public-supply-wd",
  variable_ids  = c("pswdtot", "pswdgw", "pswdsw"),
  location_type = "countycd",
  location_id   = "06029",
  time_res      = "annualcy",
  range         = "recent"
)
head(pswd)
```

## 4. Public supply consumptive use

``` r

pscu <- nwaa_water_use(
  model_id      = "wu-public-supply-cu",
  variable_ids  = "pscutot",
  location_type = "countycd",
  location_id   = "06029",
  time_res      = "annualcy",
  range         = "historical"
)
head(pscu)
```

## 5. Thermoelectric

``` r

thermo <- nwaa_water_use(
  model_id      = "wu-thermoelectric",
  variable_ids  = c("tewdftot", "tecuftot"),
  location_type = "statecd",
  location_id   = "ca",
  time_res      = "annualcy",
  range         = "historical",
  intersection  = "overlap"
)
head(thermo)
```

## Switching geographic scope

The same call works at HUC, state, or county scope. The API aggregates
HUC12 outputs to whichever boundary is requested:

``` r

state_irrig <- nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = "irrwdtot",
  location_type = "statecd",
  location_id   = "ca",
  time_res      = "annualcy",
  range         = "historical",
  intersection  = "envelop"  # stricter: only HUC12s ≥98% inside California
)
head(state_irrig)
```

## Looping across counties

A common workflow is pulling the same query across several counties and
combining the results. Native vector input on `location_id` is on the
roadmap. Until then, this idiom works:

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

## Date-range modes

Three values are supported for the `range` argument:

- `range = "recent"` returns one timepoint, the most recent in the
  model’s catalog. For Water Use models this is `2020-12` (monthly),
  `2020` (calendar year), or water year `2020`.
- `range = "historical"` returns the full available period. The first
  complete water year is the year after the catalog start (Water Year
  labeling: WY 2020 covers Oct 1 2019 to Sep 30 2020).
- `range = "custom"` requires `start` and `end`. Monthly takes
  `"YYYY-MM"`; annual takes `"YYYY"`.

``` r

# Just the most recent calendar year
recent_pswd <- nwaa_water_use(
  model_id      = "wu-public-supply-wd",
  variable_ids  = "pswdtot",
  location_type = "countycd",
  location_id   = "06029",
  time_res      = "annualcy",
  range         = "recent"
)
```
