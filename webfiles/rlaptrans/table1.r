# =========================================================
# Produces the data of Table 1 in the paper. Uses modified
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
alphavals <- rep( c(5, 2.5, 1.25), each=4)
nvals <- rep( c(1, 10, 100, 1000), 3)
nout = length(nvals)
et.rdevroye  <- numeric(nout)
et.rlaptrans <- numeric(nout)
inv.rdevroye  <- numeric(nout)
inv.rlaptrans <- numeric(nout)

nsim <- 50
times.rdev <- numeric(nsim)
times.rlap <- numeric(nsim)
counts.rdev <- numeric(nsim)
counts.rlap <- numeric(nsim)

    #-------------------
    # Get the generators
    #-------------------
source("rlaptranscount.r")
source("rdevroyecount.r")

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

    for (k in 1:nsim) {
        st <- system.time(x.rlap <- rlaptranscount(n, 
                                      lt.gammapdf, alpha, beta, tol=1e-7))
        times.rlap[k]  <- st[3]
        counts.rlap[k] <- x.rlap$count

        st <- system.time(x.rdev <- rdevroyecount(n, 
                                      lt.gammapdf, alpha, beta))
        times.rdev[k]  <- st[3]
        counts.rdev[k] <- x.rdev$count
    }
    et.rdevroye[j]  <- mean(times.rdev)
    et.rlaptrans[j] <- mean(times.rlap)
    inv.rdevroye[j]  <- mean(counts.rdev)
    inv.rlaptrans[j] <- mean(counts.rlap)
}

print( cbind(alphavals, nvals, et.rdevroye, et.rlaptrans, 
             inv.rdevroye, inv.rlaptrans) )