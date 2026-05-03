# nwaa 0.1.0

Initial release.

## Features

* Programmatic R interface to the USGS National Water Availability Assessment (NWAA) Data Companion web service.
* Coverage of all eight currently published NWAA models across three families.
    * Water Use: irrigation, public supply, thermoelectric, domestic self-supply, industrial self-supply.
    * Water Quantity: atmospheric forcing (WRF CONUS404-BA), hydrologic ensemble (NHM-PRMS plus WRF-Hydro).
    * Integrated Water Availability: water budget assessment and surface supply and use index.
* Family-organized wrappers: `nwaa_water_use()`, `nwaa_atmos()`, `nwaa_hydro()`, `nwaa_iwa()`.
* Unified catalog (`nwaa_catalog()`) listing every model, variable, unit, and period of record.
* Request validation against the catalog before any network call.
* Location specification by Hydrologic Unit Code (any length), state code, or county FIPS, with server-side aggregation.
* Date ranges supplied as explicit start and end values or as convenience labels (`"default"`, `"first10"`, `"last10"`).
* Three temporal resolutions for every model: monthly, water-year-annual, calendar-year-annual.
* Output formats: CSV, JSON, and GeoJSON.
* Lower-level helpers (`nwaa_build_query()`, `nwaa_get_data()`) for composing custom workflows.

## Documentation

* Two vignettes: `vignette("nwaa")` for getting started and `vignette("water-use")` for a full Water Use walkthrough.
* pkgdown site at https://laljeet.github.io/nwaa/.

## Testing

* 117 tests across catalog, validation, query construction, location resolution, date range resolution, and end-to-end fetch behavior.
* Offline test suite using httptest2 fixtures recorded against the live API.
* Continuous integration via GitHub Actions covering Ubuntu, macOS, and Windows on R release, devel, and oldrel-1.

## Archive

* Released artifacts archived at https://doi.org/10.5281/zenodo.19984100.
