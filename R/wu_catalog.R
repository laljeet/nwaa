#' Water Use catalog (models, variables, and time ranges)
#'
#' Returns rows from \code{\link{nwaa_catalog}} restricted to the Water Use
#' (\code{wu}) family. Provided for backwards compatibility and convenience.
#'
#' @return A tibble with one row per Water Use model. Columns: \code{model_id},
#'   \code{model_label}, \code{start_ym}, \code{end_ym}, \code{variables}
#'   (list-column), \code{units} (list-column), \code{variable_name}
#'   (list-column).
#' @export
#' @examples
#' nwaa_wu_catalog()
nwaa_wu_catalog <- function() {
  cat <- nwaa_catalog()
  wu <- cat[cat$family == "wu", , drop = FALSE]

  # Preserve historical column shape (no family/temporal columns).
  tibble::tibble(
    model_id      = wu$model_id,
    model_label   = wu$model_label,
    start_ym      = wu$start_ym,
    end_ym        = wu$end_ym,
    variables     = wu$variables,
    units         = wu$units,
    variable_name = wu$variable_name
  )
}
