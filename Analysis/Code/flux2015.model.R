# This is the script used for the complete fluxnet 2015 dataset
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

# import the data
flux <- read.csv("Fluxnet2015_no_swc.csv")
View(flux)
colnames(flux) <- c("X","Year","Month","Day","Timestamp","NEE","GPP","P","TA","VPD","SW","site")

# loading in the old data for reference reasons as well
xVSC <- read.csv("VSC.csv")
xSEG <- read.csv("SEG.csv")
xSES <- read.csv("SES.csv")
xVCP <- read.csv("VCP.csv")
xMPJ <- read.csv("MPJ.csv")
xWJS <- read.csv("WJS.csv")
xSR <- read.csv("SR.csv")

# this is some exploratory work with the data before using it to model
colnames(flux)
unique(flux$site)

site_means <- flux %>% 
                group_by(site) %>% 
                summarize(mean(TA),mean(SW),mean(P),mean(VPD))
site_data <- data.frame(site_means)
colnames(site_data) <- c("site","TA","SW","P","VPD")

ggplot(mapping=aes(x=site_data$TA,y=site_data$P,label=site_data$site)) + 
  geom_point() +
  geom_point(aes(x=20.66,y=.85,col="red")) +
  geom_point(aes(x=13.7,y=.631,col="red")) +
  geom_point(aes(x=14.406,y=.59,col="red")) +
  geom_point(aes(x=7.336,y=1.22,col="red")) +
  geom_point(aes(x=7.536,y=1.539,col="red")) +
  geom_point(aes(x=12.26,y=.9,col="red")) +
  geom_point(aes(x=11.04,y=.96,col="red")) +
  geom_text(hjust=0,vjust=0,size=3) +
  theme_minimal() +
  ggtitle("Site Annual Climate: Temp and Prec")

################### Data Preparation ###########################################
# I haven't saved bindat yet!
# import the data
flux <- read.csv("Fluxnet2015_no_swc.csv")
colnames(flux) <- c("X","Year","Month","Day","Date","NEE","GPP","P","TA","VPD","SW","site")

xVSC <- read.csv("VSC.csv")
xSEG <- read.csv("SEG.csv")
xSES <- read.csv("SES.csv")
xVCP <- read.csv("VCP.csv")
xMPJ <- read.csv("MPJ.csv")
xWJS <- read.csv("WJS.csv")
xSR <- read.csv("SR.csv")

# combining these sites into one data frame
other_sites <- rbind(xVSC,xSEG,xSES,xVCP,xMPJ,xWJS,xSR)

# dropping SWC (for now, this should be added back soon)
other_sites <- other_sites[,1:11]
colnames(other_sites) <- c("site","Year","Month","Day","Date","NEE","GPP","TA","VPD","SW","P")

# drop the id variable for flux
flux <- flux[,2:12]

# combine the old and new data
flux <- rbind(flux,other_sites)

# readd the index
flux$X <- seq(1,nrow(flux),1)

# Dropping sites from the set that don't have sufficient data
flux <- flux[!(flux$site %in% c("US-Wi0","US-Wi1","US-Wi2","US-Wi5","US-Wi6","US-Wi7",
                                "US-Wi8","US-Wi9","US-GBT","US-KS1","US-Lin","US-Me1",
                                "US-Tw2","US-Tw4","US-Wi4","US-Wi3")),]

# Dropping any points with negative GPP values (common in some sites)
flux <- flux[flux$GPP >= 0,]

# Calculating reco based on gpp and nee
flux$Reco <- flux$GPP + flux$NEE

# Changing 0 reco to 0 for the rest (I checked to make sure this is ok)
flux$Reco[flux$Reco < 0] <- 0

# Now I will drop dates where the NEE is calibrating or just funky
# I used find_calibration function to do this
# refer to clean_calib to see the work for this, otherwise I'm just going
# to load in the dates that will be dropped
load("dropDates.R")

for (i in 1:length(unique(flux$site))){
  site <- unique(flux$site)[i]
  site_drop_dates <- all_dates[[i]]
  # need to drop if they are in this site now!
  for (j in 1:length(site_drop_dates)){
    # find starting and ending date for each range
    start_date <- site_drop_dates[[j]][1]
    end_date <- site_drop_dates[[j]][2]
    # find site dates within that range
    within_date_range <- which(flux[flux$site==site,"Date"] >= start_date &
                                 flux[flux$site==site,"Date"] <= end_date)
    # find X index for this
    X_in_range <- flux[flux$site==site, "X"][within_date_range]
    # drop that from the data frame
    flux <- flux[!(flux$site==site & flux$X %in% X_in_range),]
  }
}

# relabeling X index
flux$X <- seq(1,nrow(flux),1)

