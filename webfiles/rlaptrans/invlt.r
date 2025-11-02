# ==================================================
# R implementation of Den Iseger's method of Laplace
# transform inversion
# ==================================================

invlt <- function(lt, tmax, M=32, K=8, ...)
{
   # ----------------------------------------
   # den Iseger algorithm. Improved R version
   # ----------------------------------------

   # Derived parameters
delta <- tmax/(M-1)
M2 <- K*M
a <- 44/M2
n <- 16
n2 <- n/2

   # Numerical values of lambda and beta for n=16 from Table 7
is_lambda <- c(0, 6.28318530717958, 12.5663706962589, 18.8502914166954, 
               25.2872172156717, 34.2969716635260, 56.1725527716607, 170.533131190126)
is_beta <- c(1, 1.00000000000004, 1.00000015116847, 1.00081841700481, 
             1.09580332705189, 2.00687652338724, 5.94277512934943, 54.9537264520382)

    ## Step1 
c2 <- pi*2i/M2
is_lambda <- a + 1i * is_lambda
s <- outer(is_lambda, c2*(0:M2), '+') / delta
fhat <- Re(lt(s, ...))
vfhat <- 4 * is_beta %*% fhat / delta
vfhat[1] <- 0.5*(vfhat[1] + vfhat[M2+1])

    ## Steps 2 and 3 
g <- Re(fft(vfhat[1:M2], inverse=TRUE)) / M2
f <- sign(g[1:M]) * exp(a*c(0:(M-1)) + log(abs(g[1:M])))

t <- delta * c(0:(M-1))
list(t=t, f=f)
}
