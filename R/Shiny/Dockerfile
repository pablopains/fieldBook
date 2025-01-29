# Escolhe a imagem base do R com Shiny
FROM rocker/shiny:latest

# Instala os pacotes R necessários para o seu app
RUN install2.r --error \
downloader \
dplyr \
DT \
jsonlite \
lubridate \
measurements \
plyr \
#raster \
readr \
readxl \
rhandsontable \ # tabela editavel
rnaturalearthdata \
rvest \
shiny \
shinydashboard \
shinydashboardPlus \
shinyWidgets \ # botoes
sqldf \
stringr \
textclean \
tidyr \
writexl \
glue \
tidyverse \
rmarkdown \
knitr \
data.table \

    
    
    
    # Adicione outros pacotes que seu app necessita

# Copia todos os arquivos do app para dentro do container
COPY . /srv/shiny-server/

# Define permissões de leitura e execução
RUN chmod -R 755 /srv/shiny-server/

# Expõe a porta 3838, que é onde o Shiny Server estará ouvindo
EXPOSE 3838

# Comando para rodar o Shiny Server
CMD ["/usr/bin/shiny-server"]
