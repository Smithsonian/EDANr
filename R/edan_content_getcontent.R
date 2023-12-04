#' Get content
#' 
#' This endpoint retrieves unique atom level content. Either the id and url parameter is required but not both.
#'
#'All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
#'
#' @return List or JSON with the details of the item.
#'
#' @param url The url of the content
#' @param id The id of the content.
#' @param linkedContent A linked content option. Default value: TRUE
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param returnjson If FALSE (default), converts the answer from EDAN to a list. If TRUE, returns the answer as JSON.
#'
#'
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom httr content
#' @importFrom utils URLencode
#' 

edan_content_getcontent <- function(url = NA, id = NA, linkedContent = TRUE, AppID = NA, AppKey = NA, returnjson = FALSE){
    
    if (is.na(AppID) || AppID == ""){
        stop("Error: AppID can not be empty.")
    }
    
    if (is.na(AppKey) || AppKey == ""){
        stop("Error: AppKey can not be empty.")
    }
    
    if (is.na(url) && is.na(id)){
        stop("Error: this route requires either url or id.")
    }
    
    if (!is.na(url) && !is.na(id)){
        stop("Error: this route requires either url or id, not both.")
    }
    
    if (linkedContent == TRUE){
        QueryParameters <- paste0("linkedContent=true")
    }else{
        QueryParameters <- paste0("linkedContent=false")
    }
    
    if (!is.na(url)){
        QueryParameters <- paste0(QueryParameters, "&url=", url)
    }
    
    if (!is.na(id)){
        QueryParameters <- paste0(QueryParameters, "&id=", id)
    }
    
    #API url
    api_url <- paste0('metadata/v2.0/content/getContent.htm?', QueryParameters)
    
    r <- queryAPI(AppID = AppID, AppKey = AppKey, QueryParameters = QueryParameters, api_url = api_url)
    
    if (r$status_code == 401){
        cat("\n\n============\nRequest:\n============\n")
        print(r$request)
        cat("\n\n============\nHeaders:\n============\n")
        print(r$headers)
        results <- ""
    }else{
        if (returnjson){
            results <- jsonlite::prettify(httr::content(r, "text"))
        }else{
            results <- jsonlite::fromJSON(httr::content(r, "text"))
        }
    }
    
    return(results)
}
