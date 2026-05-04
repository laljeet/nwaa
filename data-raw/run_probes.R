# probes/run_probes.R
#
# Self-contained probe script for the live NWAA API. Run from any R session
# with the nwaa package installed. Hits the live API for each of the eight
# models, plus deliberately oversized and geojson queries to characterize
# behavior the package documentation has been guessing at.
#
# Run with:
#   source("probes/run_probes.R")
#
# The script prints structured findings to the console and writes a JSON
# summary to probes/probe_results.json so they can be referenced later.
#
# Estimated runtime: 2-5 minutes depending on USGS server load. The script
# uses small queries (single HUC12, one or two months) where possible to
# minimize server load.

library(nwaa)
suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
  library(jsonlite)
})

# Use one small HUC12 for everything: 180300010602 (a Tulare Lake basin
# HUC12 in California). Picked because it's in the user's working area
# and is small enough that historical pulls are quick.
TEST_HUC12 <- "180300010602"

# Container for findings. Each section appends a list of results.
results <- list(
  meta = list(
    run_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
    nwaa_version = as.character(utils::packageVersion("nwaa")),
    test_huc12 = TEST_HUC12
  )
)

# Pretty section header.
section <- function(title) {
  cat("\n", strrep("=", 70), "\n", sep = "")
  cat(title, "\n", sep = "")
  cat(strrep("=", 70), "\n", sep = "")
}

# Run one query inside a try block, return list(ok, df_or_err, elapsed).
safe_query <- function(label, expr) {
  cat("[", label, "] ... ", sep = "")
  t0 <- Sys.time()
  out <- tryCatch(
    list(ok = TRUE, value = eval(expr)),
    error = function(e) list(ok = FALSE, value = conditionMessage(e))
  )
  out$elapsed <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
  cat(if (out$ok) "ok" else "FAIL", " (", round(out$elapsed, 1), "s)\n", sep = "")
  out
}


# =============================================================================
# C4: Smoke test all 8 models with range = "recent"
# =============================================================================
section("C4: smoke test all 8 models")

# Model -> variable_ids -> wrapper. Variable lists chosen to exercise
# multiple variables per model where available.
smoke_specs <- list(
  list(model = "wu-irrigation-cu",                  vars = "irrcutot",                              wrapper = "wu"),
  list(model = "wu-irrigation-wd",                  vars = c("irrwdtot", "irrwdgw", "irrwdsw"),     wrapper = "wu"),
  list(model = "wu-public-supply-cu",               vars = "pscutot",                               wrapper = "wu"),
  list(model = "wu-public-supply-wd",               vars = c("pswdtot", "pswdgw", "pswdsw"),        wrapper = "wu"),
  list(model = "wu-thermoelectric",                 vars = c("tewdftot", "tecuftot"),               wrapper = "wu"),
  list(model = "wqn-conus404-ba",                   vars = "precip",                                wrapper = "atmos"),
  list(model = "wqn-ensemble-conus-nwaa-v1",        vars = c("actet", "incbsflow", "incqkflow",
                                                            "swe", "soilmstfr", "incrunoff"),       wrapper = "hydro"),
  list(model = "iwa-assessment-outputs-conus-2025", vars = c("sui", "availab", "strflow", "consum"),wrapper = "iwa")
)

# Wrapper dispatcher so this loop stays readable.
call_wrapper <- function(spec) {
  args <- list(
    variable_ids  = spec$vars,
    location_type = "huc12",
    location_id   = TEST_HUC12,
    time_res      = "monthly",
    range         = "recent",
    format        = "csv",
    quiet         = TRUE
  )
  fn <- switch(spec$wrapper,
    wu    = function(...) nwaa_water_use(model_id = spec$model, ...),
    atmos = function(...) nwaa_atmos(...),
    hydro = function(...) nwaa_hydro(...),
    iwa   = function(...) nwaa_iwa(...)
  )
  do.call(fn, args)
}

smoke_results <- list()
for (spec in smoke_specs) {
  res <- safe_query(spec$model, quote(call_wrapper(spec)))
  smoke_results[[spec$model]] <- list(
    ok       = res$ok,
    elapsed  = res$elapsed,
    n_rows   = if (res$ok) nrow(res$value) else NA_integer_,
    columns  = if (res$ok) names(res$value) else character(0),
    error    = if (!res$ok) res$value else NULL
  )

  # Show columns in detail because the unit suffixes are the whole point.
  if (res$ok) {
    cat("  columns: ", paste(names(res$value), collapse = ", "), "\n", sep = "")
    cat("  rows:    ", nrow(res$value), "\n", sep = "")
  }
}
results$c4_smoke <- smoke_results


# =============================================================================
# B4: Hydro units verification (column-suffix audit)
# =============================================================================
section("B4: hydro ensemble unit suffix audit")

