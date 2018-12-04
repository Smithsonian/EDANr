## ---- eval=FALSE---------------------------------------------------------
#  #EDAN creds
#  AppID = "APP_ID"
#  AppKey = "verylong_key"
#  
#  #Required packages
#  library(c("EDANr", "magick", "stringr"))
#  
#  #Create folders to store images
#  # wide images
#  dir.create("images_w", showWarnings = FALSE)
#  # tall images
#  dir.create("images_h", showWarnings = FALSE)
#  
#  #EDAN query
#  orchids_query <- "orchid+smithsonian+gardens&fq=online_media_type:\"Images\""
#  
#  #Check for number of results
#  results <- EDANr::searchEDAN(query = orchids_query, AppID = AppID, AppKey = AppKey, rows = 1, start = 0)
#  results_count <- results$rowCount
#  
#  data <- data.frame(stringsAsFactors = FALSE, row.names = FALSE)
#  
#  steps <- floor(results_count/100)

## ---- eval=FALSE---------------------------------------------------------
#  #Loop over each step
#  for (i in seq(0, steps)){
#    #Query to get the next 100 results
#    results <- EDANr::searchEDAN(query = orchids_query, AppID = AppID, AppKey = AppKey, rows = 100, start = (i*100))
#  
#    #If there are results in this step
#    if (!is.null(dim(results$rows))){
#  
#      #Loop over each result in this step
#      for (j in seq(1, dim(results$rows)[1])){
#        #
#        #See code below
#        #
#      }
#    }
#  }

## ---- eval=FALSE---------------------------------------------------------
#  #Get images available from IDS
#  ids_images <- results$rows$content$descriptiveNonRepeating$online_media$media[j][[1]]
#  
#  #Filter images which were taken by the vendor
#  which_image <- ids_images[stringr::str_which(ids_images$caption, "Creekside Digital"),]
#  
#  #Get image of the whole plant, coded with '101' in the filename
#  which_image_whole <- which_image[stringr::str_which(ids_images$idsId, "101"),]
#  #Get close-up image of the flowers of the plant, coded with '102' in the filename
#  which_image_detail <- which_image[stringr::str_which(ids_images$idsId, "102"),]

## ---- eval=FALSE---------------------------------------------------------
#  #Get image URL
#  image <- which_image_detail$content[1]
#  
#  #Get image ID
#  idsID <- which_image_detail$idsId[1]
#  
#  localimage <- paste0("images/" ,idsID, ".jpg")
#              localimage_w <- paste0("images_w/" ,idsID, ".jpg")
#              localimage_h <- paste0("images_h/" ,idsID, ".jpg")
#              dlfile <- try(download.file(url = image, destfile = localimage, mode = "wb"), silent = TRUE)
#  
#  

## ---- eval=FALSE---------------------------------------------------------
#  common_name <- unlist(results$rows$content$indexedStructured$common_name[j])[[1]]
#                if (is.null(common_name)){
#                  common_name <- ""
#                }
#  
#  img <- image_read(localimage)
#  img_info <- image_info(img)
#  
#  #4k
#  if (img_info$width > img_info$height){
#    #Horizontal
#    img_scaled <- image_scale(img, "3840x2160")
#  }else{
#    #Vertical
#    img_scaled <- image_scale(img, "2160x3840")
#  }
#  
#  img_title <- results$rows$title[j]
#  
#  if (nchar(img_title) > 30){
#    img_title1 <- strsplit(img_title, " ")[[1]]
#    spl_no <- floor(length(img_title1)/2)
#  
#    img_title_1 <- paste(img_title1[1:spl_no], collapse = " ")
#    img_title_2 <- paste(img_title1[spl_no+1:(length(img_title1) - spl_no)], collapse = " ")
#    img_title <- paste0(img_title_1, "\n   ", img_title_2)
#  
#  }
#  
#  if (common_name != ""){
#    title <- paste0(common_name, "\n", img_title)
#  }else{
#    title <- img_title
#  }
#  
#  title <- paste0(title, "\nAccession Number: ", results$rows$content$freetext$identifier[j][[1]]$content, "\nSmithsonian Gardens")
#  
#  #4k
#  img_ready <- image_annotate(img_scaled, title, font = 'Arial', size = 60, color = "white", gravity = "SouthWest")
#  
#  if (img_info$width > img_info$height){
#    image_write(img_ready, path = localimage_w, format = "jpg")
#    file.remove(localimage)
#    localimage <- localimage_w
#  }else{
#    image_write(img_ready, path = localimage_h, format = "jpg")
#    file.remove(localimage)
#    localimage <- localimage_h
#  }

