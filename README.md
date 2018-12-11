# EDANr

A package to query Smithsonian's Enterprise Digital Asset Network (EDAN) API from R. Currently, the package allows to query metadata and obtain details of a single item using the item ID. 

All queries require valid EDAN credentials (AppID and AppKey). Consult the [EDAN Docs](https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.

To install from Github:

```R
#Install devtools, if needed
install.packages("devtools")

#Install package from Github, with vignettes
library(devtools)
install_github("Smithsonian/EDANr", build_vignettes = TRUE)
```

EDANr requires the packages httr, uuid, stringr, jsonlite, digest, and openssl. These should be installed automatically when using `install_github("Smithsonian/EDANr")`. To install these manually:

```R
install.packages(c("httr", "uuid", "stringr", "jsonlite", "digest", "openssl"))
```

Check the [wiki](https://github.com/Smithsonian/EDANr/wiki) for some examples. 

Feel free to make request or suggestions by [opening an issue](https://github.com/Smithsonian/EDANr/issues). 
