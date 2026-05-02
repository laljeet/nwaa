test_that("validator passes for a valid request", {
  expect_invisible(
    nwaa_validate_request_(
      model_id = "wu-irrigation-wd",
      variable_ids = c("irrwdtot", "irrwdgw"),
      time_res = "annualwy",
      expected_family = "wu"
    )
  )
})

test_that("validator rejects unknown model_id", {
  expect_error(
    nwaa_validate_request_(
      model_id = "garbage",
      variable_ids = "irrwdtot",
      time_res = "monthly"
    ),
    "Unknown model_id"
  )
})

test_that("validator rejects family mismatch", {
  expect_error(
    nwaa_validate_request_(
      model_id = "wu-irrigation-wd",
      variable_ids = "irrwdtot",
      time_res = "monthly",
      expected_family = "wqn"
    ),
    "belongs to family 'wu', not 'wqn'"
  )
})

test_that("validator rejects unknown variables", {
  expect_error(
    nwaa_validate_request_(
      model_id = "wu-irrigation-wd",
      variable_ids = "precipitation",
      time_res = "monthly"
    ),
    "Unknown variable_ids"
  )
})

test_that("validator rejects mixed valid + invalid variables", {
  expect_error(
    nwaa_validate_request_(
      model_id = "iwa-assessment-outputs-conus-2025",
      variable_ids = c("sui", "garbage", "consum"),
      time_res = "monthly"
    ),
    "garbage"
  )
})

test_that("validator rejects unsupported time_res", {
  expect_error(
    nwaa_validate_request_(
      model_id = "wu-irrigation-wd",
      variable_ids = "irrwdtot",
      time_res = "daily"
    ),
    "time_res = 'daily' is not supported"
  )
})

test_that("family wrappers reject wrong-family model_id", {
  expect_error(
    nwaa_atmos(
      model_id = "wu-irrigation-wd",
      variable_ids = "precip",
      location_type = "huc12",
      location_id = "180300010602"
    ),
    "belongs to family 'wu'"
  )

  expect_error(
    nwaa_water_use(
      model_id = "wqn-conus404-ba",
      variable_ids = "precip",
      location_type = "huc12",
      location_id = "180300010602"
    ),
    "belongs to family 'wqn'"
  )
})

test_that("family wrappers reject typo'd variable names with helpful message", {
  err <- tryCatch(
    nwaa_atmos(
      variable_ids = "precipitation",
      location_type = "huc12",
      location_id = "180300010602"
    ),
    error = function(e) conditionMessage(e)
  )
  expect_match(err, "precipitation")
  expect_match(err, "precip")
})
