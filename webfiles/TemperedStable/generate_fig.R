source("TSfunctions.R")
mu = 4
cv = 0.5
alpha = 0.5
x = seq(0, 16, by=0.1)
plot(x, dTS(x, c(mu,cv,alpha)), type="line", xlab="x", 
     ylab="pdf", cex.lab=1.5, cex.axis=1.5, ylim=c(0,0.36), lty="dashed", lwd=2)
lines(x, dTS(x, c(mu,cv,0.001)), col="red", lwd=2)
lines(x, dTS(x, c(mu,cv,0.75)), col="blue", lwd=2)
