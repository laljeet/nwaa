#' List Water Use models and their available date ranges
#'
#' Convenience view that returns the Water Use rows of
#' \code{\link{nwaa_catalog}} restricted to the columns most relevant for
#' picking a model.
#'
#' @return A tibble with \code{model_id}, \code{model_label},
#'   \code{start_ym}, and \code{end_ym}.
#' @export
#' @examples
#' nwaa_wu_models()
nwaa_wu_models <- function() {
  cat <- nwaa_catalog()
  wu <- cat[cat$family == "wu", c("model_id", "model_label", "start_ym", "end_ym"),
            drop = FALSE]
  tibble::as_tibble(wu)
}

#' List variables for a Water Use model
#'
#' Looks up one Water Use model in \code{\link{nwaa_catalog}} and returns
#' a long-form tibble of its variable IDs, units, and human-readable names.
#'
#' @param model_id A Water Use model ID. See \code{\link{nwaa_wu_models}}.
#'
#' @return A tibble with one row per variable. Columns:
#'   \code{model_id}, \code{variable_id}, \code{unit}, \code{variable_name}.
#' @export
#' @examples
#' nwaa_wu_variables("wu-irrigation-wd")
nwaa_wu_variables <- function(model_id) {
  cat <- nwaa_catalog()
  row <- cat[cat$model_id == model_id, , drop = FALSE]

  if (nrow(row) != 1) {
    rlang::abort(
      paste0(
        "Unknown model_id: '", model_id, "'. ",
        "Use nwaa_wu_models() to see available Water Use models."
      )
    )
  }

  if (row$family[[1]] != "wu") {
    rlang::abort(
      paste0(
        "model_id '", model_id, "' belongs to family '", row$family[[1]],
        "', not 'wu'. Use nwaa_catalog() for non-WU models."
      )
    )
  }

  tibble::tibble(
    model_id = model_id,
    variable_id = row$variables[[1]],
    unit = row$units[[1]],
    variable_name = row$variable_name[[1]]
  )
}
