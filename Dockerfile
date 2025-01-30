# Etapa 1: Criar imagem base e instalar os pacotes necessários
FROM rocker/verse:4.4.2 AS base

RUN Rscript -e 'install.packages(c("shiny", "downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), dependencies=TRUE, repos="https://cran.rstudio.com")'

# Etapa 2: Criar a imagem final e copiar os arquivos do app
FROM base AS final
WORKDIR /app

# Copiar apenas os arquivos do aplicativo
COPY . /app

# Definir permissões corretas
RUN chmod -R 755 /app

# Verificar se o pacote Shiny está instalado
RUN R -e "if (!requireNamespace('shiny', quietly = TRUE)) install.packages('shiny', repos='https://cran.rstudio.com')"

# Expor a porta para o Shiny
EXPOSE 3838

# Comando para iniciar o aplicativo
CMD ["R", "-e", "shiny::runApp('/app')"]

