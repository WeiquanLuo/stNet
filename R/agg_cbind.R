#' combine target and predictor data
#' @importFrom magrittr %>%
#' @import lubridate
#' @importFrom sf st_transform
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
#' data(weather_tmax_sf);
#' data(corn_yield_sf);
#' target_data <- spatio_fuse(target_stN = corn_yield_sf,
#'                                data_stN = weather_tmax_sf,
#'                                parm_nm = "tmax",
#'                                crs = 2163); target_data
#' target_data <- target_data %>%
#'   nest(data = c(target, predictor)); target_data
#' data <- target_data[which(target_data$county == "boone"), ]$data[[1]]; data # humboldt for none; allamakee for one; boone for two
#' agg_cbind(data,
#'           date_col = c("Year", "Date"),
#'           scaling = c("Year","Day"),
#'           aggMethod = c("mean","max"))

agg_cbind <- function(data = NULL,
                      date_col = c("Year", "Date"),
                      scaling = c("Year","Day"),
                      aggMethod = c("mean","max")){

  # exit function if data is null
  if (is.null(data$predictor[[1]])) return(NULL)

  # interger for lubridate::ymd(truncated)
  gettruncated <- function(x){
    if (x == "Year") truncation = 5L
    if (x == "Month") truncation = 4L
    if (x == "Day") truncation = 3L
    if (x == "Date") truncation = 3L
    if (x == "Hour") truncation = 2L
    if (x == "Minute") truncation = 1L
    if (x == "Second") truncation = 0L
    return(truncation)
  }

  # for target
  target <- data$target[[1]] %>%
    select(date_col[1]) %>%
    setNames(c("Date_col")) %>%
    mutate(Date = Date_col %>% lubridate::ymd_hms(truncated = gettruncated(date_col[1]))) %>% # extract ymd_hms
    mutate(join_by = eval(call(paste0("", tolower(scaling[1])), Date))) %>% # extract joinning scale
    select(join_by, Date, Date_col) %>% # reorder column: join_by, Date, Date_col
    right_join(data$target[[1]], by = c(Date_col= date_col[1])) %>% # join using Date_col with original data
    select(-Date, -Date_col); target # remove ymd_hms Date and Date_col

  # for predictor
  predictor <- data$predictor[[1]] %>%
    select(date_col[2]) %>%
    setNames(c("Date_col")) %>%
    mutate(Date = Date_col %>% lubridate::ymd_hms(truncated = gettruncated(date_col[2]))) %>% # extract ymd_hms
    mutate(join_by = eval(call(paste0("", tolower(scaling[1])), Date))) %>% # extract scale for joinning
    mutate(rescale = eval(call(paste0("", tolower(scaling[2])), Date))) %>% # extract scale for rescaling
    select(join_by, rescale, Date, Date_col) %>% # reorder column: join_by, Date, Date_col
    right_join(data$predictor[[1]], by = c(Date_col= date_col[2])) %>% # join using Date_col with original data
    select(-Date, -Date_col)%>% # remove ymd_hms Date and Date_col
    gather(key = "id", value = "val", -c(join_by, rescale)) %>%
    nest(data = val) %>%
    mutate(statistic = data %>% purrr::map_dbl(function(data) {
      temporal_rescaling(data = data, rescallingMethod = aggMethod[2])
    })) %>%
    select(-data) %>%
    tidyr::pivot_wider(names_from = c(id, rescale),
                       values_from = statistic); predictor

  # combine target & predictor
  data <- target %>%
    dplyr::left_join(predictor, by = "join_by") %>%
    setnames(new = c(scaling[1]), old = c('join_by'))

  return(data)
}





