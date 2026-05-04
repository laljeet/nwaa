# Resolve date range for a model

Returns the start and end date strings to send to the NWAA API for a
given model and date-range mode. Used internally by the family wrappers
([`nwaa_water_use`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
[`nwaa_atmos`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
[`nwaa_hydro`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
[`nwaa_iwa`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md)). Can
be called directly to inspect what dates a request would use.

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

  Any model id from
  [`nwaa_catalog`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md).

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

## Water year convention

USGS Water Years run from October 1 of one calendar year through
September 30 of the following calendar year, and are labeled by their
ending calendar year. Water Year 2020 covers October 1, 2019 through
September 30, 2020.

For a catalog start month of October through December, the catalog start
is the first day of WY (start_year + 1). For January through September,
the catalog start lies inside WY start_year and the next clean water
year begins the following October, also labeled WY (start_year + 1).
Either way, the first complete water year in the data is labeled
`start_year + 1`.

For the end of the catalog window, a clean water year ends on September
30. If the catalog end month is September the last complete WY is
end_year. Otherwise end_year is partial and the last complete WY is
`end_year - 1`.

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
