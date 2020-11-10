# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/geospatial:4.0.1

# required
MAINTAINER Victor Maus <vwmaus1@gmail.com>

COPY . /mininglucc

RUN . /etc/environment \
  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  && install2.r --error \
    tidyverse \
    raster \
    rgdal \
    rgeos \
    sf \
    lwgeom \
    bookdown \
    git2r \
    fastcluster \
    progress \
  # build this compendium package
  && R -e "devtools::install('/mininglucc', dep=TRUE)" \
  # render the scripts
  && R -e "rmarkdown::render('/mininglucc/analysis/00-data-preparation.Rmd')"
