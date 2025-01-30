# Etapa de construção para instalar as dependências e pacotes
FROM rocker/verse:4.4.2 AS builder

# Definir o diretório de trabalho
WORKDIR /app

# Instalar dependências do sistema para pacotes R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev

# Garantir que o repositório CRAN seja configurado corretamente
RUN Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org/'))"

# Instalar o pacote 'shiny'
RUN Rscript -e "install.packages('shiny', dependences=TRUE)"

# Copiar o aplicativo para o contêiner
COPY . /app

# Etapa final para rodar o app Shiny
FROM rocker/verse:4.4.2

# Definir o diretório de trabalho
WORKDIR /app

# Copiar os arquivos da etapa anterior (pacotes R e app)
COPY --from=builder /app /app

# Expor a porta para o app Shiny
EXPOSE 3838

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]
