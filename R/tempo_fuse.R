#' combine target data and site within polygon
#' @importFrom magrittr %>%
#' @export
#' @examples
#' data(weather_tmax_sf);
#' data(corn_yield_sf);
#' target_data <- spatio_fuse(target_stN = corn_yield_sf,
#'                             data_stN = weather_tmax_sf,
#'                             parm_nm = "tmax",
#'                             crs = 4326); target_data
#' target_data <- tempo_fuse(target_data = target_data,
#'                           date_col = c("Year", "Date"),
#'                           scaling = c("Year","Month"),
#'                           aggMethod = c("mean","max")); target_data


tempo_fuse <- function(target_data = NULL,
                       date_col = c("Year", "Date"),
                       scaling = c("Year","Day"),
                       aggMethod = c("mean","max")){

  target_data_fused <- target_data %>%
    nest(data = c(target, predictor)) %>%
    mutate(data = data %>% purrr::map(function(data) {
      agg_cbind(data = data,
                date_col = date_col,
                scaling = scaling,
                aggMethod = aggMethod)}))

  return(target_data_fused)
}
