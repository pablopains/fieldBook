# Base do R + Shiny
FROM rocker/shiny:latest

# Definir diretório de trabalho
WORKDIR /home/shiny-app

# Instalar pacotes necessários do R
RUN R -e "install.packages(c('shiny', 'remotes'), dependencies=TRUE)"

# Clonar código do GitHub (se necessário)
RUN R -e "remotes::install_github('pablopains/fieldbook')"

# Copiar os arquivos do app para dentro do contêiner
COPY app.R /home/shiny-app/

# Expor a porta correta para o Railway
EXPOSE 8080

# Rodar o aplicativo
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=8080)"]
