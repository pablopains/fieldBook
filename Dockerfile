# Usa a imagem base do R com Shiny
FROM rocker/shiny:latest

# Definir diretório de trabalho
WORKDIR /srv/shiny-server

# Instalar pacotes necessários do R
RUN R -e "install.packages(c('shiny', 'remotes'), dependencies=TRUE)"

# Copiar o app para dentro do contêiner
COPY app.R /srv/shiny-server/

# Expor a porta 8080 para o Railway
EXPOSE 8080

# Comando para rodar o app no Railway
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=8080)"]
