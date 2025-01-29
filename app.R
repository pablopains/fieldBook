

options(shiny.maxRequestSize=100000*1024^2) 

zero_filtro <<- 0


# Siglaherbario <<- ""





# source("C:\\ExsicataBR\\Scripts\\JABOT_IPT_Get_v3.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\JABOT_IPT_Use.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\REFLORA_IPT_Get_v3.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\REFLORA_IPT_Use.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\get_keyword_v3_retorno_unico.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\get_colector.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\check_identificationQualifier.R", encoding = "UTF-8") 
# source("C:\\ExsicataBR\\Scripts\\raw2dwc.R", encoding = "UTF-8") 


# source("C:\\ExsicataBR\\Scripts\\FuncoesFichaHerbario.R", encoding = "UTF-8") 
source("FuncoesFichaHerbario.R", encoding = "UTF-8") 

source("get_floraFungaBrasil_v2.R", encoding = "UTF-8") 

source("checkName_FloraFungaBrasil.R", encoding = "UTF-8") 

source("standardize_scientificName.R", encoding = "UTF-8") 


library(devtools)
library(downloader)
library(dplyr)
library(DT)
library(jsonlite)
library(lubridate)
library(measurements)
library(plyr)
#library(raster)
library(readr)
library(readxl)
library(rhandsontable) # tabela editavel
library(rnaturalearthdata)
library(rvest)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets) # botoes
library(sqldf)
library(stringr)
library(textclean)
library(tidyr)
library(writexl)
library(glue)
library(tidyverse)

library(rmarkdown)
library(knitr)
library(data.table)

