#' sort sites by geometry polygon
#' @importFrom magrittr %>%
#' @description matching the site from data_stN to the by polygon in target_stN
#' @return a dataframe
#' @export
#' @examples
#' data(weather_tmax_sf)
#' data(corn_yield_sf)
#' tictoc::tic()
#' target_data_sf <- spatio_fuse(target_stN = corn_yield_sf,
#'                                data_stN = weather_tmax_sf,
#'                                parm_nm = "tmax",
#'                                crs = 2163); target_data_sf
#' tictoc::toc()

spatio_fuse <- function(target_stN = NULL, data_stN = NULL, parm_nm = "parm_xxx", crs = 4326){

  # project to a appropriate project for correctly crop
  if (raster::crs(target_stN) != raster::crs(data_stN)) return("raster::crs(target_stN) != raster::crs(data_stN)")
  original_crs <- raster::crs(target_stN)
  target_stN <- target_stN %>% st_transform(crs)
  data_stN <- data_stN %>% st_transform(crs)

  target_data <- target_stN %>% # filter(county =="boone") %>% # humboldt for none; allamakee for one; boone for two
    rename(target= data) %>%
    nest(data = c(geometry)) %>% # nest geometry for purrr::map()
    mutate(predictor = purrr::map(data, function(pol){ # assign site to each pol
      suppressWarnings(cropping_cbind(data_stN = data_stN,
                                      pol = pol,
                                      parm_nm = parm_nm))})) %>%
    stN_drop_null() %>%
    select(-data); target_data

  return(target_data)
}

