# Fetch NWAA data

Fetch NWAA data

## Usage

``` r
nwaa_get_data(query, quiet = TRUE)
```

## Arguments

- query:

  Query list from nwaa_build_query()

- quiet:

  If FALSE, prints URL and content-type

## Value

tibble for csv, list for json, sf object for geojson if sf installed
