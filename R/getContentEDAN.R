#' Get details of an item
#' 
#'Get the details of an item from the EDAN API.
#'
#'All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
#'
#' @return List or JSON with the details of the item.
#'
#' @param itemID ID of the item
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
getContentEDAN <- function(itemID, AppID, AppKey, returnjson = FALSE){
  
  API_url <- 'https://edan.si.edu/'

  #Date of request
  RequestDate <- as.character(Sys.time())

  #Generated uniquely for this request
  Nonce <- substr(stringr::str_replace_all(uuid::UUIDgenerate(FALSE), "-", ""), 0, 24)

  #Your request (example of format to enter query parameters)
  QueryParameters <- paste0("id=", itemID)

  #This will be the value of X-AuthContent, each element is joined by a single newline
  StringToSign <- paste(Nonce, QueryParameters, RequestDate, AppKey, sep = "\n")

  #First hash using SHA1
  HashedString <- digest::digest(StringToSign, algo="sha1", serialize=F)
  
  #Base64 encode
  EncodedString <- openssl::base64_encode(bin = HashedString)

  #API url
  url <- paste0(API_url, 'content/v2.0/content/getContent.htm?', QueryParameters)

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
    #results <- jsonlite::fromJSON(httr::content(r, "text"))
    if (returnjson){
      results <- jsonlite::prettify(httr::content(r, "text"))
    }else{
      results <- jsonlite::fromJSON(httr::content(r, "text"))
    }
  }
  
  return(results)
}
