# List variables for a Water Use model

Looks up one Water Use model in
[`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
and returns a long-form tibble of its variable IDs, units, and
human-readable names.

## Usage

``` r
nwaa_wu_variables(model_id)
```

## Arguments

- model_id:

  A Water Use model ID. See
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

## Value

A tibble with one row per variable. Columns: `model_id`, `variable_id`,
`unit`, `variable_name`.

## Examples

``` r
nwaa_wu_variables("wu-irrigation-wd")
#> # A tibble: 3 × 4
#>   model_id         variable_id unit  variable_name                            
#>   <chr>            <chr>       <chr> <chr>                                    
#> 1 wu-irrigation-wd irrwdtot    mgd   Crop irrigation total withdrawals        
#> 2 wu-irrigation-wd irrwdgw     mgd   Crop irrigation groundwater withdrawals  
#> 3 wu-irrigation-wd irrwdsw     mgd   Crop irrigation surface-water withdrawals
```
