#' @title Rank Abundance Curve Differences
#' 
#' @description Calculates differences between two samples for four comparable
#'   aspects of rank abundance curves (richness, evenness, rank, species
#'   composition). There are three ways differences can be calculated. 1)
#'   Between treatments within a block (note: block.var and treatment.var need
#'   to be specified). 2) Between treatments, pooling all replicates into a
#'   single species pool (note: pool = TRUE, treatment.var needs to be
#'   specified, and block.var will be NULL). 3) All pairwise combinations
#'   between all replicates (note: block.var = NULL, pool = FALSE and specifying
#'   treatment.var is optional. If treatment.var is specified, the treatment
#'   that each replicate belongs to will also be listed in the output).
#'   
#' @param df A data frame containing a species, abundance, and replicate columns
#'   and optional time, treatment, and block columns.
#' @param time.var The name of the optional time column.
#' @param species.var The name of the species column.
#' @param abundance.var The name of the abundance column.
#' @param replicate.var The name of the replicate column. Replicate identifiers
#'   must be unique within the dataset and cannot be nested within treatments or
#'   blocks.
#' @param treatment.var The name of the optional treatment column.
#' @param block.var The name of the optional block column.
#' @param pool An argument to allow abundance values to be pooled within a
#'   treatment. The default value is "FALSE", a value of "TRUE" averages
#'   abundance of each species within a treatment at a given time point.
#' @param reference.treatment The name of the optional treatment that all other
#'   treatments will be compared to (e.g. only controls will be compared to all
#'   other treatments). If not specified all pairwise treatment comparisons will
#'   be made.
#'   
#' @return The RAC_difference function returns a data frame with the following
#'   attributes:
#' \itemize{
#'  \item{time.var: }{A column that has the same name and type as the time.var
#'  column, if time.var is specified.}
#'  \item{block.var: }{A column that has same name and type as the block.var
#'  column, if block.var is specified.}
#'  \item{replicate.var: }{A column that has same name and type as the
#'  replicate.var column, represents the first replicate being compared. Note, a
#'  replicate column will be returned only when pool is FALSE or block.var =
#'  NULL.}
#'  \item{replicate.var2: }{A column that has the same type as the replicate.var
#'  column, and is named replicate.var with a 2 appended to it, represents the
#'  second replicate being compared. Note, a replicate.var column will be
#'  returned only when pool is FALSE and block.var = NULL.}
#'  \item{treatment.var: }{A column that has the same name and type as the
#'  treatment.var column, represents the first treatment being compared. A
#'  treatment.var column will be returned when pool is TRUE or block.var is
#'  present, or treatment.var is specified.}
#'  \item{treatment.var2: }{A column that has the same type as the treatment.var
#'  column, and is named treatment.var with a 2 appended to it, represents the
#'  second treatment being compared. A treatment.var column will be returned
#'  when pool is TRUE or block.var is present, or treatment.var is specified.}
#'  \item{richness_diff: }{A numeric column that is the difference between the
#'  compared samples (treatments or replicates) in species richness divided by
#'  the total number of unique species in both samples. A positive value occurs
#'  when there is greater species richness in replicate.var2 than replicate.var
#'  or treatment.var2 than treatment.var.}
#'  \item{evenness_diff: }{A numeric column of the difference between the
#'  compared samples (treatments or replicates) in evenness (measured by Evar).
#'  A positive value occurs when there is greater evenness in replicate.var2
#'  than replicate.var or treatment.var2 than treatment.var.}
#'  \item{rank_diff: }{A numeric column of the absolute value of average
#'  difference between the compared samples (treatments or replicates) in
#'  species' ranks divided by the total number of unique species in both
#'  samples.Species that are not present in both samples are given the S+1 rank
#'  in the sample it is absent in, where S is the number of species in that
#'  sample.}
#'  \item{species_diff: }{A numeric column of the number of species that are
#'  different between the compared samples (treatments or replicates) divided by
#'  the total number of species in both samples. This is equivalent to the
#'  Jaccard Index.}
#' }
#' @references Avolio et al. Submitted
#' @examples
#' data(pplots)
#' # With block and no time
#' df <- subset(pplots, year == 2002 & block < 3)
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                treatment.var = 'treatment',
#'                block.var = "block",
#'                replicate.var = "plot")
#'
#' # With blocks and time
#' df <- subset(pplots, year < 2004 & block < 3)
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                treatment.var = 'treatment',
#'                block.var = "block",
#'                replicate.var = "plot",
#'                time.var = "year")
#'
#' # With blocks, time and reference treatment
#' df <- subset(pplots, year < 2004 & block < 3)
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                treatment.var = 'treatment',
#'                block.var = "block",
#'                replicate.var = "plot",
#'                time.var = "year",
#'                reference.treatment = "N1P0")
#'
#' # Pooling by treatment with time
#' df <- subset(pplots, year < 2004)
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                treatment.var = 'treatment',
#'                pool = TRUE,
#'                replicate.var = "plot",
#'                time.var = "year")
#'
#' # All pairwise replicates with treatment
#' df <- subset(pplots, year < 2004 & plot %in% c(21, 25, 32))
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                replicate.var = "plot",
#'                time.var = "year",
#'                treatment.var = "treatment")
#'
#' # All pairwise replicates without treatment
#' df <- subset(pplots, year < 2004 & plot %in% c(21, 25, 32))
#' RAC_difference(df = df,
#'                species.var = "species",
#'                abundance.var = "relative_cover",
#'                replicate.var = "plot",
#'                time.var = "year")
#' @export
RAC_difference <- function(df,
                           time.var = NULL,
                           species.var,
                           abundance.var,
                           replicate.var,
                           treatment.var = NULL,
                           pool = FALSE,
                           block.var = NULL,
                           reference.treatment = NULL) {

  # validate function call and purge extraneous columns
  args <- as.list(match.call()[-1])
  df <- do.call(check_args, args, envir = parent.frame())

  if (pool) {
    # pool and rank species in each replicate
    rankdf <- pool_replicates(df, time.var, species.var, abundance.var,
      replicate.var, treatment.var)
  } else {
    # add NA for species absent from a replicate
    by <- c(block.var, time.var)
    allsp <- split_apply_combine(df, by, FUN = fill_species,
      species.var, abundance.var)

    # rank species in each replicate
    by <- c(block.var, time.var, treatment.var, replicate.var)
    rankdf <- split_apply_combine(allsp, by, FUN = add_ranks, abundance.var)
  }

  # specify which variable to use for comparison/"cross join"
  if (!is.null(block.var)) {
    cross.var <- treatment.var
  } else if (pool) {
    cross.var <- treatment.var
  } else {
    cross.var <- replicate.var
  }

  # order cross.var if unordered factor
  to_ordered = is.factor(rankdf[[cross.var]]) &
    !is.ordered(rankdf[[cross.var]]) &
    is.null(reference.treatment)
  if (to_ordered) {
    class(rankdf[[cross.var]]) <- c('ordered', class(rankdf[[cross.var]]))
  }

  # cross join for pairwise comparisons
  split_by <- c(block.var, time.var)
  merge_to <- !(names(rankdf) %in% split_by)
  cross.var2 <- paste(cross.var, 2, sep = '')
  if (is.null(reference.treatment)) {
    ranktog <- split_apply_combine(rankdf, split_by, FUN = function(x) {
      y <- x[merge_to]
      cross <- merge(x, y, by = species.var, suffixes = c('', '2'))
      idx <- cross[[cross.var]] < cross[[cross.var2]]
      cross[idx, ]
    })
  } else {
    ranktog <- split_apply_combine(rankdf, split_by, FUN = function(x) {
      y <- x[x[[treatment.var]] != reference.treatment, merge_to]
      x <- x[x[[treatment.var]] == reference.treatment, ]
      merge(x, y, by = species.var, suffixes = c('', '2'))
    })
  }
  # unorder cross.var if orginally unordered factor
  if (to_ordered) {
    x <- class(ranktog[[cross.var]])
    class(ranktog[[cross.var]]) <- x[x != 'ordered']
    class(ranktog[[cross.var2]]) <- x[x != 'ordered']
  }

  # remove rows with NA for both abundances (preferably only when introduced
  # by fill_species)
  idx <- is.na(ranktog[[abundance.var]])
  abundance.var2 <- paste(abundance.var, 2, sep = '')
  idx2 <- is.na(ranktog[[abundance.var2]])
  ranktog[idx, abundance.var] <- 0
  ranktog[idx2, abundance.var2] <- 0
  idx <- ranktog[[abundance.var]] != 0 | ranktog[[abundance.var2]] != 0
  ranktog <- ranktog[idx, ]

  # split on treatment pairs (and block if not null)
  split_by <- c(block.var, time.var, cross.var, cross.var2)
  output <- split_apply_combine(ranktog, split_by, FUN = SERSp,
    species.var, abundance.var, abundance.var2)

  if(any(is.na(output$evenness_diff)))
    warning(paste0("evenness_diff values contain NAs because there are plots",
                   " with only one species"))

  # order and select output columns
  output_order <- c(
    time.var,
    block.var,
    replicate.var, paste(replicate.var, 2, sep = ''),
    treatment.var, paste(treatment.var, 2, sep = ''),
    'richness_diff', 'evenness_diff', 'rank_diff', 'species_diff')

  return(output[intersect(output_order, names(output))])

}

