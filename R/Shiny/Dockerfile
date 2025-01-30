FROM rocker/shiny:latest

# Cria um usuário para o Shiny Server
RUN useradd -m -s /bin/bash shinyuser

# Configura o diretório de trabalho do usuário
ENV HOME="/home/shinyuser"
WORKDIR $HOME

# Instala o renv
RUN Rscript -e 'install.packages("renv", repos = "https://cran.rstudio.com", dependencies = FALSE)'

# Copia o arquivo .Rprofile (se existir)
COPY .Rprofile $HOME/.Rprofile

# Copia o arquivo renv.lock
COPY renv.lock $HOME/

# Restaura o ambiente do projeto
RUN Rscript -e 'renv::restore()'

# Copia todos os arquivos do aplicativo para o diretório de trabalho do usuário
COPY . $HOME

# Define as permissões do usuário Shiny
USER shinyuser

# Expõe a porta 3838
EXPOSE 3838

# Executa o aplicativo Shiny no diretório de trabalho do usuário
CMD ["R", "-e", "shiny::runApp('.')"]