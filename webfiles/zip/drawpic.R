x = 0:8
w = 1/3
lambda = 2.5
p = dpois(x, lambda)
pwz = (1-w) * p/(1-exp(-lambda))
pz = w * (x==0) + (1-w) * p/(1-exp(-lambda))
par(mar=c(5, 5, 3, 2) + 0.1)
plot(x,pz, type="h", xlab="x", ylab="Pr(X=x)", cex.axis=2,
     lwd=5, col="red", cex.lab=2)
lines(x,pwz, type="h", col="blue", lwd=5)


