#' NWAA model catalog
#'
#' Master catalog of all NWAA Data Companion models supported by this package,
#' across all three families:
#' \itemize{
#'   \item \code{wu} (Water Use): irrigation, public supply, thermoelectric.
#'   \item \code{wqn} (Water Quantity): atmospheric forcing, hydrologic ensemble.
#'   \item \code{iwa} (Integrated Water Availability): water budget assessment.
#' }
#'
#' Each row describes one model: its identifier, label, family, the variable
#' IDs it produces, the units those variables are reported in (units appear
#' as a suffix on column names in API responses, e.g. \code{irrwdtot_mgd}),
#' the start and end of available data, and the temporal resolutions the
#' model is published at.
#'
#' This catalog is the single source of truth used internally by request
#' validation and date-range resolution.
#'
#' @section Temporal resolutions:
#' Temporal resolutions per model come from the upstream USGS README files.
#' \itemize{
#'   \item Water Use models: monthly, calendar-year annual (\code{annualcy}),
#'     and water-year annual (\code{annualwy}). The README explicitly
#'     describes annual mean derivation from monthly values.
#'   \item Water Quantity and Integrated Water Availability models:
#'     monthly only. The upstream READMEs describe these products as
#'     monthly. Users who want annual rollups can aggregate the monthly
#'     output client-side.
#' }
#'
#' @section Units verification:
#' Unit suffixes for all variables in this catalog have been verified against
#' actual API responses. The hydrologic ensemble model
#' (\code{wqn-ensemble-conus-nwaa-v1}) was originally inferred from one
#' README example (\code{actet_mm/mo}); a live probe in May 2026 confirmed
#' all six variables match the catalog suffixes. The actual unit suffix is
#' always returned as part of the column name in API responses, so users
#' never need to rely on the catalog for unit information at runtime.
#'
#' @return A tibble with columns:
#'   \describe{
#'     \item{model_id}{API model identifier (string).}
#'     \item{model_label}{Human-readable model name.}
#'     \item{family}{One of \code{"wu"}, \code{"wqn"}, \code{"iwa"}.}
#'     \item{start_ym, end_ym}{Earliest and latest available data, format \code{"YYYY-MM"}.}
#'     \item{temporal}{List-column of supported temporal resolutions: combinations of
#'       \code{"monthly"}, \code{"annualcy"}, \code{"annualwy"}.}
#'     \item{variables}{List-column of variable ID character vectors.}
#'     \item{variable_name}{List-column of human-readable variable names.}
#'     \item{units}{List-column of unit-suffix character vectors aligned to \code{variables}.}
#'   }
#' @export
#' @examples
#' nwaa_catalog()
#'
#' # All Water Use models
#' cat <- nwaa_catalog()
#' cat[cat$family == "wu", c("model_id", "model_label")]
nwaa_catalog <- function() {
  tibble::tibble(
    model_id = c(
      # Water Use family
      "wu-irrigation-cu",
      "wu-irrigation-wd",
      "wu-public-supply-cu",
      "wu-public-supply-wd",
      "wu-thermoelectric",
      # Water Quantity family
      "wqn-conus404-ba",
      "wqn-ensemble-conus-nwaa-v1",
      # Integrated Water Availability family
      "iwa-assessment-outputs-conus-2025"
    ),
    model_label = c(
      "Crop Irrigation Consumptive Water-Use Model",
      "Crop Irrigation Withdrawals Water-Use Model",
      "Public Supply Consumptive Water-Use Model",
      "Public Supply Withdrawals Water-Use Model",
      "Thermoelectric Power Water-Use Model",
      "Atmospheric Forcing Model (WRF CONUS404-BA)",
      "Hydrologic Model Ensemble (NHM-PRMS and WRF-Hydro, CONUS NWAA v1)",
      "National Water Availability Assessment Outputs (CONUS 2025)"
    ),
    family = c(
      "wu", "wu", "wu", "wu", "wu",
      "wqn", "wqn",
      "iwa"
    ),
    start_ym = c(
      "2000-01", "2000-01", "2009-01", "2000-01", "2008-01",
      "1979-10", "2009-10",
      "2009-10"
    ),
    end_ym = c(
      "2020-12", "2020-12", "2020-12", "2020-12", "2020-12",
      "2021-09", "2020-09",
      "2020-09"
    ),
    temporal = list(
      # Water Use: README explicitly documents monthly outputs and an annual
      # mean derivation procedure from monthly values. Annual is supported
      # for both calendar year and water year.
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      # Water Quantity (atmos and hydro ensemble): READMEs document monthly
      # outputs only. Annual rollups are not described in the README and
      # have not been verified against the API. Users requiring annual
      # totals should aggregate the monthly response client-side.
      c("monthly"),
      c("monthly"),
      # Integrated Water Availability: README documents monthly water budget
      # outputs only. Same client-side aggregation guidance applies.
      c("monthly")
    ),
    variables = list(
      c("irrcutot"),
      c("irrwdtot", "irrwdgw", "irrwdsw"),
      c("pscutot"),
      c("pswdtot", "pswdgw", "pswdsw"),
      c("tecufgw", "tecufsw", "tecuftot",
        "tewdfgw", "tewdfsw", "tewdftot", "tewdssw"),
      c("precip"),
      c("actet", "incbsflow", "incqkflow", "swe", "soilmstfr", "incrunoff"),
      c("sui", "availab", "strflow", "consum")
    ),
    variable_name = list(
      c("Crop irrigation total consumptive use"),
      c("Crop irrigation total withdrawals",
        "Crop irrigation groundwater withdrawals",
        "Crop irrigation surface-water withdrawals"),
      c("Public supply total consumptive use"),
      c("Public supply total withdrawals",
        "Public supply groundwater withdrawals",
        "Public supply surface-water withdrawals"),
      c("Thermoelectric fresh groundwater consumptive use",
        "Thermoelectric fresh surface-water consumptive use",
        "Thermoelectric fresh water total consumptive use",
        "Thermoelectric fresh groundwater withdrawals",
        "Thermoelectric fresh surface-water withdrawals",
        "Thermoelectric fresh water total withdrawals",
        "Thermoelectric saline surface-water withdrawals"),
      c("Precipitation"),
      c("Actual evapotranspiration",
        "Incremental baseflow",
        "Incremental quickflow",
        "Snow water equivalent",
        "Soil moisture fraction",
        "Incremental runoff"),
      c("Surface water supply and use index",
        "Total water availability",
        "Streamflow",
        "Total water consumption")
    ),
    units = list(
      c("mgd"),
      c("mgd", "mgd", "mgd"),
      c("mgd"),
      c("mgd", "mgd", "mgd"),
      c("mgd", "mgd", "mgd", "mgd", "mgd", "mgd", "mgd"),
      c("mm/mo"),
      c("mm/mo", "mm/mo", "mm/mo", "mm", "frac", "mm/mo"),
      c("frac", "mm/mo", "mm/mo", "mm/mo")
    )
  )
}
