# Etapa de construção para instalar as dependências e pacotes
FROM rocker/verse:4.4.2 AS builder

# Definir o diretório de trabalho
WORKDIR /app

# Atualizar e instalar as dependências do sistema para pacotes R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar o pacote 'shiny' e suas dependências com dependencies = TRUE
RUN Rscript -e "install.packages('shiny', repos = 'https://cloud.r-project.org/', dependencies = TRUE)" \
    && Rscript -e "install.packages('devtools', repos = 'https://cloud.r-project.org/', dependencies = TRUE)" \
    && Rscript -e "devtools::install_github('rstudio/shiny', dependencies = TRUE)"

# Etapa final para rodar o app Shiny
FROM rocker/verse:4.4.2

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o código do app local para o diretório /app no contêiner
COPY . /app

# Copiar os arquivos da etapa anterior (pacotes R e app)
COPY --from=builder /app /app

# Expor a porta para o app Shiny
EXPOSE 3254

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]