# now I am going to loop through each site and add their lag for each variable
lag_variables <- c("TA","VPD","SW","P")

flux <- add_lag(flux,var=lag_variables,days=1)
flux <- add_lag(flux,var=lag_variables,days=7)
flux <- add_lag(flux,var=lag_variables,days=30)
flux <- add_lag(flux,var=lag_variables,days=365)

# create empty list of growing X indices
growbin <- list()

# loop through each site and find growing season indices, add to list
for (site in unique(flux$site)){
  data <- flux[flux$site==site,]
  growing <- split.season(data$GPP)
  growbin <- append(growbin,growing)
}
flux$growbin <- as.factor(unlist(growbin))

# split dataframe based off the list of growing season indices
influx <- flux[growbin==1,]
outflux <- flux[growbin==0,]

influx <- influx[!(is.na(influx$Year)),]
outflux <- outflux[!(is.na(outflux$Year)),]

# Now I will add categorical high/low flux states for flux,influx,and outflux
# For old categorical classification, scroll to bottom
# strong sink = high gpp
# strong source = high reco
# inactive = low gpp and nee around 0

# first, split all sites at each of the 3 datasets into their quantiles for GPP and Reco
GPP_state_full <- list()
GPP_state_in <- list()
GPP_state_out <- list()
Reco_state_full <- list()
Reco_state_in <- list()
Reco_state_out <- list()
inac_state_full <- list()
inac_state_in <- list()
inac_state_out <- list()

for (site in unique(flux$site)){
  print(site)
  GPP_state_full <- append(GPP_state_full,measure_quantiles(flux[flux$site==site,"GPP"],.05,.95))
  GPP_state_in <- append(GPP_state_in,measure_quantiles(influx[influx$site==site,"GPP"],.05,.95))
  GPP_state_out <- append(GPP_state_out,measure_quantiles(outflux[outflux$site==site,"GPP"],.05,.95))
  Reco_state_full <- append(Reco_state_full,measure_quantiles(flux[flux$site==site,"Reco"],.05,.95))
  Reco_state_in <- append(Reco_state_in,measure_quantiles(influx[influx$site==site,"Reco"],.05,.95))
  Reco_state_out <- append(Reco_state_out,measure_quantiles(outflux[outflux$site==site,"Reco"],.05,.95))
  inac_state_full <- append(inac_state_full,inactive_quantiles(flux[flux$site==site,"NEE"],
                                                               flux[flux$site==site,"GPP"],.25))
  inac_state_in <- append(inac_state_in,inactive_quantiles(influx[influx$site==site,"NEE"],
                                                               influx[influx$site==site,"GPP"],.25))
  inac_state_out <- append(inac_state_out,inactive_quantiles(outflux[outflux$site==site,"NEE"],
                                                            outflux[outflux$site==site,"GPP"],.25))
}

# for each of these 3 datasets, create a binary response for source and sink
# assign strong source as high reco
# assign strong sink as high gpp

flux$sink <- ifelse(GPP_state_full==3,1,0)
influx$sink <- ifelse(GPP_state_in==3,1,0)
outflux$sink <- ifelse(GPP_state_out==3,1,0)

flux$source <- ifelse(Reco_state_full==3,1,0)
influx$source <- ifelse(Reco_state_in==3,1,0)
outflux$source <- ifelse(Reco_state_out==3,1,0)

flux$inactive <- unlist(inac_state_full)
influx$inactive <- unlist(inac_state_in)
outflux$inactive <- unlist(inac_state_out)

# make site a factor
flux$site <- as.factor(flux$site)

# aggregating to a binary response dataset 'bindat'
bindat.all <- flux
save(bindat.all,file="bindat.all.R")

bindat.in <- influx
save(bindat.in,file="bindat.in.R")

bindat.out <- outflux
save(bindat.out,file="bindat.out.R")

################################################################################
# # Now I will add categorical flux states for NEE. This will be site specific.
# flux_sites <- unique(flux$site)
# flux$NEE_state <- rep(NA,nrow(flux))
# 
# for (site in flux_sites){
#   # find the starting and ending ID's for that site
#   min_X <- min(flux[flux$site==site,"X"])
#   max_X <- max(flux[flux$site==site,"X"])
#   # using these ID's to calculate and assign NEE states
#   flux$NEE_state[min_X:max_X] <- tuned_flux_quantiles(flux$NEE[min_X:max_X],flux$GPP[min_X:max_X],
#                                                       gpp_inactive=.25,gpp_low=.25,gpp_high=.75)
# }
# 
# # categorizing GPP and Reco into extreme states. This will be site specific.
# flux$GPP_state <- rep(NA,nrow(flux))
# flux$Reco_state <- rep(NA,nrow(flux))
# 
# for (site in flux_sites){
#   # find the starting and ending ID's for that site
#   min_X <- min(flux[flux$site==site,"X"])
#   max_X <- max(flux[flux$site==site,"X"])
#   # using these ID's to calculate and assign NEE states
#   flux$GPP_state[min_X:max_X] <- measure_quantiles(flux$GPP[min_X:max_X],.05,.95)
#   flux$Reco_state[min_X:max_X] <- measure_quantiles(flux$Reco[min_X:max_X],.05,.95)
# }
# 
# # making each state a factor and checking its levels
# 
# flux$Reco_state <- as.factor(flux$Reco_state)
# levels(flux$Reco_state)
# 
# flux$GPP_state <- as.factor(flux$GPP_state)
# levels(flux$GPP_state)


