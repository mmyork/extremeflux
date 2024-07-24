# writing function for season split
split.season <- function(gpp){
  # setting the gpp threshold as the total average of all gpp data
  grow_season <- rep(NA,length(gpp))
  gpp_thresh <- quantile(gpp,.25)
  # looping through the data and finding dates when gpp is below threshold
  # for entire previous week
  for (i in 2:(length(gpp)-2)){
    if (mean(gpp[(i-1):(i+1)]) < gpp_thresh){
      grow_season[i] <- 0
    } else {
      grow_season[i] <- 1
    }
  }
  return(grow_season)
}

split.season <- function(gpp){
  # setting the gpp threshold as the total average of all gpp data
  grow_season <- rep(NA,length(gpp))
  gpp_thresh <- mean(gpp)
  # looping through the data and finding the dates when gpp is above threshold
  # for the entire previous week
  for (i in 7:length(gpp)){
    if (mean(gpp[(i-6):i]) > gpp_thresh){
      grow_season[i] <- 1
    } else {
      grow_season[i] <- 0
    }
  }
  return(grow_season)
}



# I am going to split the data into growing season and not growing season and rerun the models
library(dplyr)
library("lubridate")
library(ggplot2)

# loading in the data
setwd("C:/Users/my464/Desktop/carbon_fluxes/Data")
xMPJ <- read.csv("MPJ.csv")
xWSJ <- read.csv("WJS.csv")
xSEG <- read.csv("SEG.csv")
xSES <- read.csv("SES.csv")
xVCP <- read.csv("VCP.csv")
xVCS <- read.csv("VSC.csv")
xSR <- read.csv("SR.csv")

# historical way: I don't like this.
xMPJ$grow <- split.season.hist(xMPJ$GPP_int,xMPJ$Date,xMPJ$Month,xMPJ$Day)
xWJS$grow <- split.season.hist(xWJS$GPP_int,xWJS$Date,xWJS$Month,xWJS$Day)
xSES$grow <- split.season.hist(xSES$GPP_int,xSES$Date,xSES$Month,xSES$Day)
xSEG$grow <- split.season.hist(xSEG$GPP_int,xSEG$Date,xSEG$Month,xSEG$Day)
xVCP$grow <- split.season.hist(xVCP$GPP_int,xVCP$Date,xVCP$Month,xVCP$Day)
xVCS$grow <- split.season.hist(xVCS$GPP_int,xVCS$Date,xVCS$Month,xVCS$Day)
xSR$grow <- split.season.hist(xSR$GPP_int,xSR$Date,xSR$Month,xSR$Day)

# new way with quantile and not historical
xMPJ$qgrow <- split.season(xMPJ$GPP_int)
xWJS$qgrow <- split.season(xWJS$GPP_int)
xSES$qgrow <- split.season(xSES$GPP_int)
xSEG$qgrow <- split.season(xSEG$GPP_int)
xVCP$qgrow <- split.season(xVCP$GPP_int)
xVCS$qgrow <- split.season(xVCS$GPP_int)
xSR$qgrow <- split.season(xSR$GPP_int)


