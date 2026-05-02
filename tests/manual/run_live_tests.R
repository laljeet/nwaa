# Manual integration tests against the live USGS NWAA API.
#
# WHEN TO RUN: before each release, after any catalog edit, or when
# diagnosing a "did the API change?" question. Not run in CI.
#
# HOW TO RUN: from the package root, with internet access:
#
#   source("tests/manual/run_live_tests.R")
#
# Each test runs a real API call and checks a basic invariant about the
# response. Failures here typically mean either (a) USGS changed
# something on their end, or (b) a recent code change broke a request
# path that wasn't covered by offline tests.

if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("Install devtools first: install.packages('devtools')")
}

devtools::load_all()

results <- list()
record <- function(name, ok, note = "") {
  results[[name]] <<- list(name = name, ok = ok, note = note)
  cat(if (ok) "PASS" else "FAIL", " ", name,
      if (nzchar(note)) paste0(" -- ", note), "\n", sep = "")
}

run_check <- function(name, expr, predicate) {
  out <- tryCatch(expr, error = function(e) {
    record(name, FALSE, paste("error:", conditionMessage(e)))
    return(NULL)
  })
  if (is.null(out)) return(invisible(NULL))
  ok <- tryCatch(predicate(out), error = function(e) FALSE)
  note <- if (!ok) paste("predicate failed; got", paste(names(out), collapse = ",")) else ""
  record(name, ok, note)
}

# ---- Water Use family ----

run_check(
  "wu-irrigation-wd / annualwy / huc12",
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
  ),
  function(df) {
    is.data.frame(df) &&
      "huc12_id" %in% names(df) &&
      any(grepl("^irrwdtot_", names(df)))
  }
)

run_check(
  "wu-public-supply-wd / monthly / countycd",
  nwaa_water_use(
    model_id = "wu-public-supply-wd",
    variable_ids = "pswdtot",
    location_type = "countycd",
    location_id = "06029",
    time_res = "monthly",
    range = "custom",
    start = "2020-01",
    end = "2020-03",
    intersection = "overlap",
    format = "csv",
    quiet = TRUE
  ),
  function(df) is.data.frame(df) && nrow(df) > 0
)

# ---- Water Quantity family ----

run_check(
  "atmos / monthly / huc12",
  nwaa_atmos(
    variable_ids = "precip",
    location_type = "huc12",
    location_id = "180300010602",
    time_res = "monthly",
    range = "custom",
    start = "2020-01",
    end = "2020-12",
    format = "csv",
    quiet = TRUE
  ),
  function(df) is.data.frame(df) && any(grepl("^precip", names(df)))
)

run_check(
  "atmos / annualwy / huc12",
  nwaa_atmos(
    variable_ids = "precip",
    location_type = "huc12",
    location_id = "180300010602",
    time_res = "annualwy",
    range = "custom",
    start = "2018",
    end = "2020",
    format = "csv",
    quiet = TRUE
  ),
  function(df) is.data.frame(df) && nrow(df) > 0
)

run_check(
  "hydro / monthly / huc12",
  nwaa_hydro(
    variable_ids = c("actet", "swe"),
    location_type = "huc12",
    location_id = "180300010602",
    time_res = "monthly",
    range = "custom",
    start = "2018-01",
    end = "2018-03",
    format = "csv",
    quiet = TRUE
  ),
  function(df) {
    is.data.frame(df) &&
      any(grepl("^actet", names(df))) &&
      any(grepl("^swe", names(df)))
  }
)

# ---- Integrated Water Availability family ----

run_check(
  "iwa / monthly / huc12",
  nwaa_iwa(
    variable_ids = c("sui", "availab", "strflow", "consum"),
    location_type = "huc12",
    location_id = "180300010602",
    time_res = "monthly",
    range = "custom",
    start = "2018-01",
    end = "2018-03",
    format = "csv",
    quiet = TRUE
  ),
  function(df) {
    is.data.frame(df) &&
      "sui_frac" %in% names(df) &&
      "availab_mm/mo" %in% names(df) &&
      "strflow_mm/mo" %in% names(df) &&
      "consum_mm/mo" %in% names(df)
  }
)

# ---- Validation paths (these should error before hitting the network) ----

run_check(
  "validator: wrong family",
  tryCatch(
    nwaa_atmos(
      model_id = "wu-irrigation-wd",
      variable_ids = "precip",
      location_type = "huc12",
      location_id = "180300010602"
    ),
    error = function(e) list(err = conditionMessage(e))
  ),
  function(out) is.list(out) && grepl("belongs to family", out$err)
)

run_check(
  "validator: typo'd variable",
  tryCatch(
    nwaa_atmos(
      variable_ids = "precipitation",
      location_type = "huc12",
      location_id = "180300010602"
    ),
    error = function(e) list(err = conditionMessage(e))
  ),
  function(out) is.list(out) && grepl("Unknown variable_ids", out$err)
)

# ---- Summary ----

cat("\n========================================\n")
cat("Manual integration test summary\n")
cat("========================================\n")
n_total <- length(results)
n_pass <- sum(vapply(results, function(r) r$ok, logical(1)))
cat(n_pass, "of", n_total, "passed\n")
if (n_pass < n_total) {
  cat("\nFailed:\n")
  for (r in results) {
    if (!r$ok) cat("  -", r$name, ":", r$note, "\n")
  }
}
