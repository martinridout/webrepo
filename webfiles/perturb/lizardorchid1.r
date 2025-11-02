#========================
# Lizard orchid example
# Produces Fig 2 in paper
#========================


A = matrix( c(0.452524239, 0.166375393, 0.027652733, 0.007490637, 2.867662753, 0.299578059,
              0.116683383, 0.468367704, 0.146623794, 0.039950062, 0.563500534, 0.282700422,
              0.006853895, 0.158336246, 0.410289389, 0.197253433, 0.275346852, 0.063291139,
              0.00183885,  0.012583013, 0.180064309, 0.323345818, 0.282817503, 0.042194093,
              0.000668673, 0.008039147, 0.154340836, 0.369538077, 0.369263607, 0.012658228,
              0.037612839, 0.027962251, 0.011575563, 0.011235955, 0.017075774, 0.29535865),
            nrow=6, ncol=6, byrow=TRUE)

n.states = dim(A)[1]
cat("\nLizard orchid example\n")
cat("\nPopulation projection matrix\n")
print(A)

#===============================
 real.eigenvalues <- function(A)
#===============================
{
     # Finds all real eigenvalues of A 

  ev = eigen(A, symmetric=FALSE, only.values=TRUE)$values
  if (is.complex(ev)) ev = Re(ev[Im(ev) == 0])
  ev
}

lambda = max(real.eigenvalues(A))
cat("\nDominant eigenvalue = ", lambda, "\n")
cat("\nAll real eigenvalues: ", real.eigenvalues(A), "\n")

    #-------------------------------
    # Set up the perturbation matrix
    #-------------------------------
P = A - A
P[3,5] = -1/2
P[4,5] = -1/2
P[5,5] = +1
cat("\nPerturbation matrix is a multiple of \n\n")
print(P)

    #-------------------
    # Perturbation graph
    #-------------------
n.points = 25
delta.min = -0.2
delta.max = 0.2
eigvals = array(0, c(n.states, n.points))
delta = seq(delta.min, delta.max, length.out=n.points)

for (j in 1:n.points) {
    eigvals[,j] = eigen(A + delta[j]*P, symmetric=FALSE, 
                        only.values=TRUE)$values
}
line.type = rep("solid", n.states)
for (i in 1: n.states) {
    if ( any(Im(eigvals[i,]) != 0) ) line.type[i] = "dashed"
}

plot(delta, abs(eigvals[1,]), type="l", lty=line.type[i], ylim=c(-0.2,1.2),
     main="", cex.main=1, xlab=expression(delta), ylab=expression(tilde(lambda)))


for (i in c(2,3)) {
    lines(delta, abs(eigvals[i,]), lty=line.type[i])
}
lines(delta, eigvals[6,])
lines(delta, rep(1,n.points), col="red", lty="dotted")
condn = delta <= 0.15
lines(delta[condn], abs(eigvals[4,condn]))
lines(delta[condn], abs(eigvals[5,condn]))
condn = delta > 0.142
lines(delta[condn], abs(eigvals[4,condn]), lty="dashed")
lines(delta[condn], abs(eigvals[5,condn]), lty="dashed")

    #-----------------------
    # Sensitivity/elasticity
    #-----------------------
epsilon = c(0.1, 0.01, 0.001, 0.0001) / 10
sensitivity = numeric(length(epsilon))
for (j in 1:length(epsilon)) {
    v1 = max(real.eigenvalues(A - epsilon[j]*P))
    v2 = max(real.eigenvalues(A + epsilon[j]*P))
    sensitivity[j] = (v2-v1) / (2*epsilon[j])
}
cat("\nEstimates of sensitivity calculated by numerical differentiation\n\n")
print(cbind(epsilon, sensitivity))


