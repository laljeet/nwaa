# Intersection types for polygon selectors

Used when `location_type` selects a polygon extent (example: `"statecd"`
or `"countycd"`). The API returns HUC12s, and `intersection` controls
which HUC12s count as "inside".

## Usage

``` r
nwaa_intersection_types()
```

## Value

A tibble with intersection codes and meanings.

## Examples

``` r
nwaa_intersection_types()
#> # A tibble: 2 × 2
#>   intersection meaning                                                       
#>   <chr>        <chr>                                                         
#> 1 overlap      Include all HUC12s that have any part within the boundary.    
#> 2 envelop      Include only HUC12s that are at least 98% within the boundary.
```
