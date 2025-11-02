#===================================================================================
# THIS SCRIPT GIVES EXAMPLES OF HOW TO USE THE FUNCTIONS CONTAINED IN TSfunctions.R
#    - dTS gives the density of the TS distribution
#    - pTS gives the cumulative distribution function of the TS distribution
#    - qTS gives the quantile function
#    - rTS generates random deviates
#===================================================================================

# first need to source in the file TSfunctions.R
# May need to change the directory here. The line
# below assumes it is in the current directory.
source("TSfunctions.R")

#-------------------------------------------------------------------------------------
# Examples of how to compute the pdf, cdf, work out quantiles and simulate.  Note for
# the quantile function, we need to specify an interval to search within - an error 
# message will be given if both these limits give values of the cdf either above or 
# below the percentage point we are seeking.  We recommend drawing the cdf of the
# relevant TS distribution to determine appropriate limits.
#--------------------------------------------------------------------------------------

par(mfrow=c(2,2))

param <- c(4,0.3,0.8)                 # set the parameters (mean,CV,alpha)
x <- seq(0,10,by=0.01)                # set points at which to evaluate the pdf/cdf

f <- dTS(x,param)                     # this obtains the pdf ...
plot(x,f,type="l")                    # ... and plots it

F <- pTS(x,param)                     # this obtains the cdf ...
plot(x,F,type="l")                    # ... and plots it

p <- 0.95                             # obtain t such that Pr(X<=t) = p,
t <- qTS(p,param)                     # search for t in (lower,upper); here these
                                      # are left at their default values.

sims <- rTS(1000,param)               # simulate some data from TS ...
f <- dTS(x,param)                     # ... then calculate true density ...
hist(sims,freq=FALSE);  lines(x,f)    # ... and plot simulations vs true pdf

#-----------------------------------------------------------------------------------
# Example of how to fit the TS distribution to a set of data by maximum likelihood.
# We use simulated data to demonstrate.
#-----------------------------------------------------------------------------------

param <- c(4,0.3,0.8)     # set the TS parameters (mean,CV,alpha) which are then 
data <- rTS(100,param)    # used to simulate a set of data

param0 <- param                               # param0 is the set of starting values
st <- system.time(v <- optts(param0,data))    # for maximum likelihood, optts carries out ML
cat("\nMaximum likelihood estimation\n\n")
cat("True parameter values\n")
cat("   mu = ",param0[1],"\n")
cat("   CV = ",param0[2],"\n")
cat("alpha = ",param0[3],"\n")
cat("\nParameter estimates\n")
print(v$optparam)
cat("\nElapsed time for estimation = ",st[3],"\n")

f2 <- dTS(x,v$optparam[1,])                     # this obtains the pdf ...
plot(x,f,type="l", main="True and estimated  densities")       # ... and plots it
lines(x,f2,type="l",lty="dashed",col="red")                    # ... and plots it
legend(6,0.35,lty=c("solid","dashed"), col=c("black","red"), 
       legend=c("True", "Estimated"), cex=0.75)

# v stores the information from maximum likelihood.
#   - v$optparam gives the estimates and standard errors of the MLE's
#   - v$est.se.cor.matrix gives a matrix, where the first column gives the MLE's
#     [of log(mu), log(CV) and logit(alpha)=log(alpha/(1-alpha))], and the following
#     three columns give a 3x3 matrix with the standard errors on the diagonal and
#     correlations between tranformed parameters on the lower triangle (se's and cor's
#     of the tranformed parameters)
#   - v$gradient gives the value of the gradient at the MLE
#   - v$hessian.eigenvalues gives the eigenvalues of the hessian at the MLE
#   - v$ml gives the normal output obtained from running the optim function in R, 
#     type ?optim for an explanation (note this output is given in terms of the
#     transformed parameters)









