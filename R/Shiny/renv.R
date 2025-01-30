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






setwd('C:\\fieldBook - github.com\\fieldBook\\R\\Shiny')

renv::init()
renv::restore(clean = TRUE)


renv::snapshot(packages = c("downloader", "dplyr", "readr", "shiny", "rmarkdown", "knitr"))



.libPaths(c("C:/Users/Pablo Hendrigo/R/library", .libPaths()))

