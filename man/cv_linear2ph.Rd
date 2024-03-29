% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cv_linear2ph.R
\name{cv_linear2ph}
\alias{cv_linear2ph}
\title{Performs cross-validation to calculate the average predicted log likelihood for the \code{linear2ph} function. This function can be used to select the B-spline basis that yields the largest average predicted log likelihood.}
\usage{
cv_linear2ph(
  Y_unval = NULL,
  Y = NULL,
  X_unval = NULL,
  X = NULL,
  Z = NULL,
  Bspline = NULL,
  data = NULL,
  nfolds = 5,
  MAX_ITER = 2000,
  TOL = 1e-04,
  verbose = FALSE
)
}
\arguments{
\item{Y_unval}{Specifies the column of the error-prone outcome that is continuous. Subjects with missing values of \code{Y_unval} are omitted from the analysis. This argument is required.}

\item{Y}{Specifies the column that stores the validated value of \code{Y_unval} in the second phase. Subjects with missing values of \code{Y} are considered as those not selected in the second phase. This argument is required.}

\item{X_unval}{Specifies the columns of the error-prone covariates. Subjects with missing values of \code{X_unval} are omitted from the analysis. This argument is required.}

\item{X}{Specifies the columns that store the validated values of \code{X_unval} in the second phase. Subjects with missing values of \code{X} are considered as those not selected in the second phase. This argument is required.}

\item{Z}{Specifies the columns of the accurately measured covariates. Subjects with missing values of \code{Z} are omitted from the analysis. This argument is optional.}

\item{Bspline}{Specifies the columns of the B-spline basis. Subjects with missing values of \code{Bspline} are omitted from the analysis. This argument is required.}

\item{data}{Specifies the name of the dataset. This argument is required.}

\item{nfolds}{Specifies the number of cross-validation folds. The default value is \code{5}. Although \code{nfolds} can be as large as the sample size (leave-one-out cross-validation), it is not recommended for large datasets. The smallest value allowable is \code{3}.}

\item{MAX_ITER}{Specifies the maximum number of iterations in the EM algorithm. The default number is \code{2000}. This argument is optional.}

\item{TOL}{Specifies the convergence criterion in the EM algorithm. The default value is \code{1E-4}. This argument is optional.}

\item{verbose}{If \code{TRUE}, then show details of the analysis. The default value is \code{FALSE}.}
}
\value{
\item{avg_pred_loglike}{Stores the average predicted log likelihood.}
\item{pred_loglike}{Stores the predicted log likelihood in each fold.}
\item{converge}{Stores the convergence status of the EM algorithm in each run.}
}
\description{
Performs cross-validation to calculate the average predicted log likelihood for the \code{linear2ph} function. This function can be used to select the B-spline basis that yields the largest average predicted log likelihood.
}
\examples{
  rho = 0.3
  p = 0.3
  n = 100
  n2 = 40
  alpha = 0.3
  beta = 0.4
   
  ### generate data
  simX = rnorm(n)
  epsilon = rnorm(n)
  simY = alpha+beta*simX+epsilon
  error = MASS::mvrnorm(n, mu=c(0,0), Sigma=matrix(c(1, rho, rho, 1), nrow=2))
   
  simS = rbinom(n, 1, p)
  simU = simS*error[,2]
  simW = simS*error[,1]
  simY_tilde = simY+simW
  simX_tilde = simX+simU
   
  id_phase2 = sample(n, n2)
   
  simY[-id_phase2] = NA
  simX[-id_phase2] = NA
   
  # cubic basis
  nsieves = c(5, 10)
  pred_loglike = rep(NA, length(nsieves))
  for (i in 1:length(nsieves)) {
      nsieve = nsieves[i]
      Bspline = splines::bs(simX_tilde, df=nsieve, degree=3, 
        Boundary.knots=range(simX_tilde), intercept=TRUE)
      colnames(Bspline) = paste("bs", 1:nsieve, sep="")
      # cubic basis
     
      data = data.frame(Y_tilde=simY_tilde, X_tilde=simX_tilde, Y=simY, X=simX, Bspline)
      ### generate data
     
      res = cv_linear2ph(Y="Y", X="X", Y_unval="Y_tilde", X_unval="X_tilde", 
        Bspline=colnames(Bspline), data=data, nfolds = 5)
      pred_loglike[i] = res$avg_pred_loglik
    }
   
  data.frame(nsieves, pred_loglike)

}
