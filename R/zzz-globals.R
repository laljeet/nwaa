# Declare variables used inside dplyr NSE so R CMD check does not flag them
# as "undefined global functions or variables".
utils::globalVariables(c(
  "model_id",
  "model_label",
  "start_ym",
  "end_ym"
))
