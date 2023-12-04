#' Get the reference path for an ID
#' 
#' Returns the reference path for a given ID. This endpoint is not currently functional.
#'
#' All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
#'
#' @return List or JSON with the results.
#'
#' @param refid The refID. Default value: root
#' @param url The url. Default value: edanead-sova-aaa-thayabbo
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param returnjson Boolean to return the answer as JSON, otherwise as a list.
#'
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom httr content
#' @importFrom utils URLencode
#' 

edan_ead_getrefpath <- function(refid = NA, url = NA, AppID = NA, AppKey = NA, returnjson = FALSE){

  if (is.na(AppID) || AppID == ""){
    stop("Error: AppID can not be empty.")
  }
  
  if (is.na(AppKey) || AppKey == ""){
    stop("Error: AppKey can not be empty.")
  }
  
  #Your request (example of format to enter query parameters)
  QueryParameters <- "facet=true"

  if (!is.na(refid)){
      QueryParameters <- paste0(QueryParameters, "&refId=", refid)
  }
  
  if (!is.na(url)){
      QueryParameters <- paste0(QueryParameters, "&url=", url)
  }
  
  #API url
  api_url <- paste0('metadata/v2.0/ead/getRefPath.htm?', QueryParameters)

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
