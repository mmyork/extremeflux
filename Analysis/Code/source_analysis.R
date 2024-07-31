setwd("C:/Users/my464/Desktop/carbon_fluxes/modelResults")

# load in the models
load("mod2.mpj.R")
load("mod2.wjs.R")
load("mod2.seg.R")
load("mod2.ses.R")
load("mod2.vcp.R")
load("mod2.vcs.R")
load("mod2.sr.R")

load("mod2.mpj.hg.R")
load("mod2.wjs.hg.R")
load("mod2.seg.hg.R")
load("mod2.ses.hg.R")
load("mod2.vcp.hg.R")
load("mod2.vcs.hg.R")
load("mod2.sr.hg.R")

load("mod2.mpjh.n.R")
load("mod2.wjs.hn.R")
load("mod2.seg.hn.R")
load("mod2.ses.hn.R")
load("mod2.vcp.hn.R")
load("mod2.vcs.hn.R")
load("mod2.sr.hn.R")

# organize into a dataframe
mod2.mpj.vimp <- data.frame(mod2.mpj[['importance']])
mod2.seg.vimp <- data.frame(mod2.seg[['importance']])
mod2.ses.vimp <- data.frame(mod2.ses[['importance']])
mod2.wjs.vimp <- data.frame(mod2.wjs[['importance']])
mod2.vcp.vimp <- data.frame(mod2.vcp[['importance']])
mod2.vcs.vimp <- data.frame(mod2.vcs[['importance']])
mod2.sr.vimp <- data.frame(mod2.sr[['importance']])

mod2.results.ssource <- data.frame(cov=vnamessource[-1],mpj=mod2.mpj.vimp$ssource,wjs=mod2.wjs.vimp$ssource,
                               seg=mod2.seg.vimp$ssource,ses=mod2.ses.vimp$ssource,
                               vcp=mod2.vcp.vimp$ssource,vcs=mod2.vcs.vimp$ssource,sr=mod2.sr.vimp$ssource)

# selecting top 10 variables from each site and making barplot
site_colors = c("orange","lightblue","lightgreen","yellow","darkblue","darkgreen","pink")
mod2.results.ssource$vimp.sum <- rowSums(mod2.results.ssource[,2:8])
mod2.results.ssource <- mod2.results.ssource[,c(1,2,4,6,3,5,7,8)]
par(mfrow=c(2,3),cex.axis=1,mar=c(7,4,4,2)+.1)
for (i in 2:8){
  dat.top <- mod2.results.ssource[,c(1,i)]
  dat.top <- dat.top[order(dat.top[,2],decreasing=T),]
  barplot(dat.top[1:10,2],names.arg=dat.top[1:10,1],las=2,col=site_colors[i-1],
          main=paste("Top 10 VIMP for site",colnames(mod2.results.ssource)[i]))
}
mtext("Strong source",outer=TRUE,line=-1.5)

# barplot of the sums of the variable importances across the sites
dev.off()
mod2.results.ssource$vimp.sum <- rowSums(mod2.results.ssource[,2:8])
top.results <- mod2.results.ssource[order(mod2.results.ssource$vimp.sum,decreasing=T),]
barplot(t(as.matrix(top.results[1:10,2:8])),names.arg=top.results[1:10,1],
        col=site_colors,
        legend.text=TRUE,main="Top 10 highest VIMP across sites (strong source)")


# variables who are in the top 10 for each site
top.mpj <- mod2.results.ssource[order(mod2.results.ssource$mpj,decreasing=T),1][1:10]
top.wjs <- mod2.results.ssource[order(mod2.results.ssource$wjs,decreasing=T),1][1:10]
top.seg <- mod2.results.ssource[order(mod2.results.ssource$seg,decreasing=T),1][1:10]
top.ses <- mod2.results.ssource[order(mod2.results.ssource$ses,decreasing=T),1][1:10]
top.vcp <- mod2.results.ssource[order(mod2.results.ssource$vcp,decreasing=T),1][1:10]
top.vcs <- mod2.results.ssource[order(mod2.results.ssource$vcs,decreasing=T),1][1:10]
top.sr <- mod2.results.ssource[order(mod2.results.ssource$sr,decreasing=T),1][1:10]

# making variable that counts how many times it occurs among the 6 sites
top.all <- c(top.mpj,top.wjs,top.seg,top.ses,top.vcp,top.vcs,top.sr)
most_freq <- data.frame(table(top.all))
most_freq <- most_freq[order(most_freq$Freq,decreasing=TRUE),]
most_freq

