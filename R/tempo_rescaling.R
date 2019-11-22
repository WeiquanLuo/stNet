#' rescale a data frame with columns: a Date col , id column, val column
#' @export
#' @importFrom magrittr %>%
#' @importFrom tidyr gather pivot_wider nest
#' @importFrom dplyr select mutate right_join
#' @import lubridate
#' @importFrom stats setNames
#' @importFrom purrr map_dbl
#' @importFrom data.table setnames
#' @examples
#' data(weather_tmin_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' weather_tmin_st <- weather_tmin_sf
#' target_data_t <- spatio_fuse(target_stN = corn_yield_st,
#'                              data_stN = weather_tmin_st,
#'                              parm_nm = "tmax",
#'                              crs = 2163); target_data_t
#' target_data <- target_data_t %>%
#'   nest(data = c(target, predictor)); target_data
#' data <- target_data[which(target_data$county == "boone"), ]$data[[1]]; data
#' # humboldt for none; allamakee for one; boone for two
#' # data
#' date_col = c("Year", "Date")
#' scaling = c("Year","Month")
#' aggMethod = c("mean","max")
#'predictor <- tempo_rescaling(df = data$predictor[[1]],
#'                              date_col = date_col[2],
#'                              indf_scale = scaling[1],
#'                              destinate_scale = scaling[2],
#'                              aggMethod = aggMethod[2]);predictor
#'target <- tempo_rescaling(df = data$target[[1]],
#'                          date_col = date_col[1],
#'                          indf_scale = scaling[1],
#'                          destinate_scale = scaling[1],
#'                          aggMethod = aggMethod[1]); target

tempo_rescaling <- function(df, date_col, indf_scale, destinate_scale, aggMethod){

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

  rescaled_df <- df %>%
    select(date_col) %>%
    setNames(c("Date_col")) %>%
    mutate(Date = Date_col %>% ymd_hms(truncated = gettruncated(date_col))) %>% # extract ymd_hms
    mutate(join_by = eval(call(paste0("", tolower(indf_scale)), Date))) %>% # extract scale for joinning
    mutate(rescale = eval(call(paste0("", tolower(destinate_scale)), Date))) %>% # extract scale for rescaling
    select(join_by, rescale, Date, Date_col) %>% # reorder column: join_by, Date, Date_col
    right_join(df, by = c(Date_col= date_col)) %>% # join using Date_col with original data
    select(-Date, -Date_col)%>% # remove ymd_hms Date and Date_col
    gather(key = "id", value = "val", -c(join_by, rescale)) %>%
    nest(data = val) %>%
    mutate(statistic = data %>% map_dbl(function(data) {
      rescaling_summarise(data = data, rescallingMethod = aggMethod)
    })) %>%
    select(-data); rescaled_df

  # compare scale
  if (gettruncated(indf_scale) <= gettruncated(destinate_scale)) {
    rescaled_df <- rescaled_df %>%
      select(-rescale) %>%
      pivot_wider(names_from = c(id),
                  values_from = statistic,
                  values_fn = list(statistic = list)); rescaled_df
  } else {
    rescaled_df <- rescaled_df %>%
      pivot_wider(names_from = c(id, rescale),
                  values_from = statistic,
                  values_fn = list(statistic = list)); rescaled_df
  }
    suppressWarnings({
      rescaled_df <- rescaled_df %>%
        unnest()})

    return(rescaled_df)
}
