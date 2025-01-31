# Usar a imagem base do Shiny
FROM rocker/shiny:latest

# Atualizar e instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar pacotes do R
#RUN R -e "install.packages(c('shiny', 'downloader', 'dplyr', 'DT', 'lubridate', 'readr', 'rhandsontable', 'shinydashboard', 'shinydashboardPlus', 'shinyWidgets', 'stringr', 'rmarkdown', 'knitr'), dependencies=TRUE, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny'), dependencies=TRUE, repos='https://cran.rstudio.com/')"


# Criar diretório do aplicativo
WORKDIR /home/shiny-app
COPY . /home/shiny-app

# Expor a porta do Shiny
EXPOSE 3838

# Rodar o aplicativo
CMD ["R", "-e", "shiny::runApp('/home/shiny-app')"]
