## Resubmission

This is a resubmission. In the previous submission, the URL checker flagged
several `water.usgs.gov` links and one GitHub link as returning HTTP 404.

* The `water.usgs.gov` links resolve in a browser from the United States but
  are blocked (404) for automated requests from CRAN's servers, as the USGS
  web server restricts non-interactive and non-US traffic. Rather than keep
  links the checker cannot reach, I have removed them from the DESCRIPTION,
  the help pages, and the vignette. The service is now referred to by name.
  The full set of USGS reference links is retained in the GitHub README, which
  is excluded from the build.
* The GitHub link was a genuine error (it pointed to `LICENSE.md`; the file is
  named `LICENSE`). It has been corrected.

All remaining URLs in the built package resolve from CRAN's checkers.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Test environments

* Local: macOS, R release
* GitHub Actions:
    * macOS-latest (release)
    * windows-latest (release)
    * ubuntu-latest (release, devel, oldrel-1)
* win-builder (R-devel)

## Network access in tests and examples

The package interacts with a remote web service. All examples that issue
network requests are wrapped in `\dontrun{}`. The test suite uses `httptest2`
fixtures to record and replay API responses, so `R CMD check` does not require
live network access on CRAN servers.

## Downstream dependencies

There are currently no downstream dependencies for this package.
