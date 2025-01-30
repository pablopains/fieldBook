# Etapa 1: Criar a imagem base e instalar os pacotes R
FROM rocker/verse:4.4.2 AS base
RUN Rscript -e 'install.packages(c("shiny", "downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), dependencies=TRUE, repos="https://cran.rstudio.com")'

# Etapa 2: Instalar dependências do sistema
FROM base AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# Etapa 3: Criar a imagem final e copiar os arquivos do app
FROM rocker/verse:4.4.2  # ❌ NÃO USE "FROM base", pois "base" não é uma imagem oficial
WORKDIR /app

# Copiar apenas os arquivos do aplicativo
COPY --from=builder /app /app
COPY . /app

# Permissões
RUN chmod -R 755 /app

# Verificar os arquivos copiados
RUN ls -l /app

# Expor a porta
EXPOSE 3838

# Rodar o app
CMD ["R", "-e", "shiny::runApp('/app')"]

