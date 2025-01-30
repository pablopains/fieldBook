# Stage 0: Criar imagem base e instalar pacotes essenciais
FROM rocker/verse:4.4.2 AS base
RUN Rscript -e 'install.packages(c("downloader", "dplyr", "DT", "lubridate", "readr", "rhandsontable", "shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets", "stringr", "rmarkdown", "knitr"), repos = "https://cran.rstudio.com")'

# Stage 1: Instalar dependências do sistema
FROM base AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev && \
    rm -rf /var/lib/apt/lists/*

# Stage final: Copiar o app e rodar
FROM rocker/verse:4.4.2
WORKDIR /app

# Copiar todos os arquivos da raiz para o diretório /app do contêiner
COPY --from=builder /app /app
COPY . /app

# Confirme que app.R ou server.R e ui.R estão no diretório correto
RUN ls -l /app

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app')"]







#FROM rocker/shiny:latest

# Cria um usuário para o Shiny Server
#RUN useradd -m -s /bin/bash shinyuser

# Configura o diretório de trabalho do usuário
#ENV HOME="/home/shinyuser"
#WORKDIR $HOME

# Instala os pacotes R necessários
# RUN Rscript -e 'install.packages(c("downloader", "dplyr", "readr", "shiny", "rmarkdown", "knitr"), repos = "https://cran.rstudio.com", dependencies = TRUE)'

#RUN Rscript -e 'install.packages("renv", repos = "https://cran.rstudio.com", dependencies = FALSE)'

# Copia todos os arquivos do aplicativo para o diretório de trabalho do usuário
#COPY . $HOME

# Define as permissões do usuário Shiny
#USER shinyuser

# Expõe a porta 3838
#EXPOSE 3838

# Executa o aplicativo Shiny no diretório de trabalho do usuário
#CMD ["R", "-e", "shiny::runApp('.')"]
