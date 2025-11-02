#=========================================
# Lizard orchid example - further analysis
# Includes Figure 3 in paper
#=========================================

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

#==================================
 complex.eigenvalues <- function(A)
#==================================
{
     # Finds all complex eigenvalues of A 

  ev = eigen(A, symmetric=FALSE, only.values=TRUE)$values
  if (is.complex(ev)) ev = ev[Im(ev) != 0]
  ev
}


lambda = max(real.eigenvalues(A))
cat("\nDominant eigenvalue = ", lambda, "\n")
cat("\nAll real eigenvalues: ", real.eigenvalues(A), "\n")


     #--------------------
     # 2-parameter example
     #--------------------
P1 = A - A
P2 = A - A
#P1[4,4] = -1
#P1[5,5] = +1
#P2[1,5] = -1
#P2[2,5] = +1

P1[3,5] = -1/2
P1[4,5] = -1/2
P1[5,5] = +1

P2[3,2] = -1
P2[2,2] = +1

#P2[1,5] = -1
#P2[2,5] = +1


nx = 21
ny = 21
x = seq(-0.25, 0.25, length.out=nx)
y = seq(-0.45, 0.15, length.out=nx)
z = matrix(0, nrow=nx, ncol=ny)
for (i in 1: nx) {
    for (j in 1: nx) {
        z[i,j] = max(real.eigenvalues(A + x[i]*P1 + y[j]*P2))
    }
}

contour(x,y,z, lty="dashed", xlab=expression(delta), ylab=expression(epsilon))
contour(x,y,z, zlim=c(0.99999,1.00001), col="red", add=TRUE, lwd=2, drawlabels=FALSE)


