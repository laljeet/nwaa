test_that("nwaa_location_types returns 8 supported types", {
  lt <- nwaa_location_types()
  expect_setequal(
    lt$type,
    c("huc2", "huc4", "huc6", "huc8", "huc10", "huc12", "statecd", "countycd")
  )
})

test_that("nwaa_location formats type:id correctly", {
  expect_equal(nwaa_location("countycd", "06029"), "countycd:06029")
  expect_equal(nwaa_location("huc12", "180300010602"), "huc12:180300010602")
  expect_equal(nwaa_location("statecd", "ca"), "statecd:ca")
})

test_that("nwaa_location lowercases the type and trims whitespace", {
  expect_equal(nwaa_location("CountyCD", "06029"), "countycd:06029")
  expect_equal(nwaa_location("  huc12  ", "  180300010602  "), "huc12:180300010602")
})

test_that("nwaa_location rejects empty values", {
  expect_error(nwaa_location("", "06029"), "non-empty")
  expect_error(nwaa_location("countycd", ""), "non-empty")
})

test_that("nwaa_location rejects unknown types when validate = TRUE", {
  expect_error(nwaa_location("zipcode", "93301"), "Unsupported location type")
})

test_that("nwaa_location accepts unknown types when validate = FALSE", {
  expect_equal(
    nwaa_location("zipcode", "93301", validate = FALSE),
    "zipcode:93301"
  )
})