# Comparing most important predictors within each ecosystem
intersect(top.mpj[1:10],top.wjs[1:10])
intersect(top.seg[1:10],top.ses[1:10])
intersect(top.vcp[1:10],top.vcs[1:10])

shared3 <- intersect(shared1,shared2)
intersect(shared3,top.sr)

# Investigating the savannah sites' shared important variables
shared <- intersect(top.mpj[1:10],top.wjs[1:10])

for (var in shared){
  plot.mpj <- ggplot(data=bin_mpj,mapping=aes(x=bin_mpj$str_source,y=bin_mpj[,var],group=bin_mpj$str_source)) +
    geom_boxplot() + ggtitle("MPJ") + theme_minimal() + ylab(var) + 
    xlab("Flux state") + ylim(min(bin_mpj[,var]),max(bin_mpj[,var]))
  plot.wjs <- ggplot(data=bin_wjs,mapping=aes(x=bin_wjs$str_source,y=bin_wjs[,var],group=bin_wjs$str_source)) +
    geom_boxplot() + ggtitle("WJS") + theme_minimal() + ylab(var) + 
    xlab("Flux state")  + ylim(min(bin_wjs[,var]),max(bin_wjs[,var]))
  grid.arrange(plot.mpj,plot.wjs)
}

for (var in shared){
  plot.mpj <- ggplot(data=bin_mpj,mapping=aes(x=bin_mpj[,var],group=bin_mpj$str_source,col=bin_mpj$str_source)) +
    geom_density() + ggtitle("MPJ") + theme_minimal() + ylab(var) + 
    xlab("Flux state") + ylim(min(bin_mpj[,var]),max(bin_mpj[,var]))
  plot.wjs <- ggplot(data=bin_wjs,mapping=aes(x=bin_wjs[,var],group=bin_wjs$str_source,col=bin_wjs$str_source)) +
    geom_density() + ggtitle("WJS") + theme_minimal() + ylab(var) + 
    xlab("Flux state")  + ylim(min(bin_wjs[,var]),max(bin_wjs[,var]))
  grid.arrange(plot.mpj,plot.wjs)
}

# Comparing the most important predictors shared by sevilleta ecosystems
shared <- intersect(top.seg[1:10],top.ses[1:10])

for (var in shared){
  plot.seg <- ggplot(data=bin_seg,mapping=aes(x=bin_seg$str_source,y=bin_seg[,var],group=bin_seg$str_source)) +
    geom_boxplot() + ggtitle("SEG") + theme_minimal() + ylab(var) + 
    xlab("Flux state") + ylim(min(bin_seg[,var]),max(bin_seg[,var]))
  plot.ses <- ggplot(data=bin_ses,mapping=aes(x=bin_ses$str_source,y=bin_ses[,var],group=bin_ses$str_source)) +
    geom_boxplot() + ggtitle("SES") + theme_minimal() + ylab(var) + 
    xlab("Flux state")  + ylim(min(bin_ses[,var]),max(bin_ses[,var]))
  grid.arrange(plot.seg,plot.ses)
}

for (var in shared){
  plot.seg <- ggplot(data=bin_seg,mapping=aes(x=bin_seg[,var],group=bin_seg$str_source,col=bin_seg$str_source)) +
    geom_density() + ggtitle("SEG") + theme_minimal() + 
    xlab(var) + ylim(min(bin_seg[,var]),max(bin_seg[,var]))
  plot.ses <- ggplot(data=bin_ses,mapping=aes(x=bin_ses[,var],group=bin_ses$str_source,col=bin_ses$str_source)) +
    geom_density() + ggtitle("SES") + theme_minimal() + 
    xlab(var)  + ylim(min(bin_ses[,var]),max(bin_ses[,var]))
  grid.arrange(plot.seg,plot.ses)
}

# Comparing the most important predictors shared by evergreen ecosystems
shared <- intersect(top.vcp[1:10],top.vcs[1:10])

for (var in shared){
  plot.vcp <- ggplot(data=bin_vcp,mapping=aes(x=bin_vcp$str_source,y=bin_vcp[,var],group=bin_vcp$str_source)) +
    geom_boxplot() + ggtitle("VCP") + theme_minimal() + ylab(var) + 
    xlab("Flux state") + ylim(min(bin_vcp[,var]),max(bin_vcp[,var]))
  plot.vcs <- ggplot(data=bin_vcs,mapping=aes(x=bin_vcs$str_source,y=bin_vcs[,var],group=bin_vcs$str_source)) +
    geom_boxplot() + ggtitle("VCS") + theme_minimal() + ylab(var) + 
    xlab("Flux state")  + ylim(min(bin_vcs[,var]),max(bin_vcs[,var]))
  grid.arrange(plot.vcp,plot.vcs)
}

