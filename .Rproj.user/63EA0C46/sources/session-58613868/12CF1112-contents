# Etapa de build para instalar as dependências
FROM rocker/verse:4.4.2 AS builder

# Definir o diretório de trabalho
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev

# Configurar o repositório do CRAN para um mirror rápido
RUN Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org/'))"

# Instalar pacotes R necessários
RUN Rscript -e "install.packages('shiny', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "install.packages('renv', repos = 'https://cran.rstudio.com')"

# Copiar arquivos do aplicativo para o contêiner
COPY . /app

# Etapa final para rodar o app Shiny
FROM rocker/verse:4.4.2

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o ambiente do R e pacotes instalados da etapa anterior
COPY --from=builder /app /app

# Expor a porta padrão do Shiny
EXPOSE 3838

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]
