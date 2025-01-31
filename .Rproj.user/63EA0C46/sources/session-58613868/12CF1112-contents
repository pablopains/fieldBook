# Usar imagem base do Shiny com R
FROM rocker/shiny:latest

# Definir diretório de trabalho
WORKDIR /home/shiny-app

# Instalar dependências do sistema
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

# Instalar o pacote 'renv' e restaurar pacotes
RUN R -e "install.packages('renv', repos='https://cran.rstudio.com/')"

# Copiar arquivos do aplicativo
COPY . /home/shiny-app

# Ajustar permissões para o usuário Shiny
RUN chown -R shiny:shiny /home/shiny-app

# Restaurar pacotes do R usando renv
USER shiny
RUN R -e "renv::restore()"

# Expor a porta correta (Railway pode precisar da 8080)
EXPOSE 8080

# Rodar o aplicativo (ajuste a porta caso necessário)
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=8080)"]
