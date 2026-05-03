## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Test environments

* Local: macOS, R release
* GitHub Actions:
    * macOS-latest (release)
    * windows-latest (release)
    * ubuntu-latest (release, devel, oldrel-1)
* win-builder (R-devel) — 1 NOTE (new submission, plus URL false positives addressed below)

## Notes for the reviewer

### URL check false positives

The win-builder NOTE flags the following URLs as 404:

* https://water.usgs.gov/nwaa-data
* https://water.usgs.gov/nwaa-data/subset-download
* https://water.usgs.gov/nwaa-data/web-services
* https://water.usgs.gov/themes/hydrologic-units

These URLs all resolve correctly in a browser. The 404 responses appear to come from how the USGS web server handles HEAD requests with libcurl's default user agent, rather than from broken links. The same URLs return content with a GET request from a browser or with a non-default user agent. `urlchecker::url_check()` returns no issues on the maintainer's machine.

The URLs point to the canonical USGS National Water Availability Assessment Data Companion landing page, the Subset and Download Tool, the web services documentation, and the hydrologic units page on the USGS website. They are central to the package's purpose and removing them would degrade the documentation. The URLs were verified manually in a browser prior to submission.

### Network access in tests and examples

The package interacts with a remote web service. All examples that issue network requests are wrapped in `\dontrun{}`. The test suite uses `httptest2` fixtures to record and replay API responses, so `R CMD check` does not require live network access on CRAN servers.

## Downstream dependencies

There are currently no downstream dependencies for this package.
