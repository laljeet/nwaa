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

test_that("all models support all three temporal resolutions", {
  cat <- nwaa_catalog()
  for (i in seq_len(nrow(cat))) {
    expect_setequal(
      cat$temporal[[i]],
      c("monthly", "annualcy", "annualwy")
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

test_that("nwaa_wu_catalog is a backwards-compatible filtered view", {
  wu <- nwaa_wu_catalog()
  expected_cols <- c(
    "model_id", "model_label",
    "start_ym", "end_ym",
    "variables", "units", "variable_name"
  )
  expect_equal(names(wu), expected_cols)
  expect_equal(nrow(wu), 5)
  expect_true(all(grepl("^wu-", wu$model_id)))
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
