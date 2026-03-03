#' Disable scientific notation for printing (session option)
#'
#' Sets \code{options(scipen = 999)} to reduce scientific notation in console printing.
#' This changes a global session option.
#'
#' @param scipen Numeric. Higher values reduce scientific notation. Default 999.
#' @export
#' @examples
#' nwaa_no_sci()
nwaa_no_sci <- function(scipen = 999) {
  old <- getOption("scipen")
  options(scipen = scipen)
  invisible(old)
}
