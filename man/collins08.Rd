% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codyn-package.R
\docType{data}
\name{collins08}
\alias{collins08}
\title{Konza data from Collins et al. 2008}
\format{
A data frame with 2058 rows and 4 variables
}
\source{
Collins, Scott L., Katharine N. Suding, Elsa E. Cleland, Michael Batty, Steven C. Pennings, Katherine L. Gross, James B. Grace, Laura Gough, Joe E. Fargione, and Christopher M. Clark. (2008) "Rank clocks and plant community dynamics." Ecology 89, no. 12: 3534-41.
}
\usage{
data(collins08)
}
\description{
A dataset of tallgrass prairie plant composition at one annually burned and one unburned
site over time at the Konza Prairie LTER, Manhattan Kansas (Collins et al. 2008).
}
\details{
A data frame containing a column for replicate, year, species and abundance:
\itemize{
  \item replicate: A factor column of spatial replicates with two levels ("annually burned" and "unburned")
  \item year: An integer column of sampling time points
  \item species: A factor column of species sampled
  \item abundance: A numeric column of abundance values
}
}
\keyword{datasets}
