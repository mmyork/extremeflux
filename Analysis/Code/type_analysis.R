# This script is to analyze the outputs from the grouped variable importances
# where variables are grouped by type (eg TA,P,NEE,etc)
library(tidyr)
library(dplyr)

load("type.vimp.mod1.R")
load("type.vimp.mod2.R")

# summarizing first 
sink_allsites <- type.vimp.mod1 %>% 
  group_by(var) %>% 
    summarise(sum(ssink))

source_allsites <- type.vimp.mod2 %>% 
  group_by(var) %>% 
  summarise(sum(ssource))

# bar plot of the sum vimp across all sites 
# first I am going to isolate the measure we are interested in... sink and source
sink_vimp <- type.vimp.mod1[,c(1,3,5)]
source_vimp <- type.vimp.mod2[,c(1,4,5)]

# pivot the dataframe wider by site
sink_vimp <- pivot_wider(sink_vimp,names_from=SiteID,values_from=ssink)
source_vimp <- pivot_wider(source_vimp,names_from=SiteID,values_from=ssource)

# create a variable that is the vimp summed across sites
sink_vimp$vimp.sum <- rowSums(sink_vimp[,2:8])
source_vimp$vimp.sum <- rowSums(source_vimp[,2:8])

sink_vimp <- data.frame(sink_vimp)
source_vimp <- data.frame(source_vimp)

# now plot the barplots
site_colors = c("orange","yellow","lightblue","darkblue","lightgreen","darkgreen","pink")
names=c("TA","P","SW","SWC","VPD","NEE")

par(mfrow=c(1,2))
barplot(t(as.matrix(sink_vimp[1:6,2:8])),names.arg=names,
        col=site_colors,main="Strong sink",ylim=c(0,3.5))
legend("topleft",legend=colnames(sink_vimp)[2:8],fill=site_colors)

barplot(t(as.matrix(source_vimp[1:6,2:8])),names.arg=names,
        col=site_colors,main="Strong source",ylim=c(0,3.5))
mtext("Grouped variables summed across sites",line=-1,outer=TRUE)

# doing all this same work but for the mean and standard deviation split grouping
load("splitType.vimp.mod1.R")





