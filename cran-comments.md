## Resubmission

This is a resubmission addressing the reviewer's comments (thank you):

* Removed the single quotes around the acronyms USGS and NWAA in the Title
  and Description.
* Replaced `\dontrun{}` with `\donttest{}` in all examples. The examples call
  functions that download data from a web service, so they are kept wrapped
  (per the CRAN cookbook guidance on structuring examples) rather than
  unwrapped. One atmospheric-forcing example was narrowed to a single HUC12 so
  that every executed example completes in well under five seconds.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
* The NOTE reports "possibly misspelled words in DESCRIPTION" (USGS, NWAA,
  HUC). These are standard acronyms; the single quotes that previously marked
  them were removed at the reviewer's request.

## Test environments

* Local: macOS, R release (examples checked with --run-donttest)
* win-builder (R-devel)

## Network access in tests and examples

The package interacts with a remote web service. Examples that issue network
requests are wrapped in `\donttest{}`. The test suite uses `httptest2`
fixtures to record and replay API responses, so `R CMD check` does not require
live network access on CRAN servers.

## Downstream dependencies

There are currently no downstream dependencies for this package.
