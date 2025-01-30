# Stage 0: Criar imagem base e instalar pacotes essenciais
FROM rocker/verse:4.4.2 AS base

# Instalar pacotes essenciais (incluindo o Shiny)
RUN Rscript -e 'install.packages(c("shiny", "downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), dependencies=TRUE, repos="https://cran.rstudio.com")'

# Stage 1: Instalar dependências do sistema
FROM base AS builder
WORKDIR /app

# Instalar bibliotecas do sistema necessárias
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# Stage final: Copiar o app e rodar
FROM base  # Usa a imagem base já com os pacotes instalados
WORKDIR /app

# Copiar o aplicativo Shiny para dentro do contêiner
COPY . /app

# Garantir permissões adequadas
RUN chmod -R 755 /app

# Verificar o conteúdo do diretório
RUN ls -l /app

# Expor a porta padrão do Shiny
EXPOSE 3838

# Rodar o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]

