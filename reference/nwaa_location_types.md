# List valid location types used by the NWAA API

Returns the set of `location_type` values accepted by the API, along
with brief usage notes. The API returns HUC12 results for any selector;
HUC2 through HUC12 act as polygon containers, and `statecd` and
`countycd` also act as polygon containers (use the `intersection`
argument to control inclusion).

## Usage

``` r
nwaa_location_types()
```

## Value

A tibble with columns `type` and `notes`.

## Examples

``` r
nwaa_location_types()
#> # A tibble: 8 × 2
#>   type     notes                                                                
#>   <chr>    <chr>                                                                
#> 1 huc2     Hydrologic unit code (2 digits). Returns HUC12 results within this H…
#> 2 huc4     Hydrologic unit code (4 digits). Returns HUC12 results within this H…
#> 3 huc6     Hydrologic unit code (6 digits). Returns HUC12 results within this H…
#> 4 huc8     Hydrologic unit code (8 digits). Returns HUC12 results within this H…
#> 5 huc10    Hydrologic unit code (10 digits). Returns HUC12 results within this …
#> 6 huc12    Hydrologic unit code (12 digits). Returns results for this HUC12.    
#> 7 statecd  State abbreviation (2-letter), lowercase in the API (example: 'ca', …
#> 8 countycd County code (5-digit FIPS). Use intersection to control which HUC12s…
```
