#' combine target data and site within polygon
#' @importFrom magrittr %>%
#' @export
#' @importFrom tidyr nest
#' @importFrom dplyr mutate
#' @importFrom purrr map
#'
#' @examples
#' data(weather_tmin_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' weather_tmin_st <- weather_tmin_sf
#' tictoc::tic()
#' target_data_t <- spatio_fuse(target_stN = corn_yield_st,
#'                                data_stN = weather_tmin_st,
#'                                parm_nm = "tmin",
#'                                crs = 2163); target_data_t
#' tictoc::toc()
#' target_data <- tempo_fuse(target_data = target_data_t,
#'                           date_col = c("Year", "Date"),
#'                           scaling = c("Year","Month"),
#'                           aggMethod = c("mean","min")); target_data


tempo_fuse <- function(target_data = NULL,
                       date_col = c("Year", "Date"),
                       scaling = c("Year","Day"),
                       aggMethod = c("mean","max")){

  target_data_fused <- target_data %>%
    nest(data = c(target, predictor)) %>%
    mutate(data = data %>% map(function(data) {
      agg_cbind(data = data,
                date_col = date_col,
                scaling = scaling,
                aggMethod = aggMethod)}))

  return(target_data_fused)
}
