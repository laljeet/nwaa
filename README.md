# nwaa R Package

**nwaa** downloads **USGS National Water Availability Assessment (NWAA) Data Companion** outputs using the NWAA web service.

Current scope: **Water Use models**.

## Installation

```r
install.packages("remotes")
remotes::install_github("laljeet/nwaa")
```

# Quick start

```r
library(nwaa)

# List available Water Use models and date ranges
nwaa_wu_models()

# List variables for a model
nwaa_wu_variables("wu-irrigation-wd")
```
# Example: Kern County, California (FIPS 06029)
```r
library(dplyr)

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
  format = "csv",
  quiet = FALSE
)

glimpse(df)
```

# Location inputs

Use 'location_type' plus a matching 'location_id'.

Common patterns:

- countycd: 5-digit county FIPS, for example 06029

- statecd: 2-letter state abbreviation (lowercase), for example ca

- huc12: 12-digit HUC code, for example 180300010602

USGS HUC resources:
https://water.usgs.gov/themes/hydrologic-units/#national-water-availability-assessment-snapshot

# Intersection behavior

For polygon selectors like counties and states:

- intersection = "overlap" includes HUC12s that overlap the polygon.

- intersection = "envelop" includes HUC12s that are at least 98% within the polygon.


# Time resolution and date ranges

- time_res = "monthly" expects start and end like 2018-01.

- time_res = "annualwy" and time_res = "annualcy" expect start and end like 2018.

# Data sources

Use the USGS NWAA Data Companion.

- [NWAA Data Companion](https://water.usgs.gov/nwaa-data/)
- [Subset and Download Tool](https://water.usgs.gov/nwaa-data/subset/)
- [Web services documentation](https://water.usgs.gov/nwaa-data/web-services/)
