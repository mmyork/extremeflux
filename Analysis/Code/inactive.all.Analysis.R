# load packages
library(readr)

# this is for analying the inactive all results
load("inactive.all.results.R")

# isolate the VIMP of interest
vimp <- inactive.all[["importance"]]
vimp <- data.frame(vimp[,3])
vimp <- data.frame("var"=row.names(vimp),"inactive"=vimp[,1])

# getting a new plot of all the site temps and prec
avg_cov <- bindat.all %>% 
  group_by(site) %>% 
  summarize(avg_TA = mean(TA),avg_P = mean(P))

avg_cov <- data.frame(avg_cov)
plot(avg_cov$avg_TA,avg_cov$avg_P,xlab="TA",ylab="P",main="Site Averages")
text(avg_cov$avg_TA,avg_cov$avg_P,labels=avg_cov$site,pos=4,cex=.5)

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
top10 <- vimp[order(vimp$inactive,decreasing=TRUE),][1:10,]
barplot(top10$inactive,names.arg=top10$var,main="Inactive Predictors",col=top10$group)

# when are inactives happening?
sites <- unique(bindat.all$site)
for (site in sites){
  plot(bindat.all[bindat.all$site==site,"Date"],
       bindat.all[bindat.all$site==site,"SW_30"],
       col="black",main=site)
  axis.Date(1, at = seq(min(bindat.all$Date), max(bindat.all$Date), by = "month"), format = "%b")
  points(bindat.all[bindat.all$site==site & bindat.all$inactive=="inac","Date"],
         bindat.all[bindat.all$site==site & bindat.all$inactive=="inac","SW_30"],
         bg="red",pch=21)
  readline(prompt="Press [enter] to continue...")
}
bindat.all %>% 
  group_by(Month) %>% 
  summarize("Inac Percent" = sum(inactive=="inac") / 6945)

# making PDP plots of the top predictors
plot.variable(inactive.all, m.target="inactive",target="inac",xvar.names="SW_30",partial=TRUE)
title(main=paste("Inactives: SW_30"),outer=TRUE,line=-4,cex.main=2)

plot.variable(inactive.all, m.target="inactive",target="inac",xvar.names="SW_sd_30",partial=TRUE)
title(main=paste("Inactives: SW_sd_30"),outer=TRUE,line=-4,cex.main=2)

plot.variable(inactive.all,m.target="inactive",target="inac",xvar.names="TA_sd_365",partial=TRUE)
title(main=paste("Inactives: TA_sd_365"),outer=TRUE,line=-4,cex.main=2)

plot.variable(inactive.all,m.target="inactive",target="inac",xvar.names="P_365",partial=TRUE)
title(main=paste("Inactive: P_365"),outer=TRUE,line=-4,cex.main=2)

# plotting some of the year long variables along with the inactivity
dry <- c("US-SRG","US-Prr","US-Twt","US-Myb","US-Wkg","US-Cop")
avg_prec <- c("US-Me4","US-Sta","US-AR1","US-Ton","US-Prr","US-Me6")
wet <- c("US-Blo","US-Goo","US-KS2","US-GLE","US-Ha1","US-MMS")
par(mfrow=c(3,2))
group = avg_prec

for (site in group){
  all.data <- bindat.all[bindat.all$site==site,]
  
  # assigning yearly colors
  unique_years <- levels(as.factor(unique(all.data$Year)))
  num_years <- length(unique_years)
  auto_colors <- rainbow(num_years)
  category_colors <- setNames(auto_colors, unique_years)
  point_colors <- data.frame(category_colors[as.factor(all.data$Year)])
  all.data$colors <- point_colors[,1]
  
  # plotting nee
  p1 <- plot(all.data$P_365,all.data$NEE,col="grey",main=paste(site,":",length(unique(all.data$Year)),"years"))
  p2 <- points(all.data[all.data$inactive=="inac","P_365"],all.data[all.data$inactive=="inac","NEE"],
               col=all.data[all.data$inactive=="inac","colors"])
  
  print(c(p1,p2))
}
title(main=paste("Inactive at Dry Sites"),outer=TRUE,line=-3,cex.main=1.5)

monthly_inac <- bindat.all %>% 
  group_by(site,Year) %>% 
  summarize(avg_TA = mean(TA), inac_count = sum(inactive=="inac"))
print(monthly_inac,n=10000)
