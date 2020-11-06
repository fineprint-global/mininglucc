# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/geospatial:4.0.1

# required
MAINTAINER Victor Maus <vwmaus1@gmail.com>

COPY . /mininglucc

# go into the repo directory
RUN . /etc/environment \
  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  # build this compendium package
  && R -e "devtools::install('/mininglucc', dep=TRUE)" \
  # render the manuscript into a docx, you'll need to edit this if you've
  # customised the location and name of your main Rmd file
  && R -e "rmarkdown::render('/mininglucc/analysis/paper/paper.Rmd')"
