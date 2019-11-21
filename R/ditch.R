#' replace any inf or nan with NULL from a dataframe
#' @export

ditch <- function(data) {
  ifelse(is.infinite(data) | is.nan(x), NA, data)
}


