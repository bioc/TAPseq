#' Pick best TASC-seq primers
#'
#' Pick based primers from designed primers for every target based on Primer3 penalty score or
#' off-target priming estimated with \code{\link[TASCseq]{blastPrimers}}.
#'
#' If \code{by} is set to \code{off_targets} top primers are picked based on the lowest number of
#' exonic, intronic and intergenic off-targets (in that priority).
#'
#' @param object A \code{\link[TASCseq]{TsIO}} or \code{\link[TASCseq]{TsIOList}} object containing
#'   designed primers.
#' @param n The number of top primers to pick (default: 1, which returns the best primer).
#' @param by Attribute by which primers should be picked. Can be either \code{penalty} or
#'  \code{off_targets}.
#' @return A \code{TsIO} or \code{TsIOList} object containing the picked primers.
#' @export
setGeneric("pickPrimers",
           function(object, n = 1, by = c("penalty", "off_targets"))
             standardGeneric("pickPrimers")
)

#' @describeIn pickPrimers Pick best primers in a \code{TsIO} object
#' @export
setMethod("pickPrimers", "TsIO", function(object, n, by) {

  # match by argument
  by <- match.arg(by)

  # get all primers and their pcr products
  primers <- tascseq_primers(object)
  pcr_prods <- pcr_products(object)

  if (length(primers) > 0) {

    # extract primer metadata, which contains features to pick primers
    primer_meta <- mcols(primers)

    # order primers based to penalty or number of off targets
    if (by == "penalty") {
      order <- order(primer_meta$penalty)
    }else{
      order <- order(primer_meta$exonic_off_targets, primer_meta$intronic_off_targets,
                     primer_meta$intergenic_off_targets, primer_meta$penalty)
    }

    # pick top n primers
    picked_primers <- primers[order[1:n]]

    # get pcr products for these primers (based on primer id for the unlikely case that pcr products
    # were reordered for some reason...)
    picked_pcr_prods <- pcr_prods[names(picked_primers)]

    # replace primersand pcr products in object by picked primers and return object
    tascseq_primers(object) <- picked_primers
    pcr_products(object) <- picked_pcr_prods
    return(object)

  }else{
    warning("No primers found in TsIO object!", call. = FALSE)
    return(object)
  }

})

#' @describeIn pickPrimers Pick best primers per target in a \code{TsIOList} object
#' @export
setMethod("pickPrimers", "TsIOList", function(object, n, by) {

  # pick best primers for every TsIO object
  endoapply(object, FUN = pickPrimers, n = n, by = by)

})