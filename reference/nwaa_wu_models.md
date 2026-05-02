# List Water Use models and their available date ranges

List Water Use models and their available date ranges

## Usage

``` r
nwaa_wu_models()
```

## Value

A tibble with `model_id`, `model_label`, `start_ym`, and `end_ym`.

## Examples

``` r
nwaa_wu_models()
#> # A tibble: 5 × 4
#>   model_id            model_label                                start_ym end_ym
#>   <chr>               <chr>                                      <chr>    <chr> 
#> 1 wu-irrigation-cu    Crop Irrigation Consumptive Water-Use Mod… 2000-01  2020-…
#> 2 wu-irrigation-wd    Crop Irrigation Withdrawals Water-Use Mod… 2000-01  2020-…
#> 3 wu-public-supply-cu Public Supply Consumptive Water-Use Model  2009-01  2020-…
#> 4 wu-public-supply-wd Public Supply Withdrawals Water-Use Model  2000-01  2020-…
#> 5 wu-thermoelectric   Thermoelectric Power Water-Use Model       2008-01  2020-…
```
