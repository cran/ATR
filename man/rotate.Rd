\name{rotate}
\alias{rotate}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Change the class of a \code{party} object.
}
\description{
  Adds a new class to party objects allowing rotated tree visualisations.
}
\usage{
rotate(m, to = "left", ...)
}
\arguments{
  \item{m}{an object of class \code{party}}
  \item{to}{a character, only \code{left} is implemented at the moment.}
  \item{\dots}{additional arguments, currently ignored.}   
}
\details{
  Adds a new class allowing for improved tree printing.
}
\note{
  This package was written by the students participating in the
  Advanced R Programming course taught in spring semester 2017 at
  University of Zurich.
}
\examples{

  data("airquality", package = "datasets")
  m <- ctree(Wind ~ . , data = airquality)
  plot(rotate(m), main = "TREE", tnex = 1.5)

  if (require("trtf")) {
    data("Ozone", package = "mlbench")
    Ozone <- subset(Ozone, complete.cases(Ozone))
    Ozone <- as.data.frame(lapply(Ozone, function(x) {
        x <- x[, drop = TRUE]
        if (is.factor(x)) return(as.ordered(x))
        x
    }))
    response <- "V4"
    Ozone[[response]] <- as.numeric(Ozone[[response]])

    ns <- 20
    fm <- V4 ~ V1 + V2 + V3 + V5 + V6 + V7 + V8 + V9 + V10 + V11 + V12 + V13
    mtry <- ceiling(length(all.vars(fm[[3]])) / 3)
    var_m <- numeric_var("V4", support = quantile(Ozone[[response]], prob = c(.1, .9)), 
                     add = range(Ozone[[response]]) - 
                                 quantile(Ozone[[response]], prob = c(.1, .9)), 
                     bounds = c(0, Inf))

    B_m <- Bernstein_basis(var_m, order = 4, ui = "increasing")
    uc_ctm_Ozone <- ctm(B_m, data = Ozone, todistr = "Normal")

    tt_Ozone <- trafotree(uc_ctm_Ozone, formula = fm, data = Ozone, 
                control = ctree_control(mincriterion = .95, minsplit = 2*ns, 
                                        minbucket = ns))

    plot(rotate(tt_Ozone), tp_args = list(type = "density", id = FALSE, 
         ylines = 0, K = 100, fill = "lightgrey"), 
         terminal_panel = trtf:::node_mlt)
}
}
\keyword{tree}
