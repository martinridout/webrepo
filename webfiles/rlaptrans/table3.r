# =========================================================
# Produces the data of Table 3 in the paper. Uses modified
# versions of rlaptrans and redvroye, called rlaptranscount
# and rdevroyecount. These count the observed (rlaptrans)
# and expected (rdevroye) number of transform inversions
# used. 
# Results are averaged over 50 runs
# =========================================================

    #---------------------
    # Define the transform
    #---------------------
lt.stablepdf <- function(s, param) {
   alpha <- param[1]
   xi <- param[2]^alpha / cos(pi*alpha/2)
   exp(-xi * s^alpha)
}

    #---------------------
    # Set parameter values 
    #---------------------
alphavals <- rep( seq(0.1,0.9,by=0.1), each=2)
nvals <- rep( c(100, 1000), 9)
et.rlaptrans <- numeric(18)
inv.rlaptrans <- numeric(18)

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
set.seed(6892)


    #-------------------
    # Do the simulations
    #-------------------
for (j in 1: length(alphavals)) {
    alpha <- alphavals[j]
    n <- nvals[j]
    param = c(alpha, 1)

    for (k in 1:nsim) {
        st <- system.time(x.rlap <- rlaptranscount(n, 
                                      lt.stablepdf, param))
        times.rlap[k]  <- st[3]
        counts.rlap[k] <- x.rlap$count
    }
    et.rlaptrans[j] <- mean(times.rlap)
    inv.rlaptrans[j] <- mean(counts.rlap)
}

print( cbind(alphavals, nvals, et.rlaptrans, inv.rlaptrans) )