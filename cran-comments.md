## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new submission.
* The "unable to verify current time" NOTE is environmental and not reproducible on CRAN servers.

## Test environments

* Local: macOS, R release
* GitHub Actions:
  * macOS-latest (release)
  * windows-latest (release)
  * ubuntu-latest (release, devel, oldrel-1)
* win-builder (R-devel)  <!-- update this line after win-builder email arrives -->

## Downstream dependencies

There are currently no downstream dependencies for this package.

## Notes for the reviewer

The package provides an R interface to the U.S. Geological Survey National Water Availability Assessment (NWAA) Data Companion web service. All examples that issue network requests are wrapped in `\dontrun{}`. The test suite uses `httptest2` fixtures to avoid live network calls during `R CMD check` and on CRAN servers.
