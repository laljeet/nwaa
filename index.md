# nwaa

`nwaa` is an R interface to the U.S. Geological Survey National Water
Availability Assessment (NWAA) Data Companion web service. The package
covers all eight currently published NWAA models across three families:
Water Use (irrigation, public supply, thermoelectric — withdrawals and
consumptive use), Water Quantity (atmospheric forcing, hydrologic
ensemble), and Integrated Water Availability. Outputs are returned at
HUC12 spatial resolution as tibbles, with optional aggregation to state
or county boundaries handled server side.

## Installation

``` r

# From GitHub
install.packages("remotes")
remotes::install_github("laljeet/nwaa")

# From CRAN (once accepted)
# install.packages("nwaa")
```

## Quick start

``` r

library(nwaa)

# Inspect what's available
nwaa_catalog()

# Variables for a specific Water Use model
nwaa_wu_variables("wu-irrigation-wd")
```

## The eight models

| Family | Model ID | Description |
|----|----|----|
| Water Use | `wu-irrigation-wd` | Crop irrigation withdrawals |
| Water Use | `wu-irrigation-cu` | Crop irrigation consumptive use |
| Water Use | `wu-public-supply-wd` | Public supply withdrawals |
| Water Use | `wu-public-supply-cu` | Public supply consumptive use |
| Water Use | `wu-thermoelectric` | Thermoelectric power water use |
| Water Quantity | `wqn-conus404-ba` | Atmospheric forcing (WRF CONUS404-BA) |
| Water Quantity | `wqn-ensemble-conus-nwaa-v1` | Hydrologic ensemble (NHM-PRMS + WRF-Hydro) |
| Integrated | `iwa-assessment-outputs-conus-2025` | Integrated water availability |

## Examples by family

### Water Use

``` r

library(nwaa)
library(dplyr)

# Irrigation withdrawals across Kern County, annual water-year totals
irr <- nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = c("irrwdgw", "irrwdsw", "irrwdtot"),
  location_type = "countycd",
  location_id   = "06029",
  time_res      = "annualwy",
  range         = "custom",
  start         = "2001",
  end           = "2020",
  intersection  = "overlap",
  format        = "csv"
)

glimpse(irr)
```

### Atmospheric forcing

``` r

# Monthly precipitation for a HUC8 over a single year
precip <- nwaa_atmos(
  variable_ids  = "precip",
  location_type = "huc8",
  location_id   = "18030012",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)

glimpse(precip)
```

### Hydrologic ensemble

``` r

# Baseflow, quickflow, and actual ET, full historical period
hydro <- nwaa_hydro(
  variable_ids  = c("incbsflow", "incqkflow", "actet"),
  location_type = "huc8",
  location_id   = "18030012",
  time_res      = "annualwy",
  range         = "historical"
)

glimpse(hydro)
```

### Integrated water availability

``` r

# Surface use index, water availability, streamflow, and consumption
iwa <- nwaa_iwa(
  variable_ids  = c("sui", "availab", "strflow", "consum"),
  location_type = "huc8",
  location_id   = "18030012",
  time_res      = "monthly",
  range         = "custom",
  start         = "2020-01",
  end           = "2020-12"
)

glimpse(iwa)
```

## Location inputs

Every query takes a `location_type` and a matching `location_id`.
Supported types come from
[`nwaa_location_types()`](https://laljeet.github.io/nwaa/reference/nwaa_location_types.md):

| `location_type` | `location_id` example | Notes |
|----|----|----|
| `huc2` | `18` | Returns HUC12 results within this HUC |
| `huc4` | `1803` | Returns HUC12 results within this HUC |
| `huc6` | `180300` | Returns HUC12 results within this HUC |
| `huc8` | `18030012` | Returns HUC12 results within this HUC |
| `huc10` | `1803001206` | Returns HUC12 results within this HUC |
| `huc12` | `180300010602` | Returns results for this HUC12 |
| `statecd` | `ca` | Two-letter state abbreviation, lowercase |
| `countycd` | `06029` | Five-digit county FIPS |

Note that `statecd` is the postal abbreviation in lowercase, not the
FIPS code. The package validates this for you, but it’s worth flagging
since most R water-data packages use FIPS for both state and county.

## Time resolution and date ranges

Three temporal resolutions are supported through `time_res`:

| `time_res` | Format for `start` and `end`          |
|------------|---------------------------------------|
| `monthly`  | `2018-01`                             |
| `annualwy` | `2018` (water year ending in October) |
| `annualcy` | `2018` (calendar year)                |

The `range` argument accepts three modes:

| `range`      | Behavior                                    |
|--------------|---------------------------------------------|
| `recent`     | Returns the model’s most recent timepoint   |
| `historical` | Returns the full published period of record |
| `custom`     | Use `start` and `end` as supplied           |

Each model’s period of record is in
[`nwaa_catalog()`](https://laljeet.github.io/nwaa/reference/nwaa_catalog.md)
and
[`nwaa_wu_models()`](https://laljeet.github.io/nwaa/reference/nwaa_wu_models.md).

## Intersection behavior

For polygon selectors (counties and states), the `intersection` argument
controls which HUC12s are included:

| `intersection`      | Includes                               |
|---------------------|----------------------------------------|
| `overlap` (default) | HUC12s that overlap the polygon at all |
| `envelop`           | HUC12s at least 98% inside the polygon |

`overlap` is more inclusive at the polygon edges; `envelop` is stricter
and useful when you want to avoid double-counting at boundaries.

## Validation

Requests are validated against the catalog before any network call.
Invalid model IDs, variables incompatible with a model, and unsupported
temporal resolutions all fail fast with readable messages:

``` r

# Errors locally — no network call made
nwaa_water_use(
  model_id      = "wu-irrigation-wd",
  variable_ids  = "precip",       # not a Water Use variable
  location_type = "huc8",
  location_id   = "18030012",
  range         = "historical"
)
```

## Data sources

The package wraps the USGS NWAA Data Companion. Primary references:

- [NWAA Data Companion](https://water.usgs.gov/nwaa-data/)
- [Subset and Download
  Tool](https://water.usgs.gov/nwaa-data/subset-download/)
- [Web services
  documentation](https://water.usgs.gov/nwaa-data/web-services/)
- [USGS Hydrologic
  Units](https://water.usgs.gov/themes/hydrologic-units/)

## Citation

Run `citation("nwaa")` from R, or cite via the Zenodo DOI:

> Sangha, L. (2026). nwaa: An R interface to the USGS National Water
> Availability Assessment Data Companion.
> <https://doi.org/10.5281/zenodo.19984100>

## License

MIT. See [LICENSE.md](https://laljeet.github.io/nwaa/LICENSE.md).
