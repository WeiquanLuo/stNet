#' rescaling the temporal resolution by method
#' @export
#' @importFrom purrr flatten
#' @param rescallingMethod a string elements have to be those destinaGroup generic methods,
#'  such as min, max, mean, etc.(see: ??dplyr::summarise)
#' @param data a list of numeric data
#' @examples
#' data <- c(NA,round(runif(n = 20, min = 0, max = 100)))
#' rescallingMethod <- "max"
#' rescaling_summarise(data= data, rescallingMethod = rescallingMethod)

rescaling_summarise <- function(data, rescallingMethod) {
  if (!is.numeric(data)) data <- flatten(data) %>% unlist
  data <- na.omit(data)
  eval(call(rescallingMethod, c(data, na.rm = TRUE)))
}
