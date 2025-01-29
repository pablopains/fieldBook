checkName_FloraFungaBrasil <- function(searchedName = 'Alomia angustata',
                                       fb2020="",
                                       if_author_fails_try_without_combinations=TRUE)
{
  print(searchedName)
  # https://powo.science.kew.org/about-wcvp#unplacednames
  
  x <- {}  
  sp_fb <- standardize_scientificName(searchedName)
  
  if(sp_fb$taxonAuthors != "")
  {
    
    index_author <- 100
    
    index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) & 
      fb2020$scientificNameAuthorship_U %in% toupper(gsub ("\\s+", "", sp_fb$taxonAuthors ))
    ntaxa <- NROW(fb2020[index==TRUE,])
    
    if(ntaxa == 0 & if_author_fails_try_without_combinations == TRUE)
    {
      index_author <- 50
      index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) & 
        fb2020$scientificNameAuthorship_U %in% toupper(gsub ("\\s+", "", sp_fb$taxonAuthors_last ))
      ntaxa <- NROW(fb2020[index==TRUE,])
    }
    
    
    if(ntaxa == 0)
    {
      index_author <- 0
      index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName)
      ntaxa <- NROW(fb2020[index==TRUE,])
    }
    
  }else
  {
    index_author <- 0
    index <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName)
    ntaxa <- NROW(fb2020[index==TRUE,])
  }
  
  if(ntaxa == 0 | sp_fb$standardizeName=="")
  {
    x <- fb2020[index==TRUE,] %>%
      dplyr::add_row()  %>%
      dplyr::mutate(searchedName=searchedName,
                    taxon_status_of_searchedName = "",
                    plant_name_id_of_searchedName = "",
                    taxon_authors_of_searchedName = "",
                    verified_author = index_author,
                    verified_speciesName = 0,
                    searchNotes='Not found')
  }
  
  if(ntaxa == 1)
  {
    verified_speciesName <- 100
    
    id_accept <- ifelse(is.na(fb2020$acceptedNameUsageID[index==TRUE]),'', fb2020$acceptedNameUsageID[index==TRUE])
    
    if((!is.na(fb2020$acceptedNameUsageID[index==TRUE])) &
       (fb2020$taxonID[index==TRUE] != id_accept ))
    {
      
      x <- fb2020[index==TRUE,]
      
      taxon_status_of_searchedName <- fb2020[index==TRUE,]$taxonomicStatus
      plant_name_id_of_searchedName <- fb2020[index==TRUE,]$taxonID
      taxon_authors_of_searchedName <- fb2020[index==TRUE,]$scientificNamewithoutAuthorship
      
      index_synonym <- fb2020$taxonID %in% x$acceptedNameUsageID 
      
      if(sum(index_synonym==TRUE)==1)
      {
        x <- fb2020[index_synonym==TRUE,] %>%
          dplyr::mutate(searchedName=searchedName,
                        taxon_status_of_searchedName = taxon_status_of_searchedName,
                        plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                        taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                        verified_author = index_author,
                        verified_speciesName = verified_speciesName,
                        searchNotes= 'Updated')
        
      }else
      {
        x <- fb2020[index==TRUE,] %>%
          dplyr::mutate(searchedName=searchedName,
                        taxon_status_of_searchedName = taxon_status_of_searchedName,
                        plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                        taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                        verified_author = index_author,
                        verified_speciesName = verified_speciesName,
                        searchNotes= 'Does not occur in Brazil')
      }
      
    }else
    {
      x <- fb2020[index==TRUE,] %>%
        # dplyr::add_row()  %>%
        dplyr::mutate(searchedName=searchedName,
                      taxon_status_of_searchedName = "",
                      plant_name_id_of_searchedName = "",
                      taxon_authors_of_searchedName = "",
                      verified_author = index_author,
                      verified_speciesName = verified_speciesName,
                      searchNotes=ifelse(is.na(taxonomicStatus),'',taxonomicStatus))
    }
    
  }
  
  if(ntaxa > 1)
  {
    
    taxon_status_of_searchedName <- paste(fb2020[index==TRUE,]$taxonomicStatus, collapse = '|')
    plant_name_id_of_searchedName <- paste(fb2020[index==TRUE,]$taxonID, collapse = '|')
    # taxon_authors_of_searchedName <- paste(paste0(fb2020[index==TRUE,]$taxon_name, ' ',fb2020[index==TRUE,]$taxon_authors), collapse = '|')
    taxon_authors_of_searchedName <- paste(fb2020[index==TRUE,]$scientificNameAuthorship, collapse = '|')
    
    
    # Accepted or Homonyms
    {
      index_status <- fb2020$scientificNamewithoutAuthorship_U %in% toupper(sp_fb$standardizeName) &
        fb2020$taxonomicStatus %in% c( "NOME_ACEITO")
      
      ntaxa_status <- NROW(fb2020[index_status==TRUE,])
      
      if(ntaxa_status == 1)
      {
        
        x <- fb2020[index_status==TRUE,] %>%
          dplyr::mutate(searchedName=searchedName,
                        taxon_status_of_searchedName = taxon_status_of_searchedName,
                        plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                        taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                        verified_author = index_author,
                        verified_speciesName = 100/ntaxa,
                        searchNotes=taxonomicStatus)
      }
      else
      {
        
        
        x <- fb2020[1==2,] %>%
          dplyr::add_row()  %>%
          dplyr::mutate(searchedName=searchedName,
                        taxon_status_of_searchedName = taxon_status_of_searchedName,
                        plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                        taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                        verified_author = index_author,
                        verified_speciesName = 0,
                        searchNotes='Homonyms')
        
      }
      
    }
    
  }
  
  # 'Homonyms' ajustar família
  
  if(x$searchNotes == 'Not found' )
  {
    ### reconhecer genero e familia
    # x <-{}
    w1 <- toupper(word(sp_fb$standardizeName))
    
    index <- fb2020$genus_U %in% toupper(w1) & fb2020$taxonRank == 'GENERO' & !is.na(fb2020$acceptedNameUsageID)
    ntaxa <- NROW(fb2020[index==TRUE,])
    
    g_f <- 'g'
    
    if(ntaxa == 0 )
    {
      index <- fb2020$family_U %in% toupper(w1) & fb2020$taxonRank == 'FAMILIA' & !is.na(fb2020$acceptedNameUsageID)
      ntaxa <- NROW(fb2020[index==TRUE,])
      g_f <- 'f'
    }    
    
    if(ntaxa == 1)
    {
      verified_speciesName <- 100
      
      id_accept <- ifelse(is.na(fb2020$acceptedNameUsageID[index==TRUE]),'', fb2020$acceptedNameUsageID[index==TRUE])
      
      if((!is.na(fb2020$acceptedNameUsageID[index==TRUE])) &
         (fb2020$taxonID[index==TRUE] != id_accept ))
      {
        
        x <- fb2020[index==TRUE,]
        
        taxon_status_of_searchedName <- fb2020[index==TRUE,]$taxonomicStatus
        plant_name_id_of_searchedName <- fb2020[index==TRUE,]$taxonID
        taxon_authors_of_searchedName <- fb2020[index==TRUE,]$scientificNamewithoutAuthorship
        
        index_synonym <- fb2020$taxonID %in% x$acceptedNameUsageID 
        
        if(sum(index_synonym==TRUE)==1)
        {
          x <- fb2020[index_synonym==TRUE,] %>%
            dplyr::mutate(searchedName=searchedName,
                          taxon_status_of_searchedName = taxon_status_of_searchedName,
                          plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                          taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                          verified_author = index_author,
                          verified_speciesName = verified_speciesName,
                          searchNotes=  ifelse(g_f=='g', 'Updated_genus', 'Updated_family') )
          
        }else
        {
          x <- fb2020[index==TRUE,] %>%
            dplyr::mutate(searchedName=searchedName,
                          taxon_status_of_searchedName = taxon_status_of_searchedName,
                          plant_name_id_of_searchedName = plant_name_id_of_searchedName,
                          taxon_authors_of_searchedName = taxon_authors_of_searchedName,
                          verified_author = index_author,
                          verified_speciesName = verified_speciesName,
                          searchNotes= 'Does not occur in Brazil')
        }
        
      }else
      {
        x <- fb2020[index==TRUE,] %>%
          # dplyr::add_row()  %>%
          dplyr::mutate(searchedName=searchedName,
                        taxon_status_of_searchedName = "",
                        plant_name_id_of_searchedName = "",
                        taxon_authors_of_searchedName = "",
                        verified_author = index_author,
                        verified_speciesName = verified_speciesName,
                        searchNotes=taxonomicStatus)
      }
      
    }
    
    
    if(ntaxa >1)
    {
      
      x <- fb2020[index==TRUE,][1,] %>%
        # dplyr::add_row()  %>%
        dplyr::mutate(taxonID = '',                           
                      acceptedNameUsageID = '',
                      parentNameUsageID = '',         
                      originalNameUsageID = '',          
                      
                      # scientificName = ifelse(g_f=='g', genus, family),                    
                      scientificName = '', 
                      
                      acceptedNameUsage  = '',                
                      parentNameUsage = '',                   
                      namePublishedIn = '',                  
                      namePublishedInYear = '',               
                      higherClassification = '',             
                      # kingdom                           
                      # phylum                           
                      # class                             
                      # order                            
                      # family                            
                      # genus                            
                      specificEpithet = '',                   
                      infraspecificEpithet = '',             
                      
                      # taxonRank = ifelse(g_f=='g',"GENERO", "FAMILIA"),   
                      taxonRank = '',
                      
                      scientificNameAuthorship = '',
                      taxonomicStatus = '',                   
                      nomenclaturalStatus = '',              
                      modified = '',                          
                      bibliographicCitation = '',            
                      references = '',                        
                      scientificNamewithoutAuthorship = ifelse(g_f=='g', genus, family),
                      scientificNamewithoutAuthorship_U = ifelse(g_f=='g', genus_U, family_U),
                      scientificNameAuthorship_U = '',       
                      genus_U,                           
                      family_U) %>%
        dplyr::mutate(searchedName=searchedName,
                      taxon_status_of_searchedName = "",
                      plant_name_id_of_searchedName = "",
                      taxon_authors_of_searchedName = "",
                      verified_author = "",
                      verified_speciesName = "",
                      searchNotes=taxonRank)
    }
    ###
    
  }
  
  colnames(x) <- str_c('fb2020_',colnames(x))
  return(x)
  
}