##=========================================
## This program produces Fig 1 in the paper
##=========================================

    ##--------------
    ## Read data etc
    ##--------------
source("setup.r")

    ##--------------
    ## Draw Fig 1
    ##--------------
kmax = 3
par(mfrow=c(3,2), mar=c(4.2,3.9,0.4,0.1), oma=c(1.5,0.5,0.1,0.1))

uuu = seq(0,1, length.out=512)

cval = 1

z = kplot( times[[1]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="", ylab="Density of activity", xaxt="n")
rug(as.vector(times[[1]])/(2*pi))
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
fitdens = fit.trigseries(times[[1]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
text(0.15, 0.12, expression(bold("Tiger (n=201)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))


z = kplot( times[[2]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="", ylab="", xaxt="n")
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
rug(as.vector(times[[2]])/(2*pi))
fitdens = fit.trigseries(times[[2]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
text(0.15, 0.12, expression(bold("Muntjac (n=200)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))

z = kplot( times[[4]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="", ylab="Density of activity", xaxt="n")
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
fitdens = fit.trigseries(times[[4]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
rug(as.vector(times[[4]])/(2*pi))
text(0.15, 0.12, expression(bold("Tapir (n=181)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))

z = kplot( times[[8]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="", ylab="", xaxt="n")
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
rug(as.vector(times[[8]])/(2*pi))
fitdens = fit.trigseries(times[[8]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
text(0.445, 0.12, expression(bold("Macaque (n=273)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))

z = kplot( times[[3]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="Time of day", ylab="Density of activity", xaxt="n")
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
rug(as.vector(times[[3]])/(2*pi))
fitdens = fit.trigseries(times[[3]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
text(0.15, 0.12, expression(bold("Sambar (n=25)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))

z = kplot( times[[5]], kmax, cval)
plot(z$x, z$y/24, type="l", ylim=c(0,0.14), xlab="Time of day", ylab="", xaxt="n")
abline(v=0.25, lty="dashed", col="gray"); abline(v=0.75, lty="dashed", col="gray")
lines(z$x, z$y/24)
rug(as.vector(times[[5]])/(2*pi))
fitdens = fit.trigseries(times[[5]], nrep=c(10,10,10,10))
lines(uuu, 24*fitdens, lty="dashed")
text(0.15, 0.12, expression(bold("Wild boar (n=28)")), cex=1.5, adj=c(0,0))
axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))