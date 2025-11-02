# =========================================================
# Produces data for Table 1 for the gamma distribution with 
# parameter alpha = 0.01, for which rlaptrans can be used,
# but not rdevroye. Uses modified
# versions of rlaptrans and redvroye, called rlaptranscount
# and rdevroyecount. These count the observed (rlaptrans)
# and expected (rdevroye) number of transform inversions
# used. 
# Results are averaged over 50 runs
# =========================================================

    #---------------------
    # Define the transform
    #---------------------
lt.gammapdf <- function(s, alpha, beta) {
   (1 + beta*s) ^ (-alpha)
}

    #---------------------
    # Set parameter values 
    #---------------------
beta <- 1
alphavals <- rep(0.05,4)
nvals <- c(1, 10, 100, 1000)
et.rlaptrans <- numeric(4)
inv.rlaptrans <- numeric(4)

nsim <- 50
times.rlap <- numeric(nsim)
counts.rlap <- numeric(nsim)

    #-------------------
    # Get the generators
    #-------------------
source("rlaptranscount.r")

    #-----------------------------------
    # Initialise random number generator
    #-----------------------------------
set.seed(9613)


    #-------------------
    # Do the simulations
    #-------------------
for (j in 1: length(alphavals)) {
    alpha <- alphavals[j]
    n <- nvals[j]

    for (k in 1:nsim) {
        st <- system.time(x.rlap <- rlaptranscount(n, 
                                      lt.gammapdf, alpha, beta, tol=1e-7))
        times.rlap[k]  <- st[3]
        counts.rlap[k] <- x.rlap$count
    }
    et.rlaptrans[j] <- mean(times.rlap)
    inv.rlaptrans[j] <- mean(counts.rlap)
}

print( cbind(alphavals, nvals, et.rlaptrans, inv.rlaptrans) )