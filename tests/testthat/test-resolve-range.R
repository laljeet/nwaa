test_that("resolve_range historical returns full catalog window", {
  res <- nwaa_resolve_range(
    "wu-irrigation-wd",
    range = "historical",
    temporal = "monthly"
  )
  expect_equal(res$startDate, "2000-01")
  expect_equal(res$endDate, "2020-12")
})

test_that("resolve_range recent returns single timepoint", {
  res <- nwaa_resolve_range(
    "wu-irrigation-wd",
    range = "recent",
    temporal = "monthly"
  )
  expect_equal(res$startDate, res$endDate)
  expect_equal(res$endDate, "2020-12")
})

test_that("resolve_range custom passes through user values", {
  res <- nwaa_resolve_range(
    "wu-irrigation-wd",
    range = "custom",
    temporal = "annualwy",
    start = "2010",
    end = "2015"
  )
  expect_equal(res$startDate, "2010")
  expect_equal(res$endDate, "2015")
})

test_that("resolve_range converts to year-only for annual resolutions", {
  res_cy <- nwaa_resolve_range(
    "wu-irrigation-wd",
    range = "historical",
    temporal = "annualcy"
  )
  expect_equal(nchar(res_cy$startDate), 4)
  expect_equal(nchar(res_cy$endDate), 4)
})

test_that("resolve_range water year start bumps year when start month <= 9", {
  # wqn-conus404-ba has start_ym = 1979-10. October is month 10, so the
  # first water year is the 1980 WY (starting Oct 1979). Start year stays 1979.
  res_atm <- nwaa_resolve_range(
    "wqn-conus404-ba",
    range = "historical",
    temporal = "annualwy"
  )
  expect_equal(res_atm$startDate, "1979")

  # wu-irrigation-wd has start_ym = 2000-01. Month 1 <= 9, so bump to 2001.
  res_wu <- nwaa_resolve_range(
    "wu-irrigation-wd",
    range = "historical",
    temporal = "annualwy"
  )
  expect_equal(res_wu$startDate, "2001")
})

test_that("resolve_range warns when start/end ignored for non-custom range", {
  expect_warning(
    nwaa_resolve_range(
      "wu-irrigation-wd",
      range = "historical",
      temporal = "monthly",
      start = "2010-01",
      end = "2015-12"
    ),
    "ignored"
  )
})

test_that("resolve_range errors when range = 'custom' but start/end missing", {
  expect_error(
    nwaa_resolve_range(
      "wu-irrigation-wd",
      range = "custom",
      temporal = "monthly"
    ),
    "provide both start and end"
  )
})

test_that("resolve_range errors on unknown model_id with helpful message", {
  expect_error(
    nwaa_resolve_range("does-not-exist", range = "historical"),
    "Unknown model_id"
  )
})

test_that("resolve_range works for non-WU families (catalog covers all)", {
  res_atm <- nwaa_resolve_range(
    "wqn-conus404-ba",
    range = "historical",
    temporal = "monthly"
  )
  expect_equal(res_atm$startDate, "1979-10")
  expect_equal(res_atm$endDate, "2021-09")

  res_iwa <- nwaa_resolve_range(
    "iwa-assessment-outputs-conus-2025",
    range = "historical",
    temporal = "monthly"
  )
  expect_equal(res_iwa$startDate, "2009-10")
  expect_equal(res_iwa$endDate, "2020-09")
})
