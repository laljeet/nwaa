# NWAA model catalog

Master catalog of all NWAA Data Companion models supported by this
package, across all three families:

- `wu` (Water Use): irrigation, public supply, thermoelectric.

- `wqn` (Water Quantity): atmospheric forcing, hydrologic ensemble.

- `iwa` (Integrated Water Availability): water-budget assessment.

## Usage

``` r
nwaa_catalog()
```

## Value

A tibble with columns:

- model_id:

  API model identifier (string).

- model_label:

  Human-readable model name.

- family:

  One of `"wu"`, `"wqn"`, `"iwa"`.

- start_ym, end_ym:

  Earliest and latest available data, format `"YYYY-MM"`.

- temporal:

  List-column of supported temporal resolutions: combinations of
  `"monthly"`, `"annualcy"`, `"annualwy"`.

- variables:

  List-column of variable ID character vectors.

- variable_name:

  List-column of human-readable variable names.

- units:

  List-column of unit-suffix character vectors aligned to `variables`.

## Details

Each row describes one model: its identifier, label, family, the
variable IDs it produces, the units those variables are reported in
(units appear as a suffix on column names in API responses, e.g.
`irrwdtot_mgd`), the start and end of available data, and the temporal
resolutions the model is published at.

This catalog is the single source of truth used internally by
[`nwaa_resolve_range`](https://laljeet.github.io/nwaa/reference/nwaa_resolve_range.md)
and the family-specific helper functions
([`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md),
[`nwaa_wu_variables`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md)).

## Caveats

Unit suffixes for the hydrologic ensemble model
(`wqn-ensemble-conus-nwaa-v1`) are inferred from the upstream README,
which explicitly documents only `actet_mm/mo`. The remaining variable
units recorded here (`mm/mo` for water-flux variables, `mm` for snow
water equivalent, `frac` for soil-moisture fraction) should be verified
against an actual API response if precision matters. The actual unit
suffix is always returned as part of the column name in API responses.

## Examples

``` r
nwaa_catalog()
#> # A tibble: 8 × 9
#>   model_id   model_label family start_ym end_ym temporal variables variable_name
#>   <chr>      <chr>       <chr>  <chr>    <chr>  <list>   <list>    <list>       
#> 1 wu-irriga… Crop Irrig… wu     2000-01  2020-… <chr>    <chr [1]> <chr [1]>    
#> 2 wu-irriga… Crop Irrig… wu     2000-01  2020-… <chr>    <chr [3]> <chr [3]>    
#> 3 wu-public… Public Sup… wu     2009-01  2020-… <chr>    <chr [1]> <chr [1]>    
#> 4 wu-public… Public Sup… wu     2000-01  2020-… <chr>    <chr [3]> <chr [3]>    
#> 5 wu-thermo… Thermoelec… wu     2008-01  2020-… <chr>    <chr [7]> <chr [7]>    
#> 6 wqn-conus… Atmospheri… wqn    1979-10  2021-… <chr>    <chr [1]> <chr [1]>    
#> 7 wqn-ensem… Hydrologic… wqn    2009-10  2020-… <chr>    <chr [6]> <chr [6]>    
#> 8 iwa-asses… National W… iwa    2009-10  2020-… <chr>    <chr [4]> <chr [4]>    
#> # ℹ 1 more variable: units <list>

# All Water Use models
cat <- nwaa_catalog()
cat[cat$family == "wu", c("model_id", "model_label")]
#> # A tibble: 5 × 2
#>   model_id            model_label                                
#>   <chr>               <chr>                                      
#> 1 wu-irrigation-cu    Crop Irrigation Consumptive Water-Use Model
#> 2 wu-irrigation-wd    Crop Irrigation Withdrawals Water-Use Model
#> 3 wu-public-supply-cu Public Supply Consumptive Water-Use Model  
#> 4 wu-public-supply-wd Public Supply Withdrawals Water-Use Model  
#> 5 wu-thermoelectric   Thermoelectric Power Water-Use Model       
```
