# Record API response fixtures for offline test replay.
#
# Run once from the package root, with internet access:
#
#   source("tests/manual/record_fixtures.R")
#
# Re-run only if the API changes its response shape. To re-record a
# specific fixture, delete its directory and run again.
#
# After recording, commit tests/testthat/fixtures/ to the repository.

if (!requireNamespace("httptest2", quietly = TRUE)) {
  stop("Install httptest2 first: install.packages('httptest2')")
}
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("Install devtools first: install.packages('devtools')")
}
if (!requireNamespace("rprojroot", quietly = TRUE)) {
  stop("Install rprojroot first: install.packages('rprojroot')")
}

# Resolve the package root regardless of where this script is sourced from.
pkg_root <- rprojroot::find_root(rprojroot::is_r_package)
old_wd <- setwd(pkg_root)
on.exit(setwd(old_wd), add = TRUE)
message("Package root: ", pkg_root)

devtools::load_all()

# httptest2 prepends its current .mockPaths() to any relative path passed to
# with_mock_dir(). The default .mockPaths() is "tests/testthat" if it exists.
# Passing dir = "tests/testthat/fixtures/foo" therefore writes to
# tests/testthat/tests/testthat/fixtures/foo (path doubling).
#
# To avoid this, use ABSOLUTE paths for the fixture directories.

fixtures_root <- file.path(pkg_root, "tests", "testthat", "fixtures")
dir.create(fixtures_root, showWarnings = FALSE, recursive = TRUE)

record_one <- function(name, recipe) {
  target <- file.path(fixtures_root, name)
  if (dir.exists(target)) {
    message("Fixture '", name, "' already exists. Delete to re-record. Skipping.")
    return(invisible(NULL))
  }
  message("Recording ", name, " -> ", target)
  httptest2::with_mock_dir(target, recipe())
}

record_one("wu_irrigation", function() {
  nwaa_water_use(
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

record_one("atmos_precip", function() {
  nwaa_atmos(
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

record_one("iwa_multi", function() {
  nwaa_iwa(
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

message(
  "\nDone. Verify fixtures landed in the right place:\n",
  "  list.files('tests/testthat/fixtures')\n",
  "  # expect: 'atmos_precip' 'iwa_multi' 'wu_irrigation'\n",
  "Then run: testthat::test_local()"
)
