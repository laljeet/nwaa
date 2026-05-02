# List variables for a Water Use model

List variables for a Water Use model

## Usage

``` r
nwaa_wu_variables(model_id)
```

## Arguments

- model_id:

  A Water Use model ID from
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

## Value

A tibble with variable IDs and units.

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
