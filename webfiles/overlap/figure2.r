##=========================================
## This program produces Fig 1 in the paper
##=========================================

    ##--------------
    ## Read data etc
    ##--------------
source("setup.r")

    ##----------------------------
    ## Calculate overlap estimates
    ##----------------------------
cat("Muntjac\n")
ovl2 = ovlest.robust2(times[[1]][ftiger==2], times[[2]][fmuntjac==2], kmax=3, c=1)
ovl3 = ovlest.robust2(times[[1]][ftiger==3], times[[2]][fmuntjac==3], kmax=3, c=1)
ovl4 = ovlest.robust2(times[[1]][ftiger==4], times[[2]][fmuntjac==4], kmax=3, c=1)
print(ovl2)
print(ovl3)
print(ovl4)


cat("Tapir\n")
ovl2 = ovlest.robust2(times[[1]][ftiger==2], times[[4]][ftapir==2], kmax=3, c=1)
ovl3 = ovlest.robust2(times[[1]][ftiger==3], times[[4]][ftapir==3], kmax=3, c=1)
ovl4 = ovlest.robust2(times[[1]][ftiger==4], times[[4]][ftapir==4], kmax=3, c=1)
print(ovl2)
print(ovl3)
print(ovl4)

cat("Macaque\n")
ovl2 = ovlest.robust2(times[[1]][ftiger==2], times[[8]][fmacaque==2], kmax=3, c=1)
ovl3 = ovlest.robust2(times[[1]][ftiger==3], times[[8]][fmacaque==3], kmax=3, c=1)
ovl4 = ovlest.robust2(times[[1]][ftiger==4], times[[8]][fmacaque==4], kmax=3, c=1)
print(ovl2)
print(ovl3)
print(ovl4)


    ##-----------
    ## Draw Fig 2
    ##-----------
kmax = 3
par(mfrow=c(3,3), mar=c(4.2,3.9,0.4,0.1), oma=c(1.5,0.5,0.1,0.1))

lab.text = c(expression(bold("Muntjac")), 
             expression(bold("Tapir")), 
             expression(bold("Macaque")), 
             expression(bold("Muntjac")), 
             expression(bold("Tapir")), 
             expression(bold("Macaque")), 
             expression(bold("Muntjac")), 
             expression(bold("Tapir")), 
             expression(bold("Macaque")))


lab.text2 = c(" = 0.72 (0.57-0.79)", 
              " = 0.62 (0.47-0.74)", 
              " = 0.42 (0.32-0.49)", 
              " = 0.73 (0.53-0.80)", 
              " = 0.48 (0.33-0.59)", 
              " = 0.40 (0.26-0.52)", 
              " = 0.78 (0.53-0.81)", 
              " = 0.42 (0.27-0.51)", 
              " = 0.74 (0.56-0.80)")

lab.xaxis = c("", "", "", "", "", "", "Time of day", "Time of day", "Time of day")

cval = 1
for (j in 2:4) {
    fsubset = (ftiger %in% j)
    ztig = kplot( times[[1]][fsubset], kmax, cval)

    fsubset = (fmuntjac %in% j)
    z = kplot( times[[2]][fsubset], kmax, cval)
    plot(z$x, z$y/24, type="l", ylim=c(0,0.16), xlab=lab.xaxis[3*j-5], ylab="Density of activity", xaxt="n")
    rug(as.vector(times[[2]][fsubset])/(2*pi))
    zmin = pmin(z$y, ztig$y)/24
    polygon(c(0,ztig$x,1,0), c(0,zmin,0,0), col="grey", density=-1, border=NA)
    lines(z$x, z$y/24)
    lines(ztig$x, ztig$y/24, lty="dashed")
    axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))
    text(0.02, 0.15, lab.text[3*j-5], adj=c(0,0))
    text(0.02, 0.13, expression(hat(Delta)[4]), adj=c(0,0))
    text(0.084, 0.132, lab.text2[3*j-5], adj=c(0,0))

    fsubset = (ftapir %in% j)
    z = kplot( times[[4]][fsubset], kmax, cval)
    plot(z$x, z$y/24, type="l", ylim=c(0,.16), xlab=lab.xaxis[3*j-4], ylab="", xaxt="n")
    rug(as.vector(times[[4]][fsubset])/(2*pi))
    zmin = pmin(z$y, ztig$y)/24
    polygon(c(0,ztig$x,1,0), c(0,zmin,0,0), col="grey", density=-1, border=NA)
    lines(z$x, z$y/24)
    lines(ztig$x, ztig$y/24, lty="dashed")
    axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))
    text(0.02, 0.15, lab.text[3*j-4], adj=c(0,0))
    text(0.02, 0.13, expression(hat(Delta)[4]), adj=c(0,0))
    text(0.084, 0.132, lab.text2[3*j-4], adj=c(0,0))


    fsubset = (fmacaque %in% j)
    z = kplot( times[[8]][fsubset], kmax, cval)
    plot(z$x, z$y/24, type="l", ylim=c(0,0.16), xlab=lab.xaxis[3*j-3], ylab="", xaxt="n")
    rug(as.vector(times[[8]][fsubset])/(2*pi))
    zmin = pmin(z$y, ztig$y)/24
    polygon(c(0,ztig$x,1,0), c(0,zmin,0,0), col="grey", density=-1, border=NA)
    lines(z$x, z$y/24)
    lines(ztig$x, ztig$y/24, lty="dashed")
    axis(1, at=c(0,0.25,0.5,0.75,1), labels=c("0:00", "6:00", "12:00", "18:00", "24:00"))
    text(0.02, 0.15, lab.text[3*j-3], adj=c(0,0))
    text(0.02, 0.13, expression(hat(Delta)[4]), adj=c(0,0))
    text(0.084, 0.132, lab.text2[3*j-3], adj=c(0,0))
}
