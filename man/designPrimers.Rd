% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/primer3_io.R
\name{designPrimers}
\alias{designPrimers}
\alias{designPrimers,TsIO-method}
\alias{designPrimers,TsIOList-method}
\title{Design primers}
\usage{
designPrimers(
  object,
  thermo_params_path = NA,
  primer3_core = getOption("TAPseq.primer3_core")
)

\S4method{designPrimers}{TsIO}(
  object,
  thermo_params_path = NA,
  primer3_core = getOption("TAPseq.primer3_core")
)

\S4method{designPrimers}{TsIOList}(
  object,
  thermo_params_path = NA,
  primer3_core = getOption("TAPseq.primer3_core")
)
}
\arguments{
\item{object}{\code{\link[TAPseq:TsIO-class]{TsIO}} or
\code{\link[TAPseq:TsIOList-class]{TsIOList}} object for which primers should be designed.}

\item{thermo_params_path}{Optional path (character) to the \code{primer3_config} directory. Only
required when using Primer3 < 2.5.0.}

\item{primer3_core}{Path (character) to the \code{primer3_core} executable. Usually this is
inferred when loading/attaching the package.}
}
\value{
A new \code{\link[TAPseq:TsIO-class]{TsIO}} or
  \code{\link[TAPseq:TsIOList-class]{TsIOList}} object containing Primer3 output.
}
\description{
Design primers based on \code{\link[TAPseq:TsIO-class]{TsIO}} or
\code{\link[TAPseq:TsIOList-class]{TsIOList}} objects. Creates boulder-IO records, passes input
to Primer3 and parses the output.
}
\section{Methods (by class)}{
\itemize{
\item \code{designPrimers(TsIO)}: Design primers using Primer3 from a \code{TsIO} object

\item \code{designPrimers(TsIOList)}: Design primers using Primer3 from a \code{TsIOList} object

}}
\examples{
# chromosome 11 truncated transcript sequences and annotations
data("chr11_truncated_txs_seq")

# create TsIOList object for the first two sequence templates
tapseq_io <- TAPseqInput(chr11_truncated_txs_seq[1:2], product_size_range = c(350, 500))

# design primers
\dontrun{
tapseq_io <- designPrimers(tapseq_io)
}

# designed primers are stored in the tapseq_primers slot
tapseq_primers(tapseq_io)
}
\seealso{
\url{http://primer3.org/manual.html} for Primer3 manual and
  \link[TAPseq:TsIO-class]{TsIO} for TsIO class objects.
}
