#' rescaling the temporal resolution by method
#' @export
#' @param rescallingMethod a string elements have to be those destinaGroup generic methods,
#'  such as min, max, mean, etc.(see: ??dplyr::summarise)
#' @param data a list of numeric data
#' @examples
#' data <- c(NA,round(runif(n = 20, min = 0, max = 100)))
#' rescallingMethod <- "max"
#' temporal_rescaling(data= data, rescallingMethod = rescallingMethod)

temporal_rescaling <- function(data, rescallingMethod) {
  if (!is.numeric(data)) data <- purrr::flatten(data) %>% unlist
  data <- na.omit(data)
  eval(call(rescallingMethod, c(data, na.rm = TRUE)))
}
