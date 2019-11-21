#' drop tows where the predictor is NULL for stN class object
#' @importFrom magrittr %>%
#' @export

stN_drop_null <- function(data_stN){
  droped_NULL_data_stN <- data_stN %>%
    mutate(isnull = purrr::map_dbl(predictor, is.null)) %>%  # check if null stie
    filter(isnull==0) %>% # remove null site
    select(-isnull)  # remove isnull col
  return(droped_NULL_data_stN)
}

