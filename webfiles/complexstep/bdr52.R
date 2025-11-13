#----------------------------------------------------------------------
# Example 5.2 from Brazzale, Davison and Reid (2007)
# Nuclear power station data. A multiple linear regression problem with
# 32 observations. The response (y) is the logarithm of the cost of a
# nuclear reactor and there are 10 potential explanatory variables.
# We consider the particular model in Table 5.2 of BDR which includes
# a constant term and 6 covariates that was selected by AIC. 
# Here we consider a least squares fit. File bdr52t4.R has code for
# a maximum likelihood fit, assuming the errors follow a scaled
# t distribution with 4 d.f.
#----------------------------------------------------------------------

# Preliminaries
source("CStepDiff_functions.R")

# Data
nuclear = read.table("nuclear.txt", sep='\t', header=TRUE)

# Log-likelihood function for nuclear power station 
# data - OLS model
loglik <- function( beta, y, x) {
  mu = beta[1] + beta[2]*x[,1] + beta[3]*x[,2] + beta[4]*x[,3] + 
       beta[5]*x[,4] + beta[6]*x[,5] + beta[7]*x[,6] 
  sum( (y-mu)*(y-mu) / 2)
 }

# Least squares fit in R
nuc.norm <- lm( log(cost) ~ date + log(cap) + NE + CT + log(N) + PT,
                data=nuclear)
summary(nuc.norm)

attach(nuclear)
y = log(cost)
x = cbind(date,log(cap),NE,CT,log(N),PT)
detach(nuclear)

param = nuc.norm$coef

truese = hess2corr(ginv(vcov(nuc.norm) / summary(nuc.norm)$sigma^2))

cc <- chkerrors(loglik, param, y, x, truese)
print(round(cc[2,],2))

