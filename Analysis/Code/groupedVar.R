setwd("C:/Users/my464/Desktop/carbon_fluxes/modelResults")

# this is a seperate file to run the grouped vimp for just the model
# I am going to be grouping it by mean and standard deviation this time

# loading in the models
load("mod1.mpj.R")
load("mod1.wjs.R")
load("mod1.seg.R")
load("mod1.ses.R")
load("mod1.vcp.R")
load("mod1.vcs.R")
load("mod1.sr.R")

load("mod2.mpj.R")
load("mod2.wjs.R")
load("mod2.seg.R")
load("mod2.ses.R")
load("mod2.vcp.R")
load("mod2.vcs.R")
load("mod2.sr.R")

###########################
### Grouping Variables ####
###########################

# first I am going to group the variables by their environmental type
group.TA <- c("TA_avg","TA_avg_1","TA_avg_7","TA_avg_30","TA_avg_365",
              "TA_avg_sd_7","TA_avg_sd_30","TA_avg_sd_365")

group.P <- c("P_int","P_int_1","P_int_7","P_int_30","P_int_365",
             "P_int_sd_7","TA_int_sd_30","TA_int_sd_365")

group.SW <- c("SW_IN_avg","SW_IN_avg_1","SW_IN_avg_7","SW_IN_avg_30","SW_IN_avg_365",
              "SW_IN_avg_sd_7","SW_IN_avg_sd_30","SW_IN_avg_sd_365")

group.SWC <- c("SWC_avg","SWC_avg_1","SWC_avg_7","SWC_avg_30","SWC_avg_365",
               "SWC_avg_sd_7","SWC_avg_sd_30","SWC_avg_sd_365")

group.VPD <- c("VPD_avg","VPD_avg_1","VPD_avg_7","VPD_avg_30","VPD_avg_365",
               "VPD_avg_sd_7","VPD_avg_sd_30","VPD_avg_sd_365")

group.NEE <- c("NEE_state","NEE_state_1","NEE_state_7","NEE_state_30","NEE_state_365",
               "NEE_state_sd_7","NEE_state_sd_30","NEE_state_sd_365")

type.vimpgroups <- list(group.TA,group.P,group.SW,group.SWC,group.VPD,group.NEE)
names(type.vimpgroups) <- c("group.TA","group.P","group.SW","group.SWC","group.VPD","group.NEE")

# now I am going to group variables by their timescales, except I will leave out NEE
# should this be done with or without sd?
group.0 <- c("TA_avg","P_int","SW_IN_avg","SWC_avg","VPD_avg")

group.1 <- c("TA_avg_1","P_int_1","SW_IN_avg_1","SWC_avg_1","VPD_avg_1")

group.7 <- c("TA_avg_7","P_int_7","SW_IN_avg_7","SWC_avg_7","VPD_avg_7",
             "TA_avg_sd_7","P_int_sd_7","SW_IN_avg_sd_7","SWC_avg_sd_7","VPD_avg_sd_7")

group.30 <- c("TA_avg_30","P_int_30","SW_IN_avg_30","SWC_avg_30","VPD_avg_30",
              "TA_avg_sd_30","P_int_sd_30","SW_IN_avg_sd_30","SWC_avg_sd_30","VPD_avg_sd_30")

group.365 <- c("TA_avg_365","P_int_365","SW_IN_avg_365","SWC_avg_365","VPD_avg_365",
               "TA_avg_sd_365","P_int_sd_365","SW_IN_avg_sd_365","SWC_avg_sd_365","VPD_avg_sd_365")

lag.vimpgroups <- list(group.0,group.1,group.7,group.30,group.365)
names(lag.vimpgroups) <- c("group.0","group.1","group.7","group.30","group.365")

# getting joint variable importances with vimp()
# running for each state/site. waiting to do inactive since it needs to be fixed.

############# Variable groups by type (eg TA,P,SWC,...) ########################
parallel::detectCores()
set.seed(443112+198829)

