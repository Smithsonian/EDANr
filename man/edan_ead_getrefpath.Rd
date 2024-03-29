% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/edan_ead_getrefpath.R
\name{edan_ead_getrefpath}
\alias{edan_ead_getrefpath}
\title{Get the reference path for an ID}
\usage{
edan_ead_getrefpath(
  refid = NA,
  url = NA,
  AppID = NA,
  AppKey = NA,
  returnjson = FALSE
)
}
\arguments{
\item{refid}{The refID. Default value: root}

\item{url}{The url. Default value: edanead-sova-aaa-thayabbo}

\item{AppID}{AppID used for authentication}

\item{AppKey}{Key for the AppID used for authentication}

\item{returnjson}{Boolean to return the answer as JSON, otherwise as a list.}
}
\value{
List or JSON with the results.
}
\description{
Returns the reference path for a given ID. This endpoint is not currently functional.
}
\details{
All queries require valid EDAN credentials (AppID and AppKey). Consult the EDAN Docs (https://edandoc.si.edu/) for instructions on how to obtain a set of credentials.
}
