# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /home/shiny-app

# Install R dependencies
RUN R -e "install.packages(c('Shiny'))"

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o código do app local para o diretório /app no contêiner
COPY . /app

# Expor a porta para o app Shiny
EXPOSE 3254

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]



