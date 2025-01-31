# Usa a imagem base do R com Shiny
FROM rocker/shiny:latest

# Definir diretório de trabalho
WORKDIR /home/shiny-app

# Instalar pacotes necessários do R
RUN R -e "install.packages(c('shiny', 'remotes'), dependencies=TRUE)"

# Criar um usuário "shiny" para rodar o app com segurança
RUN useradd -m shiny && chown -R shiny:shiny /home/shiny-app
USER shiny

# Copiar o app para dentro do contêiner
COPY app.R /home/shiny-app/

# Expor a porta 8080 para o Railway
EXPOSE 8080

# Comando para rodar o app no Railway
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=8080)"]
