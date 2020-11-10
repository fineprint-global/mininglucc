#' Calculate distance matrix in parallel
#'
#' @param x simple feature object including at least one column called
#' \code{ISO3_CODE}. See \code{?sf}
#' @param output_dir path to store distance matrix RDS files.
#' Default is work dir
#' @param pb progress bar. See \code{?progress::progress_bar}.
#' Default is NULL
#' @importFrom magrittr %>%
#' @importFrom stats as.dist
#' @importFrom parallel mclapply detectCores
#' @importFrom sf st_distance st_geometry
#' @importFrom stringr str_glue
#'
#' @return path to the distance matrix
#' @export
calc_dist_matrix <- function(x,
                             output_dir = ".",
                             pb = NULL) {

  if(!is.null(pb)) pb$tick()

  path_features_dist_meter <- stringr::str_glue("{output_dir}/dist_matrix/{x$ISO3_CODE[1]}.rds")
  dir.create(dirname(path_features_dist_meter), showWarnings = FALSE, recursive = TRUE)

  # stop processing if job has less than two features --------------------------
  if( nrow(x) < 2 ){
    return(c(geo = NULL))
  }

  # compute geographical distance in parallel ----------------------------------
  x <- sf::st_geometry(x)
  cores <- parallel::detectCores()
  if(!file.exists(path_features_dist_meter)){

    dist_matrix <-
      split(x, 1:length(x)) %>%
      parallel::mclapply(mc.cores = cores, FUN = sf::st_distance, y = x)

    do.call("rbind", dist_matrix) %>%
      as.dist() %>%
      saveRDS(file = path_features_dist_meter)

  }

  return(c(geo = path_features_dist_meter))

}
