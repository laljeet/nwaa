# Build an NWAA location string

Build an NWAA location string

## Usage

``` r
nwaa_location(type, id, validate = TRUE)
```

## Arguments

- type:

  Location type used by NWAA, see nwaa_location_types().

- id:

  Location identifier for that type.

- validate:

  If TRUE, checks type against nwaa_location_types().

## Value

A string like "type:id".
