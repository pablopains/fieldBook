# Etapa 1: Criar a imagem base
FROM rocker/verse:4.4.2 AS base

# Instalar pacotes do sistema necessários para algumas bibliotecas R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libudunits2-dev 

# Instalar o renv e restaurar pacotes
RUN R -e "install.packages('renv', repos = 'https://cran.rstudio.com')"

# Criar diretório para o app
WORKDIR /app
COPY . /app

# Restaurar pacotes do renv
RUN R -e "renv::restore()"

# Expor a porta do Shiny
EXPOSE 3838

# Comando para iniciar o app Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]
