# Tests for nwaa_catalog().
#
# Expected values come from the upstream USGS README files in
# data-raw/readme data files/, NOT from re-running the implementation.
# See test-resolve-range.R for the same philosophy applied to date logic.

test_that("nwaa_catalog returns 8 models across 3 families", {
  cat <- nwaa_catalog()

  expect_s3_class(cat, "tbl_df")
  expect_equal(nrow(cat), 8)
  expect_setequal(unique(cat$family), c("wu", "wqn", "iwa"))
  expect_equal(sum(cat$family == "wu"), 5)
  expect_equal(sum(cat$family == "wqn"), 2)
  expect_equal(sum(cat$family == "iwa"), 1)
})

test_that("nwaa_catalog has the expected columns", {
  cat <- nwaa_catalog()
  expected_cols <- c(
    "model_id", "model_label", "family",
    "start_ym", "end_ym", "temporal",
    "variables", "variable_name", "units"
  )
  expect_setequal(names(cat), expected_cols)
})

test_that("nwaa_catalog list-column lengths align within each row", {
  cat <- nwaa_catalog()
  for (i in seq_len(nrow(cat))) {
    n_vars <- length(cat$variables[[i]])
    expect_equal(
      length(cat$variable_name[[i]]), n_vars,
      info = paste0("variable_name length mismatch for ", cat$model_id[i])
    )
    expect_equal(
      length(cat$units[[i]]), n_vars,
      info = paste0("units length mismatch for ", cat$model_id[i])
    )
  }
})

test_that("known WU models have stable identifiers and dates", {
  cat <- nwaa_catalog()
  expected_wu_ids <- c(
    "wu-irrigation-cu", "wu-irrigation-wd",
    "wu-public-supply-cu", "wu-public-supply-wd",
    "wu-thermoelectric"
  )
  expect_setequal(cat$model_id[cat$family == "wu"], expected_wu_ids)

  irrwd <- cat[cat$model_id == "wu-irrigation-wd", ]
  expect_equal(irrwd$start_ym, "2000-01")
  expect_equal(irrwd$end_ym, "2020-12")
  expect_setequal(irrwd$variables[[1]], c("irrwdtot", "irrwdgw", "irrwdsw"))
})

test_that("non-WU model identifiers are present", {
  cat <- nwaa_catalog()
  expect_true("wqn-conus404-ba" %in% cat$model_id)
  expect_true("wqn-ensemble-conus-nwaa-v1" %in% cat$model_id)
  expect_true("iwa-assessment-outputs-conus-2025" %in% cat$model_id)
})

test_that("Water Use models support monthly, annualcy, and annualwy", {
  # WU READMEs explicitly describe annual mean derivation from monthly
  # values for both calendar year and water year aggregations.
  cat <- nwaa_catalog()
  wu_rows <- cat[cat$family == "wu", ]
  for (i in seq_len(nrow(wu_rows))) {
    expect_setequal(
      wu_rows$temporal[[i]],
      c("monthly", "annualcy", "annualwy")
    )
  }
})

test_that("Water Quantity and IWA models are documented as monthly only", {
  # The upstream READMEs for wqn-conus404-ba, wqn-ensemble-conus-nwaa-v1,
  # and iwa-assessment-outputs-conus-2025 only describe monthly outputs.
  # Annual aggregations are not documented for these models. Users who
  # want annual rollups should aggregate the monthly response client-side.
  cat <- nwaa_catalog()
  monthly_only_models <- c(
    "wqn-conus404-ba",
    "wqn-ensemble-conus-nwaa-v1",
    "iwa-assessment-outputs-conus-2025"
  )
  for (m in monthly_only_models) {
    row <- cat[cat$model_id == m, ]
    expect_equal(
      row$temporal[[1]], "monthly",
      info = paste0(m, " temporal column should be 'monthly' only")
    )
  }
})

test_that("date strings are well-formed YYYY-MM", {
  cat <- nwaa_catalog()
  for (col in c("start_ym", "end_ym")) {
    expect_true(
      all(grepl("^[0-9]{4}-[0-9]{2}$", cat[[col]])),
      info = paste("Bad", col, "format")
    )
  }
})

test_that("IWA units include verified mm/mo suffixes for non-sui variables", {
  cat <- nwaa_catalog()
  iwa <- cat[cat$model_id == "iwa-assessment-outputs-conus-2025", ]
  vars <- iwa$variables[[1]]
  units <- iwa$units[[1]]
  expect_equal(units[vars == "sui"], "frac")
  expect_equal(units[vars == "availab"], "mm/mo")
  expect_equal(units[vars == "strflow"], "mm/mo")
  expect_equal(units[vars == "consum"], "mm/mo")
})

test_that("atmospheric model has precip in mm/mo per the README", {
  cat <- nwaa_catalog()
  atm <- cat[cat$model_id == "wqn-conus404-ba", ]
  vars <- atm$variables[[1]]
  units <- atm$units[[1]]
  expect_equal(vars, "precip")
  expect_equal(units, "mm/mo")
})

test_that("WU catalog window matches upstream README dates", {
  # Derived from data-raw/readme data files/ for each WU model.
  cat <- nwaa_catalog()
  expected <- list(
    "wu-irrigation-cu"    = c("2000-01", "2020-12"),
    "wu-irrigation-wd"    = c("2000-01", "2020-12"),
    "wu-public-supply-cu" = c("2009-01", "2020-12"),
    "wu-public-supply-wd" = c("2000-01", "2020-12"),
    "wu-thermoelectric"   = c("2008-01", "2020-12")
  )
  for (m in names(expected)) {
    row <- cat[cat$model_id == m, ]
    expect_equal(row$start_ym, expected[[m]][1], info = m)
    expect_equal(row$end_ym,   expected[[m]][2], info = m)
  }
})
