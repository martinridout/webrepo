###################################################################################
##  THIS FILE GIVES THE FUNCTIONS REQUIRED TO COMPUTE THE PDF AND CDF OF THE TS  ##
##  DISTRIBUTION, WORK OUT QUANTILES, SIMULATE AND FIT A TS DISTRIBUTION TO A    ##
##  SET OF DATA - SEE THE FILE TSscript.R FOR HOW TO USE THEM                    ##
###################################################################################


lt_ts <- function(s, param) 
{
   mu.m <- param[1]                         # the function lt_ts defines
   CV.m <- param[2]                         # the Laplace transform of the 
   alpha <- param[3]                        # pdf of the TS distribution
   theta.m <- (1-alpha)/(mu.m * CV.m^2)
   delta.m <- mu.m / (theta.m^(alpha-1))
   fhat <- exp(-delta.m * ((theta.m+s)^alpha - theta.m^alpha) / alpha)
   fhat
}

#=====================================================================================

dTS <- function(x,param)
{
   M <- length(x)
   f <- numeric(M)
   for (i in 1:M)
   {
      f[i] <- geneuler(lt_ts,x[i],param)
   }
   f
}

#=====================================================================================

pTS <- function(q,param)
{
   M <- length(q)
   F <- numeric(M)
   for (i in 1:M)
   {
      F[i] <- geneuler(ltcdf_ts,q[i],param)
   }
   F
}

ltcdf_ts <- function(s,param)
{            
   fhat <- lt_ts(s,param)          # the function ltcdf_ts defines
   Fhat <- fhat/s                  # the Laplace transform of the
   Fhat                            # cdf of the TS distribution
}

#=====================================================================================

qTS <- function(p,param,lower=1/10000,upper=10000)
{
   x <- uniroot(TSfindq,c(lower,upper),param=param,p=p)
   cat("Value of cdf at", x$root, "is", x$f.root + p,"\n")
   x$root   
}

TSfindq <- function(x,param,p)
{
   pTS(x,param) - p
}

#=====================================================================================

rTS <- function(n,param)
{
   rlaptrans(n,lt_ts,,param)
}

#=====================================================================================

geneuler <- function(lt, t, ...)
{
   # General Euler algorithm, start with (2.11) of Sakurai and form 
   # partial sums, n = nburn, m = m, A = A, L = 1

   m = 12;  L = 1;  A = 18.4;  nburn = 38

   nterms = nburn + m*L
   x = A / (2*L*t)

   # Calculate the partial sums. This array stores (0.5 * ) the partial sums EXCEPT 
   # term 0, which is not kept separately. The factor of 0.5 is taken into account 
   # when scaling at the end.

   y = pi * (1i) * seq(1:nterms) / L
   z = x + y/t
   par.sum = 0.5*Re(lt(x, ...)) + cumsum( Re(lt(z, ...)*exp(y)) )

   coef = choose(m,c(0:m)) / 2^m    #  Binomial probabilities for smoothing

   # Do the Euler summation, and output the scaled value
   exp(x*t) * sum(coef * par.sum[seq(nburn,nterms,L)]) /(L*t)
}

#=====================================================================================

#------------------------------------------------------------------------
# Function for generating a random sample of size n from a distribution, 
# given the Laplace transform of its p.d.f.
#------------------------------------------------------------------------

