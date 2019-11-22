#' drop rows where the predictor is NULL for stN class object
#' @importFrom magrittr %>%
#' @importFrom purrr map_dbl
#' @importFrom dplyr mutate filter select
#' @export

predictor_drop_null <- function(data_stN){
  droped_NULL_data_stN <- data_stN %>%
    mutate(isnull = map_dbl(predictor, is.null)) %>%  # check if null stie
    filter(isnull==0) %>% # remove null site
    select(-isnull)  # remove isnull col
  return(droped_NULL_data_stN)
}

