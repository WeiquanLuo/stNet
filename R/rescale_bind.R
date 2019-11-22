#' combine target and predictor data with rescaling
#' @importFrom magrittr %>%
#' @importFrom tidyr gather pivot_wider nest
#' @importFrom dplyr select mutate filter arrange right_join left_join
#' @import lubridate
#' @importFrom sf st_transform
#' @importFrom stats setNames
#' @importFrom purrr map_dbl
#' @importFrom data.table setnames
#' @export
#' @param date_col a two character element vector c("Date", "Date"), where the frist element is the date column from  target.
#' The second element is the date column from  predictor,
#' The string elements have to be any of names of lubridate accessor function with capitalizing the first letter,
#'  such as "Date", "Year", "Month", "Day", "Hour", "Minute", "Second", "Week", "Quarter", "Semester", "Am", "Pm", etc.
#' @param scaling a two character element vector c("Date", "Date"), where the frist element is the destinate temporal scale for target,
#' the second element is the destinate temporal scale for predictor
#' The string elements have to be any of names of lubridate accessor function with capitalizing the first letter,
#' such as "Date", "Year", "Month", "Day", "Hour", "Minute", "Second", "Week", "Quarter", "Semester", "Am", "Pm", etc
#' @param aggMethod a two character element vector c("Date", "Date"), where the frist element is the aggregation method for target,
#' the second element is the aggregation method for predictor.
#' The string elements have to be those destinaGroup generic methods such as min, max, mean, etc.(see: ??dplyr::summarise)
#' @examples
#' data(weather_tmin_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' weather_tmin_st <- weather_tmin_sf
#' target_data_t <- spatio_fuse(target_stN = corn_yield_st,
#'                                data_stN = weather_tmin_st,
#'                                parm_nm = "tmax",
#'                                crs = 2163); target_data_t
#' target_data <- target_data_t %>%
#'   nest(data = c(target, predictor)); target_data
#' data <- target_data[which(target_data$county == "boone"), ]$data[[1]]; data
#' # humboldt for none; allamakee for one; boone for two
#' rescale_bind(data,
#'           date_col = c("Year", "Date"),
#'           scaling = c("Year","Day"),
#'           aggMethod = c("mean","max"))

rescale_bind <- function(data = NULL,
                      date_col = c("Year", "Date"),
                      scaling = c("Year","Day"),
                      aggMethod = c("mean","max")){

  # exit function if data is null
  if (is.null(data$predictor[[1]])) return(NULL)

  # rescale target
  target <- tempo_rescaling(df = data$target[[1]],
                            date_col = date_col[1],
                            indf_scale = scaling[1],
                            destinate_scale = scaling[1],
                            aggMethod = aggMethod[1]); target

  # rescale predictor
  predictor <- tempo_rescaling( df = data$predictor[[1]],
                                date_col = date_col[2],
                                indf_scale = scaling[1],
                                destinate_scale = scaling[2],
                                aggMethod = aggMethod[2]);predictor

  # combine target & predictor
  data <- target %>%
    left_join(predictor, by = "join_by") %>%
    setnames(new = c(scaling[1]), old = c('join_by')) ; data

  return(data)
}