{
  tempdir <- tempdir()
  
  path_data_ipt <<- 'C:\\ExsicataBR\\data'
  
  if(!dir.exists(path_data_ipt))
  {
    dir.create('c:\\ExsicataBR')
    dir.create('c:\\ExsicataBR\\data')
  }
  # colunas de busca na taxon
  {
    
    colSearch <<- {}
    
    # fb2020
    {
      columns_FB2020 <<- c('taxonRank',
                           'taxonomicStatus')
      # ,
      #                      'nomenclaturalStatus')
      # 
      
      colSearch_fb2020 <<- {}
      
      # fb2020_taxon$taxonRank %>% unique() %>% sort()
      
      taxonRank_fb2020 <- c(
        "ESPECIE",
        "SUB_ESPECIE",
        "VARIEDADE",
        "FORMA")
      colSearch_fb2020[['taxonRank']] <- as.list(taxonRank_fb2020)
      
      # fb2020_taxon$taxonomicStatus %>% unique() %>% sort()
      taxonomicStatus_fb2020 <- c("NOME_ACEITO",
                                  "SINONIMO")
      colSearch_fb2020[['taxonomicStatus']] <- as.list(taxonomicStatus_fb2020)
      
      # nomenclaturalStatus_fb2020 <<-c("NOME_APLICACAO_INCERTA",
      #                                 "NOME_CORRETO",
      #                                 "NOME_CORRETO_VIA_CONSERVACAO",
      #                                 "NOME_ILEGITIMO",
      #                                 "NOME_LEGITIMO_MAS_INCORRETO",
      #                                 "NOME_MAL_APLICADO",
      #                                 "NOME_NAO_EFETIVAMENTE_PUBLICADO",
      #                                 "NOME_NAO_VALIDAMENTE_PUBLICADO" ,
      #                                 "NOME_REJEITADO",
      #                                 "VARIANTE_ORTOGRAFICA")
      # colSearch_fb2020[['nomenclaturalStatus']] <- as.list(nomenclaturalStatus_fb2020)
    }
    
    # wcvp
    {
      columns_wcvp <<- c('rank',
                         'taxonomic_status')
      
      
      colSearch_wcvp <<- {}
      
      # wcvp$rank %>% unique() %>% sort()
      
      taxonRank_wcvp <- c( "Form",
                           "InfraspecificName",
                           "SPECIES",
                           "Subform",
                           "SUBSPECIES",
                           "Subvariety",
                           "VARIETY"  )
      colSearch_wcvp[['rank']] <- as.list(taxonRank_wcvp)
      
      # wcvp$taxonomic_status %>% unique() %>% sort()
      taxonomicStatus_wcvp <- c("Accepted",
                                "Artificial Hybrid",
                                "Homotypic_Synonym",
                                "Synonym",
                                "Unplaced")
      colSearch_wcvp[['taxonomic_status']] <- as.list(taxonomicStatus_wcvp)
    }
    
    colunas_wcvp_sel <<- c("wcvp_kew_id",
                           "wcvp_family",
                           "wcvp_genus",
                           "wcvp_species",
                           "wcvp_infraspecies",
                           "wcvp_taxon_name",
                           "wcvp_authors",
                           "wcvp_rank",
                           "wcvp_taxonomic_status",
                           "wcvp_accepted_kew_id" ,
                           "wcvp_accepted_name",
                           "wcvp_accepted_authors",
                           "wcvp_parent_kew_id",
                           "wcvp_parent_name",
                           "wcvp_parent_authors",  
                           "wcvp_reviewed",         
                           "wcvp_publication",
                           "wcvp_original_name_id",
                           "wcvp_TAXON_NAME_U",
                           "wcvp_searchNotes",
                           "wcvp_searchedName")
    
    colunas_fb2020_sel <<- c("fb2020_taxonID",
                             "fb2020_acceptedNameUsageID",
                             "fb2020_parentNameUsageID",
                             "fb2020_originalNameUsageID",
                             "fb2020_scientificName",
                             # "fb2020_acceptedNameUsage",
                             # "fb2020_parentNameUsage",
                             "fb2020_namePublishedIn",                  
                             "fb2020_namePublishedInYear",
                             "fb2020_higherClassification",             
                             # "fb2020_kingdom",
                             # "fb2020_phylum",                           
                             # "fb2020_class",
                             # "fb2020_order",                            
                             "fb2020_family",
                             "fb2020_genus",                            
                             "fb2020_specificEpithet",
                             "fb2020_infraspecificEpithet",             
                             "fb2020_taxonRank",
                             "fb2020_scientificNameAuthorship",
                             "fb2020_taxonomicStatus",
                             "fb2020_nomenclaturalStatus",              
                             "fb2020_modified",
                             "fb2020_bibliographicCitation",
                             "fb2020_references",
                             "fb2020_scientificNamewithoutAuthorship",  
                             "fb2020_scientificNamewithoutAuthorship_U",
                             "fb2020_searchNotes",
                             "fb2020_searchedName")
    
    colunas_ctrl_dwc <<- c('Ctrl_occurrenceID',
                           # Ctrl_lastCrawled,
                           # Ctrl_lastParsed,
                           # Ctrl_lastInterpreted,
                           'Ctrl_bibliographicCitation',
                           'Ctrl_downloadAsSynonym',
                           'Ctrl_scientificNameSearched',
                           'Ctrl_scientificNameReference',
                           'Ctrl_acceptedNameUsage',
                           'Ctrl_scientificNameAuthorship',
                           'Ctrl_scientificName', 
                           'Ctrl_scientificNameOriginalSource', # aqui
                           'Ctrl_family',
                           'Ctrl_genus',
                           'Ctrl_specificEpithet',
                           'Ctrl_infraspecificEpithet',
                           'Ctrl_modified',
                           'Ctrl_institutionCode',
                           'Ctrl_collectionCode',
                           'Ctrl_catalogNumber',
                           # 'Ctrl_barCode', #aqui
                           'Ctrl_identificationQualifier',
                           'Ctrl_identifiedBy',
                           'Ctrl_dateIdentified',
                           'Ctrl_typeStatus',
                           'Ctrl_recordNumber',
                           'Ctrl_recordedBy',
                           'Ctrl_fieldNumber',
                           'Ctrl_country',
                           'Ctrl_stateProvince',
                           'Ctrl_municipality',
                           'Ctrl_locality',
                           
                           # 18-10-21
                           'Ctrl_year',
                           'Ctrl_month',
                           'Ctrl_day',
                           
                           'Ctrl_decimalLatitude',
                           'Ctrl_decimalLongitude',
                           'Ctrl_occurrenceRemarks',
                           'Ctrl_occurrenceID',
                           'Ctrl_fieldNotes',
                           'Ctrl_comments',
                           'Ctrl_taxonRank')
    
    colunas_verbatin_check <<- c('verbatimNotes',
                                 'temAnoColeta',
                                 'temCodigoInstituicao',
                                 'temNumeroCatalogo',
                                 'temColetor',
                                 'temNumeroColeta',
                                 'temPais',
                                 'temUF',
                                 'temMunicipio',
                                 'temLocalidade',
                                 'temIdentificador',
                                 'temDataIdentificacao')
    
    
    colunas_main_collectors_dictionary <<- c('Ctrl_key_family_recordedBy_recordNumber',
                                             'Ctrl_nameRecordedBy_Standard',
                                             'Ctrl_recordNumber_Standard',
                                             'Ctrl_key_year_recordedBy_recordNumber')
    
    colunas_collection_code_dictionary <<- c('Ctrl_key_collectionCode_catalogNumber',
                                             'Ctrl_collectionCode_Standard',
                                             'Ctrl_catalogNumber_Standard')
    
    
    
    
    
    fb2020_names <- data.frame(stringsAsFactors = FALSE,
                               
                               fb2020_taxonID = 0,
                               fb2020_acceptedNameUsageID = 0,
                               fb2020_parentNameUsageID = 0,
                               fb2020_originalNameUsageID = "0",
                               fb2020_scientificName = "",
                               # fb2020_acceptedNameUsage = "",
                               # fb2020_parentNameUsage = "",
                               fb2020_namePublishedIn = "",                  
                               fb2020_namePublishedInYear = 0,
                               fb2020_higherClassification = "",             
                               # fb2020_kingdom = "",
                               # fb2020_phylum = "",                           
                               # fb2020_class = "",
                               # fb2020_order = "",                            
                               fb2020_family = "",
                               fb2020_genus = "",                            
                               fb2020_specificEpithet = "",
                               fb2020_infraspecificEpithet = "",             
                               fb2020_taxonRank = "",
                               fb2020_scientificNameAuthorship = "",
                               fb2020_taxonomicStatus = "",
                               fb2020_nomenclaturalStatus = "",              
                               fb2020_modified = lubridate::as_datetime("2021-10-31 21:13:33.77"),
                               fb2020_bibliographicCitation = "",
                               fb2020_references = "",
                               fb2020_scientificNamewithoutAuthorship = "",  
                               fb2020_scientificNamewithoutAuthorship_U = "",
                               fb2020_searchNotes = "",
                               fb2020_searchedName = "")
    
    wcvp_names <- data.frame(stringsAsFactors = FALSE,
                             
                             wcvp_kew_id = "",
                             wcvp_family = "",
                             wcvp_genus = "",
                             wcvp_species = "",
                             wcvp_infraspecies = "",
                             wcvp_taxon_name = "",
                             wcvp_authors = "",
                             wcvp_rank = "",
                             wcvp_taxonomic_status = "",
                             wcvp_accepted_kew_id  = "",
                             wcvp_accepted_name = "",
                             wcvp_accepted_authors = "",
                             wcvp_parent_kew_id = "",
                             wcvp_parent_name = "",
                             wcvp_parent_authors = "",  
                             wcvp_reviewed = "",         
                             wcvp_publication = "",
                             wcvp_original_name_id = "",
                             wcvp_TAXON_NAME_U = "",
                             wcvp_searchNotes = "",
                             wcvp_searchedName = "")
    
    join_dwc <- data.frame(stringsAsFactors = FALSE,
                           
                           Ctrl_occurrenceID = "",
                           Ctrl_fieldNotes = '',
                           # Ctrl_lastCrawled = "",
                           # Ctrl_lastParsed = "",
                           # Ctrl_lastInterpreted = "",
                           Ctrl_bibliographicCitation = "",
                           Ctrl_downloadAsSynonym = "",
                           Ctrl_scientificNameSearched = "",
                           Ctrl_scientificNameReference = "",
                           Ctrl_acceptedNameUsage = "",
                           Ctrl_scientificNameAuthorship = "",
                           Ctrl_scientificName = "", 
                           Ctrl_scientificNameOriginalSource = "", # aqui
                           Ctrl_family = "",
                           Ctrl_genus = "",
                           Ctrl_specificEpithet = "",
                           Ctrl_infraspecificEpithet = "",
                           Ctrl_modified = "",
                           Ctrl_institutionCode = "",
                           Ctrl_collectionCode = "",
                           Ctrl_catalogNumber = "",
                           # Ctrl_barCode = "", #aqui
                           Ctrl_identificationQualifier = "",
                           Ctrl_identifiedBy = "",
                           Ctrl_dateIdentified = "",
                           Ctrl_typeStatus = "",
                           Ctrl_recordNumber = "",
                           Ctrl_recordedBy = "",
                           Ctrl_fieldNumber = "",
                           Ctrl_country = "",
                           Ctrl_stateProvince = "",
                           Ctrl_municipality = "",
                           Ctrl_locality = "",
                           
                           # 18-10-21
                           Ctrl_year = "",
                           Ctrl_month = "",
                           Ctrl_day = "",
                           
                           Ctrl_decimalLatitude = "",
                           Ctrl_decimalLongitude = "",
                           Ctrl_occurrenceRemarks = "",
                           Ctrl_occurrenceID = "",
                           Ctrl_fieldNotes = '',
                           Ctrl_comments = "",
                           Ctrl_taxonRank = "")
    
    verbatin_check <- data.frame(stringsAsFactors = FALSE,
                                 verbatimNotes = "",
                                 temAnoColeta = "",
                                 temCodigoInstituicao = "",
                                 temNumeroCatalogo = "",
                                 temColetor = "",
                                 temNumeroColeta = "",
                                 temPais = "",
                                 temUF = "",
                                 temMunicipio = "",
                                 temLocalidade = "",
                                 temIdentificador = "",
                                 temDataIdentificacao = "")
    
  }
  
  
  {
   
    
    require(devtools)
    require(downloader)
    require(dplyr)
    require(DT)
    require(jsonlite)
    require(lubridate)
    require(measurements)
    require(plyr)
    #require(raster)
    require(readr)
    require(readxl)
    require(rhandsontable) # tabela editavel
    require(rnaturalearthdata)
    require(rvest)
    require(shiny)
    require(shinydashboard)
    require(shinydashboardPlus)
    require(shinyWidgets) # botoes
    require(sqldf)
    require(stringr)
    require(textclean)
    require(tidyr)
    require(writexl)
    require(glue)
    require(tidyverse)
    
  }
  
  # cerregar funções 
  { 
    # get_link_source_record_url <- function(occurrenceID,
    #                                        bibliographicCitation,
    #                                        scientificNameReference)
    # {
    #   
    #   x <- data.frame(link=rep('',NROW(bibliographicCitation)), stringsAsFactors = FALSE)
    #   url <- ''
    #   
    #   bibliographicCitation <- bibliographicCitation %>% tolower()
    #   
    #   for(i in 1:NROW(bibliographicCitation))
    #   {
    #     
    #     if (bibliographicCitation[i] == "reflora")
    #     {
    #       barcode <- gsub(paste0(tolower(bibliographicCitation[i]),"=" ), '',occurrenceID[i] )
    #       
    #       base_url <- "http://reflora.jbrj.gov.br/reflora/herbarioVirtual/ConsultaPublicoHVUC/BemVindoConsultaPublicaHVConsultar.do?modoConsulta=LISTAGEM&quantidadeResultado=20&codigoBarra=%s"
    #       url <- sprintf(base_url, barcode)
    #       url
    #       
    #       x$link[i] <- paste0("<a href='", url, "'target='_blank'>", occurrenceID[i],"</a>")
    #     }
    #     
    #     
    #     # jabotRB
    #     if (bibliographicCitation[i] == 'jabotrb')
    #     {
    #       
    #       # occurrenceID = 'jabotRB=RB01031072'
    #       
    #       barcode <- gsub(paste0(bibliographicCitation[i],"=" ), '',occurrenceID[i], ignore.case = TRUE)
    #       barcode <- gsub('RB', '',barcode, ignore.case = TRUE)
    #       
    #       base_url <- 'http://rb.jbrj.gov.br/v2/regua/visualizador.php?r=true&colbot=rb&codtestemunho='
    #       url <- paste0(base_url,barcode)
    #       
    #       x$link[i] <- paste0("<a href='", url, "'target='_blank'> ", occurrenceID[i],"</a>")
    #     }
    #     
    #     
    #     # jabot
    #     if (bibliographicCitation[i] == "jabot")
    #     {
    #       occurrenceID_tmp <- gsub(paste0(tolower(bibliographicCitation[i]),"=" ), '',occurrenceID[i], ignore.case = TRUE )
    #       
    #       occurrenceID_tmp2 <- str_split(occurrenceID_tmp,':')
    #       
    #       col <- occurrenceID_tmp2[[1]][1]
    #       
    #       cat <- occurrenceID_tmp2[[1]][2]
    #       cat <- gsub(col, '',cat )
    #       
    #       base_url <- "http://rb.jbrj.gov.br/v2/regua/visualizador.php?r=true&colbot=%s&codtestemunho=%s"
    #       url <- sprintf(base_url, col, cat)
    #       
    #       # link <- paste0("<a href='", url, "> ", occurrenceID,"</a>")
    #       x$link[i] <- paste0("<a href='", url, "'target='_blank'> ", occurrenceID[i],"</a>")
    #       
    #     }
    #     
    #     
    #     
    #     if (bibliographicCitation[i] == 'splink')
    #     {
    #       
    #       # com barcode
    #       
    #       if (!is.na(str_locate(occurrenceID[i],':')[[1]]))
    #       {
    #         
    #         occurrenceID_tmp <- gsub(paste0(tolower(bibliographicCitation[i]),"=" ), '',occurrenceID[i] )
    #         occurrenceID_tmp <- str_split(occurrenceID_tmp,':')
    #         col <- occurrenceID_tmp[[1]][1]
    #         cat <- occurrenceID_tmp[[1]][2]
    #         # url <- 'https://specieslink.net/search/'
    #         url <- paste0('https://specieslink.net/search/records/catalognumber/',cat,'/collectionCode/',col)
    #         x$link[i] <- paste0("<a href='", url, "'target='_blank'>", occurrenceID[i],"</a>")
    #         
    #       }else  
    #       {
    #         barcode <- gsub(paste0(tolower(bibliographicCitation[i]),"=" ), '',occurrenceID[i] )
    #         
    #         # https://specieslink.net/search/records/barcode/MO0101458866
    #         base_url <- "https://specieslink.net/search/records/barcode/%s"
    #         url <- sprintf(base_url, barcode)
    #         
    #         x$link[i] <- paste0("<a href='", url, "'target='_blank'>", occurrenceID[i],"</a>")
    #       }
    #       
    #       
    #       
    #     }
    #     
    #     
    #     if(bibliographicCitation[i]=='gbif')
    #     {
    #       
    #       occurrenceID_tmp <- gsub(paste0(tolower(bibliographicCitation),"=" ), '',occurrenceID )
    #       
    #       base_url <- "https://www.gbif.org/occurrence/search?occurrence_id=%s&advanced=1&occurrence_status=present"
    #       
    #       # url <- sprintf(base_url,occurrenceID_tmp)
    #       
    #       url <- paste0("https://www.gbif.org/occurrence/search?occurrence_id=",occurrenceID_tmp,"&advanced=1&occurrence_status=present")
    #       
    #       x$link <- paste0("<a href='", url, "'target='_blank'>", occurrenceID,"</a>")
    #       
    #     }
    #   }
    #   
    #   return(url)
    #   
    # }
    # 
    # 
    # check_identificationQualifier <- function(txt_search='',
    #                                           keyword = c(' aff.', ' cf.'))
    # {
    #   df <- data.frame(txt_search=txt_search, stringsAsFactors = FALSE)
    #   df$identificationQualifier <- '' 
    #   
    #   for(kw in keyword)
    #   {
    #     index <- grepl(kw, txt_search, 
    #                    ignore.case = TRUE,
    #                    fixed = TRUE)
    #     
    #     if (any(index)==TRUE) 
    #       # { df$identificationQualifier[index==TRUE] <- rep(gsub('\\\\<|\\\\>','',kw),count(index==TRUE)[2,2]) }
    #     { df$identificationQualifier[index==TRUE] <- rep(gsub('\\\\<|\\\\>','',kw),sum(index==TRUE)) }
    #     
    #     df$txt_search[index==TRUE]
    #   }
    #   return(df$identificationQualifier)
    # }  
    # 
    # 
    # # source("C:/Dados/CNCFlora/shiny/cncflora/functions/verbatimCleaning_v3.R", encoding = "UTF-8")
    # {
    #   substituir_siglas <- function(x)
    #   {
    #     
    #     sigla_estados <- data.frame(nome='',
    #                                 sigla='',
    #                                 Ctrl_standardized_stateProvince='')[-1,]
    #     
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Bahia', sigla='ba', Ctrl_standardized_stateProvince='bahia')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Pará' , sigla='pa', Ctrl_standardized_stateProvince='para')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Rio de Janeiro', sigla='rj', Ctrl_standardized_stateProvince='rio de janeiro')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='São Paulo', sigla='sp', Ctrl_standardized_stateProvince='sao paulo')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Espírito Santo', sigla='es', Ctrl_standardized_stateProvince='espirito santo')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Paraíba', sigla='pb', Ctrl_standardized_stateProvince='paraiba')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Pernambuco', sigla='pe', Ctrl_standardized_stateProvince='alagoas')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Alagoas', sigla='al', Ctrl_standardized_stateProvince='alagoas')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Sergipe', sigla='se', Ctrl_standardized_stateProvince='sergipe')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Piauí', sigla='pi', Ctrl_standardized_stateProvince='piaui')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Maranhão', sigla='ma', Ctrl_standardized_stateProvince='maranhao')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Minas Gerais', sigla='mg', Ctrl_standardized_stateProvince='minas gerais')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Santa Catarina', sigla='sc', Ctrl_standardized_stateProvince='santa catarina')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Paraná', sigla='pr', Ctrl_standardized_stateProvince='parana')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Goiás', sigla='go', Ctrl_standardized_stateProvince='goias')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Mato Grosso', sigla='mt', Ctrl_standardized_stateProvince='mato grosso')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Mato Grosso do Sul', sigla='ms', Ctrl_standardized_stateProvince='mato grosso do sul')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Distrito Federal', sigla='df', Ctrl_standardized_stateProvince='distrito federal')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Rio Grande do Norte', sigla='rn', Ctrl_standardized_stateProvince='rio grande do norte')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Roraima', sigla='rr', Ctrl_standardized_stateProvince='roraima')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Ceará', sigla='ce', Ctrl_standardized_stateProvince='ceara')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Tocantins', sigla='to', Ctrl_standardized_stateProvince='tocantins')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Amapá', sigla='ap', Ctrl_standardized_stateProvince='amapa')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Amazonas', sigla='am', Ctrl_standardized_stateProvince='amazonas')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Rio Grande do Sul', sigla='rs', Ctrl_standardized_stateProvince='rio grande do sul')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Acre', sigla='ac', Ctrl_standardized_stateProvince='acre')
    #     sigla_estados <- sigla_estados %>% dplyr::add_row(nome='Rondônia', sigla='ro', Ctrl_standardized_stateProvince='rondonia')
    #     
    #     x1 <- textclean::replace_non_ascii(tolower(x))
    #     if (any(sigla_estados$sigla %in% x1)) {
    #       return(as.character(sigla_estados$nome[which(sigla_estados$sigla == x1)]))
    #       
    #     } else {
    #       as.character(x)
    #     }
    #   }
    #   
    #   # occ_tmp <- occ_j$all
    #   verbatimCleaning_v2 <- function(occ_tmp,
    #                                   view_summary=FALSE)
    #   {
    #     
    #     # Limpeza
    #     # Remover registros não informativos, sem coletor, numero de coleta, ano e informações de localidade
    #     
    #     
    #     frase_saida_verbatim <- c('ano', 
    #                               'código de instituição',
    #                               'número de catálogo',
    #                               'coletor',
    #                               'número de coleta',
    #                               'país',
    #                               'estado',
    #                               'município',
    #                               'localidade',
    #                               'identificador',
    #                               'data identificação')
    #     
    #     frase_saida_verbatim <- c('year', 
    #                               'institutionCode', #Ctrl_institutionCode
    #                               'catalogNumber', #Ctrl_catalogNumber
    #                               'recordedBy', #Ctrl_recordedBy
    #                               'recordNumber', #Ctrl_recordNumber
    #                               'country', #Ctrl_country
    #                               'stateProvince', #Ctrl_stateProvince_standardized
    #                               'municipality', #Ctrl_municipality_standardized
    #                               'locality', #Ctrl_locality_standardized
    #                               'identifiedBy', #Ctrl_identifiedBy
    #                               'dateIdentified') #Ctrl_dateIdentified
    #     
    #     # substituir_siglas(occ_tmp$Ctrl_stateProvince[1])
    #     # purrr::map(occ_tmp$Ctrl_stateProvince[1], .f = substituir_siglas) %>% simplify2array() %>% replace_non_ascii() %>% toupper()
    #     
    #     occ_tmp <- occ_tmp %>%
    #       # dplyr::filter(Ctrl_deletedRecord==TRUE) %>%
    #       dplyr::mutate(verbatimNotes = '', 
    #                     temAnoColeta = FALSE,
    #                     temCodigoInstituicao = FALSE,
    #                     temNumeroCatalogo = FALSE,
    #                     temColetor = FALSE,
    #                     temNumeroColeta = FALSE,
    #                     temPais = FALSE,
    #                     temUF = FALSE,
    #                     temMunicipio = FALSE,
    #                     temLocalidade = FALSE,
    #                     temIdentificador = FALSE,
    #                     temDataIdentificacao = FALSE) %>%
    #       
    #       dplyr::mutate(Ctrl_country_standardized = '',
    #                     Ctrl_municipality_standardized = textclean::replace_non_ascii(Ctrl_municipality) %>% toupper(),
    #                     Ctrl_stateProvince_standardized = purrr::map(Ctrl_stateProvince, .f = substituir_siglas) %>% simplify2array() %>% replace_non_ascii() %>% toupper(),
    #                     Ctrl_locality_standardized = textclean::replace_non_ascii(Ctrl_locality) %>% toupper(),
    #                     Ctrl_lastParsed = "") %>%
    #       
    #       dplyr::mutate(temAnoColeta =  ifelse( is.na(Ctrl_year) | Ctrl_year == ""  | Ctrl_year == 0 | Ctrl_year <= 10,
    #                                             FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temCodigoInstituicao = ifelse( is.na(Ctrl_institutionCode) | Ctrl_institutionCode=="",
    #                                                    FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temNumeroCatalogo = ifelse( is.na(Ctrl_catalogNumber) | Ctrl_catalogNumber=="",
    #                                                 FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temColetor = ifelse( is.na(Ctrl_recordedBy) | Ctrl_recordedBy=="",
    #                                          FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temNumeroColeta = ifelse( is.na(Ctrl_recordNumber) | Ctrl_recordNumber=="",
    #                                               FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temPais = ifelse( is.na(Ctrl_country) | 
    #                                         (! toupper(Ctrl_country) %in% c("BRAZIL", "BRASIL", "BRESIL", "BRÉSIL","BRA","BR")),
    #                                       FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temUF = ifelse( is.na(Ctrl_stateProvince_standardized) | Ctrl_stateProvince_standardized=="",
    #                                     FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temMunicipio = ifelse( is.na(Ctrl_municipality_standardized) | Ctrl_municipality_standardized=="",
    #                                            FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temLocalidade = ifelse( is.na(Ctrl_locality_standardized) | Ctrl_locality_standardized=="",
    #                                             FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temIdentificador = ifelse( is.na(Ctrl_identifiedBy) | Ctrl_identifiedBy=="",
    #                                                FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.),
    #                     
    #                     
    #                     temDataIdentificacao = ifelse( is.na(Ctrl_dateIdentified) | Ctrl_dateIdentified=="",
    #                                                    FALSE, TRUE) %>%
    #                       ifelse(is.na(.), FALSE,.)) %>%
    #       
    #       dplyr::mutate(Ctrl_country_standardized = ifelse(temPais==TRUE,
    #                                                        'BRA' ,'')) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temAnoColeta==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[1] , sep = ' - '), #'ano de coleta'
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temCodigoInstituicao==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[2], sep = ' - '), #'código de instituição'
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temNumeroCatalogo==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[3] , sep = ' - '), #'número de catálogo'
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temColetor==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[4], sep = ' - '), #'coletor'
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temNumeroColeta==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[5], sep = ' - '), #'número de coleta'
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temPais==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[6], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temUF==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[7], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temMunicipio==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[8], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temLocalidade==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[9], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temIdentificador==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[10], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(verbatimNotes = ifelse(temDataIdentificacao==FALSE,
    #                                            paste(verbatimNotes, frase_saida_verbatim[11], sep = ' - '),
    #                                            verbatimNotes)) %>%
    #       
    #       dplyr::mutate(Ctrl_lastParsed = format(Sys.time(), "%Y %m %d %X"))
    #     
    #     if (view_summary==TRUE)
    #     {
    #       occ_tmp %>%
    #         # dplyr::filter(Ctrl_deletedRecord==TRUE) %>%
    #         dplyr::select(verbatimNotes, 
    #                       temAnoColeta,
    #                       temCodigoInstituicao,
    #                       temNumeroCatalogo,
    #                       temColetor,
    #                       temNumeroColeta,
    #                       temPais,
    #                       temUF,
    #                       temMunicipio,
    #                       temLocalidade,
    #                       temIdentificador,
    #                       temDataIdentificacao,
    #                       Ctrl_country,
    #                       Ctrl_municipality, Ctrl_locality,
    #                       Ctrl_recordedBy, Ctrl_recordNumber,
    #                       Ctrl_institutionCode,  
    #                       Ctrl_catalogNumber,
    #                       Ctrl_year, 
    #                       Ctrl_identifiedBy,
    #                       Ctrl_dateIdentified,
    #                       Ctrl_decimalLatitude, 
    #                       Ctrl_decimalLongitude) %>%
    #         View()
    #     }   
    #     
    #     print(NROW(occ_tmp))
    #     return(occ_tmp)
    #     
    #   }
    #   
    # }
    # 
    # # source("C:/Dados/CNCFlora/shiny/cncflora/functions/duplicata_digital_v2.R", encoding = "UTF-8")
    # {
    #   selectMoreInformativeRecord_v2 <- function(occ_tmp, 
    #                                              onlyLatLon = TRUE,
    #                                              include_unmatched = TRUE,
    #                                              view_summary = FALSE,
    #                                              unmatched = c("__"))
    #   {  
    #     {
    #       
    #       occ_tmp <- occ_tmp %>%
    #         dplyr::mutate(verbatim_quality = (temAnoColeta +
    #                                             temCodigoInstituicao +
    #                                             temNumeroCatalogo+
    #                                             temLocalidade+
    #                                             temMunicipio+
    #                                             temUF))
    #       
    #       occ_tmp <- occ_tmp %>%
    #         dplyr::mutate(key_quality = (temColetor + temNumeroColeta))
    #       
    #       occ_tmp$key_quality
    #       occ_tmp$autoGeoStatus
    #       occ_tmp$coordenadasIncidemMunicipio %>% is.na() %>% any()
    #       occ_tmp$encontrouLocalidade %>% is.na() %>% any()
    #       
    #       occ_tmp <- occ_tmp %>%
    #         dplyr::mutate(geo_quality = (autoGeoStatus+coordenadasCentroideMunicipio+(encontrouLocalidade*2)+(coordenadasIncidemMunicipio*3)))
    #       
    #       occ_tmp$geo_quality
    #       
    #       occ_tmp <- occ_tmp %>%
    #         dplyr::mutate(Ctrl_moreInformativeRecord  = (key_quality + geo_quality + verbatim_quality))
    #       # dplyr::mutate(Ctrl_moreInformativeRecord  = (verbatim_quality))
    #       
    #       occ_tmp$Ctrl_moreInformativeRecord
    #       
    #     }
    #     
    #     {
    #       
    #       print("let's go...")
    #       recordedBy_unique <- occ_tmp$Ctrl_key_family_recordedBy_recordNumber %>% unique() %>%  as.factor()
    #       print(NROW(recordedBy_unique))
    #       
    #       occ_tmp$Ctrl_selectedMoreInformativeRecord <- FALSE
    #       occ_tmp$Ctrl_thereAreDuplicates <- FALSE
    #       occ_tmp$Ctrl_unmatched <- TRUE
    #       
    #       # r=recordedBy_unique[1]
    #       # r='Chrysobalanaceae_RODRIGUES_9408'
    #       # r='Chrysobalanaceae_GUEDES_13405'
    #       # r='Polygalaceae_GARDNER_3582'
    #       # r='Polygalaceae_HAENKE_Haenke s.n.'
    #       # r='Chrysobalanaceae__NA'
    #       # r='Myrtaceae_BARBOSA_217'
    #       # r='Apocynaceae_RIZZO_9413'
    #       # r='Polygalaceae_HASSLER_9468'
    #       
    #       for (r in recordedBy_unique)
    #       {
    #         print(r)
    #         
    #         index_occ <- (occ_tmp$Ctrl_key_family_recordedBy_recordNumber %in% r) %>% ifelse(is.na(.), FALSE,.)
    #         num_records <- NROW(occ_tmp[index_occ==TRUE,])
    #         
    #         # flaq que inidica que há duplicatas
    #         occ_tmp[index_occ==TRUE, ]$Ctrl_thereAreDuplicates <- num_records > 1 
    #         
    #         if (num_records == 0) 
    #         {
    #           print(r)
    #           print('table')
    #           break
    #         }
    #         
    #         n_inc <- lapply(unmatched, grepl, x=r) %>%
    #           simplify2array(., higher = TRUE) %>% sum()
    #         
    #         # if (r %in% unmatched) 
    #         if (n_inc>0)
    #         {
    #           
    #           # incluir filtro espacial
    #           
    #           index_end <- occ_tmp[index_occ==TRUE, ]$autoGeoStatus == TRUE
    #           
    #           occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE] <- include_unmatched
    #           
    #           occ_tmp[index_occ==TRUE, ]$Ctrl_unmatched[index_end==TRUE] <- FALSE
    #           
    #           next
    #         }
    #         
    #         occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord <- 
    #           (occ_tmp[index_occ==TRUE, ]$Ctrl_moreInformativeRecord == 
    #              max(occ_tmp[index_occ==TRUE, ]$Ctrl_moreInformativeRecord) ) 
    #         
    #         occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord
    #         occ_tmp[index_occ==TRUE, ]$Ctrl_bibliographicCitation
    #         
    #         if (sum(occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord)>1)
    #         {
    #           
    #           index_end <- occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord == TRUE &
    #             # occ_tmp[index_occ==TRUE, ]$autoGeoStatus == TRUE &
    #             occ_tmp[index_occ==TRUE, ]$Ctrl_bibliographicCitation == "REFLORA"
    #           
    #           
    #           if (sum(index_end)>0)
    #           {
    #             n_tmp <- NROW(occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE])
    #             if (n_tmp==1)
    #             {
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #             } else
    #             {
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE][2:n_tmp] <- FALSE
    #             }   
    #           } else
    #           {
    #             index_end <- occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord == TRUE &
    #               # occ_tmp[index_occ==TRUE, ]$autoGeoStatus == TRUE &
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_bibliographicCitation == "SPLINK"
    #             
    #             if (sum(index_end)>0)
    #             {
    #               n_tmp <- NROW(occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE])
    #               if (n_tmp==1)
    #               {
    #                 occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #               } else
    #               {
    #                 occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #                 occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE][2:n_tmp] <- FALSE
    #               }   
    #               
    #             } else
    #             {
    #               index_end <- occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord == TRUE 
    #               # &
    #               #    occ_tmp[index_occ==TRUE, ]$autoGeoStatus == TRUE
    #               
    #               
    #               if (sum(index_end)>0)
    #               {
    #                 n_tmp <- NROW(occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE])
    #                 if (n_tmp==1)
    #                 {
    #                   occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #                 } else
    #                 {
    #                   occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #                   occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE][2:n_tmp] <- FALSE
    #                 }   
    #               } else
    #               {
    #                 if (onlyLatLon==TRUE)
    #                 {
    #                   # todos
    #                   occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[1:num_records] <- FALSE
    #                 } else
    #                 {
    #                   # exceto o primeiro
    #                   occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[2:num_records] <- FALSE 
    #                 }   
    #               }
    #               
    #               # }   
    #             }   
    #           }   
    #         } else 
    #         {
    #           
    #           index_end <- occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord == TRUE 
    #           
    #           # &
    #           #    # is.na(occ_tmp[index_occ==TRUE, ]$new_Lat) == FALSE 
    #           #    occ_tmp[index_occ==TRUE, ]$temCoordenadas == TRUE
    #           
    #           if (sum(index_end)>0)
    #           {
    #             n_tmp <- NROW(occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE])
    #             if (n_tmp==1)
    #             {
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #             } else
    #             {
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE][2:n_tmp] <- FALSE
    #             }   
    #           } else
    #           {
    #             if (onlyLatLon==TRUE)
    #             {
    #               # todos
    #               occ_tmp[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[1:num_records] <- FALSE
    #             }   
    #           }
    #         }   
    #       }
    #       
    #       # }   
    #     }
    #     
    #     
    #     res_in <- occ_tmp %>%
    #       dplyr::select(Ctrl_key_family_recordedBy_recordNumber,
    #                     Ctrl_numberRecordsOfSample,
    #                     Ctrl_bibliographicCitation,
    #                     Ctrl_moreInformativeRecord,
    #                     Ctrl_autoGeoLongitude,
    #                     Ctrl_autoGeoLatitude,
    #                     Ctrl_selectedMoreInformativeRecord,
    #                     autoGeoStatus,
    #                     autoGeoNotes,
    #                     verbatimNotes,
    #                     Ctrl_occurrenceID)
    #     
    #     if (view_summary==TRUE)
    #     {
    #       res_in %>%
    #         View()
    #     }
    #     
    #     
    #     print('...finished!')
    #     # return(occ_tmp)
    #     return(list(occ = occ_tmp,
    #                 summary_MIR = res_in))
    #   }
    #   
    # }
    # 
    # # source("C:/Dados/CNCFlora/shiny/cncflora/functions/prepere_lastNameRecordedBy_v3.R", encoding = "UTF-8")
    # {
    #   prepere_lastNameRecordedBy_v3 <- function(occ_tmp, 
    #                                             coletoresDB=coletoresDB)
    #   {  
    #     
    #     coletoresDB <- coletoresDB %>%
    #       dplyr::rename(Ctrl_nameRecordedBy_Standard_CNCFlora = Ctrl_nameRecordedBy_Standard)
    #     
    #     
    #     Ctrl_lastNameRecordedBy <- lapply(occ_tmp$Ctrl_recordedBy %>% 
    #                                         toupper() %>%
    #                                         unique(), 
    #                                       get_lastNameRecordedBy) %>% 
    #       do.call(rbind.data.frame, .)
    #     
    #     recordedBy_Standart <- data.frame(
    #       Ctrl_nameRecordedBy_Standard =  textclean::replace_non_ascii(toupper(Ctrl_lastNameRecordedBy[,1])),
    #       Ctrl_recordedBy = occ_tmp$Ctrl_recordedBy %>% toupper() %>% unique(),
    #       stringsAsFactors = FALSE) 
    #     
    #     recordedBy_Standart <- left_join(recordedBy_Standart,
    #                                      coletoresDB,
    #                                      by = c('Ctrl_recordedBy')) %>%
    #       # dplyr::mutate(coletoresDB='') %>% 
    #       dplyr::mutate(coletoresDB=ifelse(!is.na(Ctrl_nameRecordedBy_Standard_CNCFlora),
    #                                        'Banco de Coletores OK',
    #                                        '')) %>%
    #       dplyr::mutate(Ctrl_nameRecordedBy_Standard = ifelse(coletoresDB=='Banco de Coletores OK',
    #                                                           Ctrl_nameRecordedBy_Standard_CNCFlora,
    #                                                           Ctrl_nameRecordedBy_Standard)) %>% 
    #       dplyr::arrange(coletoresDB, Ctrl_nameRecordedBy_Standard, Ctrl_recordedBy) %>%
    #       dplyr::mutate(Ctrl_notes = Ctrl_notes %>% as.character(),
    #                     Ctrl_update = Ctrl_update %>% as.character(),
    #                     Ctrl_nameRecordedBy_Standard = Ctrl_nameRecordedBy_Standard %>% as.character(),
    #                     Ctrl_recordedBy = Ctrl_recordedBy %>% as.character(),
    #                     collectorName = collectorName %>% as.character(),
    #                     Ctrl_fullName = Ctrl_fullName %>% as.character(),
    #                     Ctrl_fullNameII = Ctrl_fullNameII %>% as.character(),
    #                     CVStarrVirtualHerbarium_PersonDetails = CVStarrVirtualHerbarium_PersonDetails %>% as.character()) %>%
    #       # dplyr::select(Ctrl_notes,
    #       #               Ctrl_update,
    #       #               Ctrl_nameRecordedBy_Standard,
    #       #               Ctrl_recordedBy,
    #       #               collectorName,
    #       #               Ctrl_fullName,
    #       #               Ctrl_fullNameII,
    #       #               CVStarrVirtualHerbarium_PersonDetails)
    #       dplyr::select(Ctrl_nameRecordedBy_Standard,
    #                     Ctrl_recordedBy,
    #                     Ctrl_notes,
    #                     coletoresDB,
    #                     Ctrl_update,
    #                     collectorName,
    #                     Ctrl_fullName,
    #                     Ctrl_fullNameII,
    #                     CVStarrVirtualHerbarium_PersonDetails)
    #     
    #     
    #     # colnames(recordedBy_Standart)
    #     xn <- nrow((recordedBy_Standart))
    #     recordedBy_Standart <- recordedBy_Standart %>%
    #       dplyr::distinct_('Ctrl_recordedBy', .keep_all =TRUE)
    #     
    #     print( paste0(' Ctrl_recordedBy repetidos na base: ',xn-nrow(recordedBy_Standart)))
    #     
    #     return(recordedBy_Standart)
    #   }
    #   
    # }
    # 
    # # source("C:/Dados/CNCFlora/shiny/cncflora/functions/get_lastNameRecordedBy.R", encoding = "UTF-8")
    # {
    #   get_lastNameRecordedBy <- function(x) 
    #   {
    #     
    #     #aqui
    #     # x = gsub("et al.","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     # x = gsub("et. al.","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     # x = gsub("et al","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     # x = gsub("s.c.","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     # x = gsub("s/c","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     # x = gsub("sc","",x, fixed=TRUE) # teste pablo 10-02-2020
    #     
    #     
    #     x = gsub("[?]","",x) # teste pablo 10-02-2020
    #     
    #     x = gsub("[.]"," ",x) # teste pablo 10-02-2020
    #     
    #     if (length(grep("\\|",x))>0)
    #     {
    #       x = strsplit(x,"\\|")[[1]][1]
    #     }
    #     
    #     x = gsub("[á|à|â|ã|ä]","a",x)
    #     x = gsub("[Á|À|Â|Ã|Ä]","A",x)
    #     
    #     x = gsub("[ó|ò|ô|õ|ö]","o",x)
    #     x = gsub("[Ó|Ò|Ô|Õ|Ö]","O",x)
    #     
    #     x = gsub("[í|ì|î|ï]","i",x)
    #     x = gsub("[Í|Ì|Î|Ï]","I",x)
    #     
    #     x = gsub("[ú|ù|û|ü]","u",x)
    #     x = gsub("[Ú|Ù|Û|Ü]","U",x)
    #     
    #     x = gsub("[é|è|ê|ë]","e",x)
    #     x = gsub("[É|È|Ê|Ë]","E",x)
    #     
    #     x = gsub("ñ","n",x)
    #     x = gsub("Ñ","N",x)
    #     
    #     x = gsub("ç","c",x)
    #     x = gsub("Ç","C",x)
    #     
    #     x = gsub("\\(|\\)"," ",x) # teste pablo 10-02-2020
    #     x = gsub("\\[|\\]"," ",x) # teste pablo 10-02-2020
    #     x = gsub("[\"]"," ",x) # teste pablo 10-02-2020
    #     
    #     #pega o primeiro nome de uma lista de coletores separados por & se houver
    #     if (length(grep("&",x))>0)
    #     {
    #       x = strsplit(x,"&")[[1]][1]
    #     }
    #     
    #     #pega o primeiro nome de uma lista de coletores separados por ";" se houver
    #     if (length(grep(";",x))>0)
    #     {
    #       x_t <- strsplit(x,";")[[1]][1]
    #       
    #       # para capturar padrão iniciado por ;
    #       if (nchar(x_t)==0)
    #       {
    #         x_t <- strsplit(x,";")[[1]][2]
    #         if (is.na(x_t )) { x_t <- ""}
    #       }
    #       
    #       if (nchar(x_t)>0)
    #       {
    #         x <- x_t 
    #       } else
    #       {
    #         x <- ''
    #       }  
    #       
    #     }
    #     #se houver v?rgula pode ser dois casos:
    #     #1. ou o valor antes da v?rgula ? o sobrenome (padr?o INPA)
    #     #2. ou a v?rgula esta separando diferentes coletores (e neste caso as palavras do primeiro elemento n?o s?o apenas abrevia??es)
    #     
    #     # aqui
    #     # vl = grep(",|.",x) 
    #     
    #     vl = grep(",| ",x) 
    #     
    #     #se tem v?rgula
    #     if (length(vl)>0) {
    #       
    #       # aqui 2 se der pau voltar
    #       # x = gsub("[.]"," ",x) # teste pablo 10-02-2020
    #       
    #       #separa pela v?rgula e pega o primeiro elemento
    #       xx = strsplit(x,",")[[1]][1]
    #       
    #       #separa o primeiro elemento antes da v?rgula por espa?os
    #       xx = strsplit(xx," ")[[1]]
    #       
    #       #apaga elementos vazios
    #       xx = xx[xx!=""]
    #       
    #       #se o numero de caracteres da maior palavra for maior do que 2, ent?o o primeiro elemento era todo o nome do coletor, pega apenas o sobrenome
    #       if (max(nchar(xx))>2) {
    #         #1 pegue esta palavra como sobrenome se houver apenas 1 palavra
    #         vll = which(nchar(xx)==max(nchar(xx)))
    #         #ou 2, se houver mais de uma palavra com o mesmo tamanho, pega a ?ltima delas
    #         if (length(vll)>1) {
    #           vll = vll[length(vll)]
    #         } 
    #         sobren = xx[vll]
    #         # ##############
    #         #       # teste para pegar o ultimo nome
    #         #       #1 pegue esta palavra como sobrenome se houver apenas 1 palavra
    #         #       sobren = xx[[length(nchar(xx))]]
    #         # ##############
    #         #       
    #       } else {
    #         #caso contrario h? apenas abrevia??es em xx, ent?o, virgula separa apenas sobrenome de abreviacoes ou prenome 
    #         sb = strsplit(x,",")[[1]]
    #         sb = str_trim(sb)
    #         nsb = nchar(sb)
    #         sbvl = which(nsb==max(nsb))
    #         if (length(sbvl)>1) {
    #           sbvl = sbvl[length(sbvl)]
    #         }
    #         sobren = sb[sbvl]
    #       }
    #     } else {
    #       #neste caso n?o h? virgula, ent?o o ultimo nome ? o sobrenome
    #       xx = strsplit(x," ")[[1]]
    #       sobren = xx[length(xx)]
    #     }
    #     sobren = str_trim(sobren)
    #     sobren = gsub("?","", sobren)
    #     sobren = paste(sobren,sep="-")
    #     if (length(sobren)>0){
    #       x = strsplit(sobren,"\\|")[[1]]
    #       sobren = x[1]
    #       #print(sobren)
    #       return(sobren)
    #     } else {
    #       return("")
    #     }
    #   }
    #   
    # } 
    # 
    # # source('C:/Dados/CNCFlora/shiny/cncflora/functions/update_lastNameRecordedBy_v5.R')
    # {
    #   update_lastNameRecordedBy_v5 <- function(occ_tmp, 
    #                                            recordedBy_ajusted,
    #                                            coletoresDB)
    #   {  
    #     colunas <- colnames(coletoresDB)
    #     
    #     coletoresDB <- coletoresDB %>% 
    #       dplyr::rename(Ctrl_nameRecordedBy_Standard_CNCFlora = Ctrl_nameRecordedBy_Standard) %>%
    #       dplyr::select(Ctrl_recordedBy, Ctrl_nameRecordedBy_Standard_CNCFlora)
    #     
    #     recordedBy_ajusted$Ctrl_recordedBy <- recordedBy_ajusted$Ctrl_recordedBy %>% 
    #       toupper() %>% as.character()
    #     
    #     coletoresDB$Ctrl_recordedBy <- coletoresDB$Ctrl_recordedBy %>% 
    #       toupper() %>% as.character()
    #     
    #     recordedBy_ajusted_new <- anti_join(recordedBy_ajusted,
    #                                         coletoresDB,
    #                                         by = c('Ctrl_recordedBy')) %>%
    #       dplyr::select(colunas)
    #     
    #     ####
    #     
    #     occ_tmp <- occ_tmp %>%
    #       dplyr::mutate(Ctrl_nameRecordedBy_Standard='')
    #     
    #     recordedBy_unique <- occ_tmp$Ctrl_recordedBy %>% unique() %>%  as.factor()
    #     recordedBy_unique <- recordedBy_unique %>% toupper()
    #     # NROW(recordedBy_unique)
    #     
    #     print("let's go...")
    #     print(NROW(recordedBy_unique))
    #     
    #     # atualizando tabela de occorencias
    #     
    #     rt <- NROW(recordedBy_unique)
    #     ri <- 0
    #     
    #     r=recordedBy_unique[1] 
    #     for (r in recordedBy_unique)
    #     {
    #       ri <- ri + 1
    #       
    #       if (is.na(r)) {next}
    #       index_occ <- (occ_tmp$Ctrl_recordedBy %>% toupper() %in% r) %>% ifelse(is.na(.), FALSE,.)
    #       num_records <- NROW(occ_tmp[index_occ==TRUE,])
    #       index_ajusted <- (recordedBy_ajusted$Ctrl_recordedBy == r) %>% ifelse(is.na(.), FALSE,.)
    #       
    #       # sum(index_ajusted)
    #       # any(index_ajusted)
    #       
    #       # group_by_(campo) %>% summarise(frecuencia = n() ))
    #       # recordedBy_ajusted[index_ajusted==TRUE,] %>% dplyr::select(Ctrl_recordedBy)
    #       
    #       print(paste0(ri, ' de ', rt, ' - ', r,' : ',num_records, ' registros' ))
    #       
    #       if (NROW(recordedBy_ajusted[index_ajusted==TRUE,]) == 0)
    #       {
    #         # occ_tmp[index_occ==TRUE, c('Ctrl_nameRecordedBy_Standard')] =
    #         #    data.frame(Ctrl_nameRecordedBy_Standard  = 'undefined collector')
    #         print(r)
    #         print('in ajusted')
    #         next
    #       }
    #       
    #       if (num_records == 0)
    #       {
    #         print(r)
    #         print('table')
    #         break
    #       }
    #       
    #       recordedBy_ajusted_tmp <- recordedBy_ajusted %>%
    #         dplyr::filter(index_ajusted) %>%
    #         dplyr::select(Ctrl_nameRecordedBy_Standard)
    #       
    #       # 09-09-2022
    #       recordedBy_ajusted_tmp <- recordedBy_ajusted_tmp[1,]
    #       
    #       # 18-10-21
    #       #pode-se ajustar aqui as duplicações
    #       
    #       occ_tmp[index_occ==TRUE, c('Ctrl_nameRecordedBy_Standard')] =
    #         data.frame(Ctrl_nameRecordedBy_Standard  = recordedBy_ajusted_tmp)
    #       
    #       # # 08-02-2022 - desliguei essa conferencia desnecessária e que exige grande processamento
    #       # index_ck <- occ_tmp$Ctrl_nameRecordedBy_Standard %in% recordedBy_ajusted_tmp &
    #       #    index_occ
    #       # 
    #       # num_records_ck <- NROW(occ_tmp[index_ck==TRUE,])
    #       # 
    #       # # print(num_records)
    #       # if ((num_records-num_records_ck)>0){print(num_records-num_records_ck)}
    #       
    #     }
    #     
    #     print('...finished!')
    #     
    #     # teste antigo removido
    #     
    #     occ_tmp$Ctrl_recordNumber_Standard <- str_replace_all(occ_tmp$Ctrl_recordNumber, "[^0-9]", "")
    #     
    #     occ_tmp$Ctrl_recordNumber_Standard <- ifelse(is.na(occ_tmp$Ctrl_recordNumber_Standard) |
    #                                                    occ_tmp$Ctrl_recordNumber_Standard=='',"",occ_tmp$Ctrl_recordNumber_Standard  %>% strtoi())
    #     # occ_tmp$Ctrl_recordNumber_Standard <- ifelse(is.na(occ_tmp$Ctrl_recordNumber_Standard),"",occ_tmp$Ctrl_recordNumber_Standard)
    #     
    #     occ_tmp$Ctrl_recordNumber_Standard
    #     
    #     occ_tmp$Ctrl_key_family_recordedBy_recordNumber <- ""
    #     occ_tmp <- occ_tmp %>%
    #       dplyr::mutate(Ctrl_key_family_recordedBy_recordNumber =
    #                       paste(Ctrl_family %>% toupper() %>% glue::trim(),
    #                             Ctrl_nameRecordedBy_Standard,
    #                             Ctrl_recordNumber_Standard,
    #                             # Ctrl_recordNumber,
    #                             
    #                             # Ctrl_year,
    #                             # Ctrl_standardized_stateProvince,
    #                             sep='_'))
    #     
    #     occ_tmp$Ctrl_key_year_recordedBy_recordNumber <- ""
    #     occ_tmp <- occ_tmp %>%
    #       dplyr::mutate(Ctrl_key_year_recordedBy_recordNumber =
    #                       paste(ifelse(Ctrl_year %>% is.na() == TRUE, 'noYear',Ctrl_year)  %>% glue::trim(),
    #                             Ctrl_nameRecordedBy_Standard,
    #                             Ctrl_recordNumber_Standard,
    #                             sep='_'))
    #     
    #     # # numero de registros por frase saída in
    #     res_in <- occ_tmp %>% dplyr::count(paste0(Ctrl_key_family_recordedBy_recordNumber))
    #     colnames(res_in) <- c('Key',
    #                           'numberOfRecords')
    #     res_in <- res_in %>% dplyr::arrange_at(c('numberOfRecords'), desc )
    #     
    #     print(occ_tmp$Ctrl_key_family_recordedBy_recordNumber %>% unique())
    #     return(list(occ = occ_tmp,
    #                 summary = res_in,
    #                 MainCollectorLastNameDB_new=recordedBy_ajusted_new))
    #     
    #     ptint('Finished2!')
    #     
    #   }
    # } 
    # 
    # # no app
    # # source("C:/Dados/APP_GBOT/functions/get_wcvp.R", encoding = "UTF-8")
    # update_wcvp <<- FALSE
    # 
    # # source("C:/Dados/APP_GBOT/functions/get_floraFungaBrasil_v2.R", encoding = "UTF-8")
    #   get_floraFungaBrasil_v2 <- function(url_source = "http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil",
    #                                       path_results = tempdir)#'C:\\Dados\\APP_GBOT\\data') # if NULL
    #     
    #   {  
    #     
    #     require(dplyr)
    #     require(downloader)
    #     require(stringr)
    #     # require(plyr)
    #     
    #     # criar pasta para salvar raultados do dataset
    #     path_results <- paste0(path_results,'/FloraFungaBrasil')
    #     if (!dir.exists(path_results)){dir.create(path_results)}
    #     
    #     destfile <- paste0(path_results,"/IPT_FloraFungaBrasil_.zip")
    #     
    #     
    #     # ultima versao
    #     # destfile <- paste0(path_results,"/",Sys.Date(),'.zip')
    #     downloader::download(url = url_source, destfile = destfile, mode = "wb") 
    #     utils::unzip(destfile, exdir = path_results) # descompactar e salvar dentro subpasta "ipt" na pasta principal
    #     
    #     
    #     taxon.file <- paste0(path_results,"/taxon.txt")
    #     
    #     # taxon.file <- paste0("C:\\Dados\\APP_GBOT\\data\\FloraFungaBrasil\\taxon.txt")
    #     
    #     
    #     
    #     # taxon
    #     fb2020_taxon  <- readr::read_delim(taxon.file, delim = "\t", quote = "") %>% 
    #       dplyr::select(-id)
    #     
    #     ### familia
    #     # index = fb2020_taxon$taxonRank %in% c("ESPECIE",
    #     #                                       "SUB_ESPECIE",
    #     #                                       "VARIEDADE",
    #     #                                       "FORMA")
    #     
    #     index = fb2020_taxon$taxonRank %in% c("ESPECIE",
    #                                           "SUB_ESPECIE",
    #                                           "VARIEDADE",
    #                                           "FORMA",
    #                                           "FAMILIA",
    #                                           "GENERO")
    #     ###
    #     
    #     fb2020_taxon  <- fb2020_taxon[index==TRUE,] 
    #     
    #     
    #     scientificName_tmp <- fb2020_taxon$scientificName %>% stringr::str_split(.,pattern = ' ', simplify = TRUE)
    #     
    #     
    #     # carregando especie sem autor
    #     scientificName <- rep('',nrow(fb2020_taxon))
    #     
    #     # scientificName[index==TRUE] <- scientificName_tmp[index==TRUE,1] %>% trimws(.,'right')
    #     
    #     index = fb2020_taxon$taxonRank %in% c("ESPECIE")
    #     
    #     scientificName[index==TRUE] <-  paste0(scientificName_tmp[index==TRUE,1], ' ', scientificName_tmp[index==TRUE,2]) #%>% trimws(.,'right')
    #     
    #     index = fb2020_taxon$taxonRank %in% c("VARIEDADE")
    #     scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' var. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
    #     
    #     index = fb2020_taxon$taxonRank %in% c("SUB_ESPECIE")
    #     scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' subsp. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
    #     
    #     index = fb2020_taxon$taxonRank %in% c("FORMA")
    #     scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' form. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
    #     
    #     fb2020_taxon$scientificNamewithoutAuthorship <- scientificName
    #     fb2020_taxon$scientificNamewithoutAuthorship_U <- toupper(scientificName)
    #     
    #     fb2020_taxon$scientificNameAuthorship_U <- toupper(fb2020_taxon$scientificNameAuthorship)
    #     
    #     ### reconhecer genero e familia
    #     
    #     fb2020_taxon$genus_U <- toupper(fb2020_taxon$genus)
    #     
    #     fb2020_taxon$family_U <- toupper(fb2020_taxon$family)
    #     
    #     ###
    #     
    #     return(fb2020_taxon)
    #     
    #   }
    # # source("C:/Dados/APP_GBOT/functions/checkName_WCVP.R", encoding = "UTF-8")
    # 
    # # source("C:/Dados/APP_GBOT/functions/checkName_FloraFungaBrasil.R", encoding = "UTF-8")
    #   standardize_scientificName <- function(searchedName = 'Alomia angustata (Gardner) Benth. ex Baker')
    #   {
    #     
    #     x <- {}
    #     
    #     infrataxa = ''
    #     # str_squish(x)
    #     # setdiff(vec1, vec2)
    #     
    #     # Transformação padrão GBIF de híbrido para wcvp 
    #     searchedName_raw <- searchedName
    #     # searchedName <- gsub('×','x ',searchedName)
    #     searchedName <- gsub('×','× ',searchedName)
    #     searchedName_ori <- searchedName
    #     
    #     # if(!is.na(taxonRank))
    #     # {
    #     #   
    #     #   searchedName_clear <- ifelse(taxonRank %in% c('GENUS','FAMILY'),word(searchedName,1),
    #     #                                ifelse(taxonRank=='SPECIES',paste0(word(searchedName,1),' ',word(searchedName,2)),
    #     #                                       ifelse(taxonRank=='VARIETY',paste0(word(searchedName,1),' ', word(searchedName,2), ' var. ', word(searchedName,4)),
    #     #                                              ifelse(taxonRank=='SUBSPECIES',paste0(word(searchedName,1),' ', word(searchedName,2), ' subsp. ', word(searchedName,4)),
    #     #                                                     ifelse(taxonRank=='FORM',paste0(word(searchedName,1),' ', word(searchedName,2), ' f. ', word(searchedName,4)), 
    #     #                                                            '')))))
    #     #   
    #     #   return(list(searchedName = searchedName_raw,
    #     #               standardizeName = searchedName,
    #     #               taxonAuthors= taxon_authors))
    #     #   
    #     # }
    #     
    #     
    #     
    #     sp <- str_split(searchedName, ' ', simplify = T)
    #     padrao <- c('var.', 'subsp.', ' f. ')
    #     padrao_s <- c('var.', 'subsp.', 'f.')
    #     
    #     # Urtica gracilis Aiton subsp. gracilis
    #     
    #     if(length(sp)>1)
    #     {
    #       # if(any(str_detect(searchedName, padrao))==T)
    #       if(grepl(padrao[1],searchedName, fixed = T)|grepl(padrao[2],searchedName, fixed = T)|grepl(padrao[3],searchedName, fixed = T) ) 
    #       {
    #         ip <- 1
    #         for(ip in 1:length(padrao))
    #         {
    #           # grepl(padrao[ip],'teste var. teste', fixed = T)
    #           # grepl(padrao[ip],'"Elatostema variabile C.B.Rob."', fixed = T)
    #           
    #           # if(str_detect(searchedName, padrao[ip])==TRUE)
    #           if(grepl(padrao[ip],searchedName, fixed = T)==TRUE)
    #           {
    #             indx <- sp == padrao_s[ip]
    #             
    #             if(length(sp)>3){if(indx[3]==T){infrataxa <- sp[4]}}
    #             if(length(sp)>4){if(indx[4]==T){infrataxa <- sp[5]}}
    #             if(length(sp)>5){if(indx[5]==T){infrataxa <- sp[6]}}
    #             if(length(sp)>6){if(indx[6]==T){infrataxa <- sp[7]}}
    #             if(length(sp)>7){if(indx[7]==T){infrataxa <- sp[8]}}
    #             if(length(sp)>8){if(indx[8]==T){infrataxa <- sp[9]}}
    #             if(length(sp)>9){if(indx[9]==T){infrataxa <- sp[10]}}
    #             if(length(sp)>10){if(indx[10]==T){infrataxa <- sp[11]}}
    #             if(length(sp)>11){if(indx[11]==T){infrataxa <- sp[12]}}
    #             if(length(sp)>12){if(indx[12]==T){infrataxa <- sp[13]}}
    #             
    #             if(str_detect(searchedName_raw, '×')==TRUE)
    #             {
    #               searchedName <- paste0(sp[1], ' × ', sp[3], ifelse(infrataxa=='','',paste0(' ', padrao_s[ip], ' ', infrataxa)))  
    #             }else
    #             {
    #               searchedName <- paste0(sp[1], ' ', sp[2], ' ', padrao_s[ip], ' ', infrataxa)   
    #             }
    #             
    #             
    #             
    #             break
    #             
    #           }
    #         }
    #       }else
    #       {
    #         
    #         if(str_detect(searchedName_raw, '×')==TRUE)
    #         {
    #           
    #           searchedName <- paste0(sp[1], ' × ', sp[3])  
    #           
    #         }else
    #         {
    #           if((str_sub(sp[2],1,1)==toupper(str_sub(sp[2],1,1)) |
    #               str_sub(sp[2],1,1)=="(") )
    #           {
    #             searchedName <- sp[1]
    #           }else
    #           {
    #             searchedName <- paste0(sp[1], ' ', sp[2])
    #           } 
    #         }
    #       }
    #     }else
    #     {
    #       searchedName <- sp[1]
    #     }
    #     
    #     sp2 <- str_split(searchedName, ' ', simplify = T)
    #     
    #     taxon_authors <- str_sub(searchedName_ori, str_locate(searchedName_ori, sp2[length(sp2)])[2]+2, nchar(searchedName_ori))
    #     # if(length(sp2)>=4){if( paste0(sp2[3], ' ',sp2[4])==taxon_authors){taxon_authors <- ''}}
    #     
    #     if(length(sp2)==4 &!is.na(taxon_authors)){if(paste0(sp2[3], ' ',sp2[4])==taxon_authors){taxon_authors <- ''}}
    #     
    #     # if( (str_sub(sp[3],1,1)==toupper(str_sub(sp[3],1,1)) | str_sub(sp[3],1,1)=="(") & any(str_detect(searchedName, padrao))==TRUE ){taxon_authors <- ''}
    #     
    #     xi <- str_locate(taxon_authors,'\\(')
    #     xf <- str_locate(taxon_authors,'\\)')
    #     
    #     
    #     if(!is.na(xi)[1] & nchar(taxon_authors) > 0)
    #     {    
    #       if(xi[1]==1)
    #       {
    #         taxon_authors_last <- str_sub(taxon_authors,xf[2]+ifelse(str_sub(taxon_authors,xf[2]+1,xf[2]+1)==' ',2,1),nchar(taxon_authors))
    #       }
    #     }else
    #     {
    #       taxon_authors_last <- ''  
    #     }
    #     
    #     if(is.na(taxon_authors)){taxon_authors <- ''}
    #     
    #     
    #     return(list(searchedName = searchedName_raw,
    #                 standardizeName = searchedName,
    #                 taxonAuthors= taxon_authors,
    #                 taxonAuthors_last= taxon_authors_last))
    #   }
    #   
    #   # searchedName = "Acacia plumosa"
    #   # searchedName = "Furnarius rufus"
    #   
    #   # searchedName = "Oncidium cebolleta"
    #   
    #   checkName_FloraFungaBrasil <- function(searchedName = 'Alomia angustata',
    #                                          fb2020="",
    #                                          if_author_fails_try_without_combinations=TRUE)
    #   {
    #     print(searchedName)
    #     # https://powo.science.kew.org/about-wcvp#unplacednames
    #     
    #     x <- {}  
    #     sp_fb <- standardize_scientificName(searchedName)
    #     
    #     if(sp_fb$taxonAuthors != "")
    #     {
    #       
    #       index_author <- 100
    #       
    #       index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) & 
    #         fb2020$scientificNameAuthorship_U %in% toupper(gsub ("\\s+", "", sp_fb$taxonAuthors ))
    #       ntaxa <- NROW(fb2020[index==TRUE,])
    #       
    #       if(ntaxa == 0 & if_author_fails_try_without_combinations == TRUE)
    #       {
    #         index_author <- 50
    #         index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) & 
    #           fb2020$scientificNameAuthorship_U %in% toupper(gsub ("\\s+", "", sp_fb$taxonAuthors_last ))
    #         ntaxa <- NROW(fb2020[index==TRUE,])
    #       }
    #       
    #       
    #       if(ntaxa == 0)
    #       {
    #         index_author <- 0
    #         index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName)
    #         ntaxa <- NROW(fb2020[index==TRUE,])
    #       }
    #       
    #     }else
    #     {
    #       index_author <- 0
    #       index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName)
    #       ntaxa <- NROW(fb2020[index==TRUE,])
    #     }
    #     
    #     if(ntaxa == 0 | sp_fb$standardizeName=="")
    #     {
    #       x <- fb2020[index==TRUE,] %>%
    #         dplyr::add_row()  %>%
    #         dplyr::mutate(searchedName=searchedName,
    #                       taxon_status_of_searchedName = "",
    #                       plant_name_id_of_searchedName = "",
    #                       taxon_authors_of_searchedName = "",
    #                       verified_author = index_author,
    #                       verified_speciesName = 0,
    #                       searchNotes='Not found')
    #     }
    #     
    #     if(ntaxa == 1)
    #     {
    #       verified_speciesName <- 100
    #       
    #       id_accept <- ifelse(is.na(fb2020$acceptedNameUsageID[index==TRUE]),'', fb2020$acceptedNameUsageID[index==TRUE])
    #       
    #       if((!is.na(fb2020$acceptedNameUsageID[index==TRUE])) &
    #          (fb2020$taxonID[index==TRUE] != id_accept ))
    #       {
    #         
    #         x <- fb2020[index==TRUE,]
    #         
    #         taxon_status_of_searchedName <- fb2020[index==TRUE,]$taxonomicStatus
    #         plant_name_id_of_searchedName <- fb2020[index==TRUE,]$taxonID
    #         taxon_authors_of_searchedName <- fb2020[index==TRUE,]$scientificNamewithoutAuthorship
    #         
    #         index_synonym <- fb2020$taxonID %in% x$acceptedNameUsageID 
    #         
    #         if(sum(index_synonym==TRUE)==1)
    #         {
    #           x <- fb2020[index_synonym==TRUE,] %>%
    #             dplyr::mutate(searchedName=searchedName,
    #                           taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                           plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                           taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                           verified_author = index_author,
    #                           verified_speciesName = verified_speciesName,
    #                           searchNotes= 'Updated')
    #           
    #         }else
    #         {
    #           x <- fb2020[index==TRUE,] %>%
    #             dplyr::mutate(searchedName=searchedName,
    #                           taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                           plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                           taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                           verified_author = index_author,
    #                           verified_speciesName = verified_speciesName,
    #                           searchNotes= 'Does not occur in Brazil')
    #         }
    #         
    #       }else
    #       {
    #         x <- fb2020[index==TRUE,] %>%
    #           # dplyr::add_row()  %>%
    #           dplyr::mutate(searchedName=searchedName,
    #                         taxon_status_of_searchedName = "",
    #                         plant_name_id_of_searchedName = "",
    #                         taxon_authors_of_searchedName = "",
    #                         verified_author = index_author,
    #                         verified_speciesName = verified_speciesName,
    #                         searchNotes=ifelse(is.na(taxonomicStatus),'',taxonomicStatus))
    #       }
    #       
    #     }
    #     
    #     if(ntaxa > 1)
    #     {
    #       
    #       taxon_status_of_searchedName <- paste(fb2020[index==TRUE,]$taxonomicStatus, collapse = '|')
    #       plant_name_id_of_searchedName <- paste(fb2020[index==TRUE,]$taxonID, collapse = '|')
    #       # taxon_authors_of_searchedName <- paste(paste0(fb2020[index==TRUE,]$taxon_name, ' ',fb2020[index==TRUE,]$taxon_authors), collapse = '|')
    #       taxon_authors_of_searchedName <- paste(fb2020[index==TRUE,]$scientificNameAuthorship, collapse = '|')
    #       
    #       
    #       # Accepted or Homonyms
    #       {
    #         index_status <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) &
    #           fb2020$taxonomicStatus %in% c( "NOME_ACEITO")
    #         
    #         ntaxa_status <- NROW(fb2020[index_status==TRUE,])
    #         
    #         if(ntaxa_status == 1)
    #         {
    #           
    #           x <- fb2020[index_status==TRUE,] %>%
    #             dplyr::mutate(searchedName=searchedName,
    #                           taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                           plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                           taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                           verified_author = index_author,
    #                           verified_speciesName = 100/ntaxa,
    #                           searchNotes=taxonomicStatus)
    #         }
    #         else
    #         {
    #           
    #           
    #           x <- fb2020[1==2,] %>%
    #             dplyr::add_row()  %>%
    #             dplyr::mutate(searchedName=searchedName,
    #                           taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                           plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                           taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                           verified_author = index_author,
    #                           verified_speciesName = 0,
    #                           searchNotes='Homonyms')
    #           
    #         }
    #         
    #       }
    #       
    #     }
    #     
    #     # 'Homonyms' ajustar família
    #     
    #     if(x$searchNotes == 'Not found' )
    #     {
    #       ### reconhecer genero e familia
    #       # x <-{}
    #       w1 <- toupper(word(sp_fb$standardizeName))
    #       
    #       index <- fb2020$genus_U %in% toupper(w1) & fb2020$taxonRank == 'GENERO' & !is.na(fb2020$acceptedNameUsageID)
    #       ntaxa <- NROW(fb2020[index==TRUE,])
    #       
    #       g_f <- 'g'
    #       
    #       if(ntaxa == 0 )
    #       {
    #         index <- fb2020$family_U %in% toupper(w1) & fb2020$taxonRank == 'FAMILIA' & !is.na(fb2020$acceptedNameUsageID)
    #         ntaxa <- NROW(fb2020[index==TRUE,])
    #         g_f <- 'f'
    #       }    
    #       
    #       if(ntaxa == 1)
    #       {
    #         verified_speciesName <- 100
    #         
    #         id_accept <- ifelse(is.na(fb2020$acceptedNameUsageID[index==TRUE]),'', fb2020$acceptedNameUsageID[index==TRUE])
    #         
    #         if((!is.na(fb2020$acceptedNameUsageID[index==TRUE])) &
    #            (fb2020$taxonID[index==TRUE] != id_accept ))
    #         {
    #           
    #           x <- fb2020[index==TRUE,]
    #           
    #           taxon_status_of_searchedName <- fb2020[index==TRUE,]$taxonomicStatus
    #           plant_name_id_of_searchedName <- fb2020[index==TRUE,]$taxonID
    #           taxon_authors_of_searchedName <- fb2020[index==TRUE,]$scientificNamewithoutAuthorship
    #           
    #           index_synonym <- fb2020$taxonID %in% x$acceptedNameUsageID 
    #           
    #           if(sum(index_synonym==TRUE)==1)
    #           {
    #             x <- fb2020[index_synonym==TRUE,] %>%
    #               dplyr::mutate(searchedName=searchedName,
    #                             taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                             plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                             taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                             verified_author = index_author,
    #                             verified_speciesName = verified_speciesName,
    #                             searchNotes=  ifelse(g_f=='g', 'Updated_genus', 'Updated_family') )
    #             
    #           }else
    #           {
    #             x <- fb2020[index==TRUE,] %>%
    #               dplyr::mutate(searchedName=searchedName,
    #                             taxon_status_of_searchedName = taxon_status_of_searchedName,
    #                             plant_name_id_of_searchedName = plant_name_id_of_searchedName,
    #                             taxon_authors_of_searchedName = taxon_authors_of_searchedName,
    #                             verified_author = index_author,
    #                             verified_speciesName = verified_speciesName,
    #                             searchNotes= 'Does not occur in Brazil')
    #           }
    #           
    #         }else
    #         {
    #           x <- fb2020[index==TRUE,] %>%
    #             # dplyr::add_row()  %>%
    #             dplyr::mutate(searchedName=searchedName,
    #                           taxon_status_of_searchedName = "",
    #                           plant_name_id_of_searchedName = "",
    #                           taxon_authors_of_searchedName = "",
    #                           verified_author = index_author,
    #                           verified_speciesName = verified_speciesName,
    #                           searchNotes=taxonomicStatus)
    #         }
    #         
    #       }
    #       
    #       
    #       if(ntaxa >1)
    #       {
    #         
    #         x <- fb2020[index==TRUE,][1,] %>%
    #           # dplyr::add_row()  %>%
    #           dplyr::mutate(taxonID = '',                           
    #                         acceptedNameUsageID = '',
    #                         parentNameUsageID = '',         
    #                         originalNameUsageID = '',          
    #                         
    #                         # scientificName = ifelse(g_f=='g', genus, family),                    
    #                         scientificName = '', 
    #                         
    #                         acceptedNameUsage  = '',                
    #                         parentNameUsage = '',                   
    #                         namePublishedIn = '',                  
    #                         namePublishedInYear = '',               
    #                         higherClassification = '',             
    #                         # kingdom                           
    #                         # phylum                           
    #                         # class                             
    #                         # order                            
    #                         # family                            
    #                         # genus                            
    #                         specificEpithet = '',                   
    #                         infraspecificEpithet = '',             
    #                         
    #                         # taxonRank = ifelse(g_f=='g',"GENERO", "FAMILIA"),   
    #                         taxonRank = '',
    #                         
    #                         scientificNameAuthorship = '',
    #                         taxonomicStatus = '',                   
    #                         nomenclaturalStatus = '',              
    #                         modified = '',                          
    #                         bibliographicCitation = '',            
    #                         references = '',                        
    #                         scientificNamewithoutAuthorship = ifelse(g_f=='g', genus, family),
    #                         scientificNamewithoutAuthorship_U = ifelse(g_f=='g', genus_U, family_U),
    #                         scientificNameAuthorship_U = '',       
    #                         genus_U,                           
    #                         family_U) %>%
    #           dplyr::mutate(searchedName=searchedName,
    #                         taxon_status_of_searchedName = "",
    #                         plant_name_id_of_searchedName = "",
    #                         taxon_authors_of_searchedName = "",
    #                         verified_author = "",
    #                         verified_speciesName = "",
    #                         searchNotes=taxonRank)
    #       }
    #       ###
    #       
    #     }
    #     
    #     colnames(x) <- str_c('fb2020_',colnames(x))
    #     return(x)
    #     
    #   }
    # 
    # # source("C:\\Dados\\Kew\functions\\standardize_scientificName.R", encoding = "UTF-8")
    
  }
  
  
  main_collectors_dictionary <- data.frame(stringsAsFactors = FALSE,
                                           Ctrl_key_family_recordedBy_recordNumber = "",
                                           Ctrl_nameRecordedBy_Standard = "",
                                           Ctrl_recordNumber_Standard = "",
                                           Ctrl_key_year_recordedBy_recordNumber = "")
  
  collection_code_dictionary <- data.frame(stringsAsFactors = FALSE,
                                           Ctrl_key_collectionCode_catalogNumber = "",
                                           Ctrl_collectionCode_Standard = "",
                                           Ctrl_catalogNumber_Standard = "")
  
  
  
  
  
  occ_result <<- list(
    fb2020_names = fb2020_names,
    wcvp_names = wcvp_names,
    join_dwc = join_dwc)
  
  
  # path_data <<- 'C:\\Dados\\APP_GBOT\\data'
  
  # path_data <<- 'C:\\catalogoUCsBR - github.com\\data'
  if (!dir.exists("c:/R_temp")){dir.create("c:/R_temp")}
  path_data <<- "c:/R_temp"
  
  
  # global
  {
    Ctrl_dateIdentified <<- Sys.Date()
    Ctrl_identifiedBy <<- 'Informe Nome Sobrenome do identificador'
    Ctrl_emailVerificador <<- 'Informe o email'
    # Ctrl_identificationQualifier	<<- ''
    Ctrl_scientificName <<- 'Gênero epiteto_específico Autor'
    Ctrl_familyList <<- ''
    Ctrl_scientificNameList <<- ''
    
    # Ctrl_typeCheckIdentification <- ''
    
    
    
    # Ctrl_voucherAmostra = 'Não validado',
    # Ctrl_amostraVerificada = FALSE,
    Ctrl_naoPossivelVerificar <<- FALSE
    
    Ctrl_observacaoNaoPossivelVerificar <<- ''
    
    Ctrl_dataVerificacao <<- ''
    Ctrl_verificadoPor <<- ''
    Ctrl_scientificName_verified <<- ''
    
    
    
    Ctrl_family_new_family <<- ''
    
    Ctrl_scientificName_new_family  <<- ''
    
    
  }
  
  
  #  Preparaçao
  {
    occ_full_tmp <- {}
    occ_full <<- {}
    key_list <<- {}
    
    occ <<- list(reflora=data.frame(),
                 jabot=data.frame(),
                 jabotRB=data.frame(),
                 splink=data.frame(),
                 gbif=data.frame(),
                 all=data.frame(),
                 
                 filter=data.frame(),
                 filter_key=data.frame(),
                 
                 
                 all_results = data.frame(),
                 
                 all_collectionCode=data.frame(),
                 all_mainCollectorLastName=data.frame(),
                 
                 occ_vc=data.frame(),
                 occ_vc_summ=data.frame(),
                 
                 collectionCode=data.frame(),
                 collectionCodeNew=data.frame(),
                 collectionCodeSummary=data.frame(),
                 
                 mainCollectorLastName=data.frame(),
                 mainCollectorLastNameNew=data.frame(),
                 mainCollectorLastNameSummary=data.frame(),
                 # all_updated_collection_collector=data.frame(),
                 
                 all_geo = data.frame(),
                 
                 wcvp = data.frame(),
                 fb2020 = data.frame(),
                 
                 taxonomicAlignment = data.frame(),
                 
                 fb2020_colSearch  = data.frame(),
                 
                 
                 centroids = data.frame(),
                 
                 all_cc = data.frame(),
                 
                 scientificName_list <- data.frame())
    
    
    # mudar aqui path 
    
    # file.name.sp <- './data/collectionCode/Padronizar_collectionCode.csv'
    # file.name.sp <- 'C:\\catalogoUCsBR - github.com\\data\\collectionCode\\Padronizar_collectionCode.csv'
    # collectionCodeDB <<- readr::read_csv(file.name.sp, 
    #                                      locale = readr::locale(encoding = "UTF-8"),
    #                                      show_col_types = FALSE) %>%
    #    data.frame() %>%
    #    dplyr::mutate(Ctrl_collectionCode = Ctrl_collectionCode %>% toupper())
    
    
    # file.name.sp <- './data/recordedBy/Padronizar_Coletores_CNCFlora.csv'
    file.name.sp <- 'https://raw.githubusercontent.com/pablopains/catalogoUCsBR/main/collectorDictionary/collectorDictionary.csv'
    # file.name.sp <- 'Z:\\Kew\\data\\collectorDictionary\\CollectorsDictionary.csv'
    
    coletoresDB <<- readr::read_csv(file.name.sp, 
                                    locale = readr::locale(encoding = "UTF-8"),
                                    show_col_types = FALSE) %>%
      dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
      data.frame()    
    
    
    # path_iucn_habitats <- 'C:/Dados/APP_GBOT/data/CSVsToProflora/iucn_values'
    # # Countryoccurrence.countryoccurrencelookup.csv
    # Countryoccurrence.countryoccurrencelookup <- readr::read_delim(paste0(path_iucn_habitats,'\\Countryoccurrence.countryoccurrencelookup.csv'),
    #                                                                delim = ',',
    #                                                                locale = readr::locale(encoding = "UTF-8"),
    #                                                                show_col_types = T)
    
    #  geo
    {
      # file.centroids <- "C:/Dados/APP_GBOT/data/centroids/centroids.csv"
      # 
      # centroids <- readr::read_csv(file.centroids,
      #                              locale = readr::locale(encoding = "UTF-8"),
      #                              show_col_types = FALSE)
      
      }
    
    # files_tmp <- 'C:\\Users\\meloh\\Downloads\\Standardize_Join_Occurrences_Darwin_Corre_Terms - 2022-10-12.csv'
    # occ_tmp <- readr::read_csv(files_tmp,
    #                            locale = locale(encoding = "UTF-8"),
    #                            show_col_types = FALSE) %>%
    #    data.frame()
    # 
    # source_data <- 'all'
    # occ[[source_data]] <- occ_tmp
    # occ[[source_data]]$Ctrl_recordedBy
    
  }
}

