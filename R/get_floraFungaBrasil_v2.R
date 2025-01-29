get_floraFungaBrasil_v2 <- function(url_source = "http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil",
                                    path_results = tempdir)#'C:\\Dados\\APP_GBOT\\data') # if NULL
  
{  
  
  require(dplyr)
  require(downloader)
  require(stringr)
  # require(plyr)
  
  # criar pasta para salvar raultados do dataset
  path_results <- paste0(path_results,'/FloraFungaBrasil')
  if (!dir.exists(path_results)){dir.create(path_results)}
  
  destfile <- paste0(path_results,"/IPT_FloraFungaBrasil_.zip")
  
  
  # ultima versao
  # destfile <- paste0(path_results,"/",Sys.Date(),'.zip')
  downloader::download(url = url_source, destfile = destfile, mode = "wb") 
  utils::unzip(destfile, exdir = path_results) # descompactar e salvar dentro subpasta "ipt" na pasta principal
  
  
  taxon.file <- paste0(path_results,"/taxon.txt")
  
  # taxon.file <- paste0("C:\\Dados\\APP_GBOT\\data\\FloraFungaBrasil\\taxon.txt")
  
  
  
  # taxon
  fb2020_taxon  <- readr::read_delim(taxon.file, delim = "\t", quote = "") %>% 
    dplyr::select(-id)
  
  ### familia
  # index = fb2020_taxon$taxonRank %in% c("ESPECIE",
  #                                       "SUB_ESPECIE",
  #                                       "VARIEDADE",
  #                                       "FORMA")
  
  index = fb2020_taxon$taxonRank %in% c("ESPECIE",
                                        "SUB_ESPECIE",
                                        "VARIEDADE",
                                        "FORMA",
                                        "FAMILIA",
                                        "GENERO")
  ###
  
  fb2020_taxon  <- fb2020_taxon[index==TRUE,] 
  
  
  scientificName_tmp <- fb2020_taxon$scientificName %>% stringr::str_split(.,pattern = ' ', simplify = TRUE)
  
  
  # carregando especie sem autor
  scientificName <- rep('',nrow(fb2020_taxon))
  
  # scientificName[index==TRUE] <- scientificName_tmp[index==TRUE,1] %>% trimws(.,'right')
  
  index = fb2020_taxon$taxonRank %in% c("ESPECIE")
  
  scientificName[index==TRUE] <-  paste0(scientificName_tmp[index==TRUE,1], ' ', scientificName_tmp[index==TRUE,2]) #%>% trimws(.,'right')
  
  index = fb2020_taxon$taxonRank %in% c("VARIEDADE")
  scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' var. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
  
  index = fb2020_taxon$taxonRank %in% c("SUB_ESPECIE")
  scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' subsp. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
  
  index = fb2020_taxon$taxonRank %in% c("FORMA")
  scientificName[index==TRUE] <-  paste0(fb2020_taxon$genus[index==TRUE], ' ', fb2020_taxon$specificEpithet[index==TRUE], ' form. ', fb2020_taxon$infraspecificEpithet[index==TRUE])# %>% trimws(.,'right')
  
  fb2020_taxon$scientificNamewithoutAuthorship <- scientificName
  fb2020_taxon$scientificNamewithoutAuthorship_U <- toupper(scientificName)
  
  fb2020_taxon$scientificNameAuthorship_U <- toupper(fb2020_taxon$scientificNameAuthorship)
  
  ### reconhecer genero e familia
  
  fb2020_taxon$genus_U <- toupper(fb2020_taxon$genus)
  
  fb2020_taxon$family_U <- toupper(fb2020_taxon$family)
  
  ###
  
  return(fb2020_taxon)
  
}
