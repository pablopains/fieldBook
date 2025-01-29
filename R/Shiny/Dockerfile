# Escolhe a imagem base do R com Shiny e especifica a versão

FROM rocker/shiny:latest

# Cria um diretório para o usuário do Shiny Server
RUN useradd -m -s /bin/bash shinyuser

# Configura o diretório de trabalho do Shiny Server
ENV HOME="/home/shinyuser"
WORKDIR $HOME

# Instala os pacotes R necessários em lote
# RUN Rscript -e 'install.packages(c("downloader", "dplyr", "readr", "rhandsontable", "shiny", "shinydashboard", "shinyWidgets", "stringr", "textclean", "rmarkdown", "knitr"), repos = "https://cran.rstudio.com", dependencies = TRUE)'

# Copia todos os arquivos do app para dentro do container
COPY . $HOME

# Define as permissões do usuário Shiny
USER shinyuser

# Expõe a porta 3838
EXPOSE 3838

# Executa o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('/srv/shiny', port=3838)"]

