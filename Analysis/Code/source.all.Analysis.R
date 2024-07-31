# this file is for working with sources over all seasons

# load in packages
library(dplyr)
library(ggplot2)
library(randomForestSRC)

# load in data
load("source.all.results.R")
# or
load("vimp.source.all.R")

# first, lets pull out the vimp
vimp <- source.all[["importance"]]
vimp <- data.frame(vimp[,3])
vimp <- data.frame("var"=row.names(vimp),"source"=vimp[,1])

# assign groups specific colors for identification
TA <- c("TA","TA_1","TA_7","TA_30","TA_365","TA_sd_7","TA_sd_30","TA_sd_365")
P <- c("P","P_1","P_7","P_30","P_365","P_sd_7","P_sd_30","P_sd_365")
SW <- c("SW","SW_1","SW_7","SW_30","SW_365","SW_sd_7","SW_sd_30","SW_sd_365")
VPD <- c("VPD","VPD_1","VPD_7","VPD_30","VPD_365","VPD_sd_7","VPD_sd_30","VPD_sd_365")

vimp <- vimp %>% 
  mutate(
    group = case_when(
      var %in% TA ~ "red",
      var %in% P ~ "lightblue",
      var %in% SW ~ "orange",
      var %in% VPD ~ "purple"
    )
  )

# now lets look at the top predictors
top10 <- vimp[order(vimp$source,decreasing=TRUE),][1:10,]

# make barplot of top 10
barplot(top10$source,names.arg=top10$var,main="Source Predictors",col=top10$group)

# now I am going to plot todays temperature and reco
dry <- c("US-SRG","US-Prr","US-Twt","US-Myb","US-Wkg","US-Cop")

group=dry
par(mfrow=c(2,3))
for (site in group){
  all.data <- bindat.all[bindat.all$site==site,]
  out.data <- bindat.out[bindat.out$site==site,]
  in.data <- bindat.in[bindat.in$site==site,]
  
  plot(all.data$TA,all.data$Reco,col="grey")
  points(in.data$TA,in.data$Reco,col="orange")
  points(all.data[all.data$source=="source","TA"],all.data[all.data$source=="source","Reco"],
       bg="black",pch=21,xlim=c(min(all.data$TA),max(all.data$TA)),
       ylim=c(min(all.data$Reco),max(all.data$Reco)))
  points(out.data$TA,out.data$Reco,col="lightblue")
  points(all.data[all.data$source=="source","TA"],
         all.data[all.data$source=="source","Reco"])
  
}


# how many strong sources happen during the out of season

total = 0
for (site in unique(bindat.all$site)){
  all.data = bindat.all[bindat.all$site==site,]
  out.data = bindat.out[bindat.out$site==site,]
  out = sum(out.data$Date %in% all.data[all.data$source=="source","Date"])
  total = total + out
  if (out > 0){print(site)}
}
total / nrow(bindat.all)
