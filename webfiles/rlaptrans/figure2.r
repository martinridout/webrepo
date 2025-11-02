"=============================================
 First copula example. Produces Fig 2 in paper
 ============================================="

source("rlaptrans.r")

par(mfrow=c(1,1))

   ## Define generators psi2.1 is same as psi3.1 here
psi1 <- function(s, param) {
     (1+s)^(-1/param[1])
}

psi2.1 <- function(s, param) {
     exp( param[1] * (1 - (1+s)^(param[2]/param[3])))
}

psi3.1 <- function(s, param) {
     exp( param[1] * (1 - (1+s)^(param[2]/param[3])))
}

   ## Parameter values
theta <- c(1,3,8)
param1 <- c(theta[1])
param2.1 <- c(1, theta[1], theta[2])
param3.1 <- c(1, theta[1], theta[3])

   ## Sample size
n <- 3000

   ## Generate V sample of size n from psi1
V <- rlaptrans(n, psi1, param1)

   ## Generate negative log uniform variables for Alg 1
X1 <- -log(runif(n))
X2 <- -log(runif(n))
X3 <- -log(runif(n))
X4 <- -log(runif(n))


   ## Loop through algorithm 1 twice
for (j in 1:n) {
    param2.1[1] <- V[j] 
    param3.1[1] <- V[j]

#    print(param2.1)
    V2 <- rlaptrans(1, psi2.1, param2.1)
    X1[j] <- psi2.1(X1[j]/V2, param2.1)
    X2[j] <- psi2.1(X2[j]/V2, param2.1)
    V3 <- rlaptrans(1, psi3.1, param3.1)
    X3[j] <- psi3.1(X3[j]/V3, param3.1)
    X4[j] <- psi3.1(X4[j]/V3, param3.1)
}

U1 <- psi1(-log(X1)/V, param1)
U2 <- psi1(-log(X2)/V, param1)
U3 <- psi1(-log(X3)/V, param1)
U4 <- psi1(-log(X4)/V, param1)

print(cor(cbind(U1,U2,U3,U4), method="kendall"))
pairs(cbind(U1,U2,U3,U4), pch=".")