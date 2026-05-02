#' NWAA model catalog
#'
#' Master catalog of all NWAA Data Companion models supported by this package,
#' across all three families:
#' \itemize{
#'   \item \code{wu} (Water Use): irrigation, public supply, thermoelectric.
#'   \item \code{wqn} (Water Quantity): atmospheric forcing, hydrologic ensemble.
#'   \item \code{iwa} (Integrated Water Availability): water-budget assessment.
#' }
#'
#' Each row describes one model: its identifier, label, family, the variable
#' IDs it produces, the units those variables are reported in (units appear
#' as a suffix on column names in API responses, e.g. \code{irrwdtot_mgd}),
#' the start and end of available data, and the temporal resolutions the
#' model is published at.
#'
#' This catalog is the single source of truth used internally by
#' \code{\link{nwaa_resolve_range}} and the family-specific helper functions
#' (\code{\link{nwaa_wu_models}}, \code{\link{nwaa_wu_variables}}).
#'
#' @section Caveats:
#' Unit suffixes for the hydrologic ensemble model
#' (\code{wqn-ensemble-conus-nwaa-v1}) are inferred from the upstream
#' README, which explicitly documents only \code{actet_mm/mo}. The
#' remaining variable units recorded here (\code{mm/mo} for water-flux
#' variables, \code{mm} for snow water equivalent, \code{frac} for
#' soil-moisture fraction) should be verified against an actual API
#' response if precision matters. The actual unit suffix is always
#' returned as part of the column name in API responses.
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
      # Per the official NWAA Subset and Download Tool, all three families
      # accept monthly, annual-water-year, and annual-calendar-year
      # aggregations. Annual outputs are aggregated server-side from monthly
      # source data.
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy"),
      c("monthly", "annualcy", "annualwy")
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
      # Atmospheric: precip in mm/month per README example
      c("mm/mo"),
      # Hydrologic ensemble: water-flux variables in mm/mo, swe in mm,
      # soilmstfr is unitless fraction. README documents only the actet_mm/mo
      # convention; the exact column suffixes for other variables should be
      # confirmed against an actual API response.
      c("mm/mo", "mm/mo", "mm/mo", "mm", "frac", "mm/mo"),
      # IWA: README only documents sui_frac. The other three variables come
      # back from the API as availab_mm/mo, strflow_mm/mo, consum_mm/mo
      # (confirmed by querying the API directly).
      c("frac", "mm/mo", "mm/mo", "mm/mo")
    )
  )
}
