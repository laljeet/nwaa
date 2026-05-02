# Resolve date range for a model

Returns the start and end date strings to send to the NWAA API for a
given model and date-range mode. Used internally by
[`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md)
and
[`nwaa_data`](https://laljeet.github.io/nwaa/reference/nwaa_data.md);
can also be called directly to inspect what dates a request would use.

## Usage

``` r
nwaa_resolve_range(
  model_id,
  range = c("recent", "historical", "custom"),
  temporal = "monthly",
  start = NULL,
  end = NULL
)
```

## Arguments

- model_id:

  Water Use model id. See
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

- range:

  One of `"recent"`, `"historical"`, or `"custom"`.

  - `"recent"`: returns the model's most recent timepoint.

  - `"historical"`: returns the full available period.

  - `"custom"`: returns `start` and `end` as supplied.

- temporal:

  Temporal resolution: `"monthly"`, `"annualwy"`, or `"annualcy"`.

- start:

  Optional custom start. Monthly `"YYYY-MM"`, annual `"YYYY"`. Used only
  when `range = "custom"`.

- end:

  Optional custom end. Same format as `start`. Used only when
  `range = "custom"`.

## Value

A named list with elements `startDate` and `endDate`.

## Examples

``` r
nwaa_resolve_range("wu-irrigation-wd", range = "historical",
                   temporal = "annualwy")
#> $startDate
#> [1] "2001"
#> 
#> $endDate
#> [1] "2020"
#> 
nwaa_resolve_range("wu-irrigation-wd", range = "recent",
                   temporal = "monthly")
#> $startDate
#> [1] "2020-12"
#> 
#> $endDate
#> [1] "2020-12"
#> 
nwaa_resolve_range("wu-irrigation-wd", range = "custom",
                   temporal = "annualwy",
                   start = "2010", end = "2020")
#> $startDate
#> [1] "2010"
#> 
#> $endDate
#> [1] "2020"
#> 
```