# Pull the columns from the hydro smoke test and parse out unit suffixes.
hydro_cols <- smoke_results[["wqn-ensemble-conus-nwaa-v1"]]$columns
cat("Hydro response columns:\n")
for (col in hydro_cols) cat("  ", col, "\n", sep = "")

# Parse "<variable>_<unit>" patterns. Some variable names contain underscores
# or slashes, so split on the LAST underscore-separator that precedes a unit.
parse_unit <- function(col) {
  # Skip metadata columns
  if (col %in% c("huc12_id", "year_month", "year")) return(NA_character_)
  # API uses var_unit format. Strip variable prefix from each known var.
  for (v in c("actet", "incbsflow", "incqkflow", "swe", "soilmstfr", "incrunoff")) {
    if (startsWith(col, paste0(v, "_"))) {
      return(sub(paste0("^", v, "_"), "", col))
    }
  }
  return(NA_character_)
}

observed_units <- vapply(hydro_cols, parse_unit, character(1))
observed_units <- observed_units[!is.na(observed_units)]
names(observed_units) <- vapply(
  hydro_cols[!vapply(hydro_cols, function(c) is.na(parse_unit(c)), logical(1))],
  function(c) sub("_.*$", "", c),
  character(1)
)

cat("\nObserved units (from API column suffixes):\n")
for (n in names(observed_units)) cat("  ", n, " -> ", observed_units[[n]], "\n", sep = "")

# Compare against catalog
cat <- nwaa_catalog()
hydro_row <- cat[cat$model_id == "wqn-ensemble-conus-nwaa-v1", ]
catalog_vars <- hydro_row$variables[[1]]
catalog_units <- hydro_row$units[[1]]
names(catalog_units) <- catalog_vars

cat("\nCatalog units (current):\n")
for (n in names(catalog_units)) cat("  ", n, " -> ", catalog_units[[n]], "\n", sep = "")

cat("\nMismatches:\n")
mismatches <- list()
for (v in catalog_vars) {
  cat_u <- catalog_units[[v]]
  obs_u <- observed_units[[v]]
  if (is.null(obs_u)) {
    cat("  ", v, ": NOT IN RESPONSE (variable may not be returned by API)\n", sep = "")
    mismatches[[v]] <- list(catalog = cat_u, observed = NA_character_, status = "missing_from_response")
  } else if (cat_u != obs_u) {
    cat("  ", v, ": catalog says '", cat_u, "', API returned '", obs_u, "'\n", sep = "")
    mismatches[[v]] <- list(catalog = cat_u, observed = obs_u, status = "mismatch")
  } else {
    cat("  ", v, ": MATCH (", cat_u, ")\n", sep = "")
  }
}
results$b4_hydro_units <- list(
  observed = as.list(observed_units),
  catalog  = as.list(catalog_units),
  mismatches = mismatches
)


# =============================================================================
# B7: GeoJSON code path test
# =============================================================================
section("B7: GeoJSON code path")

# Tiny query, geojson format. Confirms the path returns an sf object.
geojson_res <- safe_query("geojson tiny query", quote({
  nwaa_water_use(
    model_id      = "wu-irrigation-wd",
    variable_ids  = "irrwdtot",
    location_type = "huc12",
    location_id   = TEST_HUC12,
    time_res      = "monthly",
    range         = "recent",
    format        = "geojson",
    quiet         = TRUE
  )
}))

if (geojson_res$ok) {
  cat("Class of result: ", paste(class(geojson_res$value), collapse = ", "), "\n", sep = "")
  cat("N features:      ", nrow(geojson_res$value), "\n", sep = "")
  if (inherits(geojson_res$value, "sf")) {
    cat("Geometry type:   ", as.character(sf::st_geometry_type(geojson_res$value, by_geometry = FALSE)), "\n", sep = "")
    cat("CRS:             ", sf::st_crs(geojson_res$value)$input, "\n", sep = "")
  }
  results$b7_geojson <- list(
    ok = TRUE,
    classes = class(geojson_res$value),
    n_features = nrow(geojson_res$value),
    columns = names(geojson_res$value)
  )
} else {
  cat("FAILED with: ", geojson_res$value, "\n", sep = "")
  results$b7_geojson <- list(ok = FALSE, error = geojson_res$value)
}


# =============================================================================
# D5: Pagination behavior probe
# =============================================================================
section("D5: pagination behavior probe")

# Strategy: pull the SAME oversized query in three ways and compare.
#   query A: skip = 0
#   query B: skip = 0 with a deliberately huge time window (CONUS-scale impractical;
#            instead use historical for one model that has many HUC12s in a state)
#   query C: skip = some_large_n to see if it returns anything different
#
# The "oversized" target is a state-level historical monthly pull. CA + 21 years
# of monthly = ~10000 HUC12s * 252 months = ~2.5M rows. If the API caps below
# that, this query exposes it.

