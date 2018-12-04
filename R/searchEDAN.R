#' Searches EDAN
#' 
#'Search metadata in the EDAN API. 
#'
#' @return List or JSON with the results.
#'
#' @param query Query to run
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param rows Number of rows to return, max is 100.
#' @param start Start number, to use with rows
#' @param returnjson If FALSE (default), converts the answer from EDAN to a list. If TRUE, returns the answer as json.
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
searchEDAN <- function(query, AppID, AppKey, rows = 10, start = 0, returnjson = FALSE){
  
  if (rows > 100){
    warning("The number of rows has been set to the maximum allowed of 100")
    rows <- 100
  }
  
  API_url <- 'https://edan.si.edu/'

  #Date of request
  RequestDate <- as.character(Sys.time())

  #Generated uniquely for this request
  Nonce <- substr(stringr::str_replace_all(uuid::UUIDgenerate(FALSE), "-", ""), 0, 24)

  #Your request (example of format to enter query parameters)
  QueryParameters <- paste0("q=", query, "&rows=", rows, "&start=", start, "&facet=true")

  #This will be the value of X-AuthContent, each element is joined by a single newline
  StringToSign <- paste(Nonce, QueryParameters, RequestDate, AppKey, sep = "\n")

  #First hash using SHA1
  HashedString <- digest::digest(StringToSign, algo="sha1", serialize=F)
  
  #Base64 encode
  EncodedString <- openssl::base64_encode(bin = HashedString)

  #API url
  url <- paste0(API_url, 'metadata/v2.0/collections/search.htm?', QueryParameters)

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
    if (returnjson){
      results <- jsonlite::prettify(httr::content(r, "text"))
    }else{
      results <- jsonlite::fromJSON(httr::content(r, "text"))
    }
  }
  
  return(results)
}
