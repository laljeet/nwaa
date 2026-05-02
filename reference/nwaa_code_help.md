# Help for finding HUC, state, and county codes

Returns a small reference tibble pointing to USGS resources where
identifiers used by the NWAA API can be looked up.

## Usage

``` r
nwaa_code_help()
```

## Value

A tibble with columns `item`, `where`, and `link`.

## Examples

``` r
nwaa_code_help()
#> # A tibble: 2 × 3
#>   item                       where                                         link 
#>   <chr>                      <chr>                                         <chr>
#> 1 HUC codes                  Use USGS hydrologic units resources and map … http…
#> 2 State and county dropdowns Use the NWAA Subset and Download Tool dropdo… http…
```