cat("Probe A: small query (single HUC12, 12 months) - baseline\n")
probe_a <- safe_query("CA HUC12 12mo", quote({
  nwaa_water_use(
    model_id      = "wu-irrigation-wd",
    variable_ids  = "irrwdtot",
    location_type = "huc12",
    location_id   = TEST_HUC12,
    time_res      = "monthly",
    range         = "custom",
    start         = "2020-01",
    end           = "2020-12",
    format        = "csv",
    quiet         = TRUE
  )
}))
cat("  rows: ", if (probe_a$ok) nrow(probe_a$value) else "FAIL", " (expected 12)\n", sep = "")

cat("Probe B: large query (CA statewide, 1 year)\n")
probe_b <- safe_query("CA statewide 12mo", quote({
  nwaa_water_use(
    model_id      = "wu-irrigation-wd",
    variable_ids  = "irrwdtot",
    location_type = "statecd",
    location_id   = "ca",
    time_res      = "monthly",
    range         = "custom",
    start         = "2020-01",
    end           = "2020-12",
    format        = "csv",
    quiet         = TRUE
  )
}))
if (probe_b$ok) {
  rows_b <- nrow(probe_b$value)
  unique_huc12_b <- length(unique(probe_b$value$huc12_id))
  cat("  rows: ", rows_b, "\n", sep = "")
  cat("  unique HUC12s: ", unique_huc12_b, "\n", sep = "")
  cat("  rows per HUC12: ", round(rows_b / unique_huc12_b, 1), " (expected 12)\n", sep = "")
  # Suspicious-round-number check
  round_caps <- c(1000, 5000, 10000, 50000, 100000, 500000, 1000000)
  near_cap <- round_caps[abs(rows_b - round_caps) / round_caps < 0.01]
  if (length(near_cap) > 0) {
    cat("  WARNING: row count is suspiciously close to ", near_cap[1],
        " - may be a hard cap. Check D5 carefully.\n", sep = "")
  } else {
    cat("  Row count does not match a likely round cap. Probably no truncation.\n", sep = "")
  }
}

cat("Probe C: large query with skip = 10000 to test pagination\n")
probe_c <- safe_query("CA statewide skip=10000", quote({
  q <- list(
    model     = "wu-irrigation-wd",
    location  = "statecd:ca",
    format    = "csv",
    variable  = "irrwdtot",
    timeRes   = "monthly",
    startDate = "2020-01",
    endDate   = "2020-12",
    skip      = 10000
  )
  nwaa_get_data(q, quiet = TRUE)
}))
if (probe_c$ok) {
  cat("  rows with skip=10000: ", nrow(probe_c$value), "\n", sep = "")
  if (probe_b$ok) {
    rows_b <- nrow(probe_b$value)
    rows_c <- nrow(probe_c$value)
    cat("  rows_B - 10000 = ", rows_b - 10000, "\n", sep = "")
    cat("  rows_C        = ", rows_c, "\n", sep = "")
    if (abs((rows_b - 10000) - rows_c) <= 100) {
      cat("  -> skip parameter works as expected (rows_B - 10000 ~= rows_C)\n", sep = "")
    } else {
      cat("  -> skip parameter behavior is unexpected. Investigate.\n", sep = "")
    }
  }
}

results$d5_pagination <- list(
  probe_a = list(ok = probe_a$ok, rows = if (probe_a$ok) nrow(probe_a$value) else NA),
  probe_b = list(
    ok = probe_b$ok,
    rows = if (probe_b$ok) nrow(probe_b$value) else NA,
    unique_huc12 = if (probe_b$ok) length(unique(probe_b$value$huc12_id)) else NA
  ),
  probe_c = list(ok = probe_c$ok, rows = if (probe_c$ok) nrow(probe_c$value) else NA)
)


# =============================================================================
# Multi-model / multi-location demonstration
# =============================================================================
section("Multi-model and multi-location patterns")

cat("\n--- Pattern 1: Multiple counties, one model -----------------------------\n")
cat("This is the 'San Joaquin Valley irrigation' workflow.\n\n")

county_fips <- c("06029", "06031", "06107", "06019")  # Kern, Kings, Tulare, Fresno
county_names <- c("Kern", "Kings", "Tulare", "Fresno")
names(county_names) <- county_fips

t0 <- Sys.time()
sjv_irrig <- map2_dfr(county_fips, county_names, function(fips, nm) {
  cat("  fetching ", nm, " (", fips, ")... ", sep = "")
  df <- nwaa_water_use(
    model_id      = "wu-irrigation-wd",
    variable_ids  = "irrwdtot",
    location_type = "countycd",
    location_id   = fips,
    time_res      = "annualcy",
    range         = "recent",
    quiet         = TRUE
  )
  cat("ok (", nrow(df), " rows)\n", sep = "")
  df |> mutate(county_fips = fips, county_name = nm)
})
elapsed_pat1 <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
cat("\nTotal: ", nrow(sjv_irrig), " rows from ", length(county_fips), " counties in ", round(elapsed_pat1, 1), "s\n", sep = "")
cat("Sample:\n")
print(head(sjv_irrig, 10))


