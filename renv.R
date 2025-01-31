library(downloader)
library(dplyr)
library(DT)
# library(jsonlite)
library(lubridate)
# library(measurements)
# library(plyr)
library(readr)
# library(readxl)
library(rhandsontable) # tabela editavel
# library(rnaturalearthdata)
# library(rvest)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets) # botoes
# library(sqldf)
library(stringr)
# library(textclean)
# library(tidyr)
# library(writexl)
# library(glue)
# library(tidyverse)

library(rmarkdown)
library(knitr)
# library(data.table)





unlink("renv", recursive = TRUE)
unlink("renv.lock")
renv::init()                      # Cria um novo ambiente
install.packages(c('shiny', 'dplyr', 'readr',  'shinydashboard', 'stringr', 'rmarkdown', 'knitr', 'rhandsontable'), dependencies=TRUE, repos="https://cran.rstudio.com")
renv::snapshot()
renv::status()




renv::upgrade()
renv::rehash()
unlink("renv", recursive = TRUE)  # Remove a pasta renv
unlink("renv.lock")               # Remove o arquivo renv.lock
renv::init()                      # Cria um novo ambiente

install.packages(c('shiny', 'dplyr', 'readr',  'shinydashboard', 'stringr', 'rmarkdown', 'knitr'), dependencies=TRUE, repos="https://cran.rstudio.com")
renv::activate()

renv::snapshot()                   # Salva os pacotes no novo renv.lock


renv::rebuild()

library(sf)

renv::restore()

.libPaths(c("C:/Users/Pablo Hendrigo/R/library", .libPaths()))

renv::remove("units")
