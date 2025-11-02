##==========================================================
## This program sets up the tiger-prey camera trap data and
## loads functions that are needed for subsequent analysis
##
## Note: You need to have 2 additional R packages installed,
##               boot   and   circular
##
##       If you get an error message saying that these are
##       not installed, use the R command
##               install.packages( c("boot", "circular))
##       to install them.
##
##       Alternatively, you can use Load packages ...
##       on the Packages menu.
##==========================================================


    ##--------------------------------------------------
    ## Read the contents of a file that contains various 
    ## functions that are used in the analysis
    ##
    ## Note that this requires two additional R packages
    ## boot and circular  
    ##--------------------------------------------------
source("ovlcode.r")


   ##----------------------------------------------------------
   ## Read the raw data and create a variable for each species, 
   ## in circular format and with missing values removed
   ##
   ## In the data file there is a column for each species
   ##----------------------------------------------------------
rawtimes <- read.table("traptimes.txt")
times <- list(1)
for (j in c(1,2,3,4,5,6,7,8)) {
    tmp <- circular(2*pi*na.omit(rawtimes[,j]))
    times[[j]] <- tmp
}

ow <- options("warn")
options(warn = -1)
tiger = as.circular(na.omit(as.vector(times[[1]])))
muntjac = as.circular(na.omit(as.vector(times[[2]])))
sambar = as.circular(na.omit(as.vector(times[[3]])))
tapir = as.circular(na.omit(as.vector(times[[4]])))
boar = as.circular(na.omit(as.vector(times[[5]])))
clouded = as.circular(na.omit(as.vector(times[[6]])))
golden = as.circular(na.omit(as.vector(times[[7]])))
macaque = as.circular(na.omit(as.vector(times[[8]])))
options(ow) # reset


    ##-------------------------------------------
    ## Set up the site indicator for each species
    ## (camera trap records come from 4 sites)
    ##-------------------------------------------
ftiger = c(rep(1,15), rep(2,83), rep(3,52), rep(4,51))
fmuntjac = c(rep(1,11), rep(2,99), rep(3,61), rep(4,29))
fsambar = c(rep(1,1), rep(2,14), rep(3,5), rep(4,5))
ftapir = c(rep(1,13), rep(2,61), rep(3,42), rep(4,65))
fboar = c(rep(2,7), rep(3,6), rep(4,15))
fclouded = c(rep(1,27), rep(2,10), rep(3,17), rep(4,32))
fgolden = c(rep(1,14), rep(2,26), rep(3,38), rep(4,26))
fmacaque = c(rep(1,23), rep(2,125), rep(3,59), rep(4,66))

