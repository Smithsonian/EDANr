#' EAD Search
#' 
#' Returns structured data rows relating to ead type of content.
#'
#' All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
#'
#' @return List or JSON with the results.
#'
#' @param query The search term. Default value: *:*
#' @param fqs A JSON array of filter query params.
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param rows Number of rows to return, max is 100.
#' @param start Start number, to use with rows
#' @param returnjson Boolean to return the answer as JSON, otherwise as a list.
#'
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom httr content
#' @importFrom utils URLencode
#' 

edan_ead_search <- function(query = NA, fqs = NA, AppID = NA, AppKey = NA, rows = 10, start = 0, returnjson = FALSE){
  
  if (rows > 100){
    warning("The number of rows has been set to the maximum allowed of 100")
    rows <- 100
  }
  
  if (is.na(AppID) || AppID == ""){
    stop("Error: AppID can not be empty.")
  }
  
  if (is.na(AppKey) || AppKey == ""){
    stop("Error: AppKey can not be empty.")
  }
  
  #Your request (example of format to enter query parameters)
  QueryParameters <- paste0("rows=", rows, "&start=", start, "&facet=true")

  if (!is.na(query)){
      QueryParameters <- paste0(QueryParameters, "&q=", query)
  }
  
  if (!is.na(fqs)){
      QueryParameters <- paste0(QueryParameters, "&fqs=", fqs)
  }
  
  #API url
  api_url <- paste0('metadata/v2.0/ead/search.htm?', QueryParameters)

  r <- queryAPI(AppID = AppID, AppKey = AppKey, QueryParameters = QueryParameters, api_url = api_url, rows = rows, start = start)
    
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
