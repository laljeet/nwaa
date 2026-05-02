# Fixture-based tests for the request -> parse layer.
#
# These tests use httptest2 to replay recorded API responses stored under
# tests/testthat/fixtures/. They run offline once the fixtures are
# recorded, so they're safe in CI.
#
# How fixtures get created:
#
#   1. From the package root, with internet access, run:
#        source("tests/manual/record_fixtures.R")
#      This makes a small set of real API calls and writes responses to
#      tests/testthat/fixtures/. Done once. Re-run only if the API
#      response shape changes (delete a fixture directory to re-record it).
#
#   2. Commit tests/testthat/fixtures/ to the repository.
#
#   3. CI runs these tests offline by replaying the fixtures.
#
# Until fixtures are recorded, all tests in this file skip cleanly.

skip_if_not_installed("httptest2")

test_that("nwaa_water_use parses CSV response into tibble (fixture)", {
  skip_if_not(
    dir.exists(test_path("fixtures", "wu_irrigation")),
    "Fixture not recorded yet. See tests/manual/record_fixtures.R."
  )

  httptest2::with_mock_dir(test_path("fixtures", "wu_irrigation"), {
    df <- nwaa_water_use(
      model_id = "wu-irrigation-wd",
      variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
      location_type = "huc12",
      location_id = "180300010602",
      time_res = "annualwy",
      range = "custom",
      start = "2018",
      end = "2020",
      format = "csv",
      quiet = TRUE
    )
  })

  expect_s3_class(df, "tbl_df")
  expect_true("huc12_id" %in% names(df))
  expect_true("year" %in% names(df))
  # Column names carry unit suffixes
  expect_true(any(grepl("irrwdtot_", names(df))))
})

test_that("nwaa_atmos parses precipitation response (fixture)", {
  skip_if_not(
    dir.exists(test_path("fixtures", "atmos_precip")),
    "Fixture not recorded yet. See tests/manual/record_fixtures.R."
  )

  httptest2::with_mock_dir(test_path("fixtures", "atmos_precip"), {
    df <- nwaa_atmos(
      variable_ids = "precip",
      location_type = "huc12",
      location_id = "180300010602",
      time_res = "monthly",
      range = "custom",
      start = "2020-01",
      end = "2020-03",
      format = "csv",
      quiet = TRUE
    )
  })

  expect_s3_class(df, "tbl_df")
  expect_true(any(grepl("^precip", names(df))))
})

test_that("nwaa_iwa parses multi-variable response (fixture)", {
  skip_if_not(
    dir.exists(test_path("fixtures", "iwa_multi")),
    "Fixture not recorded yet. See tests/manual/record_fixtures.R."
  )

  httptest2::with_mock_dir(test_path("fixtures", "iwa_multi"), {
    df <- nwaa_iwa(
      variable_ids = c("sui", "availab"),
      location_type = "huc12",
      location_id = "180300010602",
      time_res = "monthly",
      range = "custom",
      start = "2018-01",
      end = "2018-03",
      format = "csv",
      quiet = TRUE
    )
  })

  expect_s3_class(df, "tbl_df")
  expect_true(any(grepl("^sui", names(df))))
  expect_true(any(grepl("^availab", names(df))))
})
