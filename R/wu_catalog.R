#' Water Use catalog (models, variables, and time ranges)
#'
#' @return A tibble describing Water Use models.
#' @export
nwaa_wu_catalog <- function() {
  tibble::tibble(
    model_id = c(
      "wu-irrigation-cu",
      "wu-irrigation-wd",
      "wu-public-supply-cu",
      "wu-public-supply-wd",
      "wu-thermoelectric"
    ),
    model_label = c(
      "Crop Irrigation Consumptive Water-Use Model",
      "Crop Irrigation Withdrawals Water-Use Model",
      "Public Supply Consumptive Water-Use Model",
      "Public Supply Withdrawals Water-Use Model",
      "Thermoelectric Power Water-Use Model"
    ),
    start_ym = c("2000-01", "2000-01", "2009-01", "2000-01", "2008-01"),
    end_ym   = c("2020-12", "2020-12", "2020-12", "2020-12", "2020-12"),
    variables = list(
      c("irrcutot"),
      c("irrwdtot", "irrwdgw", "irrwdsw"),
      c("pscutot"),
      c("pswdtot", "pswdgw", "pswdsw"),
      c("tecufgw", "tecufsw", "tecuftot", "tewdfgw", "tewdfsw", "tewdftot", "tewdssw")
    ),
    units = list(
      c("mgd"),
      c("mgd", "mgd", "mgd"),
      c("mgd"),
      c("mgd", "mgd", "mgd"),
      c("mgd", "mgd", "mgd", "mgd", "mgd", "mgd", "mgd")
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
        "Thermoelectric saline surface-water withdrawals")
    )
  )
}