# Before moving on, I want to verify that the correct proportion of data is in
# the extreme states for each site
proportions <- flux %>% 
                  group_by(site) %>% 
                  summarize(sink=sum(NEE_state==1)/sum(!is.na(NEE_state)),
                            inactve = sum(NEE_state==3)/sum(!is.na(NEE_state)),
                            source = sum(NEE_state==5)/sum(!is.na(NEE_state)))
print(proportions,n=100)
proportions <- data.frame(proportions)
proportions[proportions$source < .05,] # these are the ones with low source count

# checking gpp proportions: looks good!
gpp_proportions <- flux %>% 
  group_by(site) %>% 
  summarize(low=sum(GPP_state==1)/sum(!is.na(GPP_state)),
            high=sum(GPP_state==3)/sum(!is.na(GPP_state)))
print(gpp_proportions,n=100)

# checking reco proportions: some of these are off
Reco_proportions <- flux %>% 
  group_by(site) %>% 
  summarize(low=sum(Reco_state==1)/sum(!is.na(Reco_state)),
            high=sum(Reco_state==3)/sum(!is.na(Reco_state)))
print(Reco_proportions,n=100)

Reco_proportions <- data.frame(Reco_proportions)
Reco_proportions[Reco_proportions$low > .055,]

x# saving this cause it took forever to run
save(flux,file="flux.R")

# Verifying that my data is clean as I want it to be
# looking at negative reco data
neg_reco <- flux %>% 
  group_by(site) %>% 
  summarize(sum(Reco<0))
print(neg_reco,n=100)

# checking time spans of all the sites
year_check <- flux %>% 
  group_by(site) %>% 
  summarize(min(Year),max(Year))
print(year_check,n=100)

# how much data each site has
site_count <- flux %>% 
  group_by(site) %>% 
  summarize(sum(!(is.na(NEE))))
print(site_count,n=100)

# plotting each sites NEE
site = "US-AR2"
for (site in unique(flux$site)){
  plot <- ggplot(data=flux[flux$site==site,],mapping=aes(x=Date,y=NEE)) +
    geom_point() +
    theme_minimal() +
    ggtitle(site)
  print(plot)
  readline(prompt = "Press [Enter] to continue...")
}

# plotting my growing and not growing seasons real quick

for (site in unique(flux$site)){
  p <- ggplot(data=flux[flux$site==site,],mapping=aes(x=Date,y=GPP,color=growbin)) +
    geom_point() + ggtitle(site)
  print(p)
  readline(prompt = "Press [Enter] to continue...")
}

# I want to get a better idea of the classifications that I have made based on definitions

########################## SINK ################################################
# setting up data to plot 
site="US-Vcp"
out.data <- bindat.out[bindat.out$site==site,]
in.data <- bindat.in[bindat.in$site==site,]
all.data <- bindat.all[bindat.all$site==site,]

# checking the strong sinks for out of season
par(mfrow=c(3,1))
plot(all.data$Date,all.data$GPP,col="lightgrey",main="Out of Season Sinks (high gpp) for AR1",xlab="date",ylab="GPP")
points(out.data$Date,out.data$GPP,col="black")
points(out.data[out.data$sink=="sink","Date"],out.data[out.data$sink=="sink","GPP"],bg="red",pch=21)

# checking the strong sinks for in season
plot(all.data$Date,all.data$GPP,col="lightgrey",main="In season sinks (high gpp) for AR1",xlab="Date",ylab="GPP")
points(in.data$Date,in.data$GPP,col="black")
points(in.data[in.data$sink=="sink","Date"],in.data[in.data$sink=="sink","GPP"],bg="red",pch=21)

# checking strong sinks for all seasons
plot(all.data$Date,all.data$GPP,col="black",main="Full year sinks (high gpp) for AR1",xlab="Date",ylab="GPP")
points(all.data[all.data$sink=="sink","Date"],all.data[all.data$sink=="sink","GPP"],bg="red",pch=21)



