
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

This is a basic example which shows a workflow of using \(stNet\)
functionality:

``` r
library(stNet)
# load data
data(weather_tmax_sf); weather_tmax_st <- weather_tmax_sf # point sf object
data(weather_tmin_sf); weather_tmin_st <- weather_tmin_sf # point sf object
data(corn_yield_sf); corn_yield_st <- corn_yield_sf # polygon sf object
```

### Step 1 fuse the spatio heterogeneity: `spatio_fuse()`

``` r
yield_tmin_t <- spatio_fuse(target_stN = corn_yield_st,
                               data_stN = weather_tmin_st,
                               parm_nm = "tmin",
                               crs = 2163)
#> Linking to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0

yield_tmax_t <- spatio_fuse(target_stN = corn_yield_st,
                               data_stN = weather_tmax_st,
                               parm_nm = "tmax",
                               crs = 2163)
yield_tmax_t
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
yield_tmax_t$target[[1]]
#> # A tibble: 39 x 2
#>     Year yield
#>    <int> <dbl>
#>  1  2018  149.
#>  2  2017  175.
#>  3  2016  190.
#>  4  2015  176.
#>  5  2014  169.
#>  6  2013  138.
#>  7  2012  104.
#>  8  2011  153.
#>  9  2010  139.
#> 10  2009  179.
#> # … with 29 more rows
yield_tmax_t$predictor[[1]]
#> # A tibble: 14,245 x 2
#>    Date       tmax_USC00133438
#>    <date>                <dbl>
#>  1 1980-01-01                0
#>  2 1980-01-02              -11
#>  3 1980-01-03              -22
#>  4 1980-01-04              -17
#>  5 1980-01-05                0
#>  6 1980-01-06               -6
#>  7 1980-01-07              -78
#>  8 1980-01-08              -83
#>  9 1980-01-09              -78
#> 10 1980-01-10               78
#> # … with 14,235 more rows
```

### Step 2: fuse temporal heterogeneity: `tempo_fuse()`

``` r
yield_tmin <- tempo_fuse(target_data = yield_tmin_t,
                          date_col = c("Year", "Date"),
                          scaling = c("Year","Month"),
                          aggMethod = c("mean","min"))

yield_tmax <- tempo_fuse(target_data = yield_tmax_t,
                          date_col = c("Year", "Date"),
                          scaling = c("Year","Month"),
                          aggMethod = c("mean","min"))
yield_tmax
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
yield_tmax$data[[1]]
#> # A tibble: 39 x 14
#>     Year yield tmax_USC0013343… tmax_USC0013343… tmax_USC0013343…
#>    <dbl> <dbl>            <dbl>            <dbl>            <dbl>
#>  1  2018  149.             -200             -128              -22
#>  2  2017  175.             -128              -83              -44
#>  3  2016  190.             -167              -78              -44
#>  4  2015  176.             -139             -133              -56
#>  5  2014  169.             -189             -144             -150
#>  6  2013  138.             -111             -133              -28
#>  7  2012  104.             -133             -106                1
#>  8  2011  153.             -133             -172                1
#>  9  2010  139.             -183             -117                1
#> 10  2009  179.             -211              -39              -56
#> # … with 29 more rows, and 9 more variables: tmax_USC00133438_4 <dbl>,
#> #   tmax_USC00133438_5 <dbl>, tmax_USC00133438_6 <dbl>,
#> #   tmax_USC00133438_7 <dbl>, tmax_USC00133438_8 <dbl>,
#> #   tmax_USC00133438_9 <dbl>, tmax_USC00133438_10 <dbl>,
#> #   tmax_USC00133438_11 <dbl>, tmax_USC00133438_12 <dbl>
```

### Step 3: bind multiple homogeneous spatiotemporal data into a single object

If there multiple parameter for the same target varible, we can use
`cbind_TargetDatas()` to join them. For example, joining two objects
`yield_tmin` and `yield_tmax` by `join_by = "Year"` with anchoring the
target varialbe `target = "yield"`:

