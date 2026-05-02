# Water Use catalog (models, variables, and time ranges)

Returns rows from
[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
restricted to the Water Use (`wu`) family. Provided for backwards
compatibility and convenience.

## Usage

``` r
nwaa_wu_catalog()
```

## Value

A tibble with one row per Water Use model. Columns: `model_id`,
`model_label`, `start_ym`, `end_ym`, `variables` (list-column), `units`
(list-column), `variable_name` (list-column).

## Examples

``` r
nwaa_wu_catalog()
#> # A tibble: 5 × 7
#>   model_id            model_label  start_ym end_ym variables units variable_name
#>   <chr>               <chr>        <chr>    <chr>  <list>    <lis> <list>       
#> 1 wu-irrigation-cu    Crop Irriga… 2000-01  2020-… <chr [1]> <chr> <chr [1]>    
#> 2 wu-irrigation-wd    Crop Irriga… 2000-01  2020-… <chr [3]> <chr> <chr [3]>    
#> 3 wu-public-supply-cu Public Supp… 2009-01  2020-… <chr [1]> <chr> <chr [1]>    
#> 4 wu-public-supply-wd Public Supp… 2000-01  2020-… <chr [3]> <chr> <chr [3]>    
#> 5 wu-thermoelectric   Thermoelect… 2008-01  2020-… <chr [7]> <chr> <chr [7]>    
```
