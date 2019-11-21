#' assign site to pol by st_intersection()
#' @importFrom magrittr %>%
#' @importFrom sf st_drop_geometry st_intersection
#' @importFrom dplyr select
#' @importFrom purrr reduce
#' @importFrom stats setNames
#' @importFrom tidyr spread nest unnest
#' @importFrom tibble rowid_to_column
#' @importFrom lwgeom st_make_valid
#' @export
#' @examples
#' data(weather_tmin_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' weather_tmin_st <- weather_tmin_sf
#'
#' pol <- corn_yield_st %>%
#'   rename(target = data) %>%
#'   nest(data = c(geometry)) %>%
#'   rename(pol = data) %>%
#'   ilter(county == "boone");pol # humboldt for none; allamakee for one; boone for two
#' pol <- pol$pol[[1]];pol
#' parm_nm = "tmin"
#' plot(st_geometry(pol))
#' plot(st_geometry(data_stN), add = TRUE)
#' cropping_cbind(data_stN = weather_tmin_st, pol = pol, parm_nm = "tmin")



cropping_cbind <- function(data_stN = NULL, pol = NULL, parm_nm = "parm_nm"){

  cropped_sites <- st_intersection(data_stN, st_make_valid(pol)) %>%
    st_drop_geometry() %>%
    suppressWarnings() %>%
    select(id, data) %>%
    rowid_to_column("index") %>%
    unnest(data) %>%
    setNames(c("index", parm_nm, "Date", "val")) %>%
    nest(data =c(-index)); cropped_sites$data; cropped_sites
  if (nrow(cropped_sites) == 0) return(NULL)
  cropped_sites <- cropped_sites$data %>%
    reduce(rbind) %>%
    spread(eval(parm_nm), val, sep = "_", drop = FALSE); cropped_sites
  return(cropped_sites)
}
