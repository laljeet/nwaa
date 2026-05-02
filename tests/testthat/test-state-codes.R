test_that("nwaa_statecd returns 50 states with lowercase 2-letter codes", {
  s <- nwaa_statecd()
  expect_s3_class(s, "tbl_df")
  expect_equal(nrow(s), 50)
  expect_setequal(names(s), c("state_name", "statecd"))
  expect_true(all(nchar(s$statecd) == 2))
  expect_true(all(s$statecd == tolower(s$statecd)))
  expect_true("ca" %in% s$statecd)
})

test_that("nwaa_state_codes returns names and uppercase abbreviations", {
  s <- nwaa_state_codes()
  expect_equal(nrow(s), 50)
  expect_setequal(names(s), c("state_name", "state_abbr"))
  expect_true(all(s$state_abbr == toupper(s$state_abbr)))
})
