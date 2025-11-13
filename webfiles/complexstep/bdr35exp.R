# ---------------------------------------------------------------
# Treatment cost example - Example 3.5 from Brazzale, Davison and 
# Reid (2007)

# ----------------------------------------------------------------
# Example 3.5 from Brazzale, Davison and # Reid (2007)
# Therapy cost data. Response variable (y) is the cost (in pounds, 
# sterling) of therapy for patients with a history of deliberate 
# self-harm. Patients received either a standard therapy of
# cognitive behaviour therapy. Parameter of interest is either
# the difference or the ratio of the group means.
#
# Costs assumed to follow either an exponential distribution (this
# code) or a lognormal distribution (bdr35ln.R)
# ----------------------------------------------------------------

# Preliminaries
source("CStepDiff_functions.R")

y = c(30, 172, 210, 212, 335, 489, 651, 1263, 1294, 1875, 2213, 
      2998, 4935, 121, 172, 201, 214, 228, 261, 278, 279, 351, 
      561, 622, 694, 848, 853, 1086, 1110, 1243, 2543)
y = y / 1000
x = rep(1:2, c(13,18))

# Log-likelihood for exponential with ratio of means
loglik <- function( param, y, x) {
  mu1 = param[1]
  mu2 = param[2]
  -( -13*log(mu1) - 18*log(mu2) - sum(y[x==1])/mu1 - sum(y[x==2])/mu2)
}

transfm1 <- function( param) {
  param[1]/param[2]
}

transfm2 <- function( param) {
   param[1] - param[2]
}

mean1 = mean(y[x==1])
mean2 = mean(y[x==2])
param = c(mean1, mean2)
truese = matrix( c(0.72050210941595216409, 0.95566632345012524281,
                   0.95566632345012524281, 0.38720003344196362612), 2, 2)

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 2, byrow=TRUE)
corr <- dermat %*% solve(h1(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err1 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 2, byrow=TRUE)
corr <- dermat %*% solve(h2(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err2 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 2, byrow=TRUE)
corr <- dermat %*% solve(h3(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err3 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g4(transfm1, param)
der2 <- g4(transfm2, param)
dermat = matrix(c(der1,der2), 2, 2, byrow=TRUE)
corr <- dermat %*% solve(h4(loglik,param,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err4 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

der1 <- g2(transfm1, param)
der2 <- g2(transfm2, param)
dermat = matrix(c(der1,der2), 2, 2, byrow=TRUE)
corr <- dermat %*% solve(hessian(loglik,param,,,y,x)) %*% t(dermat)
tmp = (sqrt(diag(corr)))
err5 = log10( max( abs( tmp - diag(truese)) / diag(truese) ))

cat(err1,err2,err3,err4,err5,"\n")
print(round(cbind(err1,err2,err3,err4,err5), 2))


