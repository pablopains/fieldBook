# Usar imagem base do Shiny
FROM rocker/shiny:latest

# Atualizar pacotes do sistema
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

# Definir diretório de trabalho
WORKDIR /home/shiny-app

# Copiar arquivos do app para o container
COPY . /home/shiny-app

# Instalar {renv} e restaurar pacotes do R
RUN R -e "install.packages('renv', repos='https://cran.rstudio.com/')"
RUN R -e "renv::restore()"

# Expor a porta do Shiny
EXPOSE 3838

# Rodar o aplicativo
CMD ["R", "-e", "shiny::runApp('/home/shiny-app')"]
