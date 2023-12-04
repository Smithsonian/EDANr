#' Prepares the query to the EDAN API
#' 
#' @return Result of the GET request
#'
#' @param AppID AppID used for authentication
#' @param AppKey Key for the AppID used for authentication
#' @param QueryParameters query params
#' @param api_url URL of the route
#' @param rows Number of rows to return, max is 100.
#' @param start Start number, to use with rows
#'
#' @importFrom httr GET
#' @importFrom uuid UUIDgenerate
#' @importFrom stringr str_replace_all
#' @importFrom jsonlite fromJSON
#' @importFrom digest digest
#' @importFrom openssl base64_encode
#' @importFrom httr add_headers
#' @importFrom httr content

#' 
queryAPI <- function(AppID = NA, AppKey = NA, QueryParameters = NA, api_url = NA, rows = 10, start = 0){
  
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
  
  #Date of request
  RequestDate <- as.character(Sys.time())

  #Generated uniquely for this request
  Nonce <- substr(stringr::str_replace_all(uuid::UUIDgenerate(FALSE), "-", ""), 0, 24)

  #This will be the value of X-AuthContent, each element is joined by a single newline
  StringToSign <- paste(Nonce, QueryParameters, RequestDate, AppKey, sep = "\n")

  #First hash using SHA1
  HashedString <- digest::digest(StringToSign, algo="sha1", serialize=F)
  
  #Base64 encode
  EncodedString <- openssl::base64_encode(bin = HashedString)

  API_url <- 'https://edan.si.edu/'
  api_url_q <- paste0(API_url, api_url)
  
  api_answer <- httr::GET(url = api_url_q,
                 httr::add_headers("X-AppId" = AppID,
                             "X-Nonce"= Nonce,
                             "X-RequestDate"= RequestDate,
                             "X-AuthContent"= EncodedString)
  )
  
  return(api_answer)
}
