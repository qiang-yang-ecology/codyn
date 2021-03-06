#' Community Dynamics Metrics
#' @description Univariate and multivariate temporal and spatial diversity indices, rank abundance curves, and community stability metrics for ecologists.
#' @details The functions in \code{codyn} implement metrics that are either explicitly temporal and include the option to  calculate them over multiple replicates, or spatial and include the option to calculate them over multiple time points.
#' Functions fall into five categories: static diversity indices, temporal diversity indices, spatial diversity indices, rank abundance curves, and community stability metrics.
#' The diversity indices in \code{codyn} are temporal and spatial analogs to traditional diversity indices.
#' Specifically, \code{codyn} includes functions to calculate community richness, evenness and diversity at a given point in space and time. In addition, \code{codyn} contains functions to calculate species turnover, mean rank shifts, and lags in community similarity between two time points. For the components of rank abundance curves, the shape of the rank abundance curve, species abundances and multivariate metrics of community composition, \code{codyn} contains functions to calculate these metrics either between time points or a single time point between two paired replicates.
#' The community stability metrics in \code{codyn} calculate overall stability and patterns of species covariance and synchrony over time.
#' Finally, \code{codyn} contains vignettes that describe methods and reproduce figures from published papers to help users contextualize and apply functions to their own data.
#' Work on this package was supported by National Science Foundation grant #1262458 to the National Center for Ecological Analysis and Synthesis (NCEAS), the University of Wisconsin, and the University of New Mexico, and a SESYNC Synthesis Postdoctoral Fellowship to MLA. 
#'
#' @author
#' \itemize{
#'  \item{Lauren Hallett \email{lauren.m.hallett@@gmail.com}}
#'  \item{Meghan L. Avolio \email{meghan.avolio@jhu.edu}}
#'  \item{Ian T. Carroll \email{icarroll@sesync.org}}
#'  \item{Sydney K. Jones \email{syd@@sevilleta.unm.edu}}
#'  \item{A. Andrew A. MacDonald \email{aammacdonald@@gmail.com}}
#'  \item{Dan F. B. Flynn \email{flynn@@fas.harvard.edu}}
#'  \item{Peter Slaughter \email{slaughter@@nceas.ucsb.edu}}
#'  \item{Julie Ripplinger \email{julie.ripplinger@@asu.edu}}
#'  \item{Scott L. Collins \email{scollins@@sevilleta.unm.edu}}
#'  \item{Corinna Gries \email{cgries@@wisc.edu}}
#'  \item{Matthew B. Jones \email{jones@@nceas.ucsb.edu}}
#' }
#'
#' @docType package
#' @name codyn-package
#' @section Functions:
#' \itemize{
#'  \item{\code{\link[=turnover]{turnover}}}{: Calculates species turnover between time periods}
#'  \item{\code{\link[=rank_shift]{rank_shift}}}{: Calculates the mean relative change in species rank abundances}
#'  \item{\code{\link[=rate_change]{rate_change}}}{: Calculates the rate change in a community over time}
#'  \item{\code{\link[=rate_change_interval]{rate_change_interval}}}{: Produces a data frame containing differences in species composition between samples at increasing time intervals}
#'  \item{\code{\link[=community_stability]{community_stability}}}{: Calculates community stability over time}
#'  \item{\code{\link[=variance_ratio]{variance_ratio}}}{: Computes the ratio of the variance of aggregate species abundances in a community }
#'  \item{\code{\link[=synchrony]{synchrony}}}{: Calculates the degree synchrony in species abundances}
#'  \item{\code{\link[=cyclic_shift]{temporal_torus_translation}}}{: Calculates a test statistic on a null ecological community created via cyclic shifts. \code{confint} provides mean and confidence intervals of this null distribution}
#'  \item{\code{\link[=community_structure]{community_structure}}}{: Calculates richness and evenness (using specified metric) for a replicate}
#'  \item{\code{\link[=community_diversity]{community_diversity}}}{: Calculates diversity (using specified metric) for a replicate}
#'  \item{\code{\link[=RAC_change]{RAC_change}}}{:Calculates changes in species richness, evenness, species' ranks, gain, and losses for a replicate over time}
#'  \item{\code{\link[=abundance_change]{abundance_change}}}{: For each species in a replicate, calculates changes in abundance over time}
#'  \item{\code{\link[=curve_change]{curve_change}}}{: Calculates changes in the shape of the RAC curve for each replicate over time}
#'  \item{\code{\link[=multivariate_change]{multivariate_change}}}{: Calculates changes in community composition and dispersion over time}
#'  \item{\code{\link[=RAC_difference]{RAC_difference}}}{: Calculates differences in species richness, evenness, species' ranks, shared species between paired samples at a single point in time}
#'  \item{\code{\link[=abundance_difference]{abundance_difference}}}{: Calculates differences in abundance for each species in paired samples at a single point in time}
#'  \item{\code{\link[=curve_difference]{curve_difference}}}{: Calculates differences in the shape of the RAC between paired samples at a single point in time}
#'  \item{\code{\link[=multivariate_difference]{multivariate_difference}}}{: Calculates differences in community composition and dispersion of all replicates between treatments at a single point in time}
#' }
NULL

