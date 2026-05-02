# Record API response fixtures for offline test replay.
#
# Run once from the package root, with internet access:
#
#   source("tests/manual/record_fixtures.R")
#
# Re-run only if the API changes its response shape. To re-record,
# delete the corresponding fixture directory and run again.
#
# After recording, commit tests/testthat/fixtures/ to the repository.

if (!requireNamespace("httptest2", quietly = TRUE)) {
  stop("Install httptest2 first: install.packages('httptest2')")
}
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("Install devtools first: install.packages('devtools')")
}

devtools::load_all()

# httptest2::with_mock_dir(dir, expr) acts as both recorder and replayer:
#   - if `dir` does not exist, it captures requests into `dir`
#   - if `dir` exists, it replays from `dir`
# So to record, ensure the directory does not exist first. To re-record,
# delete it before running.

fixtures_root <- file.path("tests", "testthat", "fixtures")
dir.create(fixtures_root, showWarnings = FALSE, recursive = TRUE)

record_one <- function(name, recipe) {
  target <- file.path(fixtures_root, name)
  if (dir.exists(target)) {
    message("Fixture '", name, "' already exists. Delete to re-record. Skipping.")
    return(invisible(NULL))
  }
  message("Recording ", name, " ...")
  httptest2::with_mock_dir(target, recipe())
  message("  -> ", target)
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

message("\nDone. Run testthat::test_local() to verify the fixtures replay.")
