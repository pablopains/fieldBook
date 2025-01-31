# Usar uma imagem base com R e Shiny pré-instalados
FROM rocker/shiny:latest

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /home/shiny-app

# Copiar o código do app para o contêiner
COPY . /home/shiny-app

# Instalar pacotes necessários
RUN R -e "install.packages(c('shiny', 'downloader', 'dplyr', 'DT','lubridate', 'readr', 'rhandsontable', 'shinydashboard', 'shinydashboardPlus', 'shinyWidgets', 'stringr', 'rmarkdown', 'knitr'), dependencies=TRUE)"

# Expor a porta do Shiny
EXPOSE 3838

# Definir comando para rodar o app
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=3838)"]
