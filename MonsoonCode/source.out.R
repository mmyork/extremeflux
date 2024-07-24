################################################################################
# Model: Out of season reco source

### Bring in necessary packages
setwd("/scratch/my464/cflux")

### Bring in necessary packages
# .libPaths(c("/scratch/my464/R", .libPaths()))
# print(.libPaths())

# pacman::p_load("randomForestSRC")
library(randomForestSRC)
# 
# # Retrieve the second argument passed as an argument
# args <- as.numeric(commandArgs(trailingOnly = TRUE))
# k <- args[1]
# param <-args[2]
################################################################################

# read in files
load("./data/bindat.out.R")
print("tada!")

# identify variables of interest for running each NEE state 
vnamessource <- colnames(bindat.out)[c(44,11,7:10,14:41)]
print("good var")

# run NEE models
set.seed(76786+12366)

source.out <- imbalanced.rfsrc(source ~.,data=bindat.out[vnamessource], na.action="na.omit",
                               method="rfq",importance="permute",block.size=1,
                               perf.type="misclass")
save(source.out,file="./results/source.out.R")
e.out,file="./results/source.out.R")
