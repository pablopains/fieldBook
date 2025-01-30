# Etapa 1: Usar imagem base com R
FROM rocker/verse:4.4.2 AS base

# Etapa 2: Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Etapa 3: Instalar pacotes do R necessários
# Exemplo com alguns pacotes comuns; ajuste conforme o seu projeto
RUN Rscript -e 'install.packages(c("shiny"), repos = "https://cran.rstudio.com")'

# Etapa 4: Copiar o código do aplicativo para dentro do contêiner
COPY . /app

# Etapa 5: Expor a porta 3838 para o Shiny
EXPOSE 3838

# Etapa 6: Rodar o aplicativo com o comando CMD
CMD ["R", "-e", "shiny::runApp('/app/app.R', host='0.0.0.0', port=3838)"]