# model 1: site mpj, strong sink vs other
system.time(type.vimp.mpj1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.mpj, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.mpj1)<- names(type.vimpgroups)

# model 2: site wjs, strong sink vs other
system.time(type.vimp.wjs1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.wjs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.wjs1)<- names(type.vimpgroups)

# model 3: site seg, strong sink vs other
system.time(type.vimp.seg1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.seg, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.seg1)<- names(type.vimpgroups)

# model 4: site ses, strong sink vs other
system.time(type.vimp.ses1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.ses, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.ses1)<- names(type.vimpgroups)

# model 5: site vcp, strong sink vs others
system.time(type.vimp.vcp1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.vcp, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcp1)<- names(type.vimpgroups)

# model 6: site vcs, strong sink vs others
system.time(type.vimp.vcs1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.vcs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcs1)<- names(type.vimpgroups)

# model 7: site sr, strong sink vs other
system.time(type.vimp.sr1 <- mclapply(type.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.sr, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(type.vimp.sr1)<- names(type.vimpgroups)

# now that the strong sink vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

type.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.mpj.joint <- rbind(type.mpj.joint,type.vimp.mpj1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.mpj.joint <- data.frame(type.mpj.joint[-1,])
type.mpj.joint <- cbind(var = names(type.vimpgroups), type.mpj.joint)
rownames(type.mpj.joint) <- NULL

type.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.wjs.joint <- rbind(type.wjs.joint,type.vimp.wjs1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.wjs.joint <- data.frame(type.wjs.joint[-1,])
type.wjs.joint <- cbind(var = names(type.vimpgroups), type.wjs.joint)
rownames(type.wjs.joint) <- NULL

type.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.seg.joint <- rbind(type.seg.joint,type.vimp.seg1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.seg.joint <- data.frame(type.seg.joint[-1,])
type.seg.joint <- cbind(var = names(type.vimpgroups), type.seg.joint)
rownames(type.seg.joint) <- NULL

type.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.ses.joint <- rbind(type.ses.joint,type.vimp.ses1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.ses.joint <- data.frame(type.ses.joint[-1,])
type.ses.joint <- cbind(var = names(type.vimpgroups), type.ses.joint)
rownames(type.ses.joint) <- NULL

type.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcp.joint <- rbind(type.vcp.joint,type.vimp.vcp1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcp.joint <- data.frame(type.vcp.joint[-1,])
type.vcp.joint <- cbind(var = names(type.vimpgroups), type.vcp.joint)
rownames(type.vcp.joint) <- NULL

type.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcs.joint <- rbind(type.vcs.joint,type.vimp.vcs1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcs.joint <- data.frame(type.vcs.joint[-1,])
type.vcs.joint <- cbind(var = names(type.vimpgroups), type.vcs.joint)
rownames(type.vcs.joint) <- NULL

type.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.sr.joint <- rbind(type.sr.joint,type.vimp.sr1[[names(type.vimpgroups)[i]]][["importance"]])
}
type.sr.joint <- data.frame(type.sr.joint[-1,])
type.sr.joint <- cbind(var = names(type.vimpgroups), type.sr.joint)
rownames(type.sr.joint) <- NULL

# now I am going to distinguish site id and combine all the output into one dataframe

type.mpj.joint$SiteID <- rep("MPJ",6)
type.wjs.joint$SiteID <- rep("WJS",6)
type.seg.joint$SiteID <- rep("SEG",6)
type.ses.joint$SiteID <- rep("SES",6)
type.vcp.joint$SiteID <- rep("VCP",6)
type.vcs.joint$SiteID <- rep("VCS",6)
type.sr.joint$SiteID <- rep("SR",6)

type.vimp.mod1 <- rbind(type.mpj.joint,type.wjs.joint,type.seg.joint,
                        type.ses.joint,type.vcp.joint,type.vcs.joint,type.sr.joint)

save(type.vimp.mod1,file="type.vimp.mod1.R")
write.csv(type.vimp.mod1,"type.vimp.mod1.csv")

# next is strong source across all sites
system.time(type.vimp.mpj2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.mpj, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.mpj2)<- names(type.vimpgroups)

system.time(type.vimp.wjs2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.wjs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.wjs2)<- names(type.vimpgroups)

system.time(type.vimp.seg2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.seg, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.seg2)<- names(type.vimpgroups)

system.time(type.vimp.ses2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.ses, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.ses2)<- names(type.vimpgroups)

system.time(type.vimp.vcp2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.vcp, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcp2)<- names(type.vimpgroups)

system.time(type.vimp.vcs2 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod2.vcs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcs2)<- names(type.vimpgroups)

system.time(type.vimp.sr2 <- mclapply(type.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.sr, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(type.vimp.sr2)<- names(type.vimpgroups)

# now that the strong source vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

type.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.mpj.joint <- rbind(type.mpj.joint,type.vimp.mpj2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.mpj.joint <- data.frame(type.mpj.joint[-1,])
type.mpj.joint <- cbind(var = names(type.vimpgroups), type.mpj.joint)
rownames(type.mpj.joint) <- NULL

type.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.wjs.joint <- rbind(type.wjs.joint,type.vimp.wjs2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.wjs.joint <- data.frame(type.wjs.joint[-1,])
type.wjs.joint <- cbind(var = names(type.vimpgroups), type.wjs.joint)
rownames(type.wjs.joint) <- NULL

type.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.seg.joint <- rbind(type.seg.joint,type.vimp.seg2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.seg.joint <- data.frame(type.seg.joint[-1,])
type.seg.joint <- cbind(var = names(type.vimpgroups), type.seg.joint)
rownames(type.seg.joint) <- NULL

type.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.ses.joint <- rbind(type.ses.joint,type.vimp.ses2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.ses.joint <- data.frame(type.ses.joint[-1,])
type.ses.joint <- cbind(var = names(type.vimpgroups), type.ses.joint)
rownames(type.ses.joint) <- NULL

type.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcp.joint <- rbind(type.vcp.joint,type.vimp.vcp2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcp.joint <- data.frame(type.vcp.joint[-1,])
type.vcp.joint <- cbind(var = names(type.vimpgroups), type.vcp.joint)
rownames(type.vcp.joint) <- NULL

type.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcs.joint <- rbind(type.vcs.joint,type.vimp.vcs2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcs.joint <- data.frame(type.vcs.joint[-1,])
type.vcs.joint <- cbind(var = names(type.vimpgroups), type.vcs.joint)
rownames(type.vcs.joint) <- NULL

type.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.sr.joint <- rbind(type.sr.joint,type.vimp.sr2[[names(type.vimpgroups)[i]]][["importance"]])
}
type.sr.joint <- data.frame(type.sr.joint[-1,])
type.sr.joint <- cbind(var = names(type.vimpgroups), type.sr.joint)
rownames(type.sr.joint) <- NULL

# now I am going to distinguish site id and combine all the output into one dataframe

type.mpj.joint$SiteID <- rep("MPJ",6)
type.wjs.joint$SiteID <- rep("WJS",6)
type.seg.joint$SiteID <- rep("SEG",6)
type.ses.joint$SiteID <- rep("SES",6)
type.vcp.joint$SiteID <- rep("VCP",6)
type.vcs.joint$SiteID <- rep("VCS",6)
type.sr.joint$SiteID <- rep("SR",6)

type.vimp.mod2 <- rbind(type.mpj.joint,type.wjs.joint,type.seg.joint,
                        type.ses.joint,type.vcp.joint,type.vcs.joint,type.sr.joint)

save(type.vimp.mod2,file="type.vimp.mod2.R")
write.csv(type.vimp.mod2,"type.vimp.mod2.csv")


# next is inactive across all sites
system.time(type.vimp.mpj3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.mpj, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.mpj3)<- names(type.vimpgroups)

system.time(type.vimp.wjs3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.wjs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.wjs3)<- names(type.vimpgroups)

system.time(type.vimp.seg3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.seg, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.seg3)<- names(type.vimpgroups)

system.time(type.vimp.ses3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.ses, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.ses3)<- names(type.vimpgroups)

system.time(type.vimp.vcp3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.vcp, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcp3)<- names(type.vimpgroups)

system.time(type.vimp.vcs3 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod3.vcs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(type.vimp.vcs3)<- names(type.vimpgroups)

system.time(type.vimp.sr3 <- mclapply(type.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod3.sr, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(type.vimp.sr3)<- names(type.vimpgroups)

# now that the inactive vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

type.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.mpj.joint <- rbind(type.mpj.joint,type.vimp.mpj3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.mpj.joint <- data.frame(type.mpj.joint[-1,])
type.mpj.joint <- cbind(var = names(type.vimpgroups), type.mpj.joint)
rownames(type.mpj.joint) <- NULL

type.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.wjs.joint <- rbind(type.wjs.joint,type.vimp.wjs3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.wjs.joint <- data.frame(type.wjs.joint[-1,])
type.wjs.joint <- cbind(var = names(type.vimpgroups), type.wjs.joint)
rownames(type.wjs.joint) <- NULL

type.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.seg.joint <- rbind(type.seg.joint,type.vimp.seg3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.seg.joint <- data.frame(type.seg.joint[-1,])
type.seg.joint <- cbind(var = names(type.vimpgroups), type.seg.joint)
rownames(type.seg.joint) <- NULL

type.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.ses.joint <- rbind(type.ses.joint,type.vimp.ses3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.ses.joint <- data.frame(type.ses.joint[-1,])
type.ses.joint <- cbind(var = names(type.vimpgroups), type.ses.joint)
rownames(type.ses.joint) <- NULL

type.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcp.joint <- rbind(type.vcp.joint,type.vimp.vcp3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcp.joint <- data.frame(type.vcp.joint[-1,])
type.vcp.joint <- cbind(var = names(type.vimpgroups), type.vcp.joint)
rownames(type.vcp.joint) <- NULL

type.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.vcs.joint <- rbind(type.vcs.joint,type.vimp.vcs3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.vcs.joint <- data.frame(type.vcs.joint[-1,])
type.vcs.joint <- cbind(var = names(type.vimpgroups), type.vcs.joint)
rownames(type.vcs.joint) <- NULL

type.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  type.sr.joint <- rbind(type.sr.joint,type.vimp.sr3[[names(type.vimpgroups)[i]]][["importance"]])
}
type.sr.joint <- data.frame(type.sr.joint[-1,])
type.sr.joint <- cbind(var = names(type.vimpgroups), type.sr.joint)
rownames(type.sr.joint) <- NULL

# now I am going to distinguish site id and combine all the output into one dataframe

type.mpj.joint$SiteID <- rep("MPJ",6)
type.wjs.joint$SiteID <- rep("WJS",6)
type.seg.joint$SiteID <- rep("SEG",6)
type.ses.joint$SiteID <- rep("SES",6)
type.vcp.joint$SiteID <- rep("VCP",6)
type.vcs.joint$SiteID <- rep("VCS",6)
type.sr.joint$SiteID <- rep("SR",6)

type.vimp.mod3 <- rbind(type.mpj.joint,type.wjs.joint,type.seg.joint,
                        type.ses.joint,type.vcp.joint,type.vcs.joint,type.sr.joint)

save(type.vimp.mod3,file="type.vimp.mod3.R")
write.csv(type.vimp.mod3,"type.vimp.mod3.csv")


###################### Lagged grouped variables ################################
parallel::detectCores()
set.seed(447852+192299)

# model 1: site mpj, strong sink vs other
system.time(lag.vimp.mpj1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.mpj, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.mpj1)<- names(lag.vimpgroups)

# model 2: site wjs, strong sink vs other
system.time(lag.vimp.wjs1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.wjs, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.wjs1)<- names(lag.vimpgroups)

# model 3: site seg, strong sink vs other
system.time(lag.vimp.seg1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.seg, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.seg1)<- names(lag.vimpgroups)

# model 4: site ses, strong sink vs other
system.time(lag.vimp.ses1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.ses, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.ses1)<- names(lag.vimpgroups)

# model 5: site vcp, strong sink vs others
system.time(lag.vimp.vcp1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.vcp, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.vcp1)<- names(lag.vimpgroups)

# model 6: site vcs, strong sink vs others
system.time(lag.vimp.vcs1 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.vcs, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.vcs1)<- names(lag.vimpgroups)

system.time(lag.vimp.sr1 <- mclapply(lag.vimpgroups,
                                     FUN=function(group)
                                     {
                                       vimp(mod1.sr, xvar.names=group,
                                            importance="permute",
                                            joint=TRUE)
                                     }))
names(lag.vimp.sr1)<- names(lag.vimpgroups)

# now that the strong sink vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

lag.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.mpj.joint <- rbind(lag.mpj.joint,lag.vimp.mpj1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.mpj.joint <- data.frame(lag.mpj.joint[-1,])
lag.mpj.joint <- cbind(var = names(lag.vimpgroups), lag.mpj.joint)
rownames(lag.mpj.joint) <- NULL

lag.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.wjs.joint <- rbind(lag.wjs.joint,lag.vimp.wjs1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.wjs.joint <- data.frame(lag.wjs.joint[-1,])
lag.wjs.joint <- cbind(var = names(lag.vimpgroups), lag.wjs.joint)
rownames(lag.wjs.joint) <- NULL

lag.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.seg.joint <- rbind(lag.seg.joint,lag.vimp.seg1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.seg.joint <- data.frame(lag.seg.joint[-1,])
lag.seg.joint <- cbind(var = names(lag.vimpgroups), lag.seg.joint)
rownames(lag.seg.joint) <- NULL

lag.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.ses.joint <- rbind(lag.ses.joint,lag.vimp.ses1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.ses.joint <- data.frame(lag.ses.joint[-1,])
lag.ses.joint <- cbind(var = names(lag.vimpgroups), lag.ses.joint)
rownames(lag.ses.joint) <- NULL

lag.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.vcp.joint <- rbind(lag.vcp.joint,lag.vimp.vcp1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.vcp.joint <- data.frame(lag.vcp.joint[-1,])
lag.vcp.joint <- cbind(var = names(lag.vimpgroups), lag.vcp.joint)
rownames(lag.vcp.joint) <- NULL

lag.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.vcs.joint <- rbind(lag.vcs.joint,lag.vimp.vcs1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.vcs.joint <- data.frame(lag.vcs.joint[-1,])
lag.vcs.joint <- cbind(var = names(lag.vimpgroups), lag.vcs.joint)
rownames(lag.vcs.joint) <- NULL

lag.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.sr.joint <- rbind(lag.sr.joint,lag.vimp.sr1[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.sr.joint <- data.frame(lag.sr.joint[-1,])
lag.sr.joint <- cbind(var = names(lag.vimpgroups), lag.sr.joint)
rownames(lag.sr.joint) <- NULL


# now I am going to distinguish site id and combine all the output into one dataframe

lag.mpj.joint$SiteID <- rep("MPJ",5)
lag.wjs.joint$SiteID <- rep("WJS",5)
lag.seg.joint$SiteID <- rep("SEG",5)
lag.ses.joint$SiteID <- rep("SES",5)
lag.vcp.joint$SiteID <- rep("VCP",5)
lag.vcs.joint$SiteID <- rep("VCS",5)
lag.sr.joint$SiteID <- rep("SR",5)


lag.vimp.mod1 <- rbind(lag.mpj.joint,lag.wjs.joint,lag.seg.joint,
                       lag.ses.joint,lag.vcp.joint,lag.vcs.joint,lag.sr.joint)

save(lag.vimp.mod1,file="lag.vimp.mod1.R")
write.csv(lag.vimp.mod1,"lag.vimp.mod1.csv")

# next is strong source across all sites
system.time(lag.vimp.mpj2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.mpj, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.mpj2)<- names(lag.vimpgroups)

system.time(lag.vimp.wjs2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.wjs, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.wjs2)<- names(lag.vimpgroups)

system.time(lag.vimp.seg2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.seg, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.seg2)<- names(lag.vimpgroups)

system.time(lag.vimp.ses2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.ses, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.ses2)<- names(lag.vimpgroups)

system.time(lag.vimp.vcp2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.vcp, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.vcp2)<- names(lag.vimpgroups)

system.time(lag.vimp.vcs2 <- mclapply(lag.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod2.vcs, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(lag.vimp.vcs2)<- names(lag.vimpgroups)

system.time(lag.vimp.sr2 <- mclapply(lag.vimpgroups,
                                     FUN=function(group)
                                     {
                                       vimp(mod2.sr, xvar.names=group,
                                            importance="permute",
                                            joint=TRUE)
                                     }))
names(lag.vimp.sr2) <- names(lag.vimpgroups)
# now that the strong source vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

lag.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.mpj.joint <- rbind(lag.mpj.joint,lag.vimp.mpj2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.mpj.joint <- data.frame(lag.mpj.joint[-1,])
lag.mpj.joint <- cbind(var = names(lag.vimpgroups), lag.mpj.joint)
rownames(lag.mpj.joint) <- NULL

lag.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.wjs.joint <- rbind(lag.wjs.joint,lag.vimp.wjs2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.wjs.joint <- data.frame(lag.wjs.joint[-1,])
lag.wjs.joint <- cbind(var = names(lag.vimpgroups), lag.wjs.joint)
rownames(lag.wjs.joint) <- NULL

lag.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.seg.joint <- rbind(lag.seg.joint,lag.vimp.seg2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.seg.joint <- data.frame(lag.seg.joint[-1,])
lag.seg.joint <- cbind(var = names(lag.vimpgroups), lag.seg.joint)
rownames(lag.seg.joint) <- NULL

lag.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.ses.joint <- rbind(lag.ses.joint,lag.vimp.ses2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.ses.joint <- data.frame(lag.ses.joint[-1,])
lag.ses.joint <- cbind(var = names(lag.vimpgroups), lag.ses.joint)
rownames(lag.ses.joint) <- NULL

lag.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.vcp.joint <- rbind(lag.vcp.joint,lag.vimp.vcp2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.vcp.joint <- data.frame(lag.vcp.joint[-1,])
lag.vcp.joint <- cbind(var = names(lag.vimpgroups), lag.vcp.joint)
rownames(lag.vcp.joint) <- NULL

lag.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.vcs.joint <- rbind(lag.vcs.joint,lag.vimp.vcs2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.vcs.joint <- data.frame(lag.vcs.joint[-1,])
lag.vcs.joint <- cbind(var = names(lag.vimpgroups), lag.vcs.joint)
rownames(lag.vcs.joint) <- NULL

lag.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(lag.vimpgroups))){
  lag.sr.joint <- rbind(lag.sr.joint,lag.vimp.sr2[[names(lag.vimpgroups)[i]]][["importance"]])
}
lag.sr.joint <- data.frame(lag.sr.joint[-1,])
lag.sr.joint <- cbind(var = names(lag.vimpgroups), lag.sr.joint)
rownames(lag.sr.joint) <- NULL

# now I am going to distinguish site id and combine all the output into one dataframe

lag.mpj.joint$SiteID <- rep("MPJ",5)
lag.wjs.joint$SiteID <- rep("WJS",5)
lag.seg.joint$SiteID <- rep("SEG",5)
lag.ses.joint$SiteID <- rep("SES",5)
lag.vcp.joint$SiteID <- rep("VCP",5)
lag.vcs.joint$SiteID <- rep("VCS",5)
lag.sr.joint$SiteID <- rep("SR",5)

lag.vimp.mod2 <- rbind(lag.mpj.joint,lag.wjs.joint,lag.seg.joint,
                       lag.ses.joint,lag.vcp.joint,lag.vcs.joint,lag.sr.joint)

save(lag.vimp.mod2,file="lag.vimp.mod2.R")
write.csv(lag.vimp.mod2,"lag.vimp.mod2.csv")

################################################
######## Further goruped by mean and sd ########
################################################

# first I am going to group each variable by 2 layers, their environmental type
# and whether its the standard deviation or the mean
group.TA.mean <- c("TA_avg","TA_avg_1","TA_avg_7","TA_avg_30","TA_avg_365")
group.TA.sd <- c("TA_avg_sd_7","TA_avg_sd_30","TA_avg_sd_365")

group.P.mean <- c("P_int","P_int_1","P_int_7","P_int_30","P_int_365")
group.P.sd <- c("P_int_sd_7","TA_int_sd_30","TA_int_sd_365")

group.SW.mean <- c("SW_IN_avg","SW_IN_avg_1","SW_IN_avg_7","SW_IN_avg_30","SW_IN_avg_365")
group.SW.sd <- c("SW_IN_avg_sd_7","SW_IN_avg_sd_30","SW_IN_avg_sd_365")

group.SWC.mean <- c("SWC_avg","SWC_avg_1","SWC_avg_7","SWC_avg_30","SWC_avg_365")
group.SWC.sd <- c("SWC_avg_sd_7","SWC_avg_sd_30","SWC_avg_sd_365")

group.VPD.mean <- c("VPD_avg","VPD_avg_1","VPD_avg_7","VPD_avg_30","VPD_avg_365")
group.VPD.sd <- c("VPD_avg_sd_7","VPD_avg_sd_30","VPD_avg_sd_365")

group.NEE.mean <- c("NEE_state","NEE_state_1","NEE_state_7","NEE_state_30","NEE_state_365")
group.NEE.sd <- c( "NEE_state_sd_7","NEE_state_sd_30","NEE_state_sd_365")

type.vimpgroups <- list(group.TA.mean,group.P.mean,group.SW.mean,group.SWC.mean,
                        group.VPD.mean,group.NEE.mean,group.TA.sd,group.P.sd,
                        group.SW.sd,group.SWC.sd,group.VPD.sd,group.NEE.sd)

names(type.vimpgroups) <- c("group.TA.mean","group.P.mean","group.SW.mean","group.SWC.mean",
                            "group.VPD.mean","group.NEE.mean","group.TA.sd","group.P.sd",
                            "group.SW.sd","group.SWC.sd","group.VPD.sd","group.NEE.sd")

# Now I am going to run the grouped variable importances
parallel::detectCores()
set.seed(26322+88127)

# model 1: site mpj, strong sink vs other
system.time(splitType.vimp.mpj1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.mpj, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.mpj1)<- names(type.vimpgroups)

# model 2: site wjs, strong sink vs other
system.time(splitType.vimp.wjs1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.wjs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.wjs1)<- names(type.vimpgroups)

# model 3: site seg, strong sink vs other
system.time(splitType.vimp.seg1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.seg, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.seg1)<- names(type.vimpgroups)

# model 4: site ses, strong sink vs other
system.time(splitType.vimp.ses1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.ses, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.ses1)<- names(type.vimpgroups)

# model 5: site vcp, strong sink vs others
system.time(splitType.vimp.vcp1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.vcp, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.vcp1)<- names(type.vimpgroups)

# model 6: site vcs, strong sink vs others
system.time(splitType.vimp.vcs1 <- mclapply(type.vimpgroups,
                                       FUN=function(group)
                                       {
                                         vimp(mod1.vcs, xvar.names=group,
                                              importance="permute",
                                              joint=TRUE)
                                       }))
names(splitType.vimp.vcs1)<- names(type.vimpgroups)

# model 7: site sr, strong sink vs other
system.time(splitType.vimp.sr1 <- mclapply(type.vimpgroups,
                                      FUN=function(group)
                                      {
                                        vimp(mod1.sr, xvar.names=group,
                                             importance="permute",
                                             joint=TRUE)
                                      }))
names(splitType.vimp.sr1)<- names(type.vimpgroups)

# now that the strong sink vs other models have been ran for each site,
# I am going to organize the variable importances into dataframes

splitType.mpj.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.mpj.joint <- rbind(splitType.mpj.joint,splitType.vimp.mpj1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.mpj.joint <- data.frame(splitType.mpj.joint[-1,])
splitType.mpj.joint <- cbind(var = names(type.vimpgroups), splitType.mpj.joint)
rownames(splitType.mpj.joint) <- NULL

splitType.wjs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.wjs.joint <- rbind(splitType.wjs.joint,splitType.vimp.wjs1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.wjs.joint <- data.frame(splitType.wjs.joint[-1,])
splitType.wjs.joint <- cbind(var = names(type.vimpgroups), splitType.wjs.joint)
rownames(splitType.wjs.joint) <- NULL

splitType.seg.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.seg.joint <- rbind(splitType.seg.joint,splitType.vimp.seg1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.seg.joint <- data.frame(splitType.seg.joint[-1,])
splitType.seg.joint <- cbind(var = names(type.vimpgroups), splitType.seg.joint)
rownames(splitType.seg.joint) <- NULL

splitType.ses.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.ses.joint <- rbind(splitType.ses.joint,splitType.vimp.ses1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.ses.joint <- data.frame(splitType.ses.joint[-1,])
splitType.ses.joint <- cbind(var = names(type.vimpgroups), splitType.ses.joint)
rownames(splitType.ses.joint) <- NULL

splitType.vcp.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.vcp.joint <- rbind(splitType.vcp.joint,splitType.vimp.vcp1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.vcp.joint <- data.frame(splitType.vcp.joint[-1,])
splitType.vcp.joint <- cbind(var = names(type.vimpgroups), splitType.vcp.joint)
rownames(splitType.vcp.joint) <- NULL

splitType.vcs.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.vcs.joint <- rbind(splitType.vcs.joint,splitType.vimp.vcs1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.vcs.joint <- data.frame(splitType.vcs.joint[-1,])
splitType.vcs.joint <- cbind(var = names(type.vimpgroups), splitType.vcs.joint)
rownames(splitType.vcs.joint) <- NULL

splitType.sr.joint <- matrix(nrow = 1,ncol = 3)
for (i in 1:length(names(type.vimpgroups))){
  splitType.sr.joint <- rbind(splitType.sr.joint,splitType.vimp.sr1[[names(type.vimpgroups)[i]]][["importance"]])
}
splitType.sr.joint <- data.frame(splitType.sr.joint[-1,])
splitType.sr.joint <- cbind(var = names(type.vimpgroups), splitType.sr.joint)
rownames(splitType.sr.joint) <- NULL

# organizing all this output into one dataframe
splitType.mpj.joint$SiteID <- rep("MPJ",12)
splitType.wjs.joint$SiteID <- rep("WJS",12)
splitType.seg.joint$SiteID <- rep("SEG",12)
splitType.ses.joint$SiteID <- rep("SES",12)
splitType.vcp.joint$SiteID <- rep("VCP",12)
splitType.vcs.joint$SiteID <- rep("VCS",12)
splitType.sr.joint$SiteID <- rep("SR",12)

splitType.vimp.mod1 <- rbind(splitType.mpj.joint,splitType.wjs.joint,splitType.seg.joint,
                       splitType.ses.joint,splitType.vcp.joint,splitType.vcs.joint,splitType.sr.joint)

save(splitType.vimp.mod1,file="splitType.vimp.mod1.R")
write.csv(splitType.vimp.mod1,"splitType.vimp.mod1.csv")



