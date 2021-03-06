% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/searchEDAN.R
\name{searchEDAN}
\alias{searchEDAN}
\title{Searches EDAN}
\usage{
searchEDAN(query, AppID = NA, AppKey = NA,
  search_application = "collections", rows = 10, start = 0,
  returnjson = FALSE)
}
\arguments{
\item{query}{Query to run}

\item{AppID}{AppID used for authentication}

\item{AppKey}{Key for the AppID used for authentication}

\item{search_application}{Which Search Application to use, either "collections" or "metadata"}

\item{rows}{Number of rows to return, max is 100.}

\item{start}{Start number, to use with rows}

\item{returnjson}{Boolean to return the answer as JSON, otherwise as a list.}
}
\value{
List or JSON with the results.
}
\description{
Search metadata in the EDAN API.
}
\details{
All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
}
