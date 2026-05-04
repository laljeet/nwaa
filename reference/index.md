# Package index

## Catalog and discovery

Inspect available models, variables, and supported codes.

- [`nwaa_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
  : NWAA model catalog
- [`nwaa_wu_models()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md)
  : List Water Use models and their available date ranges
- [`nwaa_wu_variables()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_variables.md)
  : List variables for a Water Use model
- [`nwaa_statecd()`](https://laljeet.github.io/nwaa/reference/nwaa_statecd.md)
  : State abbreviations for use with location_type = "statecd"
- [`nwaa_intersection_types()`](https://laljeet.github.io/nwaa/reference/nwaa_intersection_types.md)
  : Intersection types for polygon selectors
- [`nwaa_location_types()`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md)
  : List valid location types used by the NWAA API

## Water Use

Sectoral water use models (irrigation, public supply, thermoelectric)
for both withdrawals and consumptive use.

- [`nwaa_water_use()`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md)
  : Download Water Use model output from the NWAA Data Companion

## Water Quantity

Atmospheric forcing and hydrologic ensemble models.

- [`nwaa_atmos()`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md)
  : Download Atmospheric Forcing model output (WRF CONUS404-BA)
- [`nwaa_hydro()`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md)
  : Download Hydrologic Model Ensemble output (NHM-PRMS and WRF-Hydro)

## Integrated Water Availability

Water budget and surface water supply and use index.

- [`nwaa_iwa()`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md) :
  Download Integrated Water Availability Assessment outputs

## Lower-level interface

Send a pre-built query directly. Most users should use the family
wrappers above.

- [`nwaa_get_data()`](https://laljeet.github.io/nwaa/reference/nwaa_get_data.md)
  : Fetch NWAA data