rlaptrans <- function(n, ltpdf, tol=1e-6, ...)
{
   # ---------------------------------------------------
   # General Euler algorithm. Controlling parameters and 
   # default values are m=12, L=2, A=18.4, nburn=38
   # ---------------------------------------------------
   m = 12;   L = 2;   A = 18.4;   nburn = 38
   maxiter = 1000
   inflate = 1.5

   # -----------------------------------------------------
   # Derived quantities that need only be calculated once,
   # including the binomial coefficients
   # -----------------------------------------------------
   nterms = nburn + m*L
   seqbtL = seq(nburn,nterms,L)
   y = pi * (1i) * seq(1:nterms) / L
   expy = exp(y)
   A2L = 0.5 * A / L
   expxt = exp(A2L) / L
   coef = choose(m,c(0:m)) / 2^m

   # --------------------------------------------------
   # Generate sorted uniform random numbers. xrand will
   # store the corresponfing x values
   # --------------------------------------------------
   u = sort(runif(n))
   xrand = u

   #------------------------------------------------------------
   # Begin by finding an x-value that can act as an upper bound
   # throughout. This will be stored in upplim. Its value is
   # based on the maximum value in u. We also use the first
   # value calculated (along with its pdf and cdf) as a starting
   # value for finding the solution to F(x) = u_min. (This is
   # used only once, so doesn't need to be a good starting value
   #------------------------------------------------------------
   t = 1
   cdf = 0   
   kount = 0
   while (kount < maxiter & cdf < u[n]) {
       t = inflate * t
       kount = kount + 1
       x = A2L / t
       z = x + y/t
       ltx = ltpdf(x, ...)
       ltzexpy = ltpdf(z, ...) * expy
       par.sum = 0.5*Re(ltx) + cumsum( Re(ltzexpy) )
       par.sum2 = 0.5*Re(ltx/x) + cumsum( Re(ltzexpy/z) )
       pdf = expxt * sum(coef * par.sum[seqbtL]) / t
       cdf = expxt * sum(coef * par.sum2[seqbtL]) / t
       if (kount==1) {
           cdf1 = cdf
           pdf1 = pdf
           t1 = t
       }
   }
   if (kount >= maxiter) {
       stop('Cannot locate upper quantile')
   }
   upplim = t

   #--------------------------------
   # Now use modified Newton-Raphson
   #--------------------------------

   t = t1
   cdf = cdf1
   pdf = pdf1

   for (j in 1:n) {

      #-------------------------------
      # Initial bracketing of solution
      #-------------------------------
      lower = 0
      upper = upplim

      kount = 0
      while (kount < maxiter & abs(u[j]-cdf) > tol) {
          kount = kount + 1

          #-----------------------------------------------
          # Update t. Try Newton-Raphson approach. If this 
          # goes outside the bounds, use midpoint instead
          #-----------------------------------------------
          t = t - (cdf-u[j])/pdf 
          if (t < lower | t > upper) {
              t = 0.5 * (lower + upper)
          }

          #----------------------------------------------------
          # Calculate the cdf and pdf at the updated value of t
          #----------------------------------------------------
          x = A2L / t
          z = x + y/t
          ltx = ltpdf(x, ...)
          ltzexpy = ltpdf(z, ...) * expy
          par.sum = 0.5*Re(ltx) + cumsum( Re(ltzexpy) )
          par.sum2 = 0.5*Re(ltx/x) + cumsum( Re(ltzexpy/z) )
          pdf = expxt * sum(coef * par.sum[seqbtL]) / t
          cdf = expxt * sum(coef * par.sum2[seqbtL]) / t

          #------------------
          # Update the bounds 
          #------------------
          if (cdf <= u[j]) {
              lower = t}
          else {
              upper = t}
      }
      if (kount >= maxiter) {
          warning('Desired accuracy not achieved for F(x)=u')
      }
      xrand[j] = t
   }
   if (n > 1) {
      rsample <- sample(xrand) }
   else {
      rsample <- xrand} 
   rsample
}

#=====================================================================================

ma771grad <- function(funfcn, x)
{
	delta <- 10^(-6)
	t <- length(x)
	g <- rep(0, t)
	Dx <- delta*diag(t)	# eye :identity matrix
	for(i in 1:t) {
		g[i] <- (do.call("funfcn", list(x + Dx[i,  ])) - do.call(
			"funfcn", list(x - Dx[i,  ])))/(2 * delta)
	}
# feval : Ref : HL, p155.
	g
}

#=====================================================================================

#-------------------------------------------------------------
# The function tslik finds minus the log likelihood for a set
# of data based on the tempered stable distribution.
#-------------------------------------------------------------

