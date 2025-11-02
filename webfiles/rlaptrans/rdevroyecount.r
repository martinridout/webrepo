##=================================================================
## Implements the method of Devroye (1981, Comp & Maths with Appls,
## 7, 547-552) for simulating with a given Laplace transform. 
##
## Adapted here to work with a given Laplace transform. Requires
## the integrals of the absolute values of the characteristic
## function and its second derivative to be convergent and the
## actual numerical values are needed (c and k respectively).
##
## Also, requires evaluation of the density at various points.
## Here this is done by inversion of the Laplace transform.
##
##
## Function for generating a random sample of size n
## from a distribution, given the Laplace transform of
## its p.d.f.
##==============================================================

#===================================
rdevroyecount <- function(n, ltpdf, ...)
#===================================
{

    ##---------------------------------------------------
    ## First step is to evaluate the constants c and k
    ## and the derived constant A
    ##
    ## Use the fact that, for a density on [0, infinity),
    ## the characteristic function is given by
    ##   phi(u) = ltpdf(-1i * u)
    ## We first define functions for evaluating 
    ## (a) the absolute value of the characteristic 
    ##     function
    ## (b) the absolute value of the second derivative
    ##     of the characteristic function
    ##
    ## Note that the evaluation of the second derivative
    ## is by simple second differencing. The more
    ## hessian function from the numDeriv package cannot
    ## be used here as the function (before taking abs
    ## value) is not real-valued.
    ##---------------------------------------------------

   abscharfn <- function(u, ...) {
      abs(ltpdf( -1i * u, ...))
   }

   abscharfn2 <- function(u, ...) {
      delta <- max(.Machine$double.eps ^ (1/3) * abs(u), 1e-06)
      abs(ltpdf( -1i * (u+delta), ...) + ltpdf( -1i * (u-delta), ...)
          - 2 * ltpdf( -1i * u, ...)) / delta^2
   }

#   c <- integrate( abscharfn, 0, Inf, subdivisions=10000,,,,,, ...)$value / (pi)
#   k <- integrate( abscharfn2, 0, Inf, subdivisions=10000,,,,,, ...)$value / (pi)
   c <- integrate( abscharfn, 0, Inf, ..., subdivisions=10000)$value / (pi)
   k <- integrate( abscharfn2, 0, Inf, ..., subdivisions=10000)$value / (pi)
   A <- 2*sqrt(k*c)

    ##------------------------------------
    ## Now the actual simulation algorithm
    ##------------------------------------

   xstart <- sqrt(k/c)
   y = numeric(n)
   counter = numeric(n)

   for (j in 1:n) {

       notdone = TRUE

       while (notdone) {

            v1 <- runif(1, 0, 1)
            v2 <- runif(1, 0, 1)
            u <- runif(1, 0, 1)
            counter[n] = counter[n] + 1

            x <- xstart * v1 / v2
            fx = geneuler(ltpdf, x, ...)

            if (v1 < v2) {
               if ((c*u) < fx) notdone = FALSE
            } else {
               if ((k*u) < (x^2 * fx)) notdone = FALSE
            }          
       }
       y[j] = x
   }
#   cat(mean(counter)," A = ", A,"\n")
   list(x = y, count=A)
}


#===============================
geneuler <- function(lt, t, ...)
#===============================
{
   # ---------------------------------------------------------
   # General Euler algorithm
   # Start with (2.11) of Sakurai and form partial sums 
   #  n = nburn
   #  m = m
   #  A = A
   #  l = L

m = 12
L = 2
A = 18.4
nburn = 48

nterms = nburn + m*L
x = A / (2*L*t)

#  Calculate the partial sums. This array stores
#  (0.5 * ) the partial sums EXCEPT term 0, which 
#  is not kept separately. The factor of 0.5 is
#  taken into account when scaling at the end.

y = pi * (1i) * seq(1:nterms) / L
z = x + y/t
par.sum = 0.5*Re(lt(x, ...)) + cumsum( Re(lt(z, ...)*exp(y)) )

#  Binomial probabilities for smoothing
coef = choose(m,c(0:m)) / 2^m

#  Do the Euler summation, and output the scaled value
exp(x*t) * sum(coef * par.sum[seq(nburn,nterms,L)]) /(L*t)
}
