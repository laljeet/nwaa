# Changelog

## nwaa 0.1.0

Initial release.

### Features

- Programmatic R interface to the USGS National Water Availability
  Assessment (NWAA) Data Companion web service.
- Coverage of all eight currently published NWAA models across three
  families.
  - Water Use: irrigation, public supply, thermoelectric, domestic
    self-supply, industrial self-supply.
  - Water Quantity: atmospheric forcing (WRF CONUS404-BA), hydrologic
    ensemble (NHM-PRMS plus WRF-Hydro).
  - Integrated Water Availability: water budget assessment and surface
    supply and use index.
- Family-organized wrappers:
  [`nwaa_water_use()`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
  [`nwaa_atmos()`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
  [`nwaa_hydro()`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
  [`nwaa_iwa()`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md).
- Unified catalog
  ([`nwaa_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md))
  listing every model, variable, unit, and period of record.
- Request validation against the catalog before any network call.
- Location specification by Hydrologic Unit Code (any length), state
  code, or county FIPS, with server-side aggregation.
- Date ranges supplied as explicit start and end values or as
  convenience labels (`"default"`, `"first10"`, `"last10"`).
- Three temporal resolutions for every model: monthly,
  water-year-annual, calendar-year-annual.
- Output formats: CSV, JSON, and GeoJSON.
- Lower-level helpers
  ([`nwaa_build_query()`](https://laljeet.github.io/nwaa/reference/nwaa_build_query.md),
  [`nwaa_get_data()`](https://laljeet.github.io/nwaa/reference/nwaa_get_data.md))
  for composing custom workflows.

### Documentation

- Two vignettes:
  [`vignette("nwaa")`](https://laljeet.github.io/nwaa/articles/nwaa.md)
  for getting started and
  [`vignette("water-use")`](https://laljeet.github.io/nwaa/articles/water-use.md)
  for a full Water Use walkthrough.
- pkgdown site at <https://laljeet.github.io/nwaa/>.

### Testing

- 117 tests across catalog, validation, query construction, location
  resolution, date range resolution, and end-to-end fetch behavior.
- Offline test suite using httptest2 fixtures recorded against the live
  API.
- Continuous integration via GitHub Actions covering Ubuntu, macOS, and
  Windows on R release, devel, and oldrel-1.

### Archive

- Released artifacts archived at
  <https://doi.org/10.5281/zenodo.19984100>.
