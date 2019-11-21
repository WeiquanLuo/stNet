#' bind multiple stN class object
#' @importFrom magrittr %>%
#' @export
#' @examples
#' x <- list(yield_prcp, yield_tmin, yield_tmax)
#' cbind_TargetDatas(x, target = "yield", join_by = "Year")

cbind_TargetDatas <- function(target = NULL, join_by = NULL, ...){
  x <- list(...) # THIS WILL BE A LIST STORING EVERYTHING:
  x <- x %>%
    purrr::reduce(rbind) %>%
    group_by(county) %>%
    summarize(data = list(purrr::reduce(data, left_join, by = c(join_by, target)))); x
  return(x)
}
