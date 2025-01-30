# Etapa 1: Instalar dependências do sistema e pacotes do R
FROM rocker/verse:4.4.2 AS builder
WORKDIR /app

# Atualizar pacotes do sistema e instalar as dependências
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libproj-dev \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \  # Adicionando a biblioteca libudunits2
    && rm -rf /var/lib/apt/lists/*

# Instalar o pacote 'shiny' e outras dependências do R
RUN Rscript -e 'install.packages("shiny", repos = "https://cran.rstudio.com")'

# Etapa 2: Copiar o código do aplicativo e instalar pacotes do renv
FROM rocker/verse:4.4.2
WORKDIR /app

# Copiar o código do aplicativo para o contêiner
COPY . /app

# Instalar renv para gerenciar dependências
RUN Rscript -e 'install.packages("renv", repos = "https://cran.rstudio.com")'

# Restaurar pacotes do R usando o renv
RUN Rscript -e 'renv::restore()'

# Garantir permissões adequadas para os arquivos do aplicativo
RUN chmod -R 755 /app

# Expor a porta para o Shiny
EXPOSE 3838

# Rodar o aplicativo Shiny
CMD ["R", "-e", "shiny::runApp('/app')"]