ui <- 
{
    dashboardPage(
      dashboardHeader(title = "FieldBook WEB"),
      
      dashboardSidebar(width = 230,
                       collapsed = TRUE,
                       sidebarMenu(
                         menuItem("Manual de instuções aplicativo", 
                                  icon = icon("book"), 
                                  href = "", 
                                  newtab = TRUE), # Abre em nova aba
                         menuItem("Manual para obtenção de dados", 
                                  icon = icon("book"), 
                                  href = "",
                                  newtab = TRUE),
                         menuItem("Github pablopains", 
                                  icon = icon("link"), 
                                  href = "https://github.com/pablopains/",
                                  newtab = TRUE),
                         menuItem("CV Lattes Melo, P.H.A.", 
                                  icon = icon("link"), 
                                  href = "http://lattes.cnpq.br/9164034883998857",
                                  newtab = TRUE),
                         
                         menuItem("REFLORA", 
                                  icon = icon("link"), 
                                  href = "http://reflora.jbrj.gov.br/reflora/herbarioVirtual/ConsultaPublicoHVUC/ResultadoDaConsultaNovaConsulta.do",
                                  newtab = TRUE),
                         menuItem("Jabot", 
                                  icon = icon("link"), 
                                  href = "http://jabot.jbrj.gov.br/v3/consulta.php",
                                  newtab = TRUE),
                         menuItem("SpeciesLink", 
                                  icon = icon("link"), 
                                  href = "https://specieslink.net/search/",
                                  newtab = TRUE),
                         menuItem("GBIF", 
                                  icon = icon("link"), 
                                  href = "https://www.gbif.org/occurrence/search?occurrence_status=present&q=",
                                  newtab = TRUE),
                         menuItem("Flora e Funga do Brasil", 
                                  icon = icon("link"), 
                                  href = "https://floradobrasil.jbrj.gov.br/consulta/#CondicaoTaxonCP",
                                  newtab = TRUE)
                       )),
      
      dashboardBody(
        navbarPage("fieldBook Web",
                   tabPanel(icon("table"), 
                            
                            navbarPage("Verificador de nomes científicos de plantas conforme Flora e Funga do Brasil e gerador de etiquetas para herbário",
                                       tabPanel(icon("table"), 
                                                shinydashboard::box(title = "fieldBook - CSV",
                                                                    status = "primary",
                                                                    width = 12,
                                                                    
                                                                    # shiny::tags$a('Manual de instruções para download CatalogoUCsBR', href = 'https://github.com/pablopains/catalogoUCsBR/blob/main/Manual_download_CatalogoUCsBR.pdf'),
                                                                    
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             # shiny::tags$a('SpeciesLink', href = 'https://specieslink.net/search/'),
                                                                             fileInput(inputId = "splinkFile", 
                                                                                       label = "Carregar arquivo(s) CSV fielBook",
                                                                                       multiple = TRUE))),
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             DT::dataTableOutput('splinkContents'))),

                                                                    br(),
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             
                                                                             selectInput(inputId = 'taxonomicBackbone',
                                                                                         label = 'Escolha a espinha dorsal taxonômica:',
                                                                                         choices = list('FloraFungaBrasil'),
                                                                                         multiple = TRUE,
                                                                                         selected = c('FloraFungaBrasil')
                                                                             )
                                                                      )),
                                                                    br(),
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             actionButton("applyTaxonomicAlignment_Btn", "Verificar nomes científicos e bucar autores conforme Flora e Funga do Brasil", icon = icon("play"),
                                                                                          title = "Verificar nomes científicos e bucar autores conforme Flora e Funga do Brasil"),
                                                                      )),
                                                                    
                                                                    br(),
                                                                    
                                                                    
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             DT::dataTableOutput('applyTaxonomicAlignment_Contents'))),
                                                                    br(),
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             downloadButton("downloadData_csv", "Baixar Planilha Verificada",
                                                                                            title = "Baixar Planilha Verificada")
                                                                      )),
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             shiny::tags$div(
                                                                               title = "Informe a Instituição.",
                                                                               textInput("Instituicao_Input", "Instituição:", "")))),
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             shiny::tags$div(
                                                                               title = "Informe o nome  do herbário.",
                                                                               textInput("Nome_Input", "Nome  do herbário:", "")))),
                                                                    
                                                                    # fluidRow(
                                                                    # #   column(width = 4,
                                                                    # # shiny::tags$div(
                                                                    # #   title = "Informe a sigla do herbário.",
                                                                    # #   textInput("Siglaherbario_Input", "Sigla herbário:", ""))),
                                                                    # 
                                                                    # column(width = 12,
                                                                    #        shiny::tags$div(
                                                                    #          title = "Informe o nome  do herbário.",
                                                                    #          textInput("NomeHerbario_Input", "Nome herbário:", "")))
                                                                    # ),
                                                                    
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             shiny::tags$div(
                                                                               title = "Informe o projeto.",
                                                                               textInput("Projeto_Input", "Projeto:", "")))),
                                                                      
                                                                      # fluidRow(
                                                                      #   column(width = 12,
                                                                      #          shiny::tags$div(
                                                                      #            title = "Informe a observação etiqueta",
                                                                      #            textInput("ObservacaoFicha_Input", "Observação etiqueta:", "Prensada em Álcool 70%, amostra preservada em sílica")))),
                                                                    
                                                                    
                                                                    br(),
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             actionButton("geraFicha_Btn", "Gerar Etiquetas", icon = icon("play"),
                                                                                          title = "Gerar Etiquetas"),
                                                                             textOutput("geraFicha_txt")
                                                                      )),
                                                                    
                                                                    br(),
                                                                    fluidRow(
                                                                      column(width = 12,
                                                                             downloadButton("downloadData_zip", "Baixar Etiquetas",
                                                                                            title = "Baixar Etiquetas")
                                                                             )),
                                                
                                                                    )),
                            )),
                   
                   br(),
                   br(),
                   
                   fluidRow(
                     column(width = 12,
                            box(title = 'Copyright ©',
                                status = "primary",
                                width = 12,
                                
                                wellPanel(
                                  fluidRow(
                                    
                                    column(
                                      width = 12,
                                      # helpText("Administrado pelo Instituto de Pesquisas Jardim Botânico do Rio de Janeiro "),
                                      
                                      helpText("Desenvolvido por: Melo, Pablo Hendrigo Alves de"),
                                      
                                      helpText("Versão 1.0.0 de janeiro/2025"),
                                      
                                    ))
                                  
                                ))))
                   
                   
                   
        )
      )
      # }
    )}


  