# Barplots comparing the importance (summed across sites) of the different 
# timescales amongst each environmental covariate
# making the covariate groups
P_ts <- c("P_int","P_int_1","P_int_7","P_int_30","P_int_365")
TA_ts <- c("TA_avg","TA_avg_1","TA_avg_7","TA_avg_30","TA_avg_365")
SW_ts <- c("SW_IN_avg","SW_IN_avg_1","SW_IN_avg_7","SW_IN_avg_30","SW_IN_avg_365")
SWC_ts <- c("SWC_avg","SWC_avg_1","SWC_avg_7","SWC_avg_30","SWC_avg_365")
VPD_ts <- c("VPD_avg","VPD_avg_1","VPD_avg_7","VPD_avg_30","VPD_avg_365")
NEE_ts <- c("NEE_state_1","NEE_state_7","NEE_state_30","NEE_state_365")
ts <- c(0,1,7,30,365)

# adding standard deviation
P_sds <- c("P_int_sd_7","P_int_sd_30","P_int_sd_365")
TA_sds <- c("TA_avg_sd_7","TA_avg_sd_30","TA_avg_sd_365")
SW_sds <- c("SW_avg_sd_7","SW_avg_sd_30","SW_avg_sd_365")
SWC_sds <- c("SWC_avg_sd_7","SWC_avg_sd_30","SWC_avg_sd_365")
VPD_sds <-c("VPD_avg_sd_7","VPD_avg_sd_30","VPD_avg_sd_365")
NEE_sds <-c("NEE_state_sd_7","NEE_state_sd_30","NEE_state_sd_365")

# plot barplots of vimp of each of these
par(mfrow=c(3,2))
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% TA_ts,"vimp.sum"])),
        names.arg=ts,main="TA",xlab="Timescales")
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% P_ts,"vimp.sum"])),
        names.arg=ts,main="P",xlab="Timescales")
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% SW_ts,"vimp.sum"])),
        names.arg=ts,main="SW",xlab="Timescales")
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% SWC_ts,"vimp.sum"])),
        names.arg=ts,main="SWC",xlab="Timescales")
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% VPD_ts,"vimp.sum"])),
        names.arg=ts,main="VPD",xlab="Timescales")
barplot(t(as.matrix(mod2.results.ssource[mod2.results.ssource$cov %in% NEE_ts,"vimp.sum"])),
        names.arg=NEE_ts,main="Strong source NEE VIMP summed across sites",xlab="Timescales",col='hotpink')
mtext("Strong source",outer=TRUE,line=-2)

# I want to plot ssource of these on one graph
mod2.results.ssource$timescale <- rep(NA,47)
mod2.results.ssource$timescale[1:5] <- 0
mod2.results.ssource$timescale[6:11] <- 1
mod2.results.ssource$timescale[12:23] <- 7
mod2.results.ssource$timescale[24:35] <- 30
mod2.results.ssource$timescale[36:47] <- 365

mod2.results.ssource$timescale <- as.factor(mod2.results.ssource$timescale)
mod2.results.ssource$timescale <- as.numeric(mod2.results.ssource$timescale)
labels <- c(0,1,7,30,365)

TA_data <- mod2.results.ssource[mod2.results.ssource$cov %in% TA_ts,]
P_data <- mod2.results.ssource[mod2.results.ssource$cov %in% P_ts,]
SW_data <- mod2.results.ssource[mod2.results.ssource$cov %in% SW_ts,]
SWC_data <- mod2.results.ssource[mod2.results.ssource$cov %in% SWC_ts,]
VPD_data <- mod2.results.ssource[mod2.results.ssource$cov %in% VPD_ts,]
NEE_data <- mod2.results.ssource[mod2.results.ssource$cov %in% NEE_ts,]

TAsd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% TA_sds,]
Psd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% P_sds,]
SWsd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% SW_sds,]
SWCsd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% SWC_sds,]
VPDsd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% VPD_sds,]
NEEsd_data <- mod2.results.ssource[mod2.results.ssource$cov %in% NEE_sds,]


plot(x=TA_data$timescale,y=TA_data$vimp.sum,type="l",ylim=c(0,max(P_data$vimp.sum)),
     col="red",xaxt='n',main="Strong source VIMP over timescales",xlab="Lag days",ylab="VIMP")
