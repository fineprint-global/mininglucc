# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/geospatial:4.0.2

# required
MAINTAINER Victor Maus <vwmaus1@gmail.com>

COPY . /mininglucc

RUN . /etc/environment \
  # Install linux dependencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  # install R packages dependencies
  && install2.r --error \
    tidyverse \
    bookdown \
    git2r \
    fastcluster \
    progress \
    remotes \
    here \
    pangaear \
  && R -e "remotes::install_version('sf', version = '0.9-6', dependencies= T)" \
  && R -e "remotes::install_version('lwgeom', version = '0.2-5', dependencies= T)" \
  && R -e "remotes::install_version('dplyr', version = '1.0.2', dependencies= T)"

# build compendium package and render the scripts
RUN R -e "devtools::install('/mininglucc', dep=TRUE)" \
  && R -e "rmarkdown::render('/mininglucc/analysis/00-data-preparation.Rmd')" \
  && R -e "rmarkdown::render('/mininglucc/analysis/01-mining-clusters.Rmd')"
