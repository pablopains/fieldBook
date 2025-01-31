# Usar uma imagem base com R e Shiny pré-instalados
FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /home/shiny-app

# Copiar o código do app para o contêiner
COPY . /home/shiny-app

# Instalar pacotes necessários
#RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
#RUN R -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
#RUN R -e "install.packages('readr', repos='https://cran.rstudio.com/')"
#RUN R -e "install.packages('shinydashboard', repos='https://cran.rstudio.com/')"
#RUN R -e "install.packages('stringr', repos='https://cran.rstudio.com/')"
#RUN R -e "install.packages('rmarkdown', repos='https://cran.rstudio.com/')"
#UN R -e "install.packages('knitr', repos='https://cran.rstudio.com/')"


RUN R -e "install.packages('renv', repos='https://cran.rstudio.com/')"
COPY renv.lock /home/shiny-app/
RUN R -e "renv::restore()"


# Expor a porta do Shiny
EXPOSE 3838

# Definir comando para rodar o app
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host='0.0.0.0', port=3838)"]