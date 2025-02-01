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

install.packages('downloader', dempendences = TRUE)
install.packages('devtools', dempendences = TRUE)
install.packages('downloader', dempendences = TRUE)
install.packages('dplyr', dempendences = TRUE)
install.packages('DT', dempendences = TRUE)
install.packages('jsonlite', dempendences = TRUE)
install.packages('lubridate', dempendences = TRUE)
install.packages('measurements', dempendences = TRUE)
install.packages('plyr', dempendences = TRUE)
install.packages('readr', dempendences = TRUE)
install.packages('readxl', dempendences = TRUE)
install.packages('rhandsontable', dempendences = TRUE) # tabela editavel
install.packages('rnaturalearthdata', dempendences = TRUE)
install.packages('rvest', dempendences = TRUE)
install.packages('shiny', dempendences = TRUE)
install.packages('shinydashboard', dempendences = TRUE)
install.packages('shinydashboardPlus', dempendences = TRUE)
install.packages('shinyWidgets', dempendences = TRUE) # botoes
install.packages('stringr', dempendences = TRUE)
install.packages('textclean', dempendences = TRUE)
install.packages('tidyr', dempendences = TRUE)
install.packages('writexl', dempendences = TRUE)
install.packages('glue', dempendences = TRUE)
install.packages('tidyverse', dempendences = TRUE)
install.packages('rmarkdown', dempendences = TRUE)
install.packages('knitr', dempendences = TRUE)
install.packages('data.table', dempendences = TRUE)

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
