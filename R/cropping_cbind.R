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
#' data(water_Temperature_sf)
#' data(corn_yield_sf)
#' corn_yield_st <- corn_yield_sf
#' water_Temperature_st <- water_Temperature_sf
#'
#' pol <- corn_yield_st %>%
#'      st_transform(2163) %>%
#'   rename(target = data) %>%
#'   nest(data = c(geometry)) %>%
#'   rename(pol = data) %>%
#'   filter(county == "polk") ;pol
#'   # humboldt for none; allamakee for one; boone for two
#' pol <- pol$pol[[1]]; pol
#' data_stN <- water_Temperature_st %>% st_transform(2163)
#' parm_nm = "watertem"
#' plot(st_geometry(pol))
#' plot(st_geometry(data_stN), add = TRUE)
#' cropping_cbind(data_stN = water_Temperature_st, pol = pol, parm_nm = "watertem")

cropping_cbind <- function(data_stN = NULL, pol = NULL, parm_nm = "parm_nm"){

  cropped_sites <- st_intersection(data_stN, st_make_valid(pol)) %>%
    st_drop_geometry() %>%
    suppressWarnings() %>%
    select(id, data) %>%
    rowid_to_column("index") %>%
    unnest(data)

  if (nrow(cropped_sites) == 0) return(NULL)

  cropped_sites <- cropped_sites %>%
    setNames(c("index", parm_nm, "Date", "val")) %>%
    nest(data =c(-index)); cropped_sites$data; cropped_sites

  cropped_sites <- cropped_sites$data %>%
    reduce(rbind) %>%
    spread(eval(parm_nm), val, sep = "_", drop = FALSE); cropped_sites
  return(cropped_sites)
}
