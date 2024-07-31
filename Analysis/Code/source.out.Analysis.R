# this is for analyzing the code2 output: sources specifically
# load in packages
library(dplyr)
library(randomForestSRC)
library(ggplot2)

# load in the model
load("source.out.results.R")
load("bindat.all.R")
load("bindat.out.R")
load("bindat.in.R")

# isolate the VIMP of interest
vimp <- source.out[["importance"]]
vimp <- data.frame(vimp[,3])
vimp <- data.frame("var"=row.names(vimp),"source"=vimp[,1])

# assigning coloring for each group
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

# making bar graph of the most important predictors
top10 <- vimp[order(vimp$source,decreasing=TRUE),][1:10,]
barplot(top10$source,names.arg=top10$var,main="Out of Season High Reco Predictors",col=top10$group)

# temperature and sd seem to be important
# what months of the year are out of season typically? 
site = "US-PFa"
years <- unique(bindat.out[bindat.out$site==site,"Year"])
for (year in years){
  one_year_out <- bindat.out[bindat.out$site==site & bindat.out$Year==year,]
  one_year_all <- bindat.all[bindat.all$site==site & bindat.all$Year==year,]
  p1 <- plot(one_year_all$Date,one_year_all$Reco,col="grey",main=c(site,year))
  p2 <- points(one_year_out$Date,one_year_out$Reco,col="black")
  p3 <- points(one_year_out[one_year_out$source=="source","Date"],
               one_year_out[one_year_out$source=="source","Reco"],
               col="red",pch=21)
  p4 <- axis(1, at = one_year_all$Date, labels = format(one_year_all$Date, "%b"))
  print(c(p1,p2,p3,p4))
  readline(prompt="Press [enter] to continue...")
}

hot_wet <- c("US-Blo","US-Goo","US-KS2")
hot_dry <- c("US-SRG","US-Tw1","US-Twt","US-Myb","US-Wkg","US-Tw3")
middle <- c("US-WCr","US-UMB","US-PFa","US-Los","US-Ne3","US-Vcp")


par(mfrow=c(3,2))
group = hot_dry
for (site in group){
  out.data <- bindat.out[bindat.out$site==site,]
  all.data <- bindat.all[bindat.all$site==site,]
  
  # plotting reco
  p1 <- plot(all.data$GPP,all.data$Reco,col="grey",main=site)
  p2 <- points(out.data$GPP,out.data$Reco,col="black")
  p3 <- points(out.data[out.data$source=="source","GPP"],out.data[out.data$source=="source","Reco"],
             bg="red",pch=21)
  
  print(c(p1,p2,p3))
  
  # plotting gpp
  p1 <- plot(all.data$SW_30,all.data$Reco,col="grey",main=site)
  p2 <- points(out.data$SW_30,out.data$Reco,col="black")
  p3 <- points(out.data[out.data$source=="source","SW_30"],out.data[out.data$source=="source","Reco"],
               bg="orange",pch=21)
  
  print(c(p1,p2,p3))
}

# looking at two variables
par(mfrow=c(3,1))
group=hot_wet
for (site in group){
  out.data <- bindat.out[bindat.out$site==site,]
  all.data <- bindat.all[bindat.all$site==site,]
  
  p1 <- plot(all.data$TA,all.data$SW_30,col="grey",main=site)
  p2 <- points(out.data$TA,out.data$SW_30,col="black")
  p3 <- points(out.data[out.data$source=="source","TA"],out.data[out.data$source=="source","SW_30"],
               bg="red",pch=21)
  
  print(c(p1,p2,p3))
}

group=hot_wet
for (site in group){
  out.data <- bindat.out[bindat.out$site==site,]
  in.data <- bindat.in[bindat.in$site==site,]
  
  plot(density(na.omit(out.data[out.data$source=="source","P_30"])),col="red",main=site)
  lines(density(na.omit(in.data$P_30)),col="grey")
  lines(density(na.omit(out.data$P_30)),col="black")
  
}

# run dataset through the random forest and find where the misclassifications are: 
# this isn't working very well
input_data <- nrow(input_data)
prediction <- predict(source.out,new_data=input_data)
predicted_values <- data.frame(prediction$predicted)
bindat.out$prediction <- ifelse(predicted_values$source > predicted_values$oth,"source","oth")

# making a PDP plot
plot.variable(source.out, m.target="source",target="source",xvar.names="TA",partial=TRUE)
title(main=paste("Out of Season Source: TA"),outer=TRUE,line=-4,cex.main=2)

plot.variable(source.out, m.target="source",target="source",xvar.names="TA_30",partial=TRUE)
title(main=paste("Out of Season Source: TA_30"),outer=TRUE,line=-4,cex.main=2)

plot.variable(source.out, m.target="source",target="source",xvar.names="SW_30",partial=TRUE)
title(main=paste("Out of Season Source: SW_30"),outer=TRUE,line=-4,cex.main=2)
  