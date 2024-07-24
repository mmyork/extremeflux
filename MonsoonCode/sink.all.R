################################################################################
# Model: Full year strong gpp sink

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
load("./data/bindat.all.R")
print("tada!")

# identify variables of interest for running each NEE state 
vnamessink <- colnames(bindat.all)[c(43,11,7:10,14:41)]
print("good var")

# run NEE models
set.seed(76786+12366)

sink.all <- imbalanced.rfsrc(sink ~.,data=bindat.all[vnamessink], na.action="na.omit",
                             method="rfq",importance="permute",block.size=1,
                             perf.type="misclass")

save(sink.all,file="./results/sink.all.results.RData")
saveRDS(sink.all,file="./results/sink.all.results.rds")
save(sink.all,file="./results/sink.all.results.R")


