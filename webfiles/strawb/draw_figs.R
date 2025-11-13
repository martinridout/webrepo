x1 = 0
y1 = 0.25
r = c(0.25, 0.13, 0.05)
ang = pi / c(4, 3.5, 5)
siz = 6:3
w0 = 5
w1 = 4
w2 = 3
w3 = 2

# Level 1 flowers
x1b = 0
y1b = 0.55

# Level 2 flowers
x2 = x1 + r[1] * cos(ang[1])
y2 = y1 + r[1] * sin(ang[1])

# Level 3 flowers
x2mid = (x1+x2)/2
y2mid = (y1+y2)/2
x3 = (x1+x2)/2 + r[2] * cos(ang[1]+ang[2])
x4 = (x1+x2)/2 + r[2] * cos(ang[1]-ang[2])
y3 = (y1+y2)/2 + r[2] * sin(ang[1]+ang[2])
y4 = (y1+y2)/2 + r[2] * sin(ang[1]-ang[2])

# Level 4 flowers
x3mid = (x2mid + x3) / 2
x4mid = (x2mid + x4) / 2
y3mid = (y2mid + y3) / 2
y4mid = (y2mid + y4) / 2
x5 = x3mid + r[3] * cos(ang[1]+ang[2]+ang[3])
x6 = x3mid + r[3] * cos(ang[1]+ang[2]-ang[3])
x7 = x4mid + r[3] * cos(ang[1]-ang[2]+ang[3])
x8 = x4mid + r[3] * cos(ang[1]-ang[2]-ang[3])
y5 = y3mid + r[3] * sin(ang[1]+ang[2]+ang[3])
y6 = y3mid + r[3] * sin(ang[1]+ang[2]-ang[3])
y7 = y4mid + r[3] * sin(ang[1]-ang[2]+ang[3])
y8 = y4mid + r[3] * sin(ang[1]-ang[2]-ang[3])

# Draw full inflorescence
png(filename="strawb1.png")
dev.off()

# Main branch and rank 1 flower
plot(c(0,x1b), c(0,y1b), xlim=c(-0.28, 0.28), ylim=c(0,0.56), axes=FALSE, xlab="", ylab="",
     type="l", col="green", lwd=w0)
points(x1b, y1b, pch=20, cex=siz[1], col="red")

# Rank 2 branches and flowers
x=c(0,x1, -x2, x1, x2)
y=c(0,y1, y2, y1, y2)
lines(c(x1,x2), c(y1,y2), col="green", lwd=w1)
lines(-c(x1,x2), c(y1,y2), col="green", lwd=w1)
points(c(-x2,x2), c(y2,y2), pch=20, cex=siz[2], col="red")

# Rank 3 branches and flowers
lines(c(x2mid, x3, x2mid, x4), c(y2mid, y3, y2mid, y4), col="green", lwd=3)
lines(-c(x2mid, x3, x2mid, x4), c(y2mid, y3, y2mid, y4), col="green", lwd=3)
points(c(-x3,-x4,x3,x4), c(y3,y4,y3,y4), pch=20, cex=siz[3], col="red")

# Rank 4 branches and flowers
lines(c(x3mid, x5, x3mid, x6), c(y3mid, y5, y3mid, y6), col="green", lwd=w3)
lines(c(x4mid, x7, x4mid, x8), c(y4mid, y7, y4mid, y8), col="green", lwd=w3)
lines(-c(x3mid, x5, x3mid, x6), c(y3mid, y5, y3mid, y6), col="green", lwd=w3)
lines(-c(x4mid, x7, x4mid, x8), c(y4mid, y7, y4mid, y8), col="green", lwd=w3)
points(c(x5,x6,x7,x8), c(y5,y6,y7,y8), col="red", pch=20, cex=siz[4])
points(-c(x5,x6,x7,x8), c(y5,y6,y7,y8), col="red", pch=20, cex=siz[4])


