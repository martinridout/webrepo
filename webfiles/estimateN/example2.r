##============================================
## Example 2
##
## This produces the 2x2 plot of profiles that
## appears in the user guide to the software
##============================================

   ##-----------------
   ## Get the software
   ##-----------------
source("estimateN.r")

   ##-----
   ## Data
   ##-----
skinks = c(56, 19, 28, 18, 24, 14, 9)
kskinks = 7
link3 = c(679, 531, 379, 272, 198, 143, 99, 67, 46,
          32, 22, 14, 9, 5, 3, 1, 0, 0, 0, 0)
klink3 = 20

   ##---------------------
   ## For the graph layout
   ##---------------------
par(mfrow=c(2,2), mar=c(4.5,4,1.5,1.5), oma=c(1.25,1.25,1.25,1.25))

   ##---------------------------------------------------------
   ## Produce the figures. The set.seed call is only needed
   ## if you want to ensure exactly the same figures as appear
   ## in the user guide. You might want to explore if/how the
   ## profiles change if you change the seed
   ##---------------------------------------------------------
set.seed(12345)
fitonemodel(skinks, kskinks, model="twobin", nrandstart=20,
logn0values=seq(-4,8,length.out=20), nrandprof=10) 

set.seed(12345)
fitonemodel(link3, klink3, model="binbbin", nrandstart=20,
logn0values=seq(5,11,length.out=20), nrandprof=10)

set.seed(12345)
fitonemodel(link3, klink3, model="binbbin", nrandstart=20,
logn0values=seq(5,11,length.out=20), nrandprof=20)

set.seed(12345)
fitonemodel(link3, klink3, model="binbbin", nrandstart=20,
logn0values=seq(5,11,length.out=20), nrandprof=50)