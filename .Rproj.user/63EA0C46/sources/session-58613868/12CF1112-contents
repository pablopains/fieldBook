#  Usar a imagem base do Shiny que já tem o pacote instalado
FROM rocker/shiny:4.4.2

#  Definir diretório de trabalho
WORKDIR /home/shiny-app

#  Copiar o código do aplicativo para o contêiner
COPY app.R /home/shiny-app/app.R

#  Expor a porta padrão do Shiny (Railway usa variável de ambiente)
EXPOSE 3838

#  Rodar o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=3838)"]
