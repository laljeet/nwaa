#' Validate a request against the catalog before sending it to the API.
#'
#' Used internally by all family wrappers. Errors with a clear message
#' if model_id is unknown, doesn't match expected_family, has unknown
#' variable_ids, or uses an unsupported time_res.
#'
#' @keywords internal
#' @noRd
nwaa_validate_request_ <- function(model_id,
                                   variable_ids,
                                   time_res,
                                   expected_family = NULL) {
  cat <- nwaa_catalog()
  row <- cat[cat$model_id == model_id, , drop = FALSE]

  if (nrow(row) != 1) {
    rlang::abort(
      paste0(
        "Unknown model_id: '", model_id, "'. ",
        "See nwaa_catalog() for available models."
      )
    )
  }

  if (!is.null(expected_family) && row$family != expected_family) {
    rlang::abort(
      paste0(
        "model_id '", model_id, "' belongs to family '", row$family,
        "', not '", expected_family, "'. ",
        "Use nwaa_catalog() to see which family each model belongs to. ",
        "Family wrappers: nwaa_water_use() for 'wu', nwaa_atmos() for 'wqn' ",
        "atmospheric, nwaa_hydro() for 'wqn' hydrologic, nwaa_iwa() for 'iwa'."
      )
    )
  }

  valid_vars <- row$variables[[1]]
  bad <- setdiff(variable_ids, valid_vars)
  if (length(bad) > 0) {
    rlang::abort(
      paste0(
        "Unknown variable_ids for model '", model_id, "': ",
        paste0("'", bad, "'", collapse = ", "), ". ",
        "Valid variables: ", paste0("'", valid_vars, "'", collapse = ", "), "."
      )
    )
  }

  valid_temporal <- row$temporal[[1]]
  if (!time_res %in% valid_temporal) {
    rlang::abort(
      paste0(
        "time_res = '", time_res, "' is not supported by model '", model_id,
        "'. Supported: ", paste0("'", valid_temporal, "'", collapse = ", "), "."
      )
    )
  }

  invisible(TRUE)
}
