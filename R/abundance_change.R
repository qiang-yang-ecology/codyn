#' @title Species Abundance Changes
#' 
#' @description Calculates the abundance change for species in a replicate
#'   between two time points. Changes are on abundance values provided, if
#'   relative data is used, then changes in relative abundance will be
#'   calculated.
#'   
#' @inheritParams RAC_change
#' 
#' @return The abundance_change function returns a data frame with a subset of
#'   the following columns:
#' \itemize{
#'  \item{replicate.var: }{A column with the specified replicate.var, if it is
#'  specified.}
#'  \item{time.var: }{A column with the specified time.var and a second column,
#'  with '2' appended to the name. Time is subtracted from time2}
#'  \item{species.var: }{A column with the specified species.var.}
#'  \item{change: }{A numeric column of the change in abundance between  time
#'  points. A positive value occurs when a species increases in abundance over
#'  time, and a negative value when a species decreases in abundance over time.}
#' }
#' @references Avolio et al. Submitted
#' @examples 
#' data(pplots)
#' # Without replicates
#' df <- subset(pplots, plot == 25)
#' abundance_change(df = df,
#'                  species.var = "species",
#'                  abundance.var = "relative_cover",
#'                  time.var = "year")
#'
#' # With replicates
#' df <- subset(pplots, year < 2004 & plot %in% c(6, 25, 32))
#' abundance_change(df = df,
#'                  species.var = "species",
#'                  abundance.var = "relative_cover",
#'                  replicate.var = "plot",
#'                  time.var = "year")
#'                  
#' # With reference year
#' df <- subset(pplots, year < 2005 & plot %in% c(6, 25, 32))
#' abundance_change(df = df,
#'                  species.var = "species",
#'                  abundance.var = "relative_cover",
#'                  replicate.var = "plot",
#'                  time.var = "year",
#'                  reference.time = 2002)
#' @export
abundance_change <- function(df,
                             time.var, 
                             species.var, 
                             abundance.var, 
                             replicate.var = NULL,
                             reference.time = NULL) {
  
  # validate function call and purge extraneous columns
  args <- as.list(match.call()[-1])
  df <- do.call(check_args, args, envir = parent.frame())
  
  # add zeros for species absent from a time period within a replicate
  by <- c(replicate.var)
  allsp <- split_apply_combine(df, by, FUN = fill_species, species.var, abundance.var)

  # merge subsets on time difference of one time step
  cross.var <- time.var
  cross.var2 <- paste(cross.var, 2, sep = '')
  split_by <- c(replicate.var)
  merge_to <- !(names(allsp) %in% split_by)
  if (is.null(reference.time)) {
    ranktog <- split_apply_combine(allsp, split_by, FUN = function(x) {
      y <- x[merge_to]
      cross <- merge(x, y, by = species.var, suffixes = c('', '2'))
      f <- factor(cross[[cross.var]])
      f2 <- factor(cross[[cross.var2]], levels = levels(f))
      idx <- (as.integer(f2) - as.integer(f)) == 1
      cross[idx, ]
    })
  } else {
    ranktog <- split_apply_combine(allsp, split_by, FUN = function(x) {
      y <- x[x[[time.var]] != reference.time, merge_to]
      x <- x[x[[time.var]] == reference.time, ]
      merge(x, y, by = species.var, suffixes = c('', '2'))
    })
  }
  
  # remove rows with NA for both abundances (preferably only when introduced
  # by fill_species)
  idx <- is.na(ranktog[[abundance.var]])
  abundance.var2 <- paste(abundance.var, 2, sep = '')
  idx2 <- is.na(ranktog[[abundance.var2]])
  ranktog[idx, abundance.var] <- 0
  ranktog[idx2, abundance.var2] <- 0
  idx <- ranktog[[abundance.var]] != 0 | ranktog[[abundance.var2]] != 0
  output <- ranktog[idx, ]

  # append change column
  output[['change']] <- output[[abundance.var2]] - output[[abundance.var]]
  output_order <- c(
    time.var, paste(time.var, '2', sep = ''),
    replicate.var,
    species.var,
    'change')
  
  return(output[intersect(output_order, names(output))])
}
