#' Calculate distance matrix in parallel
#'
#' @param x simple feature object. See \code{?sf}
#' @param split_att attribute name (column) from \code{x} to use as file name.
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
#' @return TRUE if success FALSE if could not create the distance matrix
#' @export
calc_dist_matrix <-
  function(x,
           split_att,
           output_dir = ".",
           pb = NULL) {

    if(!"lwgeom" %in% loadedNamespaces())
      stop("Error: load lwgeom first - library(lwgeom)")

    if(!is.null(pb)) pb$tick()

    path_features_dist_meter <- stringr::str_glue("{output_dir}/dist_matrix/{x[[split_att]][1]}.rds")
    dir.create(dirname(path_features_dist_meter), showWarnings = FALSE, recursive = TRUE)

    # stop processing if job has less than two features --------------------------
    if( nrow(x) < 2 ){
      return(NULL)
    }

    # compute geographical distance in parallel ----------------------------------
    ids <- x$id
    x <- sf::st_geometry(x)
    cores <- parallel::detectCores()
    if(!file.exists(path_features_dist_meter)){

      dist_matrix <-
        split(x, 1:length(x)) %>%
        parallel::mclapply(mc.cores = cores, FUN = sf::st_distance, y = x)

      dist_matrix <- do.call("rbind", dist_matrix)
      row.names(dist_matrix) <- ids

      as.dist(dist_matrix) %>%
        saveRDS(file = path_features_dist_meter)

    }

    return(path_features_dist_meter)

  }

