# nwaa

<!-- badges: start -->
[![R-CMD-check](https://github.com/laljeet/nwaa/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/laljeet/nwaa/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/laljeet/nwaa/graph/badge.svg)](https://app.codecov.io/gh/laljeet/nwaa)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

**nwaa** downloads outputs from the **USGS National Water Availability Assessment (NWAA) Data Companion** web services. It covers all three NWAA model families:

- **Water Use** (`wu`): irrigation, public supply, thermoelectric, withdrawals and consumptive use
- **Water Quantity** (`wqn`): atmospheric forcing (WRF CONUS404-BA precipitation), hydrologic ensemble (NHM-PRMS and WRF-Hydro) outputs
- **Integrated Water Availability** (`iwa`): national water-budget assessment outputs and the surface water supply and use index (SUI)

All model outputs are returned at HUC12 resolution.

## Installation

```r
# install.packages("remotes")
remotes::install_github("laljeet/nwaa")
```

## Quick start

```r
library(nwaa)

# Discover all 8 models across all 3 families
nwaa_catalog()

# Or scope to one family
nwaa_wu_models()
nwaa_wu_variables("wu-irrigation-wd")
```

## Examples

### Water use: irrigation withdrawals for a county

```r
df <- nwaa_water_use(
  model_id = "wu-irrigation-wd",
  variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
  location_type = "countycd",
  location_id = "06029",
  time_res = "annualwy",
  range = "custom",
  start = "2001",
  end = "2020",
  intersection = "overlap",
  format = "csv"
)
```

### Atmospheric: monthly precipitation for a HUC12

```r
df <- nwaa_atmos(
  variable_ids = "precip",
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "monthly",
  range = "custom",
  start = "2020-01",
  end = "2020-12"
)
```

### Hydrologic: evapotranspiration and snow water equivalent

```r
df <- nwaa_hydro(
  variable_ids = c("actet", "swe"),
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "monthly",
  range = "historical"
)
```

### Integrated water availability: SUI and water budget

```r
df <- nwaa_iwa(
  variable_ids = c("sui", "availab", "strflow", "consum"),
  location_type = "huc12",
  location_id = "180300010602",
  time_res = "monthly",
  range = "custom",
  start = "2018-01",
  end = "2020-09"
)
```

## Location inputs

Use `location_type` plus a matching `location_id`:

| `location_type` | `location_id` example | Notes |
|---|---|---|
| `countycd` | `"06029"` | 5-digit county FIPS |
| `statecd`  | `"ca"` | 2-letter state abbreviation, lowercase |
| `huc2`–`huc12` | `"180300010602"` | Hydrologic unit codes, 2 to 12 digits |

For polygon selectors (state, county): `intersection = "overlap"` includes HUC12s that touch the polygon, `intersection = "envelop"` includes only HUC12s that are at least 98% inside.

USGS HUC resources: <https://water.usgs.gov/themes/hydrologic-units/#national-water-availability-assessment-snapshot>

## Time resolution and date ranges

All families accept three temporal resolutions:

- `time_res = "monthly"` — `start`/`end` formatted `"YYYY-MM"`
- `time_res = "annualwy"` — water year (Oct-Sep), `start`/`end` formatted `"YYYY"`
- `time_res = "annualcy"` — calendar year (Jan-Dec), `start`/`end` formatted `"YYYY"`

`range` can be `"recent"` (most recent timepoint), `"historical"` (full available period), or `"custom"` (you supply `start` and `end`).

## Data sources

- [NWAA Data Companion](https://water.usgs.gov/nwaa-data/)
- [Subset and Download Tool](https://water.usgs.gov/nwaa-data/subset/)
- [Web services documentation](https://water.usgs.gov/nwaa-data/web-services/)

## Citation

If you use this package in published work, please cite both the package and the underlying USGS data. Run `citation("nwaa")` in R for the package citation. See the [NWAA Data Companion](https://water.usgs.gov/nwaa-data/) for the data citation.
