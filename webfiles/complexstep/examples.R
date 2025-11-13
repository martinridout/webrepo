#---------------------------------------------------------------------------
# Runs the eight examples in Table 3 of 
# Ridout, M.S. (2009) Statistical applications of the complex-step method of
#    numerical differentiation. The American Statistician, 2009, 63, 66-74.
# 
# These examples are all from the book
# Brazzale, A.R., Davison, A.C. & Reid, N. (2007) Applied Asymptotics: Case
#    Studies in Small-Sample Statistics. Cambridge: Cambridge University
#    Press.
#
# For example, BDR 2.3 refers to example 2.3 in the book
#
# The code for each example should be reasonably straightforward to follow,
# if read in conjunction with the 2009 paper.
#---------------------------------------------------------------------------

# Load required functions
source("CStepDiff_functions.R")

# Run the 8 examples ...
{
  cat("BDR 2.3\n")  
  source("bdr23.R", echo=FALSE)
  cat("BDR 4.6\n")  
  source("bdr46.R", echo=FALSE)
  cat("BDR 5.4\n")  
  source("bdr54.R", echo=FALSE)
  cat("BDR 5.2 Gaussian errors\n")  
  source("bdr52.R", echo=FALSE)
  cat("BDR 5.2 t_4 errors\n")  
  # This example produces warning messages, because the function h2
  # gives a Hessian matrix that is not +ve definite. The warnings
  # are suppressed here, but Err2 gives NaN for this reason.
  suppressWarnings(source("bdr52t4.R", echo=FALSE))
  cat("BDR 4.3\n")  
  source("bdr43.R", echo=FALSE)
  cat("BDR 3.5 exponential\n")  
  source("bdr35exp.R", echo=FALSE)
  cat("BDR 3.5 lognormal\n")  
  source("bdr35ln.R", echo=FALSE)
}
