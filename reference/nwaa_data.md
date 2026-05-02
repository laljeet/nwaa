# Download NWAA model output (generic)

Download NWAA model output (generic)

## Usage

``` r
nwaa_data(
  model_id,
  variable_ids,
  location_type,
  location_id,
  time_res = "monthly",
  range = c("recent", "historical", "custom"),
  start = NULL,
  end = NULL,
  intersection = NULL,
  skip = 0,
  format = "csv",
  quiet = TRUE
)
```

## Arguments

- model_id:

  Model ID. See
  [`nwaa_wu_models`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

- variable_ids:

  One or more variable IDs. See
  [`nwaa_wu_variables`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md).

- location_type:

  One of
  [`nwaa_location_types`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md)\$type.

- location_id:

  Identifier for the selected location type.

- time_res:

  "monthly", "annualwy", "annualcy".

- range:

  "recent", "historical", "custom".

- start, end:

  For range = "custom".

- intersection:

  Optional, e.g. "overlap" or "envelop".

- skip:

  Record offset for paging.

- format:

  "csv", "json", or "geojson".

- quiet:

  If FALSE, prints request URL and content type.

## Value

Parsed data: tibble for csv, list for json, sf object for geojson.