cat("\n--- Pattern 2: One county, multiple models ------------------------------\n")
cat("Pull irrigation, public supply, and thermoelectric for Kern County.\n\n")

kern_specs <- list(
  irrigation_wd     = list(model = "wu-irrigation-wd",    vars = "irrwdtot",     label = "Irrigation withdrawals"),
  irrigation_cu     = list(model = "wu-irrigation-cu",    vars = "irrcutot",     label = "Irrigation consumptive"),
  public_supply_wd  = list(model = "wu-public-supply-wd", vars = "pswdtot",      label = "Public supply withdrawals"),
  public_supply_cu  = list(model = "wu-public-supply-cu", vars = "pscutot",      label = "Public supply consumptive"),
  thermoelectric_wd = list(model = "wu-thermoelectric",   vars = "tewdftot",     label = "Thermoelectric withdrawals")
)

t0 <- Sys.time()
kern_multi <- imap_dfr(kern_specs, function(spec, key) {
  cat("  ", spec$label, "... ", sep = "")
  df <- nwaa_water_use(
    model_id      = spec$model,
    variable_ids  = spec$vars,
    location_type = "countycd",
    location_id   = "06029",
    time_res      = "annualcy",
    range         = "recent",
    quiet         = TRUE
  )
  cat("ok (", nrow(df), " rows)\n", sep = "")
  # Find the value column (the one ending in _mgd)
  val_col <- grep("_mgd$", names(df), value = TRUE)[1]
  df |>
    select(huc12_id, year, value = !!val_col) |>
    mutate(sector = spec$label, model_id = spec$model)
})
elapsed_pat2 <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
cat("\nTotal: ", nrow(kern_multi), " rows across ", length(kern_specs), " models in ", round(elapsed_pat2, 1), "s\n", sep = "")
cat("Aggregated to county totals:\n")
kern_summary <- kern_multi |>
  group_by(sector) |>
  summarise(total_mgd = sum(value, na.rm = TRUE), n_huc12 = n_distinct(huc12_id), .groups = "drop") |>
  arrange(desc(total_mgd))
print(kern_summary)


cat("\n--- Pattern 3: Multiple counties + multiple models (cross product) -------\n")
cat("Same as pattern 2 but across all four SJV counties. This is what a\n")
cat("v0.2.0 native multi-arg API would handle in one call.\n\n")

t0 <- Sys.time()
sjv_full <- crossing(
  fips  = county_fips,
  spec_key = names(kern_specs)
) |>
  mutate(
    df = map2(fips, spec_key, function(fp, sk) {
      sp <- kern_specs[[sk]]
      df <- nwaa_water_use(
        model_id      = sp$model,
        variable_ids  = sp$vars,
        location_type = "countycd",
        location_id   = fp,
        time_res      = "annualcy",
        range         = "recent",
        quiet         = TRUE
      )
      val_col <- grep("_mgd$", names(df), value = TRUE)[1]
      df |> select(huc12_id, year, value = !!val_col)
    })
  ) |>
  tidyr::unnest(df) |>
  mutate(
    county_name = county_names[fips],
    sector = vapply(spec_key, function(k) kern_specs[[k]]$label, character(1))
  )
elapsed_pat3 <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
cat("Total: ", nrow(sjv_full), " rows from ",
    length(county_fips), " counties x ", length(kern_specs),
    " models = ", length(county_fips) * length(kern_specs), " API calls in ",
    round(elapsed_pat3, 1), "s\n", sep = "")

cat("\nCross-tab (sum of MGD by county and sector):\n")
sjv_cross <- sjv_full |>
  group_by(county_name, sector) |>
  summarise(total_mgd = sum(value, na.rm = TRUE), .groups = "drop") |>
  tidyr::pivot_wider(names_from = sector, values_from = total_mgd)
print(sjv_cross)

results$multi_demo <- list(
  pattern1_seconds = elapsed_pat1,
  pattern2_seconds = elapsed_pat2,
  pattern3_seconds = elapsed_pat3,
  pattern3_n_calls = length(county_fips) * length(kern_specs)
)


# =============================================================================
# Write summary to disk
# =============================================================================
section("Probe summary written to disk")
out_dir <- file.path(getwd(), "probes")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
out_path <- file.path(out_dir, "probe_results.json")
write_json(results, out_path, pretty = TRUE, auto_unbox = TRUE)
cat("Wrote: ", out_path, "\n", sep = "")

cat("\nDone.\n")
