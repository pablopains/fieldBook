# Stage 0: Instalar renv
FROM rocker/verse:4.4.2 AS renv_installer
RUN Rscript -e 'install.packages("renv", repos = "https://cran.rstudio.com")'

# Stage 1: Instalar dependências do sistema (se necessário)
FROM rocker/verse:4.2.2 AS builder
WORKDIR /app
# Instalar pacotes do sistema (exemplo)
RUN apt-get update && apt-get install -y libcurl4-openssl-dev

# Stage 2: Configurar o ambiente renv
FROM renv_installer AS renv
WORKDIR /app
COPY renv.lock renv.lock
RUN Rscript -e 'renv::restore()'

# Stage final: Copiar o aplicativo e configurar o usuário
FROM renv AS final
WORKDIR /app
COPY . .

# Copiar .Rprofile (se existir)
COPY .Rprofile .

# Configurar usuário e porta
USER shinyuser
EXPOSE 3838

# Executar o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('.')"]







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
