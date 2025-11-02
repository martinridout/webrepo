#===============================
# Produces Figure 1 in the paper
#===============================

par(mfrow=c(1,1))
set.seed(2593)
param <- c(1,1,0.75)
n <- 200
K <- 125000

T = n
tdiff = 1
   
    ## Change parametrisation
mu <- param[1];  CV <- param[2];  alpha <- param[3]
theta <- (1-alpha)/(mu * CV^2);  delta <- mu / (theta^(alpha-1))

    ## Constants
acorrect <- (delta/alpha)*2^(-alpha)
a <- acorrect / tdiff
b <- (2*theta)^alpha
g <- gamma(1-alpha)

alpha1 <- 1/ alpha
C1 <- 2 * (a*T/g)^alpha1
C2 <- 2 * b^(-alpha1)
t <- seq(0,T,by=tdiff);  lt <- length(t)
xt <- numeric(lt)

ei <- rexp(K,1)          # K exp(1) r.v's
ui <- runif(K,0,1)       # K U(0,1) r.v's
vi <- runif(K,0,1)       # K U(0,s) r.v's
bi <- cumsum(rexp(K,1))  # Poisson arrival times

m1 <- C1 * bi^(-alpha1)
m2 <- C2 * ei * vi^alpha1
m <- pmin(m1,m2)         # finds min(m1,m2) for each element

KVAL = c(125000, 200, 1000, 5000, 25000, 125000)
Tui = T * ui
for (kk in 1:length(KVAL)) {
    for (i in 1:lt) {
        ti <- t[i]
        xt[i] <- sum(m[Tui<t[i] & c(1:length(m)) <= KVAL[7-kk]])
    }
    xx <- c(0:200)
    if (kk == 1) {
       plot(xt, type="l", xlim=c(0,230),
       xlab="t", ylab=expression(paste(x^{(K)},(t))))
    } else {
       lines(xt, col="darkgray")
    }
}
lines(xt, col="black")

    #---------------------------------------------------
    # Laplace transform for tempered stable distribution
    #---------------------------------------------------
lt.ts <- function(s, param) {
    mu <- param[1];  CV <- param[2];  alpha <- param[3]
    theta <- (1-alpha)/(mu * CV^2);  delta <- mu / (theta^(alpha-1))   
    exp(-delta * ( (s+theta)^alpha - theta^alpha) / alpha)
}     

source("rlaptrans.r")
source("invlt.r")

op <- par(no.readonly = TRUE)
par(mfrow=c(1,1), mar=c(5.1,6.1,4.1,2.1))

text(205,193,adj=c(0,0.5), "K=125,000", cex=0.7)
text(205,183,adj=c(0,0.5),"K=25,000", cex=0.7)
text(205,171,adj=c(0,0.5),"K=5,000", cex=0.7)
text(205,146,adj=c(0,0.5),"K=1,000", cex=0.7)
text(205,108,adj=c(0,0.5),"K=200", cex=0.7)

lt_ts <- function(s, param) {
   mu <- param[1]
   cv <- param[2]
   alpha <- param[3]
   theta <- (1-alpha) / (mu * cv^2)
   delta <- mu / (theta^(alpha-1))
   fhat <- exp(-delta * ((theta+s)^alpha - theta^alpha) / alpha)
   fhat
}
param <- c(1,1,0.75)
   # Do the inversion
tmax <- 6
M <- 1025
ts_pdf <- invlt(lt_ts, tmax, M, 8, param)


par(omd=c(0.05,0.55,0.5,0.98), new=TRUE, cex.axis=0.7, tck=-0.03, mgp=c(2,0.3,0))
plot(ts_pdf$t, ts_pdf$f, xlab="", ylab="", type="l")

par(op)