############################################################################
#
# Private functions: these are internal functions not intended for reuse.
# Future package releases may change these without notice. External callers
# should not use them.
#
############################################################################

# A function to calculate RAC difference between two samples
# @param df a dataframe
# @param rank.var the name of the rank column at time 1
# @param rank.var2 the name of the rank column at time 2
# @param abundance.var the name of the abundance column at time 1
# @param abundance.var2 the name of the abundance column at time 2
SERSp <- function(df, species.var, abundance.var, abundance.var2) {

  out <- c(species.var, 'rank', 'rank2', abundance.var, abundance.var2)
  out <- unique(df[!(names(df) %in% out)])

  df <- subset(df, df[[abundance.var]] != 0 | df[[abundance.var2]] != 0)

  #ricness and evenness differences
  s_r1 <- S(df[[abundance.var]])
  e_r1 <- Evar(as.numeric(df[[abundance.var]]))
  s_r2 <- S(df[[abundance.var2]])
  e_r2 <- Evar(as.numeric(df[[abundance.var2]]))

  sdiff <- (s_r2-s_r1)/nrow(df)
  ediff <- e_r2-e_r1

  #Species diff beta -2 based on Carvalho (2012; 10.1111/j.1466-8238.2011.00694.x)
  idx <- df[[abundance.var]] != 0
  idx2 <- df[[abundance.var2]] != 0
  a <- sum(idx & idx2)
  b <- sum(idx & !idx2)
  c <- sum(!idx & idx2)
  spdiff <- 2*(min(b, c) / (a+b+c))

  #Mean Rank Difference
  rank_diff <- mean(abs(df[['rank']]-df[['rank2']])) / nrow(df)

  measures <- data.frame(richness_diff = sdiff, evenness_diff = ediff,
                         rank_diff = rank_diff, species_diff = spdiff)

  return(cbind(out, measures))
}
