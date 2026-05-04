# Changelog

## nwaa 0.1.0

Initial release.

### Features

- Programmatic R interface to the USGS National Water Availability
  Assessment (NWAA) Data Companion web service.
- Coverage of all eight currently published NWAA models across three
  families.
  - Water Use: irrigation withdrawals (`wu-irrigation-wd`), irrigation
    consumptive use (`wu-irrigation-cu`), public supply withdrawals
    (`wu-public-supply-wd`), public supply consumptive use
    (`wu-public-supply-cu`), thermoelectric (`wu-thermoelectric`).
  - Water Quantity: atmospheric forcing WRF CONUS404-BA
    (`wqn-conus404-ba`), hydrologic ensemble NHM-PRMS plus WRF-Hydro
    (`wqn-ensemble-conus-nwaa-v1`).
  - Integrated Water Availability: water budget assessment with surface
    water supply and use index (`iwa-assessment-outputs-conus-2025`).
- Family-organized wrappers:
  [`nwaa_water_use()`](https://laljeet.github.io/nwaa/reference/nwaa_water_use.md),
  [`nwaa_atmos()`](https://laljeet.github.io/nwaa/reference/nwaa_atmos.md),
  [`nwaa_hydro()`](https://laljeet.github.io/nwaa/reference/nwaa_hydro.md),
  [`nwaa_iwa()`](https://laljeet.github.io/nwaa/reference/nwaa_iwa.md).
- Unified catalog
  [`nwaa_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
  listing every model, variable, unit, period of record, and supported
  temporal resolutions.
- Request validation against the catalog before any network call.
  Invalid model IDs, variables incompatible with a model, and
  unsupported temporal resolutions all fail fast with readable messages.
- Location specification by Hydrologic Unit Code at HUC2, HUC4, HUC6,
  HUC8, HUC10, or HUC12 resolution, by lowercase two-letter state
  abbreviation (`statecd`), or by five-digit county FIPS code
  (`countycd`). Polygon selectors return HUC12 results aggregated
  server-side.
- Polygon intersection control through the `intersection` argument:
  `"overlap"` (default, includes any HUC12 touching the polygon) and
  `"envelop"` (HUC12s at least 98% inside).
- Three date-range modes through the `range` argument: `"recent"` (most
  recent timepoint), `"historical"` (full published period of record),
  and `"custom"` (user-supplied `start` and `end`).
- Temporal resolution support reflects what the upstream USGS READMEs
  document. Water Use models support `monthly`, `annualcy` (calendar
  year), and `annualwy` (water year). Water Quantity and Integrated
  Water Availability models are documented as monthly products and the
  catalog reflects that; users wanting annual rollups can aggregate the
  monthly response client-side.
- Output formats: CSV (default), JSON, and GeoJSON.

### Documentation

- Two vignettes:
  [`vignette("nwaa")`](https://laljeet.github.io/nwaa/articles/nwaa.md)
  for getting started and
  [`vignette("water-use")`](https://laljeet.github.io/nwaa/articles/water-use.md)
  for a full Water Use walkthrough.
- pkgdown site at <https://laljeet.github.io/nwaa/>.

### Testing

- Test suite covering catalog structure, request validation, query
  construction, location resolution, date-range resolution including the
  USGS Water Year convention, and end-to-end fetch behavior.
- Offline test suite using httptest2 fixtures recorded against the live
  API, so `R CMD check` does not require network access.
- Continuous integration via GitHub Actions covering Ubuntu, macOS, and
  Windows on R release, devel, and oldrel-1.
