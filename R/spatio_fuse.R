#' sort sites by geometry polygon
#' @importFrom magrittr %>%
#' @importFrom raster crs
#' @importFrom sf st_transform
#' @importFrom dplyr rename mutate select
#' @importFrom tidyr nest
#' @importFrom purrr map
#' @description matching the site from data_stN to the by polygon in target_stN
#' @return a dataframe
#' @export
#' @examples
#' data(weather_tmin_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' weather_tmin_st <- weather_tmin_sf
#' tictoc::tic()
#' target_data_t <- spatio_fuse(target_stN = corn_yield_st,
#'                              data_stN = weather_tmin_st,
#'                              parm_nm = "tmin",
#'                              crs = 2163); target_data_t
#' tictoc::toc()

spatio_fuse <- function(target_stN = NULL, data_stN = NULL, parm_nm = "parm_xxx", crs = 4326){

  data_stN <- data_stN %>% select(id, data, geometry)
  # project to a appropriate project for correctly crop
  target_stN <- target_stN %>% st_transform(crs)
  data_stN <- data_stN %>% st_transform(crs)

  target_data_t <- target_stN %>% # filter(county =="boone") %>% # humboldt for none; allamakee for one; boone for two
    rename(target= data) %>%
    nest(data = c(geometry)) %>% # nest geometry for purrr::map()
    mutate(predictor = map(data, function(pol){ # assign site to each pol
      suppressWarnings(pol_cropping(data_stN = data_stN,
                                      pol = pol,
                                      parm_nm = parm_nm))})) %>%
    predictor_drop_null() %>% # drop the row if the predictor is nullL: no timeseries data in the pol
    select(-data); target_data_t

  return(target_data_t)
}