lines(x=P_data$timescale,y=P_data$vimp.sum,type='l',col="blue")
lines(x=SW_data$timescale,y=SW_data$vimp.sum,type='l',col="orange")
lines(x=SWC_data$timescale,y=SWC_data$vimp.sum,type='l',col="lightblue")
lines(x=VPD_data$timescale,y=VPD_data$vimp.sum,type='l',col="deeppink")
axis(side=1,at=TA_data$timescale,labels=labels)
lines(x=TAsd_data$timescale,y=TAsd_data$vimp.sum,type='l',col="red",lty=2)
lines(x=Psd_data$timescale,y=Psd_data$vimp.sum,type='l',col="blue",lty=2)
lines(x=SWsd_data$timescale,y=SWsd_data$vimp.sum,type='l',col="orange",lty=2)
lines(x=SWCsd_data$timescale,y=SWCsd_data$vimp.sum,type='l',col="lightblue",lty=2)
lines(x=VPDsd_data$timescale,y=VPDsd_data$vimp.sum,type='l',col="deeppink",lty=2)
legend("topright",legend=c("TA","P","SW","SWC","VPD"),col=c("red","blue","orange","lightblue","deeppink"),lty=1)
legend("topleft",legend=c("Mean","SD"),col=c("black","black"),lty=c(1,2))

# Plotting this information seperately for each site seperately
par(mfrow=c(3,2))
for (i in 2:7){
  plot(x=NEE_data$timescale,y=TA_data[,i],type="l",ylim=c(0,max(TA_data[,2:8])),
       col="red",xaxt='n',main=paste("Site",colnames(TA_data)[i],"Timescales"),xlab="Lag days",ylab="VIMP")
  lines(x=P_data$timescale,y=P_data[,i],type='l',col="blue")
  lines(x=SW_data$timescale,y=SW_data[,i],type='l',col="orange")
  lines(x=SWC_data$timescale,y=SWC_data[,i],type='l',col="lightblue")
  lines(x=VPD_data$timescale,y=VPD_data[,i],type='l',col="deeppink")
  axis(side=1,at=TA_data$timescale,labels=labels)
  legend("topright",legend=c("TA","P","SW","SWC","VPD"),col=c("red","blue","orange","lightblue","deeppink"),lty=1)
  
}


# plotting the timescales for a variable across ssource sites
data = NEE_data
plot(x=data[,10],y=data[,2],type='l',col="orange",xaxt='n',ylim=c(0,max(data[,2:7])),xlab="NEE Timescale",ylab="VIMP",main="Strong source NEE VIMP's")
lines(x=data[,10],y=data[,3],type='l',col="cyan")
lines(x=data[,10],y=data[,4],type='l',col="chartreuse")
lines(x=data[,10],y=data[,5],type='l',col="red")
lines(x=data[,10],y=data[,6],type='l',col='blue')
lines(x=data[,10],y=data[,7],type='l',col="darkgreen")
lines(x=data[,10],y=data[,8],type='l',col="deeppink")
axis(side=1,at=NEE_data$timescale,labels=labels)
legend("topright",legend=c("mpj","seg","vcp","wjs","ses","vcs","sr"),col=c("orange","cyan","chartreuse","red","blue","darkgreen","deeppink"),lty=1)

# Now I am going to make partial dependency plots of some important variables
plot.variable(mod2.mpj.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site MPJ: out of season"),outer=TRUE,line=-4,cex.main=3)

plot.variable(mod2.wjs.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site WJS: out of season"),outer=TRUE,line=-4,cex.main=3)

plot.variable(mod2.seg.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site SEG: out of season"),outer=TRUE,line=-4,cex.main=3)

plot.variable(mod2.ses.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site SES: out of season"),outer=TRUE,line=-4,cex.main=3)

plot.variable(mod2.vcp.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site VCP: out of season"),outer=TRUE,line=-3,cex.main=2)

plot.variable(mod2.vcs.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site VCS: out of season"),outer=TRUE,line=-3,cex.main=2)

plot.variable(mod2.sr.hn,m.target="str_source",target="ssource",xvar.names="VPD_avg",partial=TRUE,cex.axis=1.5)
title(main=paste("Site SR: out of season"),outer=TRUE,line=-3,cex.main=2)

# Now I am going to make a joint partial dependency plot for vcp and vcs with temp and vpd
features <- c("TA_avg","VPD_avg")
pdp_result <- partial(mod2.vcp.hg,pred.var=features,grid.resolution=50)
autoplot(pdp_result,contour=TRUE)
