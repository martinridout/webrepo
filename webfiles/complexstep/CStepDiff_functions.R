#-----------------------------------------------------------------------------
# The functions
#    complex_gamma   and    lanczos
# are from the hypergeo package (version 1.2-14) by Robin Hankin 

complex_gamma <- function (z, log = FALSE) 
{
    out <- z * NaN + (0+0i)
    z <- z + (0+0i)
    left <- Re(z) < 0.5
    zl <- z[left]
    zr <- z[!left]
    if (log) {
        out[left] <- log(pi) - log(sin(pi * zl)) - lanczos(1 - zl, log = TRUE)
        out[!left] <- lanczos(zr, log = TRUE)
    }
    else {
        out[left] <- pi/(sin(pi * zl) * lanczos(1 - zl, log = FALSE))
        out[!left] <- lanczos(zr, log = FALSE)
    }
    return(out)
}

lanczos <- function (z, log = FALSE) 
{
    stopifnot(all(Re(z) >= 0.5))
    g <- 7
    p <- c(0.99999999999981, 676.520368121885, -1259.1392167224, 
           771.323428777653, -176.615029162141, 12.5073432786869, 
           -0.13857109526572, 9.98436957801957e-06, 1.50563273514931e-07)
    z <- z + (0+0i) - 1
    x <- p[1]
    for (i in seq.int(from = 2, to = g + 2)) {
        x <- x + p[i]/(z + i - 1)
    }
    tee <- z + g + 0.5
    if (log) {
        return(log(2 * pi)/2 + (z + 0.5) * log(tee) - tee + log(x))
    }
    else {
        return(sqrt(2 * pi) * tee^(z + 0.5) * exp(-tee) * x)
    }
}
#------------------------------------------------------------------------=

# Load various packages from CRAN if these are not already loaded

requiredPackages <- c("MASS", "nlme", "numDeriv", "marg")
for (p in requiredPackages) {
    if (!require(p, character.only=TRUE)) install.packages(p)
    library(p, character.only=TRUE)
}

## Various functions used in connection with the article
## "Statistical applications of the complex-step method 
##  of numerical differentiation"
##
##  Gradient functions g1, g2, g4
##  Hessian functions h1, h2, h3, h4, Ted
##  Conversion of Hessian to SE/correlation matrix (hess2corr)
##  Conversion of SE/correlation matrix to Hessian (corr2hess)
##  Evaluation of errors (chkerrors)

#=====================================
 g2 <- function(f, x, delta=1e-6, ...)
#=====================================
{
    t <- length(x)
    g <- rep(0, t)
    delta <- .Machine$double.eps ^ (1/3)
    Dx <- delta*diag(x)     
    if (t==1) Dx = matrix(delta * x , 1, 1)
    for (i in 1:t) {
        g[i] <- f(x + Dx[i,], ...) - 
                f(x - Dx[i,], ...)
    }
    g / (2 * delta * x)
}

#========================================
 g4 <- function(f, x, delta=1e-15, ...) {
#========================================

    # GRAD using complex step

    t <- length(x)
    g <- rep(0, t)
    delta <- .Machine$double.eps
    Dx <- delta*diag(x)     
    if (t==1) Dx = matrix(delta * x , 1, 1)
    for (i in 1:t) {
        g[i] <- Im(f(x + 1i* Dx[i,], ...))
    }
    g / (delta * x)
}


#=========================
 h1 <- function(f, x, ...)
#=========================
{
    t <- length(x)
    h <- matrix(0, t, t)
    delta <- .Machine$double.eps ^ (1/3)
    Dx <- delta * diag(x)
    if (t==1) Dx = matrix(delta * x , 1, 1)
    fdelta <- numeric(t)

    f0 <- f(x, ...)
    for (i in 1:t) {
        fdelta[i] <- f(x + Dx[i,], ...)
    }
    for (i in 1:t) {
        for (j in 1:i) {
            h[i,j] <- (f(x + Dx[i,] + Dx[j,], ...) - fdelta[i]) - 
                      (fdelta[j] - f0)
            h[j,i] <- h[i,j]
        }
    }
    h / (delta^2 * x %*% t(x))
}


#=========================
 h2 <- function(f, x, ...)
#=========================
{
    t <- length(x)
    h <- matrix(0, t, t)
    delta <- .Machine$double.eps ^ (1/4)
    Dx <- delta * diag(x)
    if (t==1) Dx = matrix(delta * x , 1, 1)
    fdelta <- numeric(t)
    fdelta1 <- numeric(t)

    f0 <- f(x, ...)
    for (i in 1:t) {
        fdelta[i] <- f(x + Dx[i,], ...)
        fdelta1[i] <- f(x - Dx[i,], ...)
    }
    for (i in 1:t) {
        for (j in 1:i) {
            h[i,j] <- (f(x + Dx[i,] + Dx[j,], ...) - fdelta[i]) -
                      (fdelta[j] - f0) +
                      (f(x - Dx[i,] - Dx[j,], ...) - fdelta1[i]) -
                      (fdelta1[j] - f0) 
            h[j,i] <- h[i,j]
        }
    }
    h / (2 * delta^2 * x %*% t(x))
}


#=========================
 h3 <- function(f, x, ...)
#=========================
{
    t <- length(x)
    h <- matrix(0, t, t)
    delta <- .Machine$double.eps ^ (1/4)
    Dx <- delta * diag(x)
    if (t==1) Dx = matrix(delta * x , 1, 1)
    for (i in 1:t) {
        for (j in 1:i) {
            h[i,j] <- f(x + Dx[i,] + Dx[j,], ...) - 
                      f(x + Dx[i,] - Dx[j,], ...) - 
                      f(x - Dx[i,] + Dx[j,], ...) +
                      f(x - Dx[i,] - Dx[j,], ...) 
            h[j,i] <- h[i,j]
        }
    }
    h / (4 * delta^2 * x %*% t(x))
}


