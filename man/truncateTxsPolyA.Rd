% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/truncate_txs_polyA_sites.R
\name{truncateTxsPolyA}
\alias{truncateTxsPolyA}
\alias{truncateTxsPolyA,GRanges-method}
\alias{truncateTxsPolyA,GRangesList-method}
\title{Truncate transcripts at polyA sites}
\usage{
truncateTxsPolyA(
  transcripts,
  polyA_sites,
  extend_3prime_end = 0,
  polyA_select = c("downstream", "upstream", "score"),
  transcript_id = "transcript_id",
  gene_id = "gene_id",
  exon_number = "exon_number",
  ignore_strand = FALSE,
  parallel = FALSE
)

\S4method{truncateTxsPolyA}{GRanges}(
  transcripts,
  polyA_sites,
  extend_3prime_end = 0,
  polyA_select = c("downstream", "upstream", "score"),
  transcript_id = "transcript_id",
  gene_id = "gene_id",
  exon_number = "exon_number",
  ignore_strand = FALSE,
  parallel = FALSE
)

\S4method{truncateTxsPolyA}{GRangesList}(
  transcripts,
  polyA_sites,
  extend_3prime_end = 0,
  polyA_select = c("downstream", "upstream", "score"),
  transcript_id = "transcript_id",
  gene_id = "gene_id",
  exon_number = "exon_number",
  ignore_strand = FALSE,
  parallel = FALSE
)
}
\arguments{
\item{transcripts}{A \code{\link[GenomicRanges:GRanges-class]{GRanges}} or
\code{\link[GenomicRanges:GRangesList-class]{GRangesList}} object containing  exons of the
transcripts to be truncated. Transcripts for multiple genes can be provided as \code{GRanges}
objects within a \code{GRangesList}.}

\item{polyA_sites}{A \code{\link[GenomicRanges:GRanges-class]{GRanges}} object containing the
polyA sites. This needs to contain a metadata entry names "score" if the option
\code{polyA_select = "score"} is used. PolyA sites can be either obtained via running
\code{\link[TAPseq]{inferPolyASites}} or imported from an existing .bed file
(\code{\link[rtracklayer]{BEDFile}}).}

\item{extend_3prime_end}{Specifies how far (bp) 3' ends of transcripts should be extended when
looking for overlapping polyA sites (default = 0). This enables capturing of polyA sites that
occur downstream of annotated 3' ends.}

\item{polyA_select}{Specifies which heuristic should be used to select the polyA site used to
truncate the transcripts if multiple overlapping polyA sites are found. By default
\code{"downstream"} is used which chooses the most downstream polyA site. \code{"score"}
selects the polyA site with the highest score, which corresponds to the read coverage when
using \code{\link[TAPseq]{inferPolyASites}} to estimate polyA sites.}

\item{transcript_id}{(character) Name of the column in the metadata of \code{transcripts}
providing transcript id for each exon (default: \code{"transcript_id"}). Set to \code{NULL} to
ignore transcript ids and assume that all exons per gene belong to the same transcript.}

\item{gene_id, exon_number}{(character) Optional names of columns in metadata of
\code{transcripts} containing gene id and exon number. These are only used to create new
metadata when merging multiple transcripts into a meta transcript.}

\item{ignore_strand}{(logical) Specifies whether the strand of polyA sites should be ignored when
looking for overlapping polyA sites. Default is \code{FALSE} and therefore only polyA sites on
the same strand as the transcripts are considered. PolyA sites with strand \code{*} has the
same effect as \code{ignore_strand = TRUE}.}

\item{parallel}{(logical) Triggers parallel computing using the \code{BiocParallel} package.
This requires that a parallel back-end was registered prior to executing the function.
(default: \code{FALSE}).}
}
\value{
Either a \code{\link[GenomicRanges:GRanges-class]{GRanges}} or
  \code{\link[GenomicRanges:GRangesList-class]{GRangesList}} object containing the truncated
  transcripts.
}
\description{
Truncate transcripts at overlapping polyadenylation (polyA) sites to infer  likely 3' ends of
transcripts. This is crucial to correctly design TAP-seq primers that amplify fragments of
specific lengths. Typically the exons of all annotated transcripts per target gene are provided
as input. If a polyA site overlaps a single transcript of a given gene, this transcript is
truncated and returned. In case a polyA site overlaps multiple transcripts of the same gene, a
"metatranscript" consisting of all annotated exons of the overlapping transcripts is generated
and truncated. No statements about expressed transcripts can be made if no overlapping polyA
sites are found for any transcripts of a gene. In that case a "meta transcript" consisting of
the merged exons of that gene is generated and returned.
}
\section{Methods (by class)}{
\itemize{
\item \code{truncateTxsPolyA(GRanges)}: Truncate transcripts of one gene provided as \code{GRanges} object

\item \code{truncateTxsPolyA(GRangesList)}: Truncate transcripts of multiple genes provided as
\code{GRangesList}

}}
\examples{
library(GenomicRanges)

# protein-coding exons of genes within chr11 region
data("chr11_genes")
target_genes <- split(chr11_genes, f = chr11_genes$gene_name)

# only retain first 2 target genes, because truncating transcripts is currently computationally
# quite costly. try using BiocParallel for parallelization (see ?truncateTxsPolyA).
target_genes <- target_genes[1:2]

# example polyA sites for these genes
data("chr11_polyA_sites")

# truncate target genes at most downstream polyA site (default)
truncated_txs <- truncateTxsPolyA(target_genes, polyA_sites = chr11_polyA_sites)

# change polyA selection to "score" (read coverage of polyA sites) and extend 3' end of target
# genes by 50 bp (see ?truncateTxsPolyA).
truncated_txs <- truncateTxsPolyA(target_genes, polyA_sites = chr11_polyA_sites,
                                  polyA_select = "score", extend_3prime_end = 50)
}
