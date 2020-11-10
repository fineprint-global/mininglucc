FROM rocker/binder:4.0.2
LABEL maintainer='Victor Maus'
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}



RUN wget https://github.com/fineprint-global/mininglucc/raw/master/DESCRIPTION && R -e "options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2020-11-06/')); devtools::install_deps()"

RUN rm DESCRIPTION.1; exit 0
