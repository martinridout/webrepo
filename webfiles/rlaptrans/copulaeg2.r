source("rlaptrans.r")

## Implement Algorithm 6

   ## Define generators 
psi1 <- function(s, param) {
     exp(-s^(1/param[1]))
}

psik.k1 <- function(s, v, pk, pk1) {
     exp( -v * s^(pk1/pk) )
}

   ## Parameter values
theta <- c(1:6)
param1 <- c(theta[1])
param2.1 <- c(1, theta[1], theta[2])
param3.1 <- c(1, theta[1], theta[3])

   ## Sample size
n <- 3000
d <- 6
X <- matrix(NA, nrow=n, ncol=d+1)
U <- matrix(NA, nrow=n, ncol=d+1)
V <- matrix(NA, nrow=n, ncol=d+1)

   ## Generate V1 sample of size n from psi1
V[,1] <- rlaptrans(n, psi1, theta[1])

   ## Generate uniform variables
for (j in 1: (d+1)) {
    X[,j] <- runif(n)
}

   ## Loop through algorithm 1 twice
for (j in 1:n) {
    for (k in 2: d) {
        V[j,k] <- rlaptrans(1, psik.k1, V[j,(k-1)], theta[k], theta[k-1])
    }
}

for (k in 1:d) {
    U[,k] <- psi1(-log(X[,k])/V[,k], theta[k])
}
U[,(k+1)] <- psi1(-log(X[,(k+1)])/V[,k], theta[k])

print(cor(U, method="kendall"))
pairs(cbind(U), pch=".")