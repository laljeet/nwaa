test_that("nwaa_build_query produces expected base parameters", {
  q <- nwaa_build_query(
    model = "wu-irrigation-wd",
    variables = "irrwdtot",
    location = "countycd:06029",
    format = "csv"
  )
  expect_equal(q$model, "wu-irrigation-wd")
  expect_equal(q$location, "countycd:06029")
  expect_equal(q$format, "csv")
  expect_equal(q$variable, "irrwdtot")
})

test_that("nwaa_build_query joins multiple variables with commas", {
  q <- nwaa_build_query(
    model = "wu-irrigation-wd",
    variables = c("irrwdtot", "irrwdgw", "irrwdsw"),
    location = "countycd:06029"
  )
  expect_equal(q$variable, "irrwdtot,irrwdgw,irrwdsw")
})

test_that("nwaa_build_query passes extra parameters through", {
  q <- nwaa_build_query(
    model = "wu-irrigation-wd",
    variables = "irrwdtot",
    location = "countycd:06029",
    timeRes = "annualwy",
    startDate = "2018",
    endDate = "2020",
    intersection = "overlap",
    skip = 0
  )
  expect_equal(q$timeRes, "annualwy")
  expect_equal(q$startDate, "2018")
  expect_equal(q$endDate, "2020")
  expect_equal(q$intersection, "overlap")
  expect_equal(q$skip, 0)
})

test_that("nwaa_build_query drops NULL extras", {
  q <- nwaa_build_query(
    model = "wu-irrigation-wd",
    variables = "irrwdtot",
    location = "countycd:06029",
    intersection = NULL
  )
  expect_false("intersection" %in% names(q))
})

test_that("nwaa_build_query rejects empty model, variables, or location", {
  expect_error(
    nwaa_build_query(model = "", variables = "irrwdtot", location = "countycd:06029"),
    "model must be non-empty"
  )
  expect_error(
    nwaa_build_query(model = "x", variables = character(0), location = "countycd:06029"),
    "at least one variable"
  )
  expect_error(
    nwaa_build_query(model = "x", variables = "y", location = ""),
    "location must be non-empty"
  )
})

test_that("nwaa_build_query enforces format choices", {
  expect_error(
    nwaa_build_query(model = "x", variables = "y", location = "z", format = "xml"),
    "should be one of"
  )
})
