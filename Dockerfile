






FROM rocker/shiny:latest

# Cria um usuário para o Shiny Server
RUN useradd -m -s /bin/bash shinyuser

# Configura o diretório de trabalho do usuário
ENV HOME="/home/shinyuser"
WORKDIR $HOME

# Instala os pacotes R necessários
RUN Rscript -e 'install.packages(c("downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), repos = "https://cloud.r-project.org")'

RUN Rscript -e 'install.packages("renv", repos = "https://cran.rstudio.com", dependencies = FALSE)'

# Copia todos os arquivos do aplicativo para o diretório de trabalho do usuário
COPY . $HOME

# Define as permissões do usuário Shiny
USER shinyuser

# Expõe a porta 3838
EXPOSE 3838

# Executa o aplicativo Shiny no diretório de trabalho do usuário
CMD ["R", "-e", "shiny::runApp('.')"]
