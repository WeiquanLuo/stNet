
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stNet

<!-- badges: start -->

<!-- badges: end -->

The goal of stNet is to remove the heterogeneity bewteen spatiotemporal
data by fusing the spatial and temporal feature with mapping to the
desired scale.

## Installation

You can install the released version of stNet from
[CRAN](https://CRAN.R-project.org) with:

``` r
devtools::install_github("WeiquanLuo/stNet")
# install.packages("stNet") # not yet avaliable
```

## Workflow

<center>

![Workflow for rivertopo](inst/extdata/stNet.png)

</center>

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(stNet)
data(weather_tmax_sf)
data(weather_tmin_sf)
data(corn_yield_sf)

corn_yield_st <- corn_yield_sf
weather_tmin_st <- weather_tmin_sf
tictoc::tic()
yield_tmin_t <- spatio_fuse(target_stN = corn_yield_st,
                               data_stN = weather_tmin_st,
                               parm_nm = "tmin",
                               crs = 2163); yield_tmin_t
#> Linking to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0
#> # A tibble: 89 x 3
#>    county             target predictor            
#>    <chr>      <list<df[,2]>> <list>               
#>  1 adair            [39 × 2] <tibble [14,245 × 2]>
#>  2 adams            [39 × 2] <tibble [12,805 × 2]>
#>  3 allamakee        [39 × 2] <tibble [10,641 × 2]>
#>  4 appanoose        [38 × 2] <tibble [14,113 × 3]>
#>  5 audubon          [39 × 2] <tibble [14,101 × 2]>
#>  6 benton           [39 × 2] <tibble [14,245 × 3]>
#>  7 blackhawk        [39 × 2] <tibble [14,245 × 2]>
#>  8 boone            [39 × 2] <tibble [14,245 × 3]>
#>  9 bremer           [39 × 2] <tibble [13,146 × 2]>
#> 10 buenavista       [39 × 2] <tibble [14,245 × 3]>
#> # … with 79 more rows
tictoc::toc()
#> 7.87 sec elapsed
yield_tmin <- tempo_fuse(target_data = yield_tmin_t,
                          date_col = c("Year", "Date"),
                          scaling = c("Year","Month"),
                          aggMethod = c("mean","min")); yield_tmin
#> # A tibble: 89 x 2
#>    county     data              
#>    <chr>      <list>            
#>  1 adair      <tibble [39 × 14]>
#>  2 adams      <tibble [39 × 14]>
#>  3 allamakee  <tibble [39 × 14]>
#>  4 appanoose  <tibble [38 × 26]>
#>  5 audubon    <tibble [39 × 14]>
#>  6 benton     <tibble [39 × 26]>
#>  7 blackhawk  <tibble [39 × 14]>
#>  8 boone      <tibble [39 × 26]>
#>  9 bremer     <tibble [39 × 14]>
#> 10 buenavista <tibble [39 × 26]>
#> # … with 79 more rows

weather_tmax_st <- weather_tmax_sf
tictoc::tic()
yield_tmax_t <- spatio_fuse(target_stN = corn_yield_st,
                               data_stN = weather_tmax_st,
                               parm_nm = "tmax",
                               crs = 2163); yield_tmax_t
#> # A tibble: 89 x 3
#>    county             target predictor            
#>    <chr>      <list<df[,2]>> <list>               
#>  1 adair            [39 × 2] <tibble [14,245 × 2]>
#>  2 adams            [39 × 2] <tibble [12,805 × 2]>
#>  3 allamakee        [39 × 2] <tibble [10,641 × 2]>
#>  4 appanoose        [38 × 2] <tibble [14,113 × 3]>
#>  5 audubon          [39 × 2] <tibble [14,101 × 2]>
#>  6 benton           [39 × 2] <tibble [14,245 × 3]>
#>  7 blackhawk        [39 × 2] <tibble [14,245 × 2]>
#>  8 boone            [39 × 2] <tibble [14,245 × 3]>
#>  9 bremer           [39 × 2] <tibble [13,146 × 2]>
#> 10 buenavista       [39 × 2] <tibble [14,245 × 3]>
#> # … with 79 more rows
tictoc::toc()
#> 7.331 sec elapsed
yield_tmax <- tempo_fuse(target_data = yield_tmax_t,
                          date_col = c("Year", "Date"),
                          scaling = c("Year","Month"),
                          aggMethod = c("mean","min")); yield_tmax
#> # A tibble: 89 x 2
#>    county     data              
#>    <chr>      <list>            
#>  1 adair      <tibble [39 × 14]>
#>  2 adams      <tibble [39 × 14]>
#>  3 allamakee  <tibble [39 × 14]>
#>  4 appanoose  <tibble [38 × 26]>
#>  5 audubon    <tibble [39 × 14]>
#>  6 benton     <tibble [39 × 26]>
#>  7 blackhawk  <tibble [39 × 14]>
#>  8 boone      <tibble [39 × 26]>
#>  9 bremer     <tibble [39 × 14]>
#> 10 buenavista <tibble [39 × 26]>
#> # … with 79 more rows

bind_data <- cbind_TargetDatas(yield_tmin, yield_tmax, 
                               target = "yield", join_by = "Year")
```