tslik <- function(p,x)
{
   mu <- exp(p[1])              # the parameters in p have been 
   CV <- exp(p[2])              # transformed to ensure they stay
   alpha <- 1/(1+exp(-p[3]))    # in their correct ranges - mu>0
                                # CV>0 and alpha in (0,1)
   param <- c(mu,CV,alpha)
   f <- dTS(x,param)

   if (any(f<=0)) Inf else -sum(log(f))
}

#=====================================================================================

#--------------------------------------------------------------------------------
# In order to be able to find the gradient at a given set of parameters, we need 
# to have minus the log-likelihood set up as a function with just the parameters 
# as its argument
#--------------------------------------------------------------------------------

tslikgrad <- function(p)
{
   tslik(p,data)
}

#=====================================================================================

#----------------------------------------------------------------------------
# The function optts finds the maximum likelihood estimates for the tempered 
# stable distribution.  It has arguments 
#     - param0: starting values (mu,v,alpha)
#     - data: vector containing data
#----------------------------------------------------------------------------

optts <- function(param0,data)
{
   mu0 <- param0[1];  CV0 <- param0[2];  alpha0 <- param0[3]      

   #-------------------------------------------------------------------------
   # Transform the starting values of the parameters as has been done in the
   # function setting up the log-likelihood. This is done in order to keep 
   # them in their correct range during optimization. Take logs of mu and 
   # CV so they stay >0 and take logit of alpha to keep this in (0,1)
   #-------------------------------------------------------------------------
   p0 <- c(lnmu = log(mu0), lnCV = log(CV0), logitalpha = log(alpha0/(1-alpha0)))

   #-------------------------------------------------------------------------
   # p0 is now the starting value of the parameters that is to be used in
   # optimization, and symtslik is the function setting up -log-likelihood.
   # optim carries out optimization using Nelder-Mead
   #-------------------------------------------------------------------------
   ml <- optim(p0,tslik,hessian=TRUE,x=data,control=list(maxit=2000)) 

   #-----------------------------------------------------------------------
   # Work out the standard errors of the untransformed parameters, and also
   # their correlations. Store them in the matrix info
   #-----------------------------------------------------------------------
   hess <- ml$hessian      # the hessian matrix
   eighess <- eigen(hess)       # eigenvalues of the hessian
   cov <- solve(hess)           # gives the var-cov matrix (inverse hessian)
   k <- sqrt(diag(cov))         # approx se's for transformed parameters
   k1 <- diag(k)                # puts se's on diagonal elements of a matrix
   k2 <- solve(k1)              # puts 1/se's on diagonals
   cor <- k2 %*% cov %*% k2     # approx correlation matrix
   cor <- cor * lower.tri(cor) + k1  # correlations with se's on diagonals
   info <- cbind(ml$par, cor)   # estimates and correlations
                                      # for the transformed parameters

   #------------------------------------------------------
   # Work out the gradient of the function at the maximum
   #------------------------------------------------------
   optp <- ml$par
   gradopt <- ma771grad(tslikgrad,optp)

   #-----------------------------------------------------------------------
   # Pick out the mle's of the parameters in optp and transform these back
   # into mu,CV and alpha. Then work out the standard errors
   #-----------------------------------------------------------------------
   optp <- as.list(ml$par)
   y <- optp$logitalpha
   p1 <- exp(optp$lnmu);   p2 <- exp(optp$lnCV);   p3 <- 1/(1+exp(-y))
   optparam <- c(mu = p1, CV = p2, alpha = p3)
   se.s <- c(k[1]*p1,k[2]*p2,k[3]*exp(-y)*p3^2)  
   optparaminfo <- rbind(est=optparam,se=se.s)

   #--------------------------------------------------------------------------
   # Output from the function consists of the untransformed parameters and
   # their standard errors (optparam), the gradient at the optimum (gradient),
   # the estimates, standard errors and correlations of the transformed
   # parameters (est.se.cor.matrix), the eigenvalues of the hessian
   # (hessian.eigenvalues) and the normal ouptut from running 'optim' (ml)
   #---------------------------------------------------------------------------
   list(optparam=optparaminfo,est.se.cor.matrix=info,
        gradient=gradopt, hessian.eigenvalues=eighess$values, ml=ml)
}                                                      

#=====================================================================================


