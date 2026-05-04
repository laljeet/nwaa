test_that("nwaa_statecd returns 50 states with lowercase 2-letter codes", {
  s <- nwaa_statecd()
  expect_s3_class(s, "tbl_df")
  expect_equal(nrow(s), 50)
  expect_setequal(names(s), c("state_name", "statecd"))
  expect_true(all(nchar(s$statecd) == 2))
  expect_true(all(s$statecd == tolower(s$statecd)))
  expect_true("ca" %in% s$statecd)
})