####################### SOURCE #################################################
# checking strong sources for out of season
# this is the most important of sources because it is when gpp is low and reco is high
# plotting both reco and gpp for this
par(mfrow=c(3,2))
plot(all.data$Date,all.data$Reco,col="grey",main="Out of season sources (high reco) for AR1",xlab="date",ylab="Reco")
points(out.data$Date,out.data$Reco,col="black")
points(out.data[out.data$source=="source","Date"],out.data[out.data$source=="source","Reco"],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="grey",main="Out of season sources (high reco) for AR1",xlab="date",ylab="GPP")
points(out.data$Date,out.data$GPP,col="black")
points(out.data[out.data$source=="source","Date"],out.data[out.data$source=="source","GPP"],bg="red",pch=21)

# checking out strong sources for in season
plot(all.data$Date,all.data$Reco,col="grey",main="In season source (high reco) for AR1",xlab="date",ylab="reco")
points(in.data$Date,in.data$Reco,col="black")
points(in.data[in.data$source=="source","Date"],in.data[in.data$source=="source","Reco",],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="grey",main="In season source (high reco) for AR1",xlab="date",ylab="GPP")
points(in.data$Date,in.data$GPP,col="black")
points(in.data[in.data$source=="source","Date"],in.data[in.data$source=="source","GPP",],bg="red",pch=21)

# checking out strong sources for all date
plot(all.data$Date,all.data$Reco,col="black",main="Full year source (high reco) for AR1",xlab="date",ylab="Reco")
points(all.data[all.data$source=="source","Date"],all.data[all.data$source=="source","Reco"],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="black",main="Full year source (high reco) for AR1",xlab="date",ylab="Reco")
points(all.data[all.data$source=="source","Date"],all.data[all.data$source=="source","GPP"],bg="red",pch=21)



####################### INACTIVE ###############################################
# this is going to be funky
# plotting NEE
# starting with out of season inactives
par(mfrow=c(3,1))
plot(all.data$Date,all.data$NEE,col="grey",main="Out of season inactives (low gpp & reco) for AR1",xlab="date",ylab="NEE")
points(out.data$Date,out.data$NEE,col="black")
points(out.data[out.data$inactive=="inac","Date"],out.data[out.data$inactive=="inac","NEE"],bg="red",pch=21)

# now for in season inactives
plot(all.data$Date,all.data$NEE,col="grey",main="In season inactives (high reco) for AR1",xlab="date",ylab="NEE")
points(in.data$Date,in.data$NEE,col="black")
points(in.data[in.data$inactive=="inac","Date"],in.data[in.data$inactive=="inac","NEE"],bg="red",pch=21)

# now for both seasons combined
plot(all.data$Date,all.data$NEE,col="grey",main="Full year inactives (high reco) for AR1",xlab="date",ylab="NEE")
points(all.data$Date,all.data$NEE,col="black")
points(all.data[all.data$inactive=="inac","Date"],all.data[all.data$inactive=="inac","NEE"],bg="red",pch=21)

# looking at gpp and reco for this
par(mfrow=c(3,2))
plot(all.data$Date,all.data$Reco,col="grey",main="Out of season inactive for AR2",xlab="date",ylab="Reco")
points(out.data$Date,out.data$Reco,col="black")
points(out.data[out.data$inactive=="inac","Date"],out.data[out.data$inactive=="inac","Reco"],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="grey",main="Out of season inactive for AR2",xlab="date",ylab="GPP")
points(out.data$Date,out.data$GPP,col="black")
points(out.data[out.data$inactive=="inac","Date"],out.data[out.data$inactive=="inac","GPP"],bg="red",pch=21)

plot(all.data$Date,all.data$Reco,col="grey",main="In season inactive for AR2",xlab="date",ylab="reco")
points(in.data$Date,in.data$Reco,col="black")
points(in.data[in.data$inactive=="inac","Date"],in.data[in.data$inactive=="inac","Reco",],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="grey",main="In season inactive for AR2",xlab="date",ylab="GPP")
points(in.data$Date,in.data$GPP,col="black")
points(in.data[in.data$inactive=="inac","Date"],in.data[in.data$inactive=="inac","GPP",],bg="red",pch=21)

plot(all.data$Date,all.data$Reco,col="black",main="Full year inactve for AR2",xlab="date",ylab="Reco")
points(all.data[all.data$inactive=="inac","Date"],all.data[all.data$inactive=="inac","Reco"],bg="red",pch=21)

plot(all.data$Date,all.data$GPP,col="black",main="Full year inactive for AR2",xlab="date",ylab="Reco")
points(all.data[all.data$inactive=="inac","Date"],all.data[all.data$inactive=="inac","GPP"],bg="red",pch=21)










