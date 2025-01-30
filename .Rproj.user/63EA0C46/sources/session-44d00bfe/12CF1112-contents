# Stage 0: Criar imagem base e instalar pacotes essenciais
FROM rocker/verse:4.4.2 AS base
RUN Rscript -e 'install.packages(c("downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), repos = "https://cran.rstudio.com")'

# Stage 1: Instalar dependências do sistema
FROM base AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# Stage final: Copiar o app e rodar
FROM rocker/verse:4.4.2
WORKDIR /app

# Copiar o aplicativo da pasta local para o diretório /app dentro do contêiner
COPY . /app

RUN chmod -R 755 /app

# Verificar o conteúdo do diretório /app
RUN ls -l /app

# Expor a porta para o Shiny
EXPOSE 3838

# Rodar o aplicativo
CMD ["R", "-e", "shiny::runApp('/app')"]
