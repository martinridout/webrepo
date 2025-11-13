# ----------------------------------------------------------------
# Example 4.6 from Brazzale, Davison and # Reid (2007)
# This is a nonlinear model with a discrete response variable. The
# data are the number of British male doctors dying of lung cancer
# (Y) and the number of man-tears at risk (T), cross-classified
# by number of cigarettes smoked per day (c, 7 levels) and years
# of smokiung (d, 9 levels).
# ----------------------------------------------------------------

source("CStepDiff_functions.R")

# Smoking data 
#    c = daily consumption
#    d = duration of smoking
#    T = 1e-5 * man years at risk
#   LC = number of cases of lung cancer
Years = c(10366, 8162, 5969, 4496, 3512, 2201, 1421, 1121,
          826, 3121, 2937, 2288, 2015, 1648, 1310, 927, 710,
          606, 3577, 3286, 2546, 2219, 1826, 1386, 988, 684, 
          449, 4317, 4214, 3185, 2560, 1893, 1334, 849, 470,
          280, 5683, 6385, 5483, 4687, 3646, 2411, 1567, 857,
          416, 3042, 4050, 4290, 4268, 3529, 2424, 1409, 663,
          284, 670, 1166, 1482, 1580, 1336, 924, 556, 255, 104)
y = c(1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 2, 0, 3, 0, 
       0, 1, 1, 2, 0, 1, 2, 4, 3, 0, 0, 0, 4, 0, 2, 2, 2, 5, 
       0, 1, 1, 6, 5, 12, 9, 7, 7, 0, 1, 4, 9, 9, 11, 10, 5, 
       3, 0, 0, 0, 4, 6,10, 7, 4, 1)
c = rep( c(0,5,12,17,22,29.5,40), each=9)
d = rep( c(12,22,27,32,37,42,47,52,57), 7)
T = Years / 10000
x = data.frame(T, c, d)

# Negative log-likelihood function for smoking data
# Coded to ensure that w^z = 0 when w=0 and z has non-zero
# imaginary part 
loglik <- function( theta, y, x) {
  mu = x$T * exp(theta[1]) * x$d^theta[2] * (1 + exp(theta[3]) * 
       x$c^(theta[4]*(x$c>0) + (x$c==0 & Re(theta[4])>0)))
  -sum(y * log(mu) - mu)
}

param = c(-15.355331, 4.295496, -1.387493, 1.328611)

# Find true obs inf matrix
obsinf = matrix(0, 4, 4)
n = length(y)
theta = param
obsinf[1,1] = sum(T*exp(theta[1])*d^theta[2]*(1+exp(theta[3])*c^theta[4]))
obsinf[2,1] = sum(T*exp(theta[1])*d^theta[2]*log(d)*(1+exp(theta[3])*c^theta[4]))
obsinf[1,2] = obsinf[2,1]
obsinf[2,2] = sum(T*exp(theta[1])*d^theta[2]*log(d)^2*(1+exp(theta[3])*c^theta[4]))
obsinf[3,1] = sum(T*exp(theta[1])*d^theta[2]*exp(theta[3])*c^theta[4])
obsinf[1,3] = obsinf[3,1]
obsinf[3,2] = sum(T*exp(theta[1])*d^theta[2]*log(d)*exp(theta[3])*c^theta[4])
obsinf[2,3] = obsinf[3,2]
obsinf[3,3] = sum(-y*exp(theta[3])*c^theta[4]/(1+exp(theta[3])*c^theta[4]) + 
               y*(exp(theta[3]))^2*(c^theta[4])^2/(1+exp(theta[3]) * 
               c^theta[4])^2+T*exp(theta[1])*d^theta[2]*
               exp(theta[3])*c^theta[4])
obsinf[4,1] = sum(T*exp(theta[1])*d^theta[2]*exp(theta[3])*c^theta[4]*log(c+(c==0)))
obsinf[1,4] = obsinf[4,1]
obsinf[4,2] = sum(T*exp(theta[1])*d^theta[2]*log(d)*exp(theta[3])*c^theta[4]*log(c+(c==0)))
obsinf[2,4] = obsinf[4,2]
obsinf[4,3] = sum(-y*exp(theta[3])*c^theta[4]*log(c+(c==0))/(1+exp(theta[3])*c^theta[4])+
               y*(exp(theta[3]))^2*(c^theta[4])^2*log(c+(c==0))/(1+exp(theta[3])*
               c^theta[4])^2+T*exp(theta[1])*d^theta[2]*exp(theta[3])*
               c^theta[4]*log(c+(c==0)))
obsinf[3,4] = obsinf[4,3]
obsinf[4,4] = sum(-y*exp(theta[3])*c^theta[4]*log(c+(c==0))^2/(1+exp(theta[3])*
               c^theta[4])+y*(exp(theta[3]))^2*(c^theta[4])^2*log(c+(c==0))^2/
               (1+exp(theta[3])*c^theta[4])^2+T*exp(theta[1])*d^theta[2]*
               exp(theta[3])*c^theta[4]*log(c+(c==0))^2)
truese = hess2corr(obsinf)

cc <- chkerrors(loglik, theta, y, x, truese)
print(round(cc[2,],2))