server <- function(input, output, session)
{
    # filtros
    {
      
      {
      output$Ctrl_scientificName <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          
          dt <- unique(load_occ()[,'Ctrl_scientificName']) %>% na.omit() %>% as.data.frame() #
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))

          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_family <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_family']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))

          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_genus <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_genus']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))

          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_specificEpithet <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_specificEpithet']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_infraspecificEpithet <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_infraspecificEpithet']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_identifiedBy <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_identifiedBy']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_identifiedBy <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_identifiedBy']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_catalogNumber <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_catalogNumber']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_recordNumber <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_recordNumber']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_recordedBy <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_recordedBy']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 500,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_decimalLatitude <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_decimalLatitude']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_bibliographicCitation <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_bibliographicCitation']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_decimalLongitude <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_decimalLongitude']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
    
      output$Ctrl_locality <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_locality']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 500,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_occurrenceRemarks <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_occurrenceRemarks']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_comments <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_comments']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_dateIdentified <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_dateIdentified']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_institutionCode <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_institutionCode']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_collectionCode <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_collectionCode']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_typeStatus <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_typeStatus']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_taxonRank <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_taxonRank']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_day <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_day']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_month <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_month']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_year <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_year']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      
      output$Ctrl_municipality <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_municipality']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_stateProvince <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_stateProvince']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })

      output$Ctrl_country <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_country']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      
      output$Ctrl_dateIdentified <- renderRHandsontable(
        {
          shiny::validate(need(NROW(load_occ())>0,  "..."))
          
          dt <- unique(load_occ()[,'Ctrl_dateIdentified']) %>% na.omit() %>% as.data.frame() #%>% dplyr::arrange_at(., c(colunas[i]))
          dt$Selecionar <- FALSE
          colnames(dt) <- c('Valor','Selecionar')
          dt<- dt %>% dplyr::arrange_at(., c('Valor'))
          
          rhandsontable(dt %>% dplyr::select(Selecionar,Valor),#[,c('Selecionar','Ctrl_scientificName')], 
                        width = '100%', height = 250,selectionMode = 'multiple',selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Selecionar'), readOnly = FALSE, type='checkbox') 
        })
      

      }
      
      output$filter_Download <- downloadHandler(
        filename = function() {
          paste("tabela_filtro - ", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          
          # write.csv(data(), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          write.csv(load_filter(), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          
        })
      
      output$filter_key_Download <- downloadHandler(
        filename = function() {
          paste("tabela_palavra-chave - ", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
          
          # write.csv(data(), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          write.csv(load_filterKey(), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          
        })
      
      load_occ <- eventReactive(input$standardizeFilterBtn, 
                                  {
                                    zero_filtro <<- 0
                                    occ[['all']] <<- loadfilter()
                                  })
      
      
      load_filterKey <- eventReactive(input$applyFilter_keyBtn, 
                                      {
                                        withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                          
                                          r_tmp <- {}
                                          
                                          if(NROW(occ[['reflora']])>0)
                                          {
                                            occ[['reflora']]$Ctrl_modified <- occ[['reflora']]$Ctrl_modified %>% as.character()                    
                                            r_tmp <- rbind(r_tmp,occ[['reflora']])}
                                          
                                          if(NROW(occ[['jabot']])>0)
                                          {
                                            occ[['jabot']]$Ctrl_modified <- occ[['jabot']]$Ctrl_modified %>% as.character()                    
                                            r_tmp <- rbind(r_tmp,occ[['jabot']])}
                                          
                                          if(NROW(occ[['splink']])>0)
                                          {
                                            occ[['splink']]$Ctrl_modified <- occ[['splink']]$Ctrl_modified %>% as.character()                    
                                            r_tmp <- rbind(r_tmp,occ[['splink']])}
                                          
                                          if(NROW(occ[['gbif']])>0)
                                          {
                                            occ[['gbif']]$Ctrl_modified <- occ[['gbif']]$Ctrl_modified %>% as.character()                    
                                            r_tmp <- rbind(r_tmp,occ[['gbif']])}
                                          
                                          occ[['all']] <<- r_tmp
                                          
                                          
                                          kw <- strsplit(input$Ctrl_keyword,';')[[1]]

                                          x <- rep(FALSE,NROW(r_tmp))
                                          
                                          colunas <- colnames(r_tmp)
                                          
                                          r_tmp$Resultado <- ''
                                          
                                          if(input$locality==TRUE)
                                          {
                                          x1 <- get_keyword(keyword = kw,
                                                            field= 'Ctrl_locality',
                                                            data = r_tmp)
                                          x <- x | x1
                                          
                                          r_tmp$Resultado[x1==TRUE] <- rep(paste0(kw, ' - ','locality',';'), sum(x1))
                                          }
                                          
                                          if(input$occurrenceRemarks==TRUE)
                                          {
                                            
                                          x2 <- get_keyword(keyword = kw,
                                                          field= 'Ctrl_occurrenceRemarks',
                                                          data = r_tmp)
                                          x <- x | x2
                                          
                                          r_tmp$Resultado[x2==TRUE] <- ifelse(r_tmp$Resultado[x2==TRUE]=='',
                                                                              rep(paste0(kw, ' - ','occurrenceRemarks',';'), sum(x2)),
                                                                              paste0(r_tmp$Resultado[x2==TRUE],rep(paste0(kw, ' - ','occurrenceRemarks',';'), sum(x2))))
                                          
                                          }
                                        
                                          if(input$fieldNotes==TRUE)
                                          {
                                            
                                        x3 <- get_keyword(keyword = kw,
                                                          field= 'Ctrl_fieldNotes',
                                                          data = r_tmp)
                                        x <- x | x3
                                        
                                        r_tmp$Resultado[x3==TRUE] <- ifelse(r_tmp$Resultado[x3==TRUE]=='',
                                                                            rep(paste0(kw, ' - ','fieldNotes',';'), sum(x3)),
                                                                            paste0(r_tmp$Resultado[x3==TRUE],rep(paste0(kw, ' - ','fieldNotes',';'), sum(x3))))
                                        
                                          }
                                          
                                        if(input$comments==TRUE)
                                        {
                                        x4 <- get_keyword(keyword = kw,
                                                          field= 'Ctrl_comments',
                                                          data = r_tmp)
                                        x <- x | x4
                                        r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                            rep(paste0(kw, ' - ','comments',';'), sum(43)),
                                                                            paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                        }
                                        

                                          if(input$institutionCode==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_institutionCode',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','institutionCode',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          if(input$collectionCode==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_collectionCode',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','collectionCode',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          if(input$catalogNumber==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_catalogNumber',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','catalogNumber',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          if(input$recordNumber==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_recordNumber',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','recordNumber',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          if(input$recordedBy==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_recordedBy',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','recordedBy',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          if(input$occurrenceID==TRUE)
                                          {
                                            x4 <- get_keyword(keyword = kw,
                                                              field= 'Ctrl_occurrenceID',
                                                              data = r_tmp)
                                            x <- x | x4
                                            r_tmp$Resultado[x4==TRUE] <- ifelse(r_tmp$Resultado[x4==TRUE]=='',
                                                                                rep(paste0(kw, ' - ','occurrenceID',';'), sum(43)),
                                                                                paste0(r_tmp$Resultado[x4==TRUE],rep(paste0(kw, ' - ','comments',';'), sum(x4))))
                                          }
                                          
                                          
                                          
                                          
                                          # x <- x1 | x2 | x3 | x4
                                        
                                          
                                          
                                        x <- r_tmp[x==TRUE,]
                                        
                                        print(NROW(x))
                                        
                                        incProgress(100, detail = '100')
                                        })
                                        
                                        x
                                      })
      
      output$aplicarfiltros_key_txt <- renderText({
        print(paste0(NROW(load_filterKey()), ' linhas selecionadas de um total de ',NROW(occ[['all']])))
      })
      
      
      
      
      load_filter <- eventReactive(input$applyFilterBtn, 
                                   {
                                     
                                     # index <- rep(TRUE, NROW(occ[['all']]))
                                     
                                     index <- rep(TRUE, NROW(occ[['all']]))

                                     x <- hot_to_r(input$Ctrl_family) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_family %in% valor}
                                     
                                     x <- hot_to_r(input$Ctrl_scientificName) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_scientificName %in% valor}

                                     x <- hot_to_r(input$Ctrl_genus) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_genus %in% valor}

                                     x <- hot_to_r(input$Ctrl_specificEpithet) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_specificEpithet %in% valor}

                                     x <- hot_to_r(input$Ctrl_infraspecificEpithet) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_infraspecificEpithet %in% valor}

                                     x <- hot_to_r(input$Ctrl_identifiedBy) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_identifiedBy %in% valor}

                                     x <- hot_to_r(input$Ctrl_dateIdentified) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_dateIdentified %in% valor}

                                     x <- hot_to_r(input$Ctrl_taxonRank) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_taxonRank %in% valor}

                                     x <- hot_to_r(input$Ctrl_bibliographicCitation) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_bibliographicCitation %in% valor}

                                     x <- hot_to_r(input$Ctrl_institutionCode) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_institutionCode %in% valor}

                                     x <- hot_to_r(input$Ctrl_collectionCode) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_collectionCode %in% valor}

                                     x <- hot_to_r(input$Ctrl_typeStatus) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_typeStatus %in% valor}

                                     x <- hot_to_r(input$Ctrl_recordedBy) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_recordedBy %in% valor}

                                     x <- hot_to_r(input$Ctrl_year) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_year %in% valor}

                                     x <- hot_to_r(input$Ctrl_month) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_month %in% valor}

                                     x <- hot_to_r(input$Ctrl_day) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_day %in% valor}

                                     x <- hot_to_r(input$Ctrl_country) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_country %in% valor}

                                     x <- hot_to_r(input$Ctrl_stateProvince) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_stateProvince %in% valor}

                                     x <- hot_to_r(input$Ctrl_municipality) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_municipality %in% valor}

                                     x <- hot_to_r(input$Ctrl_locality) %>% as.data.frame()
                                     valor <- x$Valor[x$Selecionar==TRUE] %>% as.character()
                                     if(NROW(valor)>0){index <- index & occ[['all']]$Ctrl_locality %in% valor}
                                     
                                     zero_filtro <<- sum(index)
                                     
                                     occ[['filter']] <<- occ[['all']][index==TRUE,]
                                     
                                     occ[['all']][index==TRUE,]
                                     
                                     
                                     
                                     
                                   })
      
      
      output$lerfiltros_txt <- renderText({
        print(paste0(NROW(load_occ()), ' linhas'))
        })
      
      output$aplicarfiltros_txt <- renderText({
        
        # print(paste0(NROW(load_filter()), ' linhas'))
        load_occ()
        load_filter()
        print(paste0(zero_filtro, ' linhas'))
        
        
         
      })
      
      output$standardizeFilter <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                            {
                                                              occ[['filter']] <<- load_filter()
                                                            })
      
      output$standardizeFilter_key <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                      {
                                                        occ[['filter_key']] <- load_filterKey()
                                                        occ[['filter_key']][,c(ncol(occ[['filter_key']]),1:(ncol(occ[['filter_key']])-1))]
                                                      })
      
      loadfilter <- eventReactive(input$standardizeFilterBtn, 
                                  {
                                    withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                      
                                      r_tmp <- {}
                                      
                                      if(NROW(occ[['reflora']])>0)
                                      {
                                        occ[['reflora']]$Ctrl_modified <- occ[['reflora']]$Ctrl_modified %>% as.character()                    
                                        r_tmp <- rbind(r_tmp,occ[['reflora']])}
                                      
                                      if(NROW(occ[['jabot']])>0)
                                      {
                                        occ[['jabot']]$Ctrl_modified <- occ[['jabot']]$Ctrl_modified %>% as.character()                    
                                        r_tmp <- rbind(r_tmp,occ[['jabot']])}
                                      
                                      if(NROW(occ[['splink']])>0)
                                      {
                                        occ[['splink']]$Ctrl_modified <- occ[['splink']]$Ctrl_modified %>% as.character()                    
                                        r_tmp <- rbind(r_tmp,occ[['splink']])}
                                      
                                      if(NROW(occ[['gbif']])>0)
                                      {
                                        occ[['gbif']]$Ctrl_modified <- occ[['gbif']]$Ctrl_modified %>% as.character()                    
                                        r_tmp <- rbind(r_tmp,occ[['gbif']])}
                                      
                                      occ[['all']] <<- r_tmp
                                      incProgress(100, detail = '100')
                                    })
                                    
                                    r_tmp
                                    
                                  })
      
      
    }
    
  # valores <- reactiveValues(LogoHerbario ='![Logo Herbario](HRCBlogo.png)',
  #                           NomeHerbario = "",
  #                           Instituicao = "",
  #                           Projeto = "",
  #                           ObservacaoFicha = '')
  # 
  # observe({
  #   valores$LogoHerbario <- input$LogoHerbario_Input
  #   valores$NomeHerbario <- input$NomeHerbario_Input
  #   valores$Instituicao <- input$Instituicao_Input
  #   valores$Projeto <- input$Projeto_Input
  #   valores$ObservacaoFicha <- input$ObservacaoFicha_Input})
  
    
    
  
    # abrir csv
    {
        
        splinkLoad <- reactive({
          req(input$splinkFile)
          tryCatch(
            {
              withProgress(message = 'Processing...', style = 'notification', value = 0.5, 
                           {
                             
                             incProgress(0.1, detail = 'carregando arquivos CSV fieldBook...')
              
              # files_tmp <- 'C:\\catalogoUCsBR - github.com\\doc 2024\\dados_serra das lontras\\speciesLink_Serra_das_Lontras.txt'
              files_tmp <- input$splinkFile$datapath
              nf <- length(files_tmp)
              occ_tmp <- data.frame({})
              if(nf>0)
              {
                
                i <- 1
                for(i in 1:nf)
                {
                  occ_tmp_1 <- read.delim(file = files_tmp[i],
                                          header = TRUE, 
                                          sep = ";",
                                          quote = '"',
                                          dec = '.',
                                          stringsAsFactors = FALSE,
                                          # fileEncoding = "Windows-1258")
                                          fileEncoding = "UTF-8")
                  
                  occ_tmp <- rbind.data.frame(occ_tmp, occ_tmp_1)   
                }
              }
              
              source_data <- 'all'
              if(NROW(occ_tmp)>0)
              {
                occ[[source_data]] <<- occ_tmp
              }
              
              incProgress(0.1, detail = 'Carregando informações IPT Flora e Funga do Brasil...')
              
              occ[['fb2020']] <<- get_floraFungaBrasil_v2(path_results = tempdir)#"C:/Dados/APP_GBOT/data")#path_data) 
              
              incProgress(1, detail = 'OK')
            })
              
              return(occ_tmp)
            },
            error = function(e) {
              stop(safeError(e))
            }
          )
        })
        
        output$splinkContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                     {
                                                       splinkLoad()
                                                     })
    }
  
  # baixar
  {
    
    output$downloadData_csv <- downloadHandler(
      filename = function() {
        paste("fieldBook_Tabela_de_dados.csv", sep="")
      },
      content = function(file) {
        
        dt <- occ[['taxonomicAlignment']]
        write.csv(dt, file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        
      }
    )
    
    output$downloadData_zip <- downloadHandler(
      filename = function() {
        paste("fieldBook_Fichas.zip", sep="")
      },
      content = function(file) {
        
        dir <- paste0(getwd(),"/fichas")
        arquivo_zip <- file.path(dir, "fieldBook_Fichas.zip")
        
        if (file.exists(arquivo_zip)) {
            # Copia o arquivo ZIP para o destino do download
            file.copy(arquivo_zip, file)
        } else {
          stop("O arquivo ZIP não foi encontrado no diretório especificado.")
        }
        
        

      }
    )
    
  }
  
  # gerar fichas
  {
    # ficha
    
    geraFicha<- 
      eventReactive(input$geraFicha_Btn,
                    {
                      
                      withProgress(message = 'Processing...', style = 'notification', value = 0.5, 
                                   {
                                     
                                     # dir <- "C:\\ExsicataBR\\Scripts\\fichas"
                                     dir <- paste0(getwd(),"/fichas")
                                     
                                     # dir <- 'C:\\ExsicataBR\\Scripts\\fichas'
                                     arquivo_zip <- file.path(dir, "fieldBook_Fichas.zip")
                                     arquivo_zip_corrigido <- normalizePath(arquivo_zip, winslash = "/")
                                     
                                     
                                     LogoHerbario <<-'![Logo Herbario](HRCBlogo.png)'
                                     # # Siglaherbario <<- ""
                                     
                                     # Instituicao <<- ""
                                     # NomeHerbario <<- ""
                                     # Projeto <<- ""
                                     
                                     
                                     Instituicao <<- input$Instituicao_Input
                                     NomeHerbario <<- input$Nome_Input
                                     Projeto <<- input$Projeto_Input
                                     
                                     
                                     print(Instituicao)
                                     print(NomeHerbario)
                                     print(Projeto)
                                     print(input$Nomeherbario_Input)
                                     

                                     
                                     gerafichas(coletas=occ[['taxonomicAlignment']], 
                                                qtdefichaspagina=6, 
                                                pastafichas=dir)
                                     
                                     
                                     
                                     arquivos <- list.files(
                                       path = dir,
                                       pattern = "\\.(html|doc)$", # Filtra extensões .html e .doc
                                       full.names = TRUE           # Retorna os caminhos completos
                                     )
                                     
                                     arquivos_corrigidos <- normalizePath(arquivos, winslash = "/")
                                     
                                     # Compactar os arquivos
                                     zip_result <- tryCatch({
                                       
                                       utils::zip(
                                         zipfile = arquivo_zip_corrigido,
                                         files = arquivos
                                       )
                                       TRUE
                                     }, error = function(e) {
                                       cat("Erro ao compactar os arquivos:", e$message, "\n")
                                       FALSE
                                     })
                                     
                                   })
                    })
    
    
    output$geraFicha_txt <- renderText({
      geraFicha()
      print("Etiquetas geradas com sucesso!")
    })
  }
      
    # applyTaxonomicAlignment_Contents
    # backbone
    {
      
      # save taxonomic
      {
        
        # downloadData_applyCollectionCodesPattern_NewCollectionCodesDictionary
        output$downloadData_applyTaxonomicAlignment <- downloadHandler(
          filename = function() {
            paste("Catalogo_Plantas_UCs_Brasil - Taxonomic_Alignment.csv", sep="")
          },
          content = function(file) {
            
            colunas_occ <- colnames(occ[['all']])
            
            occ[['all_results']] <<- occ[['all']]
            
            if(NROW(occ[['taxonomicAlignment']])==NROW(occ[['all_results']]))
            {
              occ[['all_results']] <<- cbind(occ[['all_results']],
                                             occ[['taxonomicAlignment']] %>%
                                               dplyr::select(-colunas_occ))
            }
            
            
            if(NROW(occ[['all_mainCollectorLastName']])==NROW(occ[['all_results']]))
            {
              occ[['all_results']] <<- cbind(occ[['all_results']],
                                             occ[['all_mainCollectorLastName']] %>%
                                               dplyr::select(-colunas_occ))
            }
            
            if(NROW(occ[['all_collectionCode']])==NROW(occ[['all_results']]))
            {
              occ[['all_results']] <<- cbind(occ[['all_results']],
                                             occ[['all_collectionCode']] %>%
                                               dplyr::select(-colunas_occ))
            }
            
            write.csv(occ[['all_results']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          })
      }
      
      
      
      
      
      # applyTaxonomicAlignment_Contents 
      {
        applyTaxonomicAlignment <- 
          eventReactive(input$applyTaxonomicAlignment_Btn,
                        {
                          # occ_tmp <- readr::read_csv('C:\\ExsicataBR\\data\\fieldbook\\MELO - 20250126.CSV',
                          #                            locale = readr::locale(encoding = "UTF-8"),
                          #                            show_col_types = FALSE)
                          # occ[['all']] <- occ_tmp
                          # occ[['fb2020']] <- get_floraFungaBrasil_v2(path_results = tempdir)#"C:/Dados/APP_GBOT/data")#path_data) 
                          
                          
                          {
                            occ[['all']]$Ctrl_scientificName <- ""
                            occ[['all']]$Ctrl_scientificName <- ifelse( occ[['all']]$family == "Indeterminada", "",  occ[['all']]$family )
                            occ[['all']]$Ctrl_scientificName <- ifelse( occ[['all']]$genus == "Indeterminado", occ[['all']]$Ctrl_scientificName,  occ[['all']]$genus )
                            
                            occ[['all']] $Ctrl_scientificName <- ifelse( occ[['all']]$genus != "Indeterminado" & !is.na(occ[['all']]$specificEpithet), 
                                                                         paste0(occ[['all']]$genus," ", occ[['all']]$specificEpithet), 
                                                                         occ[['all']]$Ctrl_scientificName )
                            
                            
                            occ[['all']] $Ctrl_scientificName <-  ifelse(!is.na(occ[['all']]$infraspecificEpithet), 
                                                                         paste0(occ[['all']] $Ctrl_scientificName," ",occ[['all']]$infraspecificEpithet),
                                                                         occ[['all']]$Ctrl_scientificName)
                            
                            
                            name_search <- occ[['all']]$Ctrl_scientificName %>% unique() %>% as.character()
                            
                            # NROW(name_search)
                            
                            occ[['all']] <- occ[['all']] %>%
                              dplyr::mutate(wcvp_kew_id = "",
                                            wcvp_family = "",
                                            wcvp_genus = "",
                                            wcvp_species = "",
                                            wcvp_infraspecies = "",
                                            wcvp_taxon_name = "",
                                            wcvp_authors = "",
                                            wcvp_rank = "",
                                            wcvp_taxonomic_status = "",
                                            wcvp_accepted_kew_id = "",
                                            wcvp_accepted_name = "",
                                            wcvp_accepted_authors = "",
                                            wcvp_parent_kew_id = "",
                                            wcvp_parent_name = "",
                                            wcvp_parent_authors = "",
                                            wcvp_reviewed = "",
                                            wcvp_publication = "",
                                            wcvp_original_name_id = "",
                                            wcvp_TAXON_NAME_U = "",
                                            wcvp_searchNotes = "",
                                            wcvp_searchedName = "") %>%
                              dplyr::mutate(fb2020_taxonID = 0,
                                            fb2020_acceptedNameUsageID = 0,
                                            fb2020_parentNameUsageID = 0,
                                            fb2020_originalNameUsageID = 0,
                                            fb2020_scientificName = "",
                                            # fb2020_acceptedNameUsage = "",
                                            # fb2020_parentNameUsage = "",
                                            fb2020_namePublishedIn = "",
                                            fb2020_namePublishedInYear = 0,
                                            fb2020_higherClassification = "",             
                                            # fb2020_kingdom = "",
                                            # fb2020_phylum = "",                     
                                            # fb2020_class = "",
                                            # fb2020_order = "",                       
                                            fb2020_family = "",
                                            fb2020_genus = "",                      
                                            fb2020_specificEpithet = "",
                                            fb2020_infraspecificEpithet = "",             
                                            fb2020_taxonRank = "",
                                            fb2020_scientificNameAuthorship = "",
                                            fb2020_taxonomicStatus = "",
                                            fb2020_nomenclaturalStatus = "",             
                                            fb2020_modified = lubridate::as_datetime("2021-10-31 21:13:33.77"),
                                            fb2020_bibliographicCitation = "",
                                            fb2020_references = "",
                                            fb2020_scientificNamewithoutAuthorship = "",
                                            fb2020_scientificNamewithoutAuthorship_U = "",
                                            fb2020_searchNotes = "",
                                            fb2020_searchedName = "")
                            
                            wcvp_na <- data.frame(wcvp_kew_id = "",
                                                  wcvp_family = "",
                                                  wcvp_genus = "",
                                                  wcvp_species = "",
                                                  wcvp_infraspecies = "",
                                                  wcvp_taxon_name = "",
                                                  wcvp_authors = "",
                                                  wcvp_rank = "",
                                                  wcvp_taxonomic_status = "",
                                                  wcvp_accepted_kew_id = "",
                                                  wcvp_accepted_name = "",
                                                  wcvp_accepted_authors = "",
                                                  wcvp_parent_kew_id = "",
                                                  wcvp_parent_name = "",
                                                  wcvp_parent_authors = "",
                                                  wcvp_reviewed = "",
                                                  wcvp_publication = "",
                                                  wcvp_original_name_id = "",
                                                  wcvp_TAXON_NAME_U = "",
                                                  wcvp_searchNotes = "",
                                                  wcvp_searchedName = "")
                            
                            fb2020_na <- data.frame(fb2020_taxonID = 0,
                                                    fb2020_acceptedNameUsageID = 0,
                                                    fb2020_parentNameUsageID = 0,
                                                    fb2020_originalNameUsageID = 0,
                                                    fb2020_scientificName = "",
                                                    # fb2020_acceptedNameUsage = "",
                                                    # fb2020_parentNameUsage = "",
                                                    fb2020_namePublishedIn = "",
                                                    fb2020_namePublishedInYear = 0,
                                                    fb2020_higherClassification = "",             
                                                    # fb2020_kingdom = "",
                                                    # fb2020_phylum = "",                     
                                                    # fb2020_class = "",
                                                    # fb2020_order = "",                       
                                                    fb2020_family = "",
                                                    fb2020_genus = "",                      
                                                    fb2020_specificEpithet = "",
                                                    fb2020_infraspecificEpithet = "",             
                                                    fb2020_taxonRank = "",
                                                    fb2020_scientificNameAuthorship = "",
                                                    fb2020_taxonomicStatus = "",
                                                    fb2020_nomenclaturalStatus = "",             
                                                    fb2020_modified = lubridate::as_datetime("2021-10-31 21:13:33.77"),
                                                    fb2020_bibliographicCitation = "",
                                                    fb2020_references = "",
                                                    fb2020_scientificNamewithoutAuthorship = "",
                                                    fb2020_scientificNamewithoutAuthorship_U = "",
                                                    fb2020_searchNotes = "",
                                                    fb2020_searchedName = "")
                            
                            # fb2020_na <- fb2020[1,]
                            # fb2020_na[1,] <- NA
                          }
                          
                          withProgress(message = 'Processing...', style = 'notification', value = 0.5, 
                                       {
                                         x <- {}
                                         i <- 1
                                         # i <- 938
                                         
                                         ok <- FALSE
                                         japrocessado <<- rep(FALSE,NROW(name_search))
                                         
                                         while (i<=NROW(name_search) & ok != TRUE)
                                         {
                                           try(
                                             {
                                               
                                               for(i in 1:NROW(name_search))
                                               {
                                                 if(japrocessado[i]==TRUE){next} # 03-05-2022 para evitar tentar baixar a mesma espécies 2 vezes caso ocorra erro
                                                 
                                                 sp_tmp <- name_search[i]
                                                 
                                                 # 'FloraFungaBrasil','WCVP'
                                                 if(any(input$taxonomicBackbone %in% c('WCVP'))==TRUE)
                                                 {
                                                   x_tmp <- checkName_WCVP(searchedName = sp_tmp,
                                                                           wcvp_name = occ[['wcvp']])
                                                 }else
                                                 {
                                                   x_tmp <- wcvp_na
                                                 }
                                                 
                                                 if(any(input$taxonomicBackbone %in% c('FloraFungaBrasil'))==TRUE)
                                                 {
                                                   
                                                   x_tmp_fb2020 <- checkName_FloraFungaBrasil(searchedName = sp_tmp,
                                                                                              fb2020 = occ[['fb2020']])
                                                   
                                                 }else
                                                 {
                                                   x_tmp_fb2020 <- fb2020_na
                                                 }
                                                 
                                                 
                                                 x <- rbind(x,
                                                            cbind(x_tmp[,
                                                                        colunas_wcvp_sel],
                                                                  x_tmp_fb2020[,
                                                                               colunas_fb2020_sel]))
                                                 
                                                 index <- occ[['all']]$Ctrl_scientificName %in% name_search[i]
                                                 
                                                 n_reg <- NROW(occ[['all']][index==TRUE,])
                                                 
                                                 if(any(input$taxonomicBackbone %in% c('WCVP'))==TRUE)
                                                 {
                                                   print( str_c( i, ' - WCVP: ', name_search[i], ' : ',n_reg, ' registros - ', ifelse(is.na(x_tmp$wcvp_taxon_name),'',x_tmp$wcvp_taxon_name), ' : ', x_tmp$wcvp_searchNotes))
                                                 }
                                                 
                                                 if(any(input$taxonomicBackbone %in% c('FloraFungaBrasil'))==TRUE)
                                                 {
                                                   print( str_c( i, ' - FB2020: ', name_search[i], ' : ',n_reg, ' registros - ', ifelse(is.na(x_tmp_fb2020$fb2020_scientificName),'',x_tmp_fb2020$fb2020_scientificName), ' : ', x_tmp_fb2020$fb2020_searchNotes))
                                                 }
                                                 
                                                 # occ[['all']][index==TRUE,]$scientificNamewithoutAuthorship
                                                 
                                                 occ[['all']][index==TRUE,
                                                              c(colunas_wcvp_sel, colunas_fb2020_sel)] <- cbind(x_tmp[,
                                                                                                                      colunas_wcvp_sel],
                                                                                                                x_tmp_fb2020[,
                                                                                                                             colunas_fb2020_sel])
                                                 
                                                 occ[['all']][index==TRUE,]$recordedBy <- paste0(occ[['all']][index==TRUE,]$recordedBy, ", ",  occ[['all']][index==TRUE,]$collectorInitials)
                                                 
                                                 
                                                 occ[['all']][index==TRUE,
                                                              c('family',
                                                                'genus',
                                                                'specificEpithet',
                                                                'infraspecificEpithet',             
                                                                'scientificNameAuthorship')] <-  data.frame(ifelse(occ[['all']][index==TRUE,]$fb2020_searchNotes %in% c('NOME_ACEITO', 'Updated'), occ[['all']][index==TRUE,]$fb2020_family,occ[['all']][index==TRUE,]$family),
                                                                                                            ifelse(occ[['all']][index==TRUE,]$fb2020_searchNotes %in% c('NOME_ACEITO', 'Updated'), occ[['all']][index==TRUE,]$fb2020_genus, occ[['all']][index==TRUE,]$genus),
                                                                                                            ifelse(occ[['all']][index==TRUE,]$fb2020_searchNotes %in% c('NOME_ACEITO', 'Updated'), occ[['all']][index==TRUE,]$fb2020_specificEpithet,occ[['all']][index==TRUE,]$specificEpithet),
                                                                                                            ifelse(occ[['all']][index==TRUE,]$fb2020_searchNotes %in% c('NOME_ACEITO', 'Updated'), occ[['all']][index==TRUE,]$fb2020_infraspecificEpithet,occ[['all']][index==TRUE,]$infraspecificEpithet),
                                                                                                            ifelse(occ[['all']][index==TRUE,]$fb2020_searchNotes %in% c('NOME_ACEITO', 'Updated'), occ[['all']][index==TRUE,]$fb2020_scientificNameAuthorship,occ[['all']][index==TRUE,]$scientificNameAuthorship ))
                                                 
                                                 
                                                 
                                                 
                                                 japrocessado[i] <- TRUE
                                               }
                                               
                                               ok <- TRUE
                                             })
                                           
                                           print('reconectar em 2 segundos...')
                                           Sys.sleep(2)
                                         }
                                         
                                         incProgress(100, detail = '100')
                                       })
                          
                          source_data <- 'taxonomicAlignment'
                          occ[[source_data]] <<- occ[['all']]
                          
                          
                          # return(x)
                          return(occ[['taxonomicAlignment']])
                        })
        
        output$applyTaxonomicAlignment_Contents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                       {
                                                                         applyTaxonomicAlignment()
                                                                         occ[['taxonomicAlignment']]
                                                                       })
      }
      
      
      # checkSpeciesNames_FB2020
      {
        checkSpeciesNames_FB2020 <- eventReactive(input$checkSpeciesNames_FB2020_Btn,
                                                  {
                                                    withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                      
                                                      occ[['fb2020']] <<- get_floraFungaBrasil_v2(path_results = tempdir)#"C:/Dados/APP_GBOT/data")#path_data) 
                                                      
                                                      
                                                      
                                                      # colnames(occ[['fb2020']]) <<- paste0('fb2020_',colnames(occ[['fb2020']]))
                                                      
                                                      # occ_result[['fb2020_names']] <<- occ[['fb2020']] %>% 
                                                      #    dplyr::select(colunas_fb2020_sel)
                                                      
                                                      # occ_result[['fb2020_names']] <<- occ[['fb2020']] %>% 
                                                      #    dplyr::select(colunas_fb2020_sel)
                                                      
                                                      
                                                      # r_tmp <- get_floraFungaBrasil()
                                                      # 
                                                      # occ[['fb2020']] <<- r_tmp[['taxon_floraFungaBrasil']]
                                                      # 
                                                      # occ[['fb2020_colSearch']] <<- r_tmp[['colSearch']]
                                                      
                                                      incProgress(100, detail = '100')
                                                    })
                                                    
                                                    return(occ[['fb2020']])
                                                  })
        
        # aqui 21-11-2022
        
        output$checkSpeciesNames_FB2020_Contents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                        {
                                                                          data_sel_fb2020()
                                                                          # occ[['fb2020']] <<- checkSpeciesNames_FB2020()
                                                                        })
        
        
        output$forMenu    <- renderUI({createSelectRadio(1)})    
        
        createSelectRadio <- function(id){
          
          family_ID <- paste0('family_ID',id)
          
          if(!NROW(checkSpeciesNames_FB2020())>0)
          {res <- list(
            selectInput(inputId = family_ID,
                        label = 'Family:',
                        choices = as.list(c('Tudo', 'get data...'))))
          }else{   
            res <- list(
              selectInput(inputId = family_ID,
                          label = 'Family:',
                          choices = as.list(c('Tudo',
                                              checkSpeciesNames_FB2020()$family %>%
                                                unique() %>% sort()))))
          }
          return(res)
        }
        
        data_sel_fb2020 <- reactive({
          
          occ[['fb2020']] <<- checkSpeciesNames_FB2020()
          
          if (input$family_ID1 == 'Tudo'){
            return(occ[['fb2020']] %>% dplyr::filter(
              # nomenclaturalStatus %in% input$nomenclaturalStatus &
              taxonomicStatus %in% input$taxonomicStatus &
                taxonRank %in% input$taxonRank))
          }else{
            return(occ[['fb2020']] %>% dplyr::filter(family %in% input$family_ID1 & 
                                                       # nomenclaturalStatus %in% input$nomenclaturalStatus &
                                                       taxonomicStatus %in% input$taxonomicStatus &
                                                       taxonRank %in% input$taxonRank))
            
          }
        })
        
      }
      
      # checkSpeciesNames_WCVPN
      {
        checkSpeciesNames_WCVPN <- eventReactive(input$checkSpeciesNames_WCVPN_Btn,
                                                 {
                                                   withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                     
                                                     occ[['wcvp']] <<- get_wcvp(url_source = 'http://sftp.kew.org/pub/data-repositories/WCVP/Archive/wcvp_webapp_oct_2019_to_jun_2022/',
                                                                                path_results = path_data,
                                                                                update = update_wcvp)$wcvp_names
                                                     
                                                     incProgress(100, detail = '100')
                                                   })
                                                   
                                                   return(occ[['wcvp']])
                                                 })
        
        output$checkSpeciesNames_WCVPN_Contents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                       {
                                                                         # checkSpeciesNames_WCVPN()
                                                                         
                                                                         data_sel_wcvp()
                                                                       })
        
        output$forMenu_wcvp    <- renderUI({createSelectRadio_wcvp(1)})    
        
        createSelectRadio_wcvp <- function(id){
          
          family_ID <- paste0('family_wcvp_ID',id)
          
          if(!NROW(checkSpeciesNames_WCVPN())>0)
          {res <- list(
            selectInput(inputId = family_ID,
                        label = 'Family:',
                        choices = as.list(c('Tudo', 'get data...'))))
          }else{   
            res <- list(
              selectInput(inputId = family_ID,
                          label = 'Family:',
                          choices = as.list(c('Tudo',
                                              checkSpeciesNames_WCVPN()$family %>%
                                                unique() %>% sort()))))
          }
          return(res)
        }
        
        data_sel_wcvp <- reactive({
          
          occ[['wcvp']] <<- checkSpeciesNames_WCVPN()
          
          if (input$family_wcvp_ID1 == 'Tudo'){
            return(occ[['wcvp']] %>% dplyr::filter(
              # nomenclaturalStatus %in% input$nomenclaturalStatus &
              taxonomic_status %in% input$taxonomic_status &
                rank %in% input$rank))
          }else{
            return(occ[['wcvp']] %>% dplyr::filter(family %in% input$family_wcvp_ID1 & 
                                                     # nomenclaturalStatus %in% input$nomenclaturalStatus &
                                                     taxonomic_status %in% input$taxonomic_status &
                                                     rank %in% input$rank))
            
          }
        })
      }
      
    }
    
    
    # checkMapLocationBtn
    {
      checkMapLocation <- eventReactive(input$checkMapLocationBtn,
                                        {
                                          # padronizar nome de paises e codigos iso2 e iso3
                                          withProgress(message = 'Processing...', style = 'notification', value = 0.25, {
                                            occ_global <- occ[['all']] 
                                            
                                            if (NROW(occ_global)>0)
                                            { 
                                              # standardize country names and iso 2 iso3 codes
                                              {
                                                incProgress(0.51, detail = 'standardize country names and ISO2 and ISO3 codes...')
                                                
                                                
                                                occ_global <- bdc::bdc_country_standardized(occ_global, country = "Ctrl_country")
                                                
                                                # iso2ToIso3 para utilizar em coordinateCleaner
                                                index_1 <- !is.na(occ_global$countryCode)
                                                occ_global$countryCode_ISO3[index_1==TRUE] <- MazamaSpatialUtils::iso2ToIso3(occ_global$countryCode[index_1==TRUE])
                                                
                                                # occ_global$countryCode[index_1==TRUE]
                                                ioo=61
                                                for (ioo in 1:NROW(occ_global))
                                                {
                                                  index_oo <- Countryoccurrence.countryoccurrencelookup$countryCode%in%occ_global$countryCode[ioo]
                                                  
                                                  occ_global$CountryOccurrenceName[ioo] <- na.omit(Countryoccurrence.countryoccurrencelookup$nome[index_oo==TRUE])
                                                }
                                                
                                                source_data <- 'all_geo'
                                                occ[[source_data]] <<- occ_global
                                                
                                                incProgress(0.5, detail = '100')
                                              }
                                              
                                              # centroids
                                              {
                                                # incProgress(0.51, detail = 'get centroids...')
                                                # centroids_tmp <- get_centroids(countryCode_ISO3=occ_global$countryCode_ISO3 %>% unique())
                                                # source_data <- 'centroids'
                                                # occ[[source_data]] <<- centroids_tmp
                                                # incProgress(0.75, detail = '100')
                                              }
                                              
                                              # coordinateCleaner and bdc
                                              {
                                                incProgress(0.76, detail = 'coordinateCleaner and bdc packages...')
                                                occ_cc <- occ_global %>%
                                                  dplyr::select(Ctrl_scientificNameReference,
                                                                Ctrl_decimalLongitude,
                                                                Ctrl_decimalLatitude,
                                                                countryCode_ISO3) %>%
                                                  dplyr::rename(species = Ctrl_scientificNameReference,
                                                                decimallongitude  = Ctrl_decimalLongitude,
                                                                decimallatitude = Ctrl_decimalLatitude) %>%
                                                  dplyr::mutate(.val = TRUE,
                                                                .zer = TRUE,
                                                                .sea = TRUE,
                                                                .equ = TRUE,
                                                                .cen = TRUE,
                                                                .cap = TRUE,
                                                                .urb = TRUE,
                                                                .con = TRUE,
                                                                .inst = TRUE,                         
                                                                .dup = TRUE,
                                                                .summary_CoordinateCleaner = TRUE,
                                                                .submittedToCoordinateCleaner = !is.na(species),
                                                                
                                                                .before = 1) 
                                                
                                                index <- occ_cc$.submittedToCoordinateCleaner
                                                
                                                index <- TRUE
                                                
                                                occ_cc <- bdc_coordinates_outOfRange(
                                                  data = occ_cc[index==TRUE,],
                                                  lat = "decimallatitude",
                                                  lon = "decimallongitude")
                                                
                                                
                                                index <- index & occ_cc$.coordinates_outOfRange
                                                occ_cc$.val[index==TRUE] <- CoordinateCleaner::cc_val(x=occ_cc[index==TRUE, ],
                                                                                                      value = 'flagged')
                                                
                                                index <- index & occ_cc$.val
                                                occ_cc$.zer[index==TRUE] <- CoordinateCleaner::cc_zero(x=occ_cc[index==TRUE,],
                                                                                                       value = 'flagged')
                                                
                                                index <- index & occ_cc$.zer
                                                occ_cc$.sea[index==TRUE] <- !CoordinateCleaner::cc_sea(x=occ_cc[index==TRUE,],
                                                                                                       value = 'flagged')
                                                
                                                index <- index & !occ_cc$.sea
                                                occ_cc$.equ[index==TRUE] <- CoordinateCleaner::cc_equ(x=occ_cc[index==TRUE,],
                                                                                                      value = 'flagged')
                                                
                                                index <- index & occ_cc$.equ
                                                occ_cc$.cen[index==TRUE] <- CoordinateCleaner::cc_cen(x=occ_cc[index==TRUE,],
                                                                                                      value = 'flagged')
                                                
                                                occ_cc$.cap[index==TRUE] <- CoordinateCleaner::cc_cap(x=occ_cc[index==TRUE,],
                                                                                                      value = 'flagged')
                                                
                                                occ_cc$.urb[index==TRUE] <- CoordinateCleaner::cc_urb(x=occ_cc[index==TRUE,],
                                                                                                      value = 'flagged')
                                                
                                                occ_cc$.inst[index==TRUE] <- CoordinateCleaner::cc_inst(x=occ_cc[index==TRUE,],
                                                                                                        value = 'flagged')
                                                
                                                occ_cc$.con[index==TRUE] <- CoordinateCleaner::cc_coun(x = occ_cc[index==TRUE,],
                                                                                                       lon = "decimallongitude",
                                                                                                       lat = "decimallatitude",
                                                                                                       iso3 = "countryCode_ISO3",
                                                                                                       value = "flagged",
                                                                                                       ref = world,
                                                                                                       ref_col = "iso_a3_eh")
                                                
                                                occ_cc$.dup[index==TRUE] <- CoordinateCleaner::cc_dupl(x=occ_cc[index==TRUE,],
                                                                                                       value = 'flagged')
                                                
                                                
                                                # 
                                                
                                                # #
                                                # x <- cf_outl(x=occ_cc[index==TRUE,],
                                                #              min_age = '1500',
                                                #                 max_age = '2022',
                                                #         value = 'flagged')
                                                # #
                                                
                                                
                                                
                                                # s.spatialvalid
                                                # 
                                                # cd_round
                                                # 
                                                # cc_gbif
                                                # cc_iucn
                                                # cc_outl
                                                # cd_ddmm
                                                # cf_outl
                                                # clean_dataset
                                                # 
                                                # clean_coordinates
                                                # 
                                                # plot.spatialvalid
                                                # 
                                                # countryref
                                                # institutions
                                                # 
                                                
                                                # sumário
                                                occ_cc$.summary_CoordinateCleaner <- occ_cc$.val & occ_cc$.zer & (!occ_cc$.sea) & occ_cc$.cen & occ_cc$.coordinates_outOfRange
                                                
                                                occ_cc <- occ_cc %>% dplyr::select(-species,
                                                                                   -decimallongitude,
                                                                                   -decimallatitude,
                                                                                   # -countryCode,
                                                                                   -countryCode_ISO3)
                                              }
                                              
                                              source_data <- 'all_cc'
                                              occ[[source_data]] <<- occ_cc
                                              
                                              incProgress(1, detail = 'ok')
                                              
                                              # occ_cc
                                            }
                                          })
                                          
                                          source_data <- 'all_cc'
                                          occ[[source_data]]
                                        })
      
      output$checkMapLocationContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                             {
                                                               checkMapLocation()
                                                             })
    }                                                             
    
    
    # applyMainCollectorLastName
    {
      # applyMainCollectorLastNameBtn
      applyMainCollectorLastNamePattern <- eventReactive(input$applyMainCollectorLastNameBtn,
                                                         {
                                                           withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                             
                                                             MainCollectorLastName_I <- hot_to_r(input$getMainCollectorLastNameContents) 
                                                             
                                                             
                                                             # MainCollectorLastName_II <- hot_to_r(input$getMainCollectorLastNameContents_II) 
                                                             
                                                             source_data <- 'mainCollectorLastName'
                                                             MainCollectorLastName_II <- occ[[source_data]]
                                                             
                                                             
                                                             if(NROW(MainCollectorLastName_I)>0)
                                                             {MainCollectorLastName <- MainCollectorLastName_I}
                                                             
                                                             if(NROW(MainCollectorLastName_II)>0)
                                                             {MainCollectorLastName <- MainCollectorLastName_II}
                                                             
                                                             source_data <- 'mainCollectorLastName'
                                                             occ[[source_data]] <<- MainCollectorLastName
                                                             
                                                             mainCollectorLastName_tmp <- update_lastNameRecordedBy_v5(occ_tmp=occ[['all']],
                                                                                                                       recordedBy_ajusted=MainCollectorLastName,
                                                                                                                       coletoresDB=coletoresDB)
                                                             
                                                             
                                                             source_data <- 'mainCollectorLastNameNew'
                                                             occ[[source_data]] <<- mainCollectorLastName_tmp[['MainCollectorLastNameDB_new']]
                                                             
                                                             source_data <- 'all_mainCollectorLastName'
                                                             occ[[source_data]] <<- mainCollectorLastName_tmp[['occ']]
                                                             
                                                             print(paste0(NROW(occ[[source_data]]),' all_mainCollectorLastName'))
                                                             
                                                             source_data <- 'mainCollectorLastNameSummary'
                                                             occ[[source_data]] <<- mainCollectorLastName_tmp[['summary']]
                                                             
                                                             occ[[source_data]]
                                                             
                                                             incProgress(100, detail = '100')
                                                           })
                                                           
                                                           mainCollectorLastName_tmp[['summary']]
                                                           
                                                           
                                                         })
      
      output$applyMainCollectorLastNameContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                       {
                                                                         # print('aqui')
                                                                         applyMainCollectorLastNamePattern()
                                                                         # print('aqui2')
                                                                       })
      
      # downloadData_applyCollectionCodesPattern_Summary
      output$downloadData_applyMainCollectorLastName_Summary <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - Main_CollectorLast_Name_Summary.csv", sep="")
        },
        content = function(file) {
          write.csv(occ[['mainCollectorLastNameSummary']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      
      # downloadData_applyCollectionCodesPattern_NewCollectionCodesDictionary
      output$downloadData_applyMainCollectorLastName_NewMainCollectorLastName_Dictionary <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - New_Main_CollectorLast_Name_Dictionary.csv", sep="")
        },
        content = function(file) {
          write.csv(occ[['mainCollectorLastNameNew']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      
    }
    
    
    # applyCollectionCodes
    {
      
      # occ[['collectionCodeNew']] <<- hot_to_r(input$getUniqueCollectionsCodeContents)
      applyCollectionCodesPattern <- eventReactive(input$applyCollectionCodesPatternBtn,
                                                   {
                                                     withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                       
                                                       CollectionsCode_I <- hot_to_r(input$getUniqueCollectionsCodeContents) 
                                                       CollectionsCode_II <- hot_to_r(input$getUniqueCollectionsCodeContents_II) 
                                                       
                                                       if(NROW(CollectionsCode_I)>0)
                                                       {CollectionsCode <- CollectionsCode_I}
                                                       
                                                       if(NROW(CollectionsCode_II)>0)
                                                       {CollectionsCode <- CollectionsCode_II}
                                                       
                                                       source_data <- 'collectionCode'
                                                       occ[[source_data]] <<- CollectionsCode
                                                       
                                                       collectionCode_tmp <- update_collectionCode_v2(occ_tmp=occ[['all']],
                                                                                                      collectionCode_ajusted=CollectionsCode,
                                                                                                      collectionCodeDB=collectionCodeDB)
                                                       
                                                       source_data <- 'collectionCodeNew'
                                                       occ[[source_data]] <<- collectionCode_tmp[['collectionCodeDB_new']]
                                                       
                                                       source_data <- 'all_collectionCode'
                                                       occ[[source_data]] <<- collectionCode_tmp[['occ']]
                                                       
                                                       source_data <- 'collectionCodeSummary'
                                                       occ[[source_data]] <<- collectionCode_tmp[['summary']]
                                                       incProgress(100, detail = '100')
                                                     })
                                                     
                                                     collectionCode_tmp[['summary']]
                                                     
                                                     
                                                   })
      
      output$applyCollectionCodesPatternContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                        {
                                                                          applyCollectionCodesPattern()
                                                                          
                                                                        })
      
      # downloadData_applyCollectionCodesPattern_Summary
      output$downloadData_applyCollectionCodesPattern_Summary <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - Collection_Codes_Summary.csv", sep="")
        },
        content = function(file) {
          write.csv(occ[['collectionCodeSummary']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      
      # downloadData_applyCollectionCodesPattern_NewCollectionCodesDictionary
      output$downloadData_applyCollectionCodesPattern_NewCollectionCodesDictionary <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - New_Collection_Codes_Dictionary.csv", sep="")
        },
        content = function(file) {
          write.csv(occ[['collectionCodeNew']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      
    }
    
    
    # getMainCollectorLastName
    {
      
      ###
      loadMainCollectorLastName <- reactive({
        req(input$mainCollectorLastNameFile)
        tryCatch(
          {
            # files_tmp <- 'C:\\Users\\meloh\\Downloads\\data-2022-10-10.csv'
            
            files_tmp <- input$mainCollectorLastNameFile$datapath
            occ_tmp <- readr::read_csv(files_tmp,
                                       locale = readr::locale(encoding = "UTF-8"),
                                       show_col_types = FALSE) %>%
              data.frame() %>%
              dplyr::mutate(Ctrl_notes = Ctrl_notes %>% as.character(),
                            Ctrl_update = Ctrl_update %>% as.character(),
                            Ctrl_nameRecordedBy_Standard = Ctrl_nameRecordedBy_Standard %>% as.character(),
                            Ctrl_recordedBy = Ctrl_recordedBy %>% as.character(),
                            collectorName = collectorName %>% as.character(),
                            Ctrl_fullName = Ctrl_fullName %>% as.character(),
                            Ctrl_fullNameII = Ctrl_fullNameII %>% as.character(),
                            CVStarrVirtualHerbarium_PersonDetails = CVStarrVirtualHerbarium_PersonDetails %>% as.character())
            
            source_data <- 'mainCollectorLastName'
            occ[[source_data]] <<- occ_tmp
            
            
            return(occ_tmp)
          },
          error = function(e) {
            stop(safeError(e))
          }
        )
      })
      
      output$getMainCollectorLastNameContents_II <- renderRHandsontable({
        rhandsontable(loadMainCollectorLastName(), 
                      width = '100%', height = 500,
                      selectCallback = FALSE,
                      selectionMode = 'single') %>%
          hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
          hot_col("Ctrl_nameRecordedBy_Standard", readOnly = FALSE) %>%
          hot_col("Ctrl_notes", readOnly = FALSE)
      })
      
      
      output$II_getMainCollectorLastNameContents <-renderRHandsontable({
        rhandsontable(loadMainCollectorLastName(), 
                      width = '100%', height = 500,
                      selectCallback = FALSE,
                      selectionMode = 'single') %>%
          hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
          hot_col("Ctrl_nameRecordedBy_Standard", readOnly = FALSE) %>%
          hot_col("Ctrl_notes", readOnly = FALSE)
      })
      
      ###
      
      
      
      output$downloadDataMainCollectorLastName <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - Main_Collector_Last_Name.csv", sep="")
        },
        content = function(file) {
          write.csv(hot_to_r(input$getMainCollectorLastNameContents) %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      # }
      
      # getMainCollectorLastName
      {
        
        getMainCollectorLastName <- eventReactive(input$getMainCollectorLastNameBtn,
                                                  {
                                                    withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                      source_data <- 'mainCollectorLastName'
                                                      occ[[source_data]] <<- prepere_lastNameRecordedBy_v3(occ_tmp=occ[['all']],
                                                                                                           coletoresDB=coletoresDB)
                                                      
                                                      incProgress(100, detail = '100')
                                                    })
                                                    
                                                    return(occ[[source_data]])
                                                    
                                                  })
        
        
        output$getMainCollectorLastNameContents <- renderRHandsontable({
          rhandsontable(getMainCollectorLastName(), 
                        # width = 1300, height = 300,
                        selectCallback = FALSE,
                        selectionMode = 'single') %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col("Ctrl_nameRecordedBy_Standard", readOnly = FALSE) %>%
            hot_col("Ctrl_notes", readOnly = FALSE)
        })
        
      }
      
    }
    
    
    # geCollectionsCode
    {
      
      # loadOccCollectionsFileBtn occCollectionsFile
      {
        loadOccCollections <- reactive({
          req(input$occCollectionsFile)
          tryCatch(
            {
              # files_tmp <- 'C:\\Users\\meloh\\Downloads\\data-2022-10-10.csv'
              
              files_tmp <- input$occCollectionsFile$datapath
              occ_tmp <- readr::read_csv(files_tmp,
                                         locale = readr::locale(encoding = "UTF-8"),
                                         show_col_types = FALSE) %>%
                data.frame() %>%
                dplyr::select(colunas_ctrl_dwc)
              
              source_data <- 'all'
              occ[[source_data]] <<- occ_tmp
              
              
              return(occ_tmp)
            },
            error = function(e) {
              stop(safeError(e))
            }
          )
        })
        
        output$standardizeJoinContents_II <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                 {
                                                                   loadOccCollections()
                                                                 })
        
        
        output$downloadDataCollectionsCode <- downloadHandler(
          filename = function() {
            paste("Catalogo_Plantas_UCs_Brasil - Collections_Code.csv", sep="")
          },
          content = function(file) {
            write.csv(hot_to_r(input$getUniqueCollectionsCodeContents) %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          }
        )
      }
      
      # getUniqueCollectionsCode
      {
        
        loadCollectionsCode <- reactive({
          req(input$collectionsCodeFile)
          tryCatch(
            {
              # files_tmp <- 'C:\\Users\\meloh\\Downloads\\data-2022-10-10.csv'
              
              files_tmp <- input$collectionsCodeFile$datapath
              occ_tmp <- readr::read_csv(files_tmp,
                                         locale = readr::locale(encoding = "UTF-8"),
                                         show_col_types = FALSE) %>%
                data.frame() %>%
                dplyr::mutate(Ctrl_notes = Ctrl_notes %>% as.character(),
                              Ctrl_update = Ctrl_update %>% as.character(),
                              Ctrl_collectionCode_Standard = Ctrl_collectionCode_Standard %>% as.character(),
                              Ctrl_collectionCode = Ctrl_collectionCode %>% as.character(),
                              Ctrl_collectionsDictionary = Ctrl_collectionsDictionary %>% as.character(),
                              Ctrl_herbariumCode = Ctrl_herbariumCode %>% as.character(),
                              Ctrl_Institution = Ctrl_Institution %>% as.character(),
                              Ctrl_Location = Ctrl_Location %>% as.character())
              
              source_data <- 'collectionCode'
              occ[[source_data]] <<- occ_tmp
              
              
              return(occ_tmp)
            },
            error = function(e) {
              stop(safeError(e))
            }
          )
        })
        
        
        output$getUniqueCollectionsCodeContents_II <- renderRHandsontable({
          rhandsontable(loadCollectionsCode(), 
                        
                        # width = 1300, height = 300,
                        selectCallback = FALSE,
                        selectionMode = 'single') %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col("Ctrl_collectionCode_Standard", readOnly = FALSE) %>%
            hot_col("Ctrl_notes", readOnly = FALSE)
        })
        
        
        getUniqueCollectionsCode <- eventReactive(input$getUniqueCollectionsCodeBtn,
                                                  {
                                                    withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                      source_data <- 'collectionCode'
                                                      occ[[source_data]] <<- prepere_collectionCode_v2(occ_tmp=occ[['all']],
                                                                                                       collectionCodeDB=collectionCodeDB)
                                                      incProgress(100, detail = '100')
                                                    })
                                                    return(occ[[source_data]])
                                                    
                                                  })
        
        
        output$getUniqueCollectionsCodeContents <- renderRHandsontable({
          rhandsontable(getUniqueCollectionsCode(), 
                        # width = 1300, height = 300,
                        selectCallback = FALSE,
                        selectionMode = 'single') %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col("Ctrl_collectionCode_Standard", readOnly = FALSE) %>%
            hot_col("Ctrl_notes", readOnly = FALSE)
        })
      }
    }
    
    
    # checkTextualInformation
    {
      checkTextualInformation <- eventReactive(input$checkTextualInformationBtn,
                                               {
                                                 withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                   
                                                   {
                                                     # tempo_processo_tmp <- inicia_tempo_processamento('Conferência textual',
                                                     #                                                  tempo_processo)
                                                     print('Conferir informações textuais')
                                                     
                                                     # conferência textual
                                                     {
                                                       occ_tmp_3 <- verbatimCleaning_v2(occ[['all']], view_summary=FALSE)
                                                       
                                                       occ[['occ_vc']] <<- occ_tmp_3
                                                       occ[['occ_vc']]
                                                       
                                                     }
                                                     # tempo_processo <- get_tempo_processamento(tempo_processo_tmp)
                                                   }
                                                   incProgress(100, detail = '100')
                                                 })
                                                 
                                                 occ[['occ_vc']]
                                                 
                                                 
                                               })
      
      output$checkTextualInformationContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                                    {
                                                                      # occ[['occ_vc']] <<- checkTextualInformation()
                                                                      checkTextualInformation()
                                                                    })
    }

    # standardizeJoin
    {
      
      standardizeJoin <- eventReactive(input$standardizeJoinBtn, 
                                       {
                                         withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                           
                                           r_tmp <- {}
                                           
                                           if(NROW(occ[['reflora']])>0)
                                           {
                                             occ[['reflora']]$Ctrl_modified <- occ[['reflora']]$Ctrl_modified %>% as.character()                    
                                             r_tmp <- rbind(r_tmp,occ[['reflora']])}
                                           
                                           if(NROW(occ[['jabot']])>0)
                                           {
                                             occ[['jabot']]$Ctrl_modified <- occ[['jabot']]$Ctrl_modified %>% as.character()                    
                                             r_tmp <- rbind(r_tmp,occ[['jabot']])}

                                           if(NROW(occ[['splink']])>0)
                                           {
                                             occ[['splink']]$Ctrl_modified <- occ[['splink']]$Ctrl_modified %>% as.character()                    
                                             r_tmp <- rbind(r_tmp,occ[['splink']])}
                                           
                                           if(NROW(occ[['gbif']])>0)
                                           {
                                             occ[['gbif']]$Ctrl_modified <- occ[['gbif']]$Ctrl_modified %>% as.character()                    
                                             r_tmp <- rbind(r_tmp,occ[['gbif']])}
                                           
                                           occ[['all']] <<- r_tmp
                                           incProgress(100, detail = '100')
                                         })
                                         
                                         occ[['all']]
                                         
                                       })
      
      
      output$standardizeJoinContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                            {
                                                              
                                                              standardizeJoin()
                                                              
                                                            })
      
      # saveStandardizeJoinBtn
      {
        output$downloadData <- downloadHandler(
          filename = function() {
            paste("Catalogo_Plantas_UCs_Brasil - Join_occurrence_Darwin_Corre_Terms.csv", sep="")
          },
          content = function(file) {
            
            dt <- occ[['all']]
            write.csv(dt, file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
            
          }
        )
      }
    }
    
    
    # sources
    {
      
      
      # jabotBR
      {
        
        jabotRBLoad <- reactive({
          req(input$jabotBRFile)
          tryCatch(
            {
              files_tmp <- input$jabotBRFile$datapath
              
              # files_tmp <- 'C:\\Dados\\CNCFlora\\shiny\\cncflora\\scriptsAdd\\CatalogoUCs_v2\\busca_manual\\Serra das Lontras\\jabotRB\\ExportaDarwinCore.csv'
              
              nf <- length(files_tmp)
              occ_tmp <- data.frame({})
              if(nf>0)
              {
                
                i <- 1
                for(i in 1:nf)
                {
                  occ_tmp_1 <- read.delim(file = files_tmp[i],
                                          header = TRUE, 
                                          sep = "|",
                                          # quote = '"',
                                          dec = '.',
                                          stringsAsFactors = FALSE,
                                          # fileEncoding = "Windows-1258")
                                          fileEncoding = "UTF-8")
                  
                  occ_tmp <- rbind.data.frame(occ_tmp, occ_tmp_1)   
                }
              }
              
              # jabot
              source_data <- 'jabotRB'   
              # occ[[source_data]] <<- occ[['jabot']] #jabotLoad()
              
              if(NROW(occ_tmp)>0)
              {
                occ[[source_data]] <- occ_tmp
                
                # padronizar em dwc
                {
                  print(paste0('n. registros: ', nrow(occ[[source_data]])))
                  print(paste0('n. colunas: ', ncol(occ[[source_data]])))
                  
                  occ[[source_data]]$Ctrl_scientificNameOriginalSource <- NA
                  occ[[source_data]]$Ctrl_scientificNameOriginalSource <- occ[[source_data]]$scientificName
                  
                  occ[[source_data]] <- occ[[source_data]] %>%
                    dplyr::mutate(occurrenceID = occurrenceID,
                                  source = 'jabotRB',
                                  comments = '',
                                  scientificName = ifelse(taxonRank=='fam.',family,
                                                          ifelse(taxonRank=='gen.',genus,
                                                                 ifelse(taxonRank=='sp.', paste0(genus, ' ', specificEpithet),
                                                                        ifelse(taxonRank=='var.', paste0(genus, ' ', specificEpithet, ' var. ', infraspecificEpithet),
                                                                               ifelse(taxonRank=='Infr.', paste0(genus, ' ', specificEpithet, ' var. ', infraspecificEpithet),
                                                                                      
                                                                                      ifelse(taxonRank=='subsp.', paste0(genus, ' ', specificEpithet, ' subsp. ', infraspecificEpithet),
                                                                                             ifelse(taxonRank=='f.', paste0(genus, ' ', specificEpithet, ' form. ', infraspecificEpithet), 
                                                                                                    ""))))))),
                                  
                                  taxonRank = ifelse(taxonRank=='fam.','FAMILY',
                                                     ifelse(taxonRank=='gen.','GENUS',
                                                            ifelse(taxonRank=='sp.','SPECIES',
                                                                   ifelse(taxonRank=='var.', 'VARIETY',
                                                                          ifelse(taxonRank=='Infr.', 'VARIETY',
                                                                                 
                                                                                 ifelse(taxonRank=='subsp.', 'SUBSPECIES',
                                                                                        ifelse(taxonRank=='f.', 'FORM', 
                                                                                               ""))))))))
                  
                  
                }
                
                # padronizar pre-processamento
                {
                  occ_tmp_2 <- occ[[source_data]] %>%
                    dplyr::mutate(Ctrl_acceptedNameUsage = '',
                                  Ctrl_scientificNameAuthorship = scientificNameAuthorship,
                                  Ctrl_scientificName = scientificName,
                                  Ctrl_family = family,
                                  Ctrl_genus = genus,
                                  Ctrl_specificEpithet = specificEpithet,
                                  Ctrl_infraspecificEpithet = infraspecificEpithet,
                                  Ctrl_scientificNameSearched = "",
                                  Ctrl_scientificNameReference = "",
                                  Ctrl_bibliographicCitation = 'jabotRB',
                                  Ctrl_downloadAsSynonym = "",
                                  Ctrl_taxonRank = taxonRank) %>%
                    dplyr::mutate(
                      # CNCFlora_lastParsed = Sys.time(),
                      Ctrl_modified = modified_incomplete,# modified, 
                      Ctrl_institutionCode = institutionCode, 
                      Ctrl_collectionCode = collectionCode,  #'Herbário.de.Origem',
                      Ctrl_catalogNumber =  catalogNumber,#'Código.de.Barra',
                      
                      # Ctrl_identificationQualifier = check_identificationQualifier(scientificName),
                      Ctrl_identificationQualifier = identificationQualifier,
                      
                      Ctrl_identifiedBy = identifiedBy, #Determinador
                      
                      Ctrl_dateIdentified = dateIdentified,#str_sub(dateIdentified,1,10),  
                      # Ctrl_dateIdentified =  lubridate::year(dateIdentified),
                      Ctrl_typeStatus = typeStatus, 
                      Ctrl_recordNumber = recordNumber, #'Número.da.Coleta', 
                      Ctrl_recordedBy = recordedBy, # Coletor,
                      Ctrl_fieldNumber = "", 
                      Ctrl_country =  country, # País, 
                      Ctrl_stateProvince = stateProvince, #Estado, 
                      Ctrl_municipality =  municipality , #county, #Município, 
                      Ctrl_locality = locality,  #'Descrição.da.Localidade'
                      Ctrl_year = year, 
                      Ctrl_month = month, 
                      Ctrl_day = day,
                      Ctrl_decimalLatitude = decimalLatitude, 
                      Ctrl_decimalLongitude = decimalLongitude, 
                      Ctrl_occurrenceRemarks = paste0(fieldNotes, ', ',occurrenceRemarks), 
                      
                      Ctrl_comments = "",
                      
                      # memória de registro
                      # 21-08-2021
                      Ctrl_occurrenceID = paste0('jabotRB=',catalogNumber) %>% as.character(),
                      Ctrl_fieldNotes = fieldNotes) %>%
                    dplyr::select(colunas_ctrl_dwc)
                  
                  # occ[['all']] <<- rbind.data.frame(occ[['all']],
                  #                                   occ_tmp)
                  
                  occ[[source_data]] <<- occ_tmp_2
                }
              }
              
              return(occ_tmp)
            },
            error = function(e) {
              stop(safeError(e))
            }
          )
        })
        
        output$jabotRBContents <- DT::renderDataTable(options = list(scrollX = TRUE),
                                                      {
                                                        jabotRBLoad()
                                                      })
        
        
        
      }
      
      
    }
    
    
    # mergeOccurrencesCollectionCodeMainCollector
    {
      mergeOccurrencesCollectionCodeMainCollector <- eventReactive(input$mergeOccurrencesCollectionCodeMainCollectorBtn,
                                                                   {
                                                                     withProgress(message = 'Processing...', style = 'notification', value = 0.5, {
                                                                       
                                                                       if(NROW(occ[['all']])>0)
                                                                       {
                                                                         r_tmp <- data.frame(idtmp=1:NROW(occ[['all']]))
                                                                         
                                                                         if(NROW(occ[['all_collectionCode']])==NROW(occ[['all']]))
                                                                         {
                                                                           r_tmp <- cbind(r_tmp,
                                                                                          occ[['all_collectionCode']] %>% 
                                                                                            dplyr::select(Ctrl_collectionCode_Standard,
                                                                                                          Ctrl_catalogNumber_Standard,
                                                                                                          Ctrl_key_collectionCode_catalogNumber))
                                                                         }
                                                                         
                                                                         
                                                                         if(NROW(occ[['all_mainCollectorLastName']])==NROW(occ[['all']]))
                                                                         {
                                                                           r_tmp <- cbind(r_tmp,
                                                                                          occ[['all_mainCollectorLastName']] %>% 
                                                                                            dplyr::select(Ctrl_nameRecordedBy_Standard,
                                                                                                          Ctrl_recordNumber_Standard,
                                                                                                          Ctrl_key_family_recordedBy_recordNumber,
                                                                                                          Ctrl_key_year_recordedBy_recordNumber))
                                                                         }
                                                                         
                                                                         if(NROW(occ[['occ_vc']])==NROW(occ[['all']]))
                                                                         {
                                                                           r_tmp <- cbind(r_tmp,
                                                                                          occ[['occ_vc']] %>% 
                                                                                            dplyr::select(verbatimNotes,
                                                                                                          temAnoColeta,
                                                                                                          temCodigoInstituicao,
                                                                                                          temNumeroCatalogo,
                                                                                                          temColetor,
                                                                                                          temNumeroColeta,
                                                                                                          temPais,
                                                                                                          temUF,
                                                                                                          temMunicipio,
                                                                                                          temLocalidade,
                                                                                                          temIdentificador,
                                                                                                          temDataIdentificacao
                                                                                                          # Ctrl_country_standardized,
                                                                                                          # Ctrl_municipality_standardized,
                                                                                                          # Ctrl_stateProvince_standardized,
                                                                                                          # Ctrl_locality_standardized,
                                                                                                          # Ctrl_lastParsed
                                                                                            ))
                                                                           
                                                                         }
                                                                         
                                                                         
                                                                         if(NROW(occ[['taxonomicAlignment']])==NROW(occ[['all']]))
                                                                         {
                                                                           r_tmp <- cbind(r_tmp,
                                                                                          occ[['taxonomicAlignment']] %>%
                                                                                            dplyr::select(
                                                                                              c(wcvp_kew_id,
                                                                                                wcvp_family,
                                                                                                wcvp_genus,
                                                                                                wcvp_species,
                                                                                                wcvp_infraspecies,
                                                                                                wcvp_taxon_name,
                                                                                                wcvp_authors,
                                                                                                wcvp_rank,
                                                                                                wcvp_taxonomic_status,
                                                                                                wcvp_accepted_kew_id ,
                                                                                                wcvp_accepted_name,
                                                                                                wcvp_accepted_authors,
                                                                                                wcvp_parent_kew_id,
                                                                                                wcvp_parent_name,
                                                                                                wcvp_parent_authors,
                                                                                                wcvp_reviewed,
                                                                                                wcvp_publication,
                                                                                                wcvp_original_name_id,
                                                                                                wcvp_TAXON_NAME_U,
                                                                                                wcvp_searchNotes,
                                                                                                wcvp_searchedName,
                                                                                                
                                                                                                ###
                                                                                                
                                                                                                fb2020_taxonID,
                                                                                                fb2020_acceptedNameUsageID,
                                                                                                fb2020_parentNameUsageID,
                                                                                                fb2020_originalNameUsageID,
                                                                                                fb2020_scientificName,
                                                                                                # fb2020_acceptedNameUsage,
                                                                                                # fb2020_parentNameUsage,
                                                                                                fb2020_namePublishedIn,                  
                                                                                                fb2020_namePublishedInYear,
                                                                                                fb2020_higherClassification,             
                                                                                                # fb2020_kingdom,
                                                                                                # fb2020_phylum,                           
                                                                                                # fb2020_class,
                                                                                                # fb2020_order,                            
                                                                                                fb2020_family,
                                                                                                fb2020_genus,                            
                                                                                                fb2020_specificEpithet,
                                                                                                fb2020_infraspecificEpithet,             
                                                                                                fb2020_taxonRank,
                                                                                                fb2020_scientificNameAuthorship,
                                                                                                fb2020_taxonomicStatus,
                                                                                                fb2020_nomenclaturalStatus,              
                                                                                                fb2020_modified,
                                                                                                fb2020_bibliographicCitation,
                                                                                                fb2020_references,
                                                                                                fb2020_scientificNamewithoutAuthorship,  
                                                                                                fb2020_scientificNamewithoutAuthorship_U,
                                                                                                fb2020_searchNotes,
                                                                                                fb2020_searchedName)
                                                                                            ))
                                                                           
                                                                         }
                                                                         
                                                                         
                                                                         r_tmp <- cbind(r_tmp,
                                                                                        occ[['all']]) %>% 
                                                                           dplyr::select(-idtmp) %>%
                                                                           dplyr::mutate(Ctrl_voucherAmostra = FALSE,
                                                                                         Ctrl_amostraVerificada = FALSE,
                                                                                         Ctrl_naoPossivelVerificar = FALSE,
                                                                                         Ctrl_observacaoNaoPossivelVerificar = '',
                                                                                         
                                                                                         Ctrl_dataVerificacao = '',
                                                                                         Ctrl_verificadoPor = '',
                                                                                         Ctrl_emailVerificador = '',
                                                                                         Ctrl_scientificName_verified	= '',
                                                                                         Ctrl_family_verified = '',
                                                                                         
                                                                                         Ctrl_Record_ID_Review = 1:NROW(occ[['all']])
                                                                           )
                                                                         
                                                                         
                                                                         # updated occurrences CSV file: collection code and main collector's last name
                                                                         
                                                                         # source_data <- 'all_updated_collection_collector'
                                                                         # occ[[source_data]] <<- r_tmp
                                                                         
                                                                         
                                                                         print('gerar link amostras....')
                                                                         
                                                                         r_tmp$link_imagem_amostra <- rep('',NROW(r_tmp))
                                                                         i=1
                                                                         for(i in 1:NROW(r_tmp))
                                                                         {
                                                                           print(paste0(i, ' ', NROW(r_tmp)))
                                                                           r_tmp$link_imagem_amostra[i] <- get_link_source_record_url(r_tmp$Ctrl_occurrenceI[i],
                                                                                                                                      r_tmp$Ctrl_bibliographicCitation[i],
                                                                                                                                      r_tmp$Ctrl_scientificName[i]) #%>% data.frame(stringsAsFactors = FALSE)
                                                                         }
                                                                         
                                                                         
                                                                         source_data <- 'all_results'
                                                                         occ[[source_data]] <<- r_tmp
                                                                         
                                                                       }
                                                                       
                                                                       
                                                                       incProgress(100, detail = '100')
                                                                     })
                                                                     
                                                                     
                                                                     return(r_tmp)
                                                                     # all_collectionCode
                                                                     # all_mainCollectorLastName
                                                                     # 
                                                                     # mergeOccurrencesCollectionCodeMainCollectorBtn
                                                                     # downloadDataMgeOccurrencesCollectionCodeMainCollector
                                                                     # mergeOccurrencesCollectionCodeMainCollectorContents
                                                                     # 
                                                                     # Ctrl_collectionCode_Standard
                                                                     # Ctrl_catalogNumber_Standard
                                                                     # Ctrl_key_collectionCode_catalogNumber
                                                                     # 
                                                                     # Ctrl_nameRecordedBy_Standard
                                                                     # Ctrl_recordNumber_Standard
                                                                     # Ctrl_key_family_recordedBy_recordNumber
                                                                     # Ctrl_key_year_recordedBy_recordNumber
                                                                     
                                                                     
                                                                   })
      
      # output$mergeOccurrencesCollectionCodeMainCollectorContents <- DT::renderDataTable(options = list(scrollX = TRUE),
      #                                                                                   {
      #                                                                                      req(input$mergeOccurrencesCollectionCodeMainCollectorBtn)
      #                                                                                      pega_dados()
      #                                                                                      # mergeOccurrencesCollectionCodeMainCollector()
      #                                                                                   })
      pega_dados <- function(){
        
        x1 <- data.frame(hot_to_r(input$hot_mergeOccurrencesContents),
                         stringsAsFactors = FALSE)
        
        x1$Incluir_Amostra <- ifelse(is.na(x1$Incluir_Amostra), FALSE, x1$Incluir_Amostra )
        x1 <- x1 %>%
          dplyr::filter(Incluir_Amostra==TRUE) 
        
        
        x2 <- occ[['all_results']]
        
        
        x <- left_join(x1 %>% dplyr::select(Ctrl_Record_ID_Review), 
                       x2,
                       by = 'Ctrl_Record_ID_Review')
        
        return(x)
      }
      
      
      output$downloadDataMgeOccurrencesCollectionCodeMainCollector <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - Planilha para Revisao Eletronica.csv", sep="")
        },
        content = function(file) {
          # print('aqui')
          
          dt<- pega_dados()
          
          # write.csv(occ[['all_results']] %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          write.csv(dt, file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
        })
      
      
      output$hot_mergeOccurrencesContents <- renderRHandsontable(
        {
          shiny::validate(
            need(NROW(mergeOccurrencesCollectionCodeMainCollector())>0,  "..."))
          
          
          dt <- mergeOccurrencesCollectionCodeMainCollector()
          
          # dt <- occ[['all_results']]
          dt$Incluir_Amostra <- TRUE
          
          dt <- dt %>%
            dplyr::select(Incluir_Amostra,
                          Ctrl_locality, Ctrl_country, Ctrl_stateProvince, Ctrl_municipality,
                          Ctrl_family, Ctrl_scientificName, fb2020_family, fb2020_scientificName,
                          Ctrl_collectionCode, Ctrl_catalogNumber, Ctrl_key_family_recordedBy_recordNumber, Ctrl_recordNumber, Ctrl_recordedBy,
                          Ctrl_year, Ctrl_month, Ctrl_day,
                          link_imagem_amostra,
                          Ctrl_Record_ID_Review) %>%
            arrange_at(.,c('Ctrl_locality', 'Ctrl_country', 'Ctrl_stateProvince', 'Ctrl_municipality') )
          
          
          # dt <- dt %>%
          #    dplyr::select(Incluir_Amostra,
          #                  Ctrl_locality, Ctrl_country, Ctrl_stateProvince, Ctrl_municipality
          #                  # Ctrl_occurrenceID, Ctrl_bibliographicCitation, Ctrl_downloadAsSynonym, Ctrl_scientificNameSearched, Ctrl_scientificNameReference, Ctrl_acceptedNameUsage, Ctrl_scientificNameAuthorship, Ctrl_scientificName, Ctrl_scientificNameOriginalSource, Ctrl_family, Ctrl_genus, Ctrl_specificEpithet, Ctrl_infraspecificEpithet, Ctrl_modified, Ctrl_institutionCode, Ctrl_collectionCode, Ctrl_catalogNumber, Ctrl_identificationQualifier, Ctrl_identifiedBy, Ctrl_dateIdentified, Ctrl_typeStatus, Ctrl_recordNumber, Ctrl_recordedBy, Ctrl_fieldNumber, Ctrl_year, Ctrl_month, Ctrl_day, Ctrl_decimalLatitude, Ctrl_decimalLongitude, Ctrl_occurrenceRemarks, Ctrl_comments, Ctrl_taxonRank, 
          #                  # Ctrl_nameRecordedBy_Standard, Ctrl_recordNumber_Standard, Ctrl_key_family_recordedBy_recordNumber, Ctrl_key_year_recordedBy_recordNumber,
          #                  # # Ctrl_recordNumber_Standard, Ctrl_key_family_recordedBy_recordNumber, Ctrl_key_year_recordedBy_recordNumber, 
          #                  # wcvp_kew_id, wcvp_family, wcvp_genus, wcvp_species, wcvp_infraspecies, wcvp_taxon_name, wcvp_authors, wcvp_rank, wcvp_taxonomic_status, wcvp_accepted_kew_id, wcvp_accepted_name, wcvp_accepted_authors, wcvp_parent_kew_id, wcvp_parent_name, wcvp_parent_authors, wcvp_reviewed, wcvp_publication, wcvp_original_name_id, wcvp_TAXON_NAME_U, wcvp_searchNotes, wcvp_searchedName, 
          #                  # fb2020_taxonID, fb2020_acceptedNameUsageID, fb2020_parentNameUsageID, fb2020_originalNameUsageID, fb2020_scientificName, fb2020_namePublishedIn, fb2020_namePublishedInYear, fb2020_higherClassification, fb2020_family, fb2020_specificEpithet, fb2020_infraspecificEpithet, fb2020_taxonRank, fb2020_scientificNameAuthorship, fb2020_taxonomicStatus, fb2020_nomenclaturalStatus, fb2020_modified, fb2020_bibliographicCitation, fb2020_references, fb2020_scientificNamewithoutAuthorship, fb2020_scientificNamewithoutAuthorship_U, fb2020_searchNotes, fb2020_searchedName, 
          #                  # Ctrl_voucherAmostra, Ctrl_amostraVerificada, Ctrl_naoPossivelVerificar, Ctrl_observacaoNaoPossivelVerificar, Ctrl_dataVerificacao, Ctrl_verificadoPor, Ctrl_emailVerificador, Ctrl_scientificName_verified, Ctrl_family_verified, Ctrl_Record_ID_Review
          #                  ) %>%
          #    arrange_at(.,c('Ctrl_locality', 'Ctrl_country', 'Ctrl_stateProvince', 'Ctrl_municipality') )
          
          rhandsontable(dt, 
                        
                        # row_highlight = 1,
                        
                        width = '100%', height = 400,
                        
                        digits = 0,
                        selectionMode = 'single',
                        selectCallback = TRUE) %>%
            hot_table(highlightCol = TRUE, highlightRow = TRUE, readOnly = TRUE) %>%
            hot_col(col = c('Incluir_Amostra'), readOnly = FALSE, type='checkbox') 
        })
      
      
      # planilha modelo
      output$download_ModeloCatalogo <- downloadHandler(
        filename = function() {
          paste("Catalogo_Plantas_UCs_Brasil - Planilha para Revisao Manual.xls", sep="")
        },
        content = function(file) {
          
          # dt <- occ[['all_results']]
          
          dt<- pega_dados()
          
          
          dt$bancodados <- rep('',NROW(dt))
          dt$barcode <- rep('',NROW(dt)) 
          for(ii in 1:NROW(dt))
          {
            bancodados <- stringr::str_sub(dt$Ctrl_occurrenceID[ii], 
                                           1, 
                                           stringr::str_locate(dt$Ctrl_occurrenceID[ii], '=')[,1]-1)
            
            
            bancodados <- paste0(toupper(stringr::str_sub(bancodados,1,1)),stringr::str_sub(bancodados, 2,nchar(bancodados)))
            
            barcode <- stringr::str_sub(dt$Ctrl_occurrenceID[ii],
                                        stringr::str_locate(dt$Ctrl_occurrenceID[ii], '=')[,1]+1,
                                        nchar(dt$Ctrl_occurrenceID[ii]))
            
            dt$bancodados[ii] <- bancodados
            dt$barcode[ii] <- barcode
          }
          
          
          dt <- dt %>%
            dplyr::arrange_at(., c('Ctrl_family','Ctrl_scientificName','Ctrl_nameRecordedBy_Standard','Ctrl_recordNumber_Standard'))
          
          
          data_imp <- data.frame(UC = rep('',NROW(dt)),
                                 Grupos = rep('',NROW(dt)),
                                 `Táxon completo (segundo ficha herbário)` = paste0(dt$Ctrl_family, ' ',dt$Ctrl_scientificName),
                                 `Família (segundo Flora & Funga do Brasil)`= dt$fb2020_family,
                                 `Gênero (segundo Flora & Funga do Brasil)` =  word(dt$fb2020_scientificName,1),
                                 `Espécie (segundo Flora & Funga do Brasil)` = word(dt$fb2020_scientificName,2),
                                 `Autor (segundo Flora & Funga do Brasil)` = dt$fb2020_scientificNameAuthorship,
                                 `Táxon completo (segundo Flora & Funga do Brasil)` = paste0(dt$fb2020_family, ' ',dt$fb2020_scientificName),
                                 `Barcode`	=  dt$barcode,
                                 `Banco de dados de origem`	= dt$bancodados,
                                 `Sigla Herbário` = dt$Ctrl_collectionCode,
                                 `Coletor`	= dt$Ctrl_recordedBy,
                                 `Número da Coleta`	= dt$Ctrl_recordNumber,
                                 `link para imagem da amostra` = dt$link_imagem_amostra,
                                 `Origem (segundo Flora e Funga do Brasil)` = rep('',NROW(dt)),
                                 `Determinador` = dt$Ctrl_identifiedBy,
                                 `Data Determinação` = dt$Ctrl_dateIdentified,
                                 `Data Coleta` = paste0(dt$Ctrl_day,'/',dt$Ctrl_month, '/',dt$Ctrl_year),
                                 `País` = dt$Ctrl_country,
                                 `UF` = dt$Ctrl_stateProvince,
                                 `Município` = dt$Ctrl_municipality,
                                 `Localidade` = dt$Ctrl_locality,
                                 `Longitude` = dt$Ctrl_decimalLongitude,
                                 `Latitude` = dt$Ctrl_decimalLatitude
          )
          
          # write.csv(data_imp %>% data.frame(stringsAsFactors = FALSE), file, row.names = FALSE, fileEncoding = "UTF-8", na = "")
          # write_excel_csv(data_imp %>% data.frame(stringsAsFactors = FALSE), file, na = "")
          
          
          # setting the threshold for the maximum number of characters to be preserved
          n_char_to_truncate_threshold <- 32767
          
          # tidyverse
          # adjusted data.frame where the character columns are truncated so that they do not exceed the threshold of 32767 characters
          df2 <- map_df(data_imp, ~ifelse(is.character(.x) & nchar(.x) > n_char_to_truncate_threshold,  str_sub(.x, 1, n_char_to_truncate_threshold), .x))
          
          # checking the result to make sure it is truncated
          # you can also use it beforehand to see which columns are the ones causing problems
          map_df(df2, ~ifelse(is.character(.x), nchar(.x), NA) )
          
          
          writexl::write_xlsx(df2, 
                              file)
          # sheetName = 'Modelo', 
          # append = FALSE)
          
          
        })
      
      
    }
    
    
  }
  
  # shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
  shinyApp(ui = ui, server = server)

  
  #' @title Prepare Plant Catalog App
  #' @name app_exsicata
  #' @description An R app for preparing species listings for the Plant.
  #' @return CSV files
  #' @author Pablo Hendrigo Alves de Melo
  #'        
  #' @seealso \code{\link[utils]{download.file}}, \code{\link[utils]{aspell}}
  #' 
  #' @import devtools
  #' @import plyr
  #' @import dplyr
  #' @import tidyr
  #' @import readr
  #' @import stringr
  #' @import lubridate
  #' @import jsonlite
  #' @import sqldf
  #' @import rvest
  #' @import shiny
  #' @import shinydashboard
  #' @import rhandsontable
  #' @import DT
  #' @import rhandsontable
  #' @import shinyWidgets
  #' @import measurements
  #' @import downloader
  #' @import glue
  #' @import tidyverse
  #' 
  #' @examples
  #' \donttest{
  #' app_exsicata()
  #' }
  #' 
  #' @export
  # app_exsicata <- function()
  