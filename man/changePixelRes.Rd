% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/methods-changePixelRes.R
\name{changePixelRes}
\alias{changePixelRes}
\alias{changePixelRes,GInteractions,character-method}
\title{Change pixels from one resolution to another
selecting the new pixel using Hi-C data.}
\usage{
changePixelRes(
  x,
  files,
  from,
  to,
  aggFUN = sum,
  selectFUN = "which.max",
  nBlocks = 5,
  verbose = TRUE,
  norm = "KR",
  half = "upper",
  ...
)

\S4method{changePixelRes}{GInteractions,character}(
  x,
  files,
  from,
  to,
  aggFUN = sum,
  selectFUN = "which.max",
  nBlocks = 5,
  verbose = TRUE,
  norm = "KR",
  half = "upper",
  ...
)
}
\arguments{
\item{x}{GInteractions object.}

\item{files}{Character file paths to `.hic` files.}

\item{from}{Number (length one numeric vector) describing
the resolution of `x`. Data will be binned to this
value if it is not already binned.}

\item{to}{Number (length one numeric vector) describing
the new resolution for the pixels.}

\item{aggFUN}{Function to use for aggregating
across Hi-C files. Must be passable to
`which.max` or `which.min`. Default is "sum".}

\item{selectFUN}{Function to use for selecting
among aggregated interactions. Must be one of
"which.max" or "which.min".}

\item{nBlocks}{Number of blocks for block-processing
arrays. Default is 5. Increase this for large
datasets. To read and process all data at once, set
this value to 1.}

\item{verbose}{Boolean (TRUE or FALSE) describing
whether to report block-processing progress. Default
is TRUE.}

\item{norm}{String (length one character vector)
describing the Hi-C normalization to apply. Use
`strawr::readHicNormTypes()` to see accepted values
for each file in `files`.}

\item{half}{String (character vector of length one)
indicating whether to keep values for the upper
triangular (`half="upper"`) where `start1 < start2`,
lower triangular (`half="lower"`) where
`start1 > start2`, or both (`half="both"`, default).
When `half="upper"` all lower triangular values are `NA`.
When `half="lower"` all upper triangular values are `NA`.
When `half="both"` there are no `NA` values.
For interchromosomal interactions there is no inherent
directionality between chromosomes, so data is returned
regardless of specified order.}

\item{...}{Additional arguments passed to `pullHicMatrices()`.
See ?[`pullHicMatrices`].}
}
\value{
A GInteractions object with the updated
 pixel interactions, along with a column with the
 aggregated max/min value for that pixel.
}
\description{
A GInteractions object containing pixels of
interest is resized to the `from` resolution
(if its not already), then count matrices are
extracted for each interaction and Hi-C file
using the new `to` resolution. Count matrices
are aggregated by interactions with the
supplied `aggFUN`, and a new pixel is selected
with the supplied `selectFUN`. For large
datasets, increase `nBlocks` to allow for smaller
blocks of data to be processed in memory.
}
\examples{
## Read .hic file paths
hicFiles <-
    system.file("extdata/test_hic", package="mariner") |>
    list.files(pattern=".hic", full.names=TRUE)

## Read in loops as GInteractions object
loops <-
    system.file("extdata", package="mariner") |>
    list.files(pattern="WT.*Loops.txt", full.names=TRUE) |>
    read.table(header=TRUE) |>
    as_ginteractions(keep.extra.columns=FALSE)

## Removes the "chr" prefix for compatibility
## with the preprocessed hic files
GenomeInfoDb::seqlevelsStyle(loops) <- 'ENSEMBL'

## Rebin loops to 2.5e6 resolution
loops <- binPairs(x=loops, binSize=2.5e06)

## Change pixel resolution from 2.5e6 to 500e3
changePixelRes(x=loops[1:5],
               files=hicFiles,
               from=2.5e6,
               to=500e3)

}
