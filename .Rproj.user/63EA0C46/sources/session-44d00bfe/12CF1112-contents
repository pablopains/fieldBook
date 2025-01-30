# Etapa 1: Criar imagem base e instalar os pacotes necessários
FROM rocker/verse:4.4.2 AS base
RUN Rscript -e 'install.packages(c("shiny", "downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), dependencies=TRUE, repos="https://cran.rstudio.com")'

# Etapa 2: Instalar dependências do sistema
FROM base AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# Etapa 3: Criar a imagem final e copiar os arquivos do app
FROM rocker/verse:4.4.2 AS final
WORKDIR /app

# Copiar apenas os arquivos do aplicativo
COPY . /app

# Definir permissões corretas
RUN chmod -R 755 /app

# Expor a porta para o Shiny
EXPOSE 3838

# Comando para iniciar o aplicativo
CMD ["R", "-e", "shiny::runApp('/app')"]

