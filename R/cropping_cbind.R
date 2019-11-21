#' assign site to pol by st_intersection()
#' @importFrom magrittr %>%
#' @export
#' @examples
#' data(weather_tmax_sf)
#' data(corn_yield_sf)
#' pol <- corn_yield_sf %>%
#' rename(target = data) %>%
#' nest(data = c(geometry)) %>%
#' rename(pol = data) %>%
#' filter(county == "boone");pol # humboldt for none; allamakee for one; boone for two
#' pol <- pol$pol[[1]];pol
#' parm_nm = "parm_nm"
#' plot(st_geometry(pol))
#' plot(st_geometry(data_stN), add = TRUE)
#' cropping_cbind(data_stN = weather_tmax_sf, pol = pol, parm_nm = "tmax")



cropping_cbind <- function(data_stN = NULL, pol = NULL, parm_nm = "parm_nm"){

  cropped_sites <- st_intersection(data_stN, lwgeom::st_make_valid(pol)) %>%
    st_drop_geometry() %>%
    suppressWarnings() %>%
    select(id, data) %>%
    tibble::rowid_to_column("index") %>%
    unnest(data) %>%
    setNames(c("index", parm_nm, "Date", "val")) %>%
    nest(data =c(-index)); cropped_sites$data; cropped_sites
  if (nrow(cropped_sites) == 0) return(NULL)
  cropped_sites <- cropped_sites$data %>%
    purrr::reduce(rbind) %>%
    spread(eval(parm_nm), val, sep = "_", drop = FALSE); cropped_sites
  return(cropped_sites)
}
