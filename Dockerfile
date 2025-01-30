FROM rocker/shiny:latest

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

WORKDIR /srv/shiny-server/

COPY ./renv.lock ./renv.lock

COPY . ./srv/shiny-server/

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"