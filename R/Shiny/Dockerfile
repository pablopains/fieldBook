# Escolhe a imagem base do R com Shiny e especifica a versão

FROM rocker/shiny:latest

# Cria um diretório para o usuário do Shiny Server
RUN useradd -m -s /bin/bash shinyuser

# Configura o diretório de trabalho do Shiny Server
ENV HOME="/home/shinyuser"
WORKDIR $HOME

# Copia o arquivo .Rprofile (se existir)
# COPY .Rprofile $HOME/.Rprofile

# Instala os pacotes R necessários em lote
RUN Rscript -e 'install.packages(c("downloader", "dplyr", "DT", "jsonlite", "lubridate", "measurements", "plyr", "readr", "readxl", "rhandsontable", "rnaturalearthdata", "rvest", "shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "sqldf", "stringr", "textclean", "tidyr", "writexl", "glue", "tidyverse", "rmarkdown", "knitr", "data.table")), repos = "https://cran.rstudio.com")'

# ... (rest of your Dockerfile)
# Copia todos os arquivos do app para dentro do container
COPY . $HOME

# Define as permissões do usuário Shiny
USER shinyuser

# Expõe a porta 3838
EXPOSE 3838

# Executa o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('/srv/shiny', port=3838)"]

