# This script is to analyze the output from the grouped variable importances,
# where variables are grouped by timescale

library(dplyr)

load("lag.vimp.mod1.R")
load("lag.vimp.mod2.R")

# summarising first
lag.vimp.mod1 %>% 
  group_by(var) %>% 
  summarise(sum(ssink))

lag.vimp.mod2 %>% 
  group_by(var) %>% 
  summarise(sum(ssource))

# bar plot of the sum vimp across all sites 
# first I am going to isolate the measure we are interested in... sink and source
sink_vimp_lag <- lag.vimp.mod1[,c(1,3,5)]
source_vimp_lag <- lag.vimp.mod2[,c(1,4,5)]

# pivot the dataframe wider by site
sink_vimp_lag <- pivot_wider(sink_vimp_lag,names_from=SiteID,values_from=ssink)
source_vimp_lag <- pivot_wider(source_vimp_lag,names_from=SiteID,values_from=ssource)

# create a variable that is the vimp summed across sites
sink_vimp_lag$vimp.sum <- rowSums(sink_vimp_lag[,2:7])
source_vimp_lag$vimp.sum <- rowSums(source_vimp_lag[,2:7])

sink_vimp_lag <- data.frame(sink_vimp_lag)
source_vimp_lag <- data.frame(source_vimp_lag)

# now plot the barplots
site_colors = c("orange","yellow","lightblue","darkblue","lightgreen","darkgreen","pink")
names=c(0,1,7,30,365)

par(mfrow=c(1,2))
barplot(t(as.matrix(sink_vimp_lag[1:5,2:8])),names.arg=names,
        col=site_colors,main="Strong sink",ylim=c(0,2),xlab="Timescale")
legend("topleft",legend=colnames(sink_vimp)[2:8],fill=site_colors)

barplot(t(as.matrix(source_vimp_lag[1:5,2:8])),names.arg=names,
        col=site_colors,main="Strong source",ylim=c(0,2),xlab="Timescale")
mtext("Grouped variables summed across sites",line=-1,outer=TRUE)




