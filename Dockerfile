# 1️⃣ Usar imagem base com suporte ao Shiny
FROM rocker/shiny:4.4.2

# 2️⃣ Definir diretório de trabalho
WORKDIR /app

# 3️⃣ Instalar pacotes do sistema necessários
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# 4️⃣ Instalar pacotes do CRAN (com dependências)
RUN R -e "install.packages(c('shiny', 'remotes', 'tidyverse', 'sf', 'devtools'), repos='https://cloud.r-project.org/', dependencies=TRUE)"

# 5️⃣ Instalar pacotes do GitHub (Exemplo: 'pablopains/fieldbook')
RUN R -e "remotes::install_github('pablopains/fieldbook')"

# 6️⃣ Copiar código do aplicativo para o contêiner
COPY . /app

# 7️⃣ Definir permissões
RUN chmod -R 755 /app

# 8️⃣ Expor porta para Railway
EXPOSE 3838

# 9️⃣ Definir o comando para iniciar o Shiny
CMD ["R", "-e", "shiny::runApp('/app', host='0.0.0.0', port=3838)"]
