\name{showSmooth}
\alias{showSmooth}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
showSmooth(x, leg.x = 1, leg.y = max(x))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{leg.x}{
%%     ~~Describe \code{leg.x} here~~
}
  \item{leg.y}{
%%     ~~Describe \code{leg.y} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x, leg.x = 1, leg.y = max(x)) 
{
    ss <- cbind(x, `3c` = smooth(x, "3", end = "copy"), `3` = smooth(x, 
        "3"), `3Rc` = smooth(x, "3R", end = "copy"), `3R` = smooth(x, 
        "3R"), sm = smooth(x))
    k <- ncol(ss) - 1
    n <- length(x)
    slwd <- c(1, 1, 4, 1, 3, 2)
    slty <- c(0, 2:(k + 1))
    matplot(ss, main = "Tukey Smoothers", ylab = "y ;  sm(y)", 
        type = c("p", rep("l", k)), pch = par("pch"), lwd = slwd, 
        lty = slty)
    legend(leg.x, leg.y, c("Data", "3   (copy)", "3  (Tukey)", 
        "3R  (copy)", "3R (Tukey)", "smooth()"), pch = c(par("pch"), 
        rep(-1, k)), col = 1:(k + 1), lwd = slwd, lty = slty)
    ss
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
