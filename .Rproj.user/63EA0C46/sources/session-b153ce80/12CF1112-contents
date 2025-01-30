# Etapa 1: Criar imagem base
FROM rocker/verse:4.4.2 AS base

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório do app
WORKDIR /app

# Copiar arquivos do R e renv
COPY . /app

# Instalar o renv e restaurar pacotes
RUN Rscript -e "install.packages('renv', repos='https://cran.rstudio.com')"
RUN Rscript -e "renv::restore()"

# Expor porta do Shiny
EXPOSE 3838

# Comando para iniciar o app
CMD ["R", "-e", "shiny::runApp('/app')"]

