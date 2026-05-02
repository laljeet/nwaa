# Package index

## Catalog and helpers

Inspect available models, variables, and supported codes.

- [`nwaa_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
  : NWAA model catalog
- [`nwaa_wu_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_catalog.md)
  : Water Use catalog (models, variables, and time ranges)
- [`nwaa_wu_models()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md)
  : List Water Use models and their available date ranges
- [`nwaa_wu_variables()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md)
  : List variables for a Water Use model
- [`nwaa_state_codes()`](https://laljeet.github.io/nwaa/reference/nwaa_state_codes.md)
  : US state codes
- [`nwaa_statecd()`](https://laljeet.github.io/nwaa/reference/nwaa_statecd.md)
  : State abbreviations for use with location_type = "statecd"
- [`nwaa_code_help()`](https://laljeet.github.io/nwaa/reference/nwaa_code_help.md)
  : Help for finding HUC, state, and county codes
- [`nwaa_intersection_types()`](https://laljeet.github.io/nwaa/reference/nwaa_intersection_types.md)
  : Intersection types for polygon selectors
- [`nwaa_location_types()`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md)
  : List valid location types used by the NWAA API

## Water Use

Sectoral water use models (irrigation, public supply, thermoelectric,
domestic, industrial).

- [`nwaa_water_use()`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md)
  : Download Water Use model output from the NWAA Data Companion

## Water Quantity

Atmospheric forcing and hydrologic ensemble models.

- [`nwaa_atmos()`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md)
  : Download Atmospheric Forcing model output (WRF CONUS404-BA)
- [`nwaa_hydro()`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md)
  : Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)

## Integrated Water Availability

Water budget and surface supply and use index.

- [`nwaa_iwa()`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md) :
  Download Integrated Water Availability Assessment outputs

## Lower-level interface

Inspect or build queries directly without going through a family
wrapper.

- [`nwaa_data()`](https://laljeet.github.io/nwaa/reference/nwaa_data.md)
  : Download NWAA model output (generic)
- [`nwaa_build_query()`](https://laljeet.github.io/nwaa/reference/nwaa_build_query.md)
  : Build query parameters for NWAA data endpoint
- [`nwaa_get_data()`](https://laljeet.github.io/nwaa/reference/nwaa_get_data.md)
  : Fetch NWAA data
- [`nwaa_location()`](https://laljeet.github.io/nwaa/reference/nwaa_location.md)
  : Build an NWAA location string
- [`nwaa_resolve_range()`](https://laljeet.github.io/nwaa/reference/nwaa_resolve_range.md)
  : Resolve date range for a model
