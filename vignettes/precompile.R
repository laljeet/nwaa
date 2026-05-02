# vignettes/precompile.R
#
# Maintainer-only script. Knits each *.Rmd.orig file into a *.Rmd file
# alongside it. The committed *.Rmd contains the rendered output as static
# text plus chunks marked eval = FALSE, so package build never touches the
# network. CRAN, GitHub Actions, and end users see only the *.Rmd.
#
# When to run:
#   - After editing any *.Rmd.orig
#   - Before pushing a release
#   - Whenever the API responses or catalog change in a way that affects
#     rendered output
#
# Usage (from package root):
#   source("vignettes/precompile.R")
#
# Requires network access (hits api.water.usgs.gov).

precompile_vignettes <- function() {
  pkg_root <- rprojroot::find_root(rprojroot::is_r_package)
  vig_dir  <- file.path(pkg_root, "vignettes")
  orig     <- list.files(vig_dir, pattern = "\\.Rmd\\.orig$", full.names = TRUE)

  if (length(orig) == 0L) {
    message("No .Rmd.orig files found in ", vig_dir)
    return(invisible(NULL))
  }

  old_wd <- getwd()
  setwd(vig_dir)
  on.exit(setwd(old_wd), add = TRUE)

  for (src in orig) {
    out <- sub("\\.Rmd\\.orig$", ".Rmd", basename(src))
    message("Knitting ", basename(src), " -> ", out)
    knitr::knit(input = basename(src), output = out)
  }

  message("Done. Review the rendered .Rmd files, commit both .Rmd.orig and .Rmd.")
  invisible(orig)
}

precompile_vignettes()
