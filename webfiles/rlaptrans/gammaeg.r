# ==================================================
# Example of using the function rlaptrans
# Gamma distribution with scale parameter beta = 1
# and various values of the shape parameter alpha
# (mean = alpha*beta,  variance = alpha*beta^2)
# ==================================================

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
alphavals = c(1.25, 2.5, 5, 10)

    #-------------------
    # Get the generators
    #-------------------
source("rlaptrans.r")
source("rdevroye.r")

    #-----------------------------------
    # Initialise random number generator
    #-----------------------------------
set.seed(682)

    #---------------------------------------
    # Generate 1000 random values from each
    # distribution by two methods and plot a 
    # kernel density estimate (black, blue) 
    # and true density (red)
    #---------------------------------------
par(mfrow=c(2,2))
for (alpha in alphavals) {
    x.rlap <- rlaptrans(1000, lt.gammapdf, alpha, beta)
    x.rdev <- rdevroye(1000, lt.gammapdf, alpha, beta)

    w.rlap <- density(log(x.rlap))
    u.rlap <- exp(w.rlap$x)
    v.rlap <- w.rlap$y / u.rlap

    w.rdev <- density(log(x.rdev))
    u.rdev <- exp(w.rdev$x)
    v.rdev <- w.rdev$y / u.rdev

    plot(u.rlap, v.rlap, type="l")
    lines(u.rdev, v.rdev, type="l",col="blue")
    lines(u.rlap, dgamma(u.rlap, alpha, scale=beta),col="red")
}
