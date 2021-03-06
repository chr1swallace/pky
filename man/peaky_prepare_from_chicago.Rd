% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/peaky.R
\name{peaky_prepare_from_chicago}
\alias{peaky_prepare_from_chicago}
\title{Wrapper that prepares CHiCAGO output for Peaky analysis}
\usage{
peaky_prepare_from_chicago(
  chicago_rds_path,
  peaky_output_dir,
  chicago_max_dist = 1e+06,
  chicago_bait_subset = NA,
  subsample_size = 10000
)
}
\arguments{
\item{chicago_rds_path}{Path to the .rds file produced by CHiCAGO.}

\item{peaky_output_dir}{Directory to store Peaky's intermediate files and results in. Will be created if it doesn't exist.}

\item{chicago_max_dist}{Maximum distance putative interactions may span if they are to be extracted and analyzed.}

\item{chicago_bait_subset}{Path to a file specifying baitIDs to extract from the CHiCAGO object. This file just needs one column name: baitID. By default, all bais will be extracted.}

\item{subsample_size}{Number of putative interactions to build a null model from that relates CHiCAGO scores to count data. Used for all distance bins. See also \code{\link{model_bin_fs}}.}
}
\value{
List containing the output directory where baits are stored and their individual paths.
}
\description{
Reads a CHiCAGO .rds object (example at https://osf.io/eaqz6/) and prepares it for post-hoc analysis with Peaky.
This setup fine-maps chromatin interactions based on CHiCAGO scores, instead of based on the adjusted readcounts that Peaky's own model (see \code{\link{interpret_peaky_fs}} for a full pipeline) would generate from raw Capture Hi-C or Capture-C counts. 
The next step of this pipeline is to process the generated files with \code{\link{peaky_run}}.
}
\section{Details}{

This function exports CHiCAGO-made bins (analogous to \code{\link{bin_interactions_fs}} in Peaky's standard pipeline), uses a modified version of \code{\link{model_bin_fs}} where only CHiCAGO scores are used, and ultimately calls \code{\link{split_baits_fs}}.
}

\examples{
base = system.file("extdata",package="peaky")
chicago_rds_path = paste0(base,"/chicago_output.rds")
peaky_output_dir = paste0(base,"/peaky_from_chicago")
\donttest{
peaky_prepare_from_chicago(chicago_rds_path, peaky_output_dir, subsample_size=NA) 
#Big dataset? Consider subsample_size=10e3 for speed.

for(i in 1:3){ peaky_run(peaky_output_dir,i) }
#Tip: run this in parallel on a cluster by scheduling an array job and passing its elements to i.

peaky_wrapup(peaky_output_dir)
}
}
