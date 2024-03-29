% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tempo_rescaling.R
\name{tempo_rescaling}
\alias{tempo_rescaling}
\title{rescale a data frame with columns: a Date col , id column, val column}
\usage{
tempo_rescaling(df, date_col, indf_scale, destinate_scale, aggMethod)
}
\description{
rescale a data frame with columns: a Date col , id column, val column
}
\examples{
data(weather_tmin_sf)
data(corn_yield_sf)
corn_yield_st <- corn_yield_sf
weather_tmin_st <- weather_tmin_sf
target_data_t <- spatio_fuse(target_stN = corn_yield_st,
                             data_stN = weather_tmin_st,
                             parm_nm = "tmax",
                             crs = 2163); target_data_t
target_data <- target_data_t \%>\%
  nest(data = c(target, predictor)); target_data
data <- target_data[which(target_data$county == "boone"), ]$data[[1]]; data
# humboldt for none; allamakee for one; boone for two
# data
date_col = c("Year", "Date")
scaling = c("Year","Month")
aggMethod = c("mean","max")
predictor <- tempo_rescaling(df = data$predictor[[1]],
                             date_col = date_col[2],
                             indf_scale = scaling[1],
                             destinate_scale = scaling[2],
                             aggMethod = aggMethod[2]);predictor
target <- tempo_rescaling(df = data$target[[1]],
                         date_col = date_col[1],
                         indf_scale = scaling[1],
                         destinate_scale = scaling[1],
                         aggMethod = aggMethod[1]); target
}
