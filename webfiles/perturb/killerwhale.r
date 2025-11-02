#========================
# Killer whale example
# Produces Fig 1 in paper
#========================

A = matrix( c(0, 0.0043, 0.1132, 0, 0.9975, 0.9111, 0, 0,
              0, 0.0736, 0.9534, 0, 0, 0, 0.0452, 0.9804), 
            nrow=4, ncol=4, byrow=TRUE)

n.states = dim(A)[1]
cat("\nKiller whale example\n")
cat("\nPopulation projection matrix\n")
print(A)

    # Eigenvalues
ev = eigen(A, symmetric=FALSE, only.values=TRUE)$values
lambda = max(ev)
cat("\nDominant eigenvalue = ", lambda, "\n")
cat("\nAll real eigenvalues: ", ev, "\n")

    # Set up the perturbation matrix
P = A - A
P[3,3] = 1
cat("\nPerturbation matrix is a multiple of \n\n")
print(P)

    # Perturbation graph
n.points = 5
delta.min = -0.08
delta.max = 0
eigvals = array(0, c(n.states, n.points))
delta = seq(delta.min, delta.max, length.out=n.points)

for (j in 1:n.points) {
    eigvals[,j] = eigen(A + delta[j]*P, symmetric=FALSE, 
                        only.values=TRUE)$values
}
plot(delta, eigvals[1,], type="l", ylim=c(0,1.2),
     main="Eigenvalues as a function of perturbation", cex.main=1, 
     xlab="Perturbation, delta", ylab="Magnitude of eigenvalue")


for (i in 2: n.states) {
    lines(delta, eigvals[i,])
lines(delta, rep(1,n.points), col="red", lty="dashed")
}

    # Sensitivity/elasticity
epsilon = c(0.1, 0.01, 0.001, 0.0001) / 10
sensitivity = numeric(length(epsilon))
for (j in 1:length(epsilon)) {
    v1 = max(eigen(A - epsilon[j]*P, symmetric=FALSE, 
             only.values=TRUE)$values)
    v2 = max(eigen(A + epsilon[j]*P, symmetric=FALSE, 
             only.values=TRUE)$values)
    sensitivity[j] = (v2-v1) / (2*epsilon[j])
}
elasticity = A[3,3] * sensitivity / lambda

cat("\nEstimates of sensitivity and elasticity
calculated by numerical differentiation\n\n")
print(cbind(epsilon, sensitivity, elasticity))

    # Find perturbation that gives lambda=1
stable <- function( tau) {
    max(eigen(A + tau*P, symmetric=FALSE, 
             only.values=TRUE)$values) - 1
}
stable.perturb = uniroot(stable, lower = -2, upper = 2)$root
cat("\nPerturbation that gives asymptotic growth rate = 1\n")
cat("delta = ", stable.perturb,"\n")