#' Konza data from Collins et al. 2008
#'
#' A dataset of tallgrass prairie plant composition at one annually burned and one unburned
#' site over time at the Konza Prairie LTER, Manhattan Kansas (Collins et al. 2008).
#'
#' A data frame containing a column for replicate, year, species and abundance:
#' \itemize{
#'   \item replicate: A factor column of spatial replicates with two levels ("annually burned" and "unburned")
#'   \item year: An integer column of sampling time points
#'   \item species: A factor column of species sampled
#'   \item abundance: A numeric column of abundance values
#' }
#'
#' @source
#' Collins, Scott L., Katharine N. Suding, Elsa E. Cleland, Michael Batty, Steven C. Pennings, Katherine L. Gross, James B. Grace, Laura Gough, Joe E. Fargione, and Christopher M. Clark. (2008) "Rank clocks and plant community dynamics." Ecology 89, no. 12: 3534-41.
#' @docType data
#' @keywords datasets
#' @name collins08
#' @usage data(collins08)
#' @format A data frame with 2058 rows and 4 variables
NULL

#' Data from Konza Prairie, watershed 001d
#'
#' Plant composition within multiple replicates at an annually burned tallgrass
#' prairie site in the Konza Prairie LTER, Manhattan KS (Watershed 001d).
#'
#' A data frame containing a column for species, year, subplot and abundance:
#' \itemize{
#'   \item species: A factor column of species sampled
#'   \item year: An integer column of sampling time points
#'   \item subplot: A factor column of spatial replicates with 20 levels
#'   \item abundance: A numeric column of abundance values
#' }
#'
#' @source
#' Konza Prairie LTER Dataset ID: PVC02, watershed 1D
#'
#' Collins, S. L. (2000) Disturbance frequency and community stability in native tallgrass prairie. American Naturalist 155:311-325.
#' @docType data
#' @keywords datasets
#' @name knz_001d
#' @usage data(knz_001d)
#' @format A data frame with 8768 rows and 4 variables
NULL

#' Phosphorus plots data from Avolio et al. 2014
#' 
#' A dataset of tallgrass prairie plant composition in a nitrogen and phosphorus addition experiment at Konza Prairie, Manhattan Kansas (Avolio et al. 2014). This dataset is a subset of the full dataset.
#'
#' A data frame containing a column for replicate, year, species, abundance, block and treatment :
#' \itemize{
#'   \item plot: An integer column of spatial replicates with 18 levels (6-48)
#'   \item year: An integer column of sampling time points
#'   \item species: A factor column of species sampled
#'   \item relative_cover: A numeric column of relative cover values
#'   \item block: An integer column of dummy blocking variable, grouping treatment plots into blocks
#'   \item treatment: A factor column of nitrogen and phosphorus treatments applied to the plots
#' }
#'
#' @source
#' Avolio, ML, Koerner, S, La Pierre, K, Wilcox, K, Wilson, GTW, Smith, MD, Collins, S. 2014. Changes in plant community composition, not diversity, to a decade of nitrogen and phosphorus additions drive changes in aboveground productivity in a tallgrass prairie. Journal of Ecology. 102: 1649-1660.  
#' @docType data
#' @keywords datasets
#' @name pplots
#' @usage data(pplots)
#' @format A data frame with 1232 rows and 6 variables
NULL
