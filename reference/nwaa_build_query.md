# Build query parameters for NWAA data endpoint

Build query parameters for NWAA data endpoint

## Usage

``` r
nwaa_build_query(
  model,
  variables,
  location,
  format = c("csv", "json", "geojson"),
  ...
)
```

## Arguments

- model:

  Model ID.

- variables:

  One or more variable IDs.

- location:

  Location string like "countycd:06029".

- format:

  Output format: "csv", "json", or "geojson".

- ...:

  Additional query parameters accepted by the API.

## Value

Named list of query parameters.
