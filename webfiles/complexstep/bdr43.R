# ---------------------------------------------------------
# Example 4.3 from Brazzale, Davison and # Reid (2007)
# Association between cell phone use and vehicle collisions

source("CStepDiff_functions.R")

#----------------------------------
loglik1 <- function( param, y, x) {
  # Log-likelihood function for phone usage data
  gamma = param[1]
  -(y * log(gamma) + (x-y) * log(1-gamma))
}

transfm <- function( param) {
  param[1]/(1-param[1])
}

y = 157
n = 181
x = n

truese = 1.4337461049706529258
param = 157/181

hess1 <- h1(loglik1, param, y, x)
corr1 <- hess2corr(hess1)
corr1 <- corr1 * g2(transfm, param)

hess2 <- h2(loglik1, param, y, x)
corr2 <- hess2corr(hess2)
corr2 <- corr2 * g2(transfm, param)

hess3 <- h3(loglik1, param, y, x)
corr3 <- hess2corr(hess3)
corr3 <- corr3 * g2(transfm, param)

hess4 <- h4(loglik1, param, y, x)
corr4 <- hess2corr(hess4)
corr4 <- corr4 * g4(transfm, param)

hess5 <- hessian(loglik1,param,,,y,x)
corr5 <- hess2corr(hess5)
corr5 <- corr5 * grad(transfm,param)

err1 = log10(abs( (corr1 - truese) / truese))
err2 = log10(abs( (corr2 - truese) / truese))
err3 = log10(abs( (corr3 - truese) / truese))
err4 = log10(abs( (corr4 - truese) / truese))
err5 = log10(abs( (corr5 - truese) / truese))

cat(err1,err2,err3,err4,err5,"\n")