# plotting gpp with growing season indication
ggplot(data=xMPJ[xMPJ$Year%in%c(2010,2011,2012),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xWJS[xWJS$Year%in%c(2010,2011,2012,2013,2014),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xSEG[xSEG$Year%in%c(2010,2011,2012),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xSES[xSES$Year%in%c(2010,2011,2012),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xVCS[xVCS$Year%in%c(2016,2017,2018),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xVCP[xVCP$Year%in%c(2010,2011,2012),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

ggplot(data=xSR[xSR$Year%in%c(2016,2017,2018,2019),],mapping=aes(x=Date,y=GPP_int,col=qgrow)) +
  geom_point()

# calculating the average for each day of the year

mpj_GPP <- xMPJ %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

mpj_GPP <- data.frame(mpj_GPP)

wjs_GPP <- xWSJ %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

wjs_GPP <- data.frame(wjs_GPP)

seg_GPP <- xSEG %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

seg_GPP <- data.frame(seg_GPP)

ses_GPP <- xSES %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

ses_GPP <- data.frame(ses_GPP)

vcs_GPP <- xVCS %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

vcs_GPP <- data.frame(vcs_GPP)

vcp_GPP <- xVCP %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

vcp_GPP <- data.frame(vcp_GPP)

sr_GPP <- xSR %>% 
  group_by(Month, Day) %>% 
  summarise(mean(GPP_int))

sr_GPP <- data.frame(sr_GPP)

# adding dates to these so that I can plot them

mpj_GPP <- mpj_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

wjs_GPP <- wjs_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

ses_GPP <- ses_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

seg_GPP <- seg_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

vcs_GPP <- vcs_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

vcp_GPP <- vcp_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

sr_GPP <- sr_GPP %>% 
  mutate(date=as.Date(paste("2023",Month,Day,sep="-")))

# renaming the columns for these dataframes
cols <- c("Month","Day","GPP_avg","Date")
colnames(mpj_GPP) <- cols
colnames(wjs_GPP) <- cols
colnames(ses_GPP) <- cols
colnames(seg_GPP) <- cols
colnames(vcs_GPP) <- cols
colnames(vcp_GPP) <- cols
colnames(sr_GPP) <- cols

# plotting these means over time
ggplot(data=mpj_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: MPJ") +
  theme_minimal()

ggplot(data=wjs_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: WJS") +
  theme_minimal()

ggplot(data=ses_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: SES") +
  theme_minimal()

ggplot(data=seg_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: SEG") +
  theme_minimal()

ggplot(data=vcp_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: VCP") +
  theme_minimal()

ggplot(data=vcs_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: VCS") +
  theme_minimal()

ggplot(data=sr_GPP,mapping=aes(x=Date,y=GPP_avg)) +
  geom_point() + 
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  ggtitle("Average Daily GPP: SR") +
  theme_minimal()

# looking at GPP information overall
summary(xMPJ$GPP_int)


# determining inactive state by NEE=0 AND GPP=0
# plotting gpp and NEE on the same plot
xMPJ$Date <- as.Date(xMPJ$Date)
ggplot(data=xMPJ[xMPJ$Year %in% c(2008,2009,2010),],mapping=aes(x=Date,y=GPP_int)) +
  geom_point() +
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  geom_point(mapping=aes(y=NEE_int,col="red")) +
  ggtitle("GPP and NEE on same graph")

# we want to remove the inactive states when gpp is high, because thats not inactive
# finding crossover between the lowest .05 of GPP and .05 around 0 for NEE

# first I am going to run the current rank_flux_quantile and look at the inactive states
xMPJ$NEE_state <- rank_flux_quantiles(xMPJ$NEE_int,.05,.95,.05)
xMPJ$NEE_state <- as.factor(xMPJ$NEE_state)

# Now I will run summary statistics on the inactive state and plot them in comparison
# to GPP as well. 238 in inactive state for this period
ggplot(data=xMPJ[xMPJ$Year %in% c(2008,2009,2010),],mapping=aes(x=Date,y=GPP_int)) +
  geom_line() +
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  geom_point(mapping=aes(y=NEE_int,col=NEE_state)) +
  scale_color_manual(values=c("red","grey","orange","grey","green")) +
  ggtitle("GPP and NEE on same graph")

xMPJ %>% 
  group_by(NEE_state) %>% 
  count()

xMPJ %>% 
  group_by(NEE_state) %>% 
  summarise(mean(GPP_int))

# now I will run the new rank_flux quantile and look at the inactive states
xMPJ$NEE_state_2 <- rank_flux_quantiles(xMPJ$NEE_int,xMPJ$GPP_int,.05,.95,.05,.25)
xMPJ$NEE_state_2 <- as.factor(xMPJ$NEE_state_2)
table(xMPJ$NEE_state_2)
table(xMPJ$NEE_state)

ggplot(data=xMPJ[xMPJ$Year %in% c(2008,2009,2010),],mapping=aes(x=Date,y=GPP_int)) +
  geom_line() +
  scale_x_date(date_breaks="1 month",date_labels="%b") +
  geom_point(mapping=aes(y=NEE_int,col=NEE_state_2)) +
  scale_color_manual(values=c("red","grey","orange","grey","green")) +
  ggtitle("GPP and NEE on same graph")

# this looks a lot more promising! now I will run my models with it

# exploring why season counts are so different between historical and week lags fir ses
# first plotting the 7 day lag gpp definition of growing season

grow_plot <- ggplot(data=bin_ses,mapping=aes(x=Date,y=NEE_int,col=grow)) + geom_point()
hgrow_plot <- ggplot(data=bin_ses,mapping=aes(x=Date,y=NEE_int,col=hgrow)) + geom_point()
grid.arrange(grow_plot,hgrow_plot)

