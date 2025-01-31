# Usar imagem base com R e Shiny pré-instalados
FROM rocker/shiny:latest

# Definir o diretório de trabalho no contêiner
WORKDIR /home/shiny-app

# Instalar dependências do sistema para pacotes do R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar o código do app para o contêiner
COPY . /home/shiny-app

# Instalar pacotes do R (incluindo o Shiny)
RUN R -e "install.packages(c('shiny', 'ggplot2', 'dplyr'), dependencies=TRUE)"

# Expor a porta usada pelo Shiny
EXPOSE
