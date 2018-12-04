# EDANr

A package to query Smithsonian's Enterprise Digital Asset Network (EDAN) from R.

All queries require valid EDAN credentials (AppID and AppKey). Consult the [EDAN Docs](https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.

To install from Github:

```R
#Install devtools, if needed
install.packages("devtools")

#Install package from Github
library(devtools)
install_github("Smithsonian/EDANr")
```

EDANr requires the packages httr, uuid, stringr, jsonlite, digest, and openssl. These should be installed automatically when using `install_github("Smithsonian/EDANr")`. To install these manually:

```R
install.packages(c("httr", "uuid", "stringr", "jsonlite", "digest", "openssl"))
```

Feel free to make request or suggestions by [opening an issue](https://github.com/Smithsonian/EDANr/issues). 
