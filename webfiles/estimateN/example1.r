##============================================
## Example 1
##
## This produces the initial example from the
## user guide and the later detailed output
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

   ##---------------
   ## Fit all models
   ##---------------
fitallmodels(skinks, kskinks)

   ##---------------------
   ## Fit a specific model
   ##---------------------
fitonemodel( skinks, kskinks, model="twobin", nrandstart=25)