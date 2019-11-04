#' Retrieve object lists from EDAN using the EDAN API.
#' 
#'All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
#'Same library requirements as getContentEDAN function.
#'library("devtools", lib.loc="~/R/R-3.5.1/library")
# library("digest", lib.loc="~/R/R-3.5.1/library")
# library("EDANr")
# library("httr", lib.loc="~/R/R-3.5.1/library")
# library("jsonlite", lib.loc="~/R/R-3.5.1/library")
# library("stringr", lib.loc="~/R/R-3.5.1/library")
# library("uuid", lib.loc="~/R/R-3.5.1/library")

# Most of the code duplicates the great work done by Luis Villanueva in the getContentEdan function, main changes decribed below.

#listID references the string which most commonly can be found attached to object groups. IE https://americanhistory.si.edu/collections/object-groups/tokuno-gift has the object list with the id "p2a-1502402857224-1502899539095-0".

#Default query parameter includes objectGroupId, other parameters can be see in the docs at https://edandoc.si.edu/apidocs/#api-metadata-getObjectLists
#'
#' @param listID The string which most commonly can be found attached to object groups. IE https://americanhistory.si.edu/collections/object-groups/tokuno-gift has the object list with the id "p2a-1502402857224-1502899539095-0".
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param returnjson If FALSE (default), converts the answer from EDAN to a list. If TRUE, returns the answer as JSON.
#'
#'
#' @export
#' @importFrom httr GET
#' @importFrom uuid UUIDgenerate
#' @importFrom stringr str_replace_all
#' @importFrom jsonlite fromJSON
#' @importFrom digest digest
#' @importFrom openssl base64_encode
#' @importFrom httr add_headers
#' @importFrom httr content
#' 
getObjectList <- function(listID, AppID, AppKey, returnjson = FALSE){
  
  API_url <- 'https://edan.si.edu/'
  
  #Date of request
  RequestDate <- as.character(Sys.time())
  
  #Generated uniquely for this request
  Nonce <- substr(stringr::str_replace_all(uuid::UUIDgenerate(FALSE), "-", ""), 0, 24)
  
  #Your request (example of format to enter query parameters)
  QueryParameters <- paste0("objectGroupId=", listID)
  
  #This will be the value of X-AuthContent, each element is joined by a single newline
  StringToSign <- paste(Nonce, QueryParameters, RequestDate, AppKey, sep = "\n")
  
  #First hash using SHA1
  HashedString <- digest::digest(StringToSign, algo="sha1", serialize=F)
  
  #Base64 encode
  EncodedString <- openssl::base64_encode(bin = HashedString)
  
  #API url
  url <- paste0(API_url, 'metadata/v2.0/metadata/getObjectLists.htm?', QueryParameters)
  
  r <- httr::GET(url = url,
                 httr::add_headers("X-AppId" = AppID,
                                   "X-Nonce"= Nonce,
                                   "X-RequestDate"= RequestDate,
                                   "X-AuthContent"= EncodedString)
  )
  
  
  if (r$status_code == 401){
    cat("\n\n============\nRequest:\n============\n")
    print(r$request)
    cat("\n\n============\nHeaders:\n============\n")
    print(r$headers)
    results <- ""
  }else{
    results <- jsonlite::fromJSON(httr::content(r, "text"))
    if (returnjson){
      results <- jsonlite::prettify(httr::content(r, "text"))
    }else{
      results <- jsonlite::fromJSON(httr::content(r, "text"))
    }
  }
  
  return(results)
}

