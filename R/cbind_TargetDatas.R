#' bind multiple stN class object
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by summarize left_join
#' @importFrom purrr reduce
#' @export
#' @examples
#' x <- list(yield_prcp, yield_tmin, yield_tmax)
#' cbind_TargetDatas(x, target = "yield", join_by = "Year")

cbind_TargetDatas <- function(target = NULL, join_by = NULL, ...){
  x <- list(...) # THIS WILL BE A LIST STORING EVERYTHING:
  x <- x %>%
    reduce(rbind) %>%
    group_by(county) %>%
    summarize(data = list(reduce(data, left_join, by = c(join_by, target)))); x
  return(x)
}
