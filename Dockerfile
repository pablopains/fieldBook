# Stage 1: Instalar dependências do sistema
FROM rocker/verse:4.4.2 AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# Stage final: Copiar o app e rodar
FROM rocker/verse:4.4.2
WORKDIR /app

# Copiar o aplicativo da pasta local para o diretório /app dentro do contêiner
COPY . /app

RUN chmod -R 755 /app

# Expor a porta para o Shiny
EXPOSE 3838

# Rodar o aplicativo
CMD ["R", "-e", "shiny::runApp('/app')"]

