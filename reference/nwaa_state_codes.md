# US state codes

Convenience tibble of US state names and 2-letter abbreviations, sourced
from the base R
[`datasets::state.name`](https://rdrr.io/r/datasets/state.html) and
[`datasets::state.abb`](https://rdrr.io/r/datasets/state.html) vectors.

## Usage

``` r
nwaa_state_codes()
```

## Value

A tibble with columns `state_name` and `state_abbr`.

## Examples

``` r
nwaa_state_codes()
#> # A tibble: 50 × 2
#>    state_name  state_abbr
#>    <chr>       <chr>     
#>  1 Alabama     AL        
#>  2 Alaska      AK        
#>  3 Arizona     AZ        
#>  4 Arkansas    AR        
#>  5 California  CA        
#>  6 Colorado    CO        
#>  7 Connecticut CT        
#>  8 Delaware    DE        
#>  9 Florida     FL        
#> 10 Georgia     GA        
#> # ℹ 40 more rows
```