``` r

bind_data <- cbind_TargetDatas(yield_tmin, yield_tmax, 
                               target = "yield", join_by = "Year"); bind_data; bind_data$data[[1]]
#> # A tibble: 89 x 2
#>    county     data              
#>    <chr>      <list>            
#>  1 adair      <tibble [39 × 26]>
#>  2 adams      <tibble [39 × 26]>
#>  3 allamakee  <tibble [39 × 26]>
#>  4 appanoose  <tibble [38 × 50]>
#>  5 audubon    <tibble [39 × 26]>
#>  6 benton     <tibble [39 × 50]>
#>  7 blackhawk  <tibble [39 × 26]>
#>  8 boone      <tibble [39 × 50]>
#>  9 bremer     <tibble [39 × 26]>
#> 10 buenavista <tibble [39 × 50]>
#> # … with 79 more rows
#> # A tibble: 39 x 26
#>     Year yield tmin_USC0013343… tmin_USC0013343… tmin_USC0013343…
#>    <dbl> <dbl>            <dbl>            <dbl>            <dbl>
#>  1  2018  149.             -306             -211              -94
#>  2  2017  175.             -211             -167             -133
#>  3  2016  190.             -233             -178             -111
#>  4  2015  176.             -228             -239             -200
#>  5  2014  169.             -261             -256             -228
#>  6  2013  138.             -189             -228             -117
#>  7  2012  104.             -189             -200              -89
#>  8  2011  153.             -206             -261             -133
#>  9  2010  139.             -289             -267             -106
#> 10  2009  179.             -289             -189             -161
#> # … with 29 more rows, and 21 more variables: tmin_USC00133438_4 <dbl>,
#> #   tmin_USC00133438_5 <dbl>, tmin_USC00133438_6 <dbl>,
#> #   tmin_USC00133438_7 <dbl>, tmin_USC00133438_8 <dbl>,
#> #   tmin_USC00133438_9 <dbl>, tmin_USC00133438_10 <dbl>,
#> #   tmin_USC00133438_11 <dbl>, tmin_USC00133438_12 <dbl>,
#> #   tmax_USC00133438_1 <dbl>, tmax_USC00133438_2 <dbl>,
#> #   tmax_USC00133438_3 <dbl>, tmax_USC00133438_4 <dbl>,
#> #   tmax_USC00133438_5 <dbl>, tmax_USC00133438_6 <dbl>,
#> #   tmax_USC00133438_7 <dbl>, tmax_USC00133438_8 <dbl>,
#> #   tmax_USC00133438_9 <dbl>, tmax_USC00133438_10 <dbl>,
#> #   tmax_USC00133438_11 <dbl>, tmax_USC00133438_12 <dbl>
```

### Afterword: Fit Your Model\!

After fusing the spatial and temporal heterogeneity of the data, you can
use other generic modeling technique to do analysis. For example:

``` r
# fitmodel = lm
fitmodel <- function(data){
  model <- lm(yield ~ ., data=data %>% na.omit() %>% dplyr::select(-Year))
  return(model)
}
F_model <- yield_tmin %>%
  dplyr::mutate(model = data %>% purrr::map(fitmodel)) %>% 
  dplyr::mutate(statisics = model %>% purrr::map(.f = function(m) broom::glance(m))) %>%
  tidyr::unnest(statisics); F_model
#> # A tibble: 89 x 14
#>    county data  model r.squared adj.r.squared sigma statistic p.value    df
#>    <chr>  <lis> <lis>     <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>
#>  1 adair  <tib… <lm>      0.353        0.152   27.9     1.76  0.121      10
#>  2 adams  <tib… <lm>      0.559        0.406   22.9     3.66  0.00454    10
#>  3 allam… <tib… <lm>      0.528        0.304   26.2     2.36  0.0551     10
#>  4 appan… <tib… <lm>      0.645        0.309   31.4     1.92  0.0839     19
#>  5 audub… <tib… <lm>      0.227       -0.0209  33.8     0.916 0.526      10
#>  6 benton <tib… <lm>      0.488        0.0281  35.6     1.06  0.446      19
#>  7 black… <tib… <lm>      0.491        0.333   27.6     3.11  0.00972    10
#>  8 boone  <tib… <lm>      0.638        0.312   24.9     1.96  0.0741     19
#>  9 bremer <tib… <lm>      0.503        0.309   28.2     2.59  0.0316     10
#> 10 buena… <tib… <lm>      0.714        0.396   23.8     2.25  0.0448     21
#> # … with 79 more rows, and 5 more variables: logLik <dbl>, AIC <dbl>,
#> #   BIC <dbl>, deviance <dbl>, df.residual <int>
```
