# ---------------------------------------------------------
# Example 2.3 from Brazzale, Davison and Reid (2007)
# Artificial sample of size 5, assumed to be generated from
# a gamma distribution.
# Illustrates how the log-gamma function can be redefined
# to accepty complex arguments
# ---------------------------------------------------------

# Preliminaries
source("CStepDiff_functions.R")

# (Artificial) gamma data
y = c(0.2, 0.45, 0.78, 1.28, 2.28)

# Redefine lgamma function to accept complex argument
lgamma.complex <- function(z) complex_gamma(z, log = TRUE)
lgamma <- function(z) UseMethod("lgamma")
lgamma.default <- base::lgamma

# Negative log-likelihood function for gamma data
loglik <- function( theta, y, x) {
  lambda = theta[1]
  psi = theta[2]
  -sum( -lambda*y + (psi-1)*log(y) + psi*log(lambda) - lgamma(psi) )  
}

# Parameter values and true SE/correlation matrix from MAPLE
param = c(1738549, 1734939) / 1000000
truese = matrix( c(1.1711950167604293378, 0.86370360128419526434,
           0.86370360128419526434, 1.0094648947630115330), 2,2)

cc <- chkerrors(loglik, param, y, x, truese)
print(round(cc[2,],2))
