# State abbreviations for use with location_type = "statecd"

The NWAA API uses lowercase 2-letter state abbreviations (example:
`"ca"`, `"al"`). This helper returns a lookup between full state names
and the lowercase abbreviation expected by the API.

## Usage

``` r
nwaa_statecd()
```

## Value

A tibble with columns `state_name` and `statecd`.

## Examples

``` r
nwaa_statecd()
#> # A tibble: 50 × 2
#>    state_name  statecd
#>    <chr>       <chr>  
#>  1 Alabama     al     
#>  2 Alaska      ak     
#>  3 Arizona     az     
#>  4 Arkansas    ar     
#>  5 California  ca     
#>  6 Colorado    co     
#>  7 Connecticut ct     
#>  8 Delaware    de     
#>  9 Florida     fl     
#> 10 Georgia     ga     
#> # ℹ 40 more rows
```
