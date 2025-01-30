FROM rocker/shiny:latest

RUN R -e "install.packages('shiny', dependences=TRUE, , repos = c(CRAN = 'https://cloud.r-project.org'))"

WORKDIR /srv/shiny-server/

COPY . ./srv/shiny-server/

# Expor a porta para o app Shiny
EXPOSE 3838

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server')"]
