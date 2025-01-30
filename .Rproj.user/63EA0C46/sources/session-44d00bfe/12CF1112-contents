# Etapa 1: Criar imagem base e instalar os pacotes R necessários
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
FROM rocker/verse:4.4.2 AS final  # Aqui NÃO pode ser "FROM base"
WORKDIR /app

# Copiar os pacotes e configurações do estágio anterior
COPY --from=builder /build /app

# Copiar apenas os arquivos do aplicativo (certifique-se de que estão no mesmo diretório do Dockerfile)
COPY . /app

# Permissões para o diretório do app
RUN chmod -R 755 /app

# Verificar se os arquivos foram copiados corretamente
RUN ls -l /app

# Expor a porta para o Shiny
EXPOSE 3838

# Comando para iniciar o aplicativo
CMD ["R", "-e", "shiny::runApp('/app')"]

