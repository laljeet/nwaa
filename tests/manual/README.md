# Manual tests

These scripts run against the live USGS NWAA API and are **not** part of the
automated test suite. They require internet access. Run them by hand from
the package root.

## `record_fixtures.R`

Records API responses to `tests/testthat/fixtures/` so the offline test
suite (`test-fixtures.R`) can replay them. Run once after package install
and re-run only when the API response shape changes.

```r
source("tests/manual/record_fixtures.R")
```

Commit the resulting `tests/testthat/fixtures/` directory.

## `run_live_tests.R`

Smoke tests every family wrapper against the live API. Run before each
release, or whenever you suspect the upstream API has changed.

```r
source("tests/manual/run_live_tests.R")
```

Prints a `PASS`/`FAIL` line per check and a summary at the end.

## Why these are separate from `tests/testthat/`

CRAN runs `R CMD check` (which runs the testthat suite) without network
access. Tests that hit a live API will fail intermittently or always.
Keeping live integration here lets the automated suite stay deterministic
while still preserving "does it actually work end-to-end" coverage.

`tests/manual/` is excluded from the built tarball via `.Rbuildignore`.