#=========================
 h4 <- function(f, x, ...)
#=========================
{
    t <- length(x)
    h <- matrix(0, t, t)
    delta.1 <- .Machine$double.eps ^ (1/3)
    delta.2 <- .Machine$double.eps ^ (1/5)
    Dx <- diag(x)
    if (t==1) Dx = matrix(x, 1, 1)
    for (i in 1:t) {
        for (j in 1:i) {
            delta <- delta.1 + (delta.2-delta.1) * (i==j)
            h[i,j] <- Im(f(x + 1i*delta*Dx[i,] + delta*Dx[j,], ...) - 
                         f(x + 1i*delta*Dx[i,] - delta*Dx[j,], ...))
            h[i,j] <- h[i,j] / (delta^2 * x[i] * x[j])
            h[j,i] <- h[i,j]
        }
    }
    h / 2
}

#==============================
 hess2corr <- function(hessian)
#==============================
{
    # Calculate correlation matrix from a given Hessian

    n <- nrow(hessian)
    vcov <- solve(hessian)
    vcorr <- vcov
    for (j in 1: n) {
        vcorr[j,j] <- sqrt(vcov[j,j])
    }
    if (n > 1) {
       for (i in 1:(n-1)) {
           for (j in (i+1):n) {
               vcorr[i,j] <- vcov[i,j] / (vcorr[i,i] * vcorr[j,j])
               vcorr[j,i] <- vcorr[i,j]
           }
       }
    }
    vcorr
}


#============================
 corr2hess <- function(vcorr)
#============================
{
    # Calculate correlation matrix from a given Hessian

    n <- nrow(vcorr)
    vcov <- vcorr
    if (n > 1) {
       for (i in 1:(n-1)) {
           for (j in (i+1):n) {
               vcov[i,j] <- vcov[i,j] * (vcov[i,i] * vcov[j,j])
               vcov[j,i] <- vcov[i,j]
           }
       }
    }
    for (j in 1: n) {
        vcov[j,j] <- vcov[j,j]^2
    }
    solve(vcov)
}


#=============================================
 chkerrors <- function(f, param, y, x, truese)
#=============================================
{

    Err1 <- numeric(3)
    Err2 <- numeric(3)
    Err3 <- numeric(3)
    Err4 <- numeric(3)
    Err5 <- numeric(3)

    hess1 <- h1(f, param, y, x)
    corr1 <- hess2corr(hess1)
    hess2 <- h2(f, param, y, x)
    corr2 <- hess2corr(hess2)
    hess3 <- h3(f, param, y, x)
    corr3 <- hess2corr(hess3)
    hess4 <- h4(f, param, y, x)
    corr4 <- hess2corr(hess4)
    hess5 <- hessian(f,param,,method.args=list(eps=1e-4, d=0.1, r=4, v=2),y,x)
    corr5 <- hess2corr(hess5)

    truehess = corr2hess(truese)
    Err1[1] <- abs(1/det(hess1)-1/det(truehess)) / abs(1/det(truehess))
    Err2[1] <- abs(1/det(hess2)-1/det(truehess)) / abs(1/det(truehess))
    Err3[1] <- abs(1/det(hess3)-1/det(truehess)) / abs(1/det(truehess))
    Err4[1] <- abs(1/det(hess4)-1/det(truehess)) / abs(1/det(truehess))
    Err5[1] <- abs(1/det(hess5)-1/det(truehess)) / abs(1/det(truehess))

    if (length(param) > 1) {
       Err1[2] <- max(abs(diag(corr1)-diag(truese))/diag(truese))
       Err2[2] <- max(abs(diag(corr2)-diag(truese))/diag(truese))
       Err3[2] <- max(abs(diag(corr3)-diag(truese))/diag(truese))
       Err4[2] <- max(abs(diag(corr4)-diag(truese))/diag(truese))
       Err5[2] <- max(abs(diag(corr5)-diag(truese))/diag(truese))

       c1 <- corr1-diag(diag(corr1))
       c2 <- corr2-diag(diag(corr2))
       c3 <- corr3-diag(diag(corr3))
       c4 <- corr4-diag(diag(corr4))
       c5 <- corr5-diag(diag(corr5))
       tr <- truese-diag(diag(truese))
       Err1[3] <- max(abs(c1-tr))
       Err2[3] <- max(abs(c2-tr))
       Err3[3] <- max(abs(c3-tr))
       Err4[3] <- max(abs(c4-tr))
       Err5[3] <- max(abs(c5-tr))
    }
    
    Err1 <- log10(Err1)
    Err2 <- log10(Err2)
    Err3 <- log10(Err3)
    Err4 <- log10(Err4)
    Err5 <- log10(Err5)

    cbind(Err1,Err2,Err3,Err4,Err5)
}


#========================================
 timing <- function(f, param, y, x, nrun)
#========================================
{

t1 = system.time({for (j in 1:nrun) {h1(f, param, y, x)}})
t2 = system.time({for (j in 1:nrun) {h2(f, param, y, x)}})
t3 = system.time({for (j in 1:nrun) {h3(f, param, y, x)}})
t4 = system.time({for (j in 1:nrun) {h4(f, param, y, x)}})
t5 = system.time({for (j in 1:nrun) {hessian(f, param,,, y, x)}})
c(t1[3],t2[3],t3[3],t4[3],t5[3])
}
