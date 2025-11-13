# ----------------------------------------------------------------
# Example 3.5 from Brazzale, Davison and # Reid (2007)
# Therapy cost data. Response variable (y) is the cost (in pounds, 
# sterling) of therapy for patients with a history of deliberate 
# self-harm. Patients received either a standard therapy of
# cognitive behaviour therapy. Parameter of interest is either
# the difference or the ratio of the group means.
#
# Costs assumed to follow either a lognormal distribution (this
# code) or an exponential distribution (bdr35exp.R)
# ----------------------------------------------------------------

# Preliminaries
source("CStepDiff_functions.R")

# Data
y = c(30, 172, 210, 212, 335, 489, 651, 1263, 1294, 1875, 2213, 
      2998, 4935, 121, 172, 201, 214, 228, 261, 278, 279, 351, 
      561, 622, 694, 848, 853, 1086, 1110, 1243, 2543)
y = y / 1000
x = rep(1:2, c(13,18))

# Negative log-likelihood for log-normal costs
loglik <- function( param, y, x) {
  mu1 = param[1]
  mu2 = param[2]
  sigma12 = param[3]
  sigma22 = param[4]
  (13 * log(sigma12) + 18 * log(sigma22) +
      sum( (log(y[x==1])-mu1)*(log(y[x==1])-mu1)/sigma12 ) +
      sum( (log(y[x==2])-mu2)*(log(y[x==2])-mu2)/sigma22 ) ) / 2
}


transfm1 <- function( param) {
  param[1]+param[3]/2 - param[2] - param[4]/2
}

transfm2 <- function( param) {
  exp(param[1]+param[3]/2) - exp(param[2]+param[4]/2)
}

param = c(-4621829, -7693342, 18655443, 6606971) / 10000000
truese = matrix( c(0.57113053637223720792, 0.97369054216345122422,
                   0.97369054216345122422, 0.85508294260693626485), 2, 2)

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 4, byrow=TRUE)
corr <- dermat %*% solve(h1(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err1 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 4, byrow=TRUE)
corr <- dermat %*% solve(h2(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err2 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 4, byrow=TRUE)
corr <- dermat %*% solve(h3(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err3 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))


der1 <- g4(transfm1, param)
der2 <- g4(transfm2, param)
dermat = matrix(c(der1,der2), 2, 4, byrow=TRUE)
corr <- dermat %*% solve(h4(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err4 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))


der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 4, byrow=TRUE)
corr <- dermat %*% solve(hessian(loglik,param,,,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err5 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

print(round(cbind(err1,err2,err3,err4,err5), 2))

