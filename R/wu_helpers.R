#' List Water Use models and their available date ranges
#'
#' @return A tibble with \code{model_id}, \code{model_label}, \code{start_ym}, and \code{end_ym}.
#' @export
#' @examples
#' nwaa_wu_models()
nwaa_wu_models <- function() {
  nwaa_wu_catalog() |>
    dplyr::select(model_id, model_label, start_ym, end_ym)
}

#' List variables for a Water Use model
#'
#' @param model_id A Water Use model ID from \code{\link{nwaa_wu_models}}.
#' @return A tibble with variable IDs and units.
#' @export
#' @examples
#' nwaa_wu_variables("wu-irrigation-wd")
nwaa_wu_variables <- function(model_id) {
  cat <- nwaa_wu_catalog()
  row <- cat[cat$model_id == model_id, , drop = FALSE]
  if (nrow(row) != 1) rlang::abort("Unknown model_id. Use nwaa_wu_models().")

  tibble::tibble(
    model_id = model_id,
    variable_id = row$variables[[1]],
    unit = row$units[[1]],
    variable_name = row$variable_name[[1]]
  )
}
