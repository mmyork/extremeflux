# Loading in all the data sets and beginning comparisons

# packages
library(dplyr)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(MASS)
library(estimatr)

# load in daily data from the 5 sites
xMPJ <- read.csv("FLX_US-Mpj_FLUXNET2015_FULLSET_DD_2008-2017_beta-3.csv")
xSEG <- read.csv("FLX_US-Seg_FLUXNET2015_FULLSET_DD_2007-2017_beta-3.csv")
xSES <- read.csv("FLX_US-Ses_FLUXNET2015_FULLSET_DD_2007-2017_beta-3.csv")
xWSJ <- read.csv("FLX_US-Wjs_FLUXNET2015_FULLSET_DD_2007-2017_beta-3.csv")

# adding site location variable to each of these dataframes
xMPJ$site <- rep("MPJ",nrow(xMPJ))
xSEG$site <- rep("SEG",nrow(xSEG))
xSES$site <- rep("SES",nrow(xSES))
xWSJ$site <- rep("WSJ",nrow(xWSJ))

# stacking all the dataframes into one
dfs <- list(xMPJ,xSEG,xSES,xWSJ)
df <- bind_rows(dfs)

# selecting variables of interest
var <- c("TIMESTAMP","site","NEE_VUT_USTAR50","GPP_DT_VUT_USTAR50","TA_F_MDS","VPD_F_MDS","SW_IN_F_MDS","P_F")
df <- df[,var]
colnames(df) <- c("TIMESTAMP","site","NEE","GPP","TA","VPD","SWC","P")
View(df)

# boxplots of each sites variables
par(mfrow=c(3,2))
for (i in 3:8){
  var_df <- df[which(df[,i]!=-9999),]
  boxplot(var_df[,i]~var_df[,"site"],main=colnames(df)[i],xlab="Site",ylab=colnames(df)[i])
}

# variable impact on NEE by covariates
TA_df <- df[which(df[,5]!=-9999),]
VPD_df <- df[which(df[,6]!=-9999),]
SWC_df <- df[which(df[,7]!=-9999),]

p1 <- ggplot(data=df,mapping=aes(x=GPP,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("NEE by GPP")
p2 <- ggplot(data=TA_df,mapping=aes(x=TA,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("NEE by TA")
p3 <- ggplot(data=VPD_df,mapping=aes(x=VPD,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("NEE by VPD")
p4 <- ggplot(data=SWC_df,mapping=aes(x=SWC,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("NEE by SWC")
p5 <- ggplot(data=df,mapping=aes(x=P,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("NEE by P")

grid.arrange(p1,p2,p3,p4,p5)

# splitting time stamp into dates
df$TIMESTAMP <- factor(df$TIMESTAMP)
df_year <- as.integer(substr(df$TIMESTAMP,1,4))
df_month <- as.integer(substr(df$TIMESTAMP,5,6))
df_day <- as.integer(substr(df$TIMESTAMP,7,8))

# add year, month, and day to raw data
df <- cbind(Year = df_year, Month = df_month, Day = df_day, df)
head(df)[,1:7]

# LAGGED EFFECT OF TEMPERATURE ON NEE

# the effect of concurrent temperature on NEE
ggplot(data=df,mapping=aes(x=P,y=NEE)) + geom_point(alpha=.1) + geom_smooth(method="lm") + ggtitle("Concurrent prec on NEE")
reg0 <- lm(df$NEE~df$P)
summary(reg0)

# the effect of the prior day's temperature on NEE?
# first make prior day column
df$P_1 <- rep(NA,nrow(df))
k <- 1
sites <- vector("list",4)
for (j in 1:4){
  site_df <- df[df$site==unique(df$site)[j],]
  P_1 <- rep(NA,nrow(site_df))
  for (i in 2:nrow(site_df)){
    P_1[i] <- site_df$P[i-1]
  }
  site_df$P_1 <- P_1
  sites[[j]] <- site_df
}
df <- bind_rows(sites)


# plotting and regressing the prior day temperature
ggplot(data=df[(df$P_1!=0),],mapping=aes(x=P_1,y=GPP)) + geom_point(alpha=.1) + 
  geom_smooth(method="lm") + ggtitle("Previous day prec on GPP")
reg1 <- lm(data=df[df$P_1!=0,],GPP~P_1)
summary(reg1)

# relationship of the average over the previous week and current NEE
# calculating the average over the previous week, not including today
df$P_7 <- rep(NA,nrow(df))
k <- 1
sites <- vector("list",4)
for (j in 1:4){
  site_df <- df[df$site==unique(df$site)[j],]
  P_7 <- rep(NA,nrow(site_df))
  for (i in 8:nrow(site_df)){
    prev_week <- site_df[(i-7):(i-1),"P"]
    prev_week_avg <- mean(prev_week[(is.na(prev_week)==FALSE)&(prev_week!=-9999)])
    P_7[i] <- prev_week_avg
  }
  site_df$P_7 <- P_7
  sites[[j]] <- site_df
}
df <- bind_rows(sites)

# plotting and regressing the avg of the previous week
ggplot(data=df,mapping=aes(x=P_7,y=GPP)) + geom_point(alpha=.1) + 
  geom_smooth(method="lm") + ggtitle("Previous week avg prec on GPP") + theme_minimal()
reg7 <- lm(df$NEE~df$P_7)
summary(reg7)

# calculating the average over the previous month, not including today
df$P_30 <- rep(NA,nrow(df))
k <- 1
sites <- vector("list",4)
for (j in 1:4){
  site_df <- df[df$site==unique(df$site)[j],]
  P_30 <- rep(NA,nrow(site_df))
  for (i in 31:nrow(site_df)){
    prev_month <- site_df[(i-30):(i-1),"P"]
    prev_month_avg <- mean(prev_month[(is.na(prev_month)==FALSE)&(prev_month!=-9999)])
    P_30[i] <- prev_month_avg
  }
  site_df$P_30 <- P_30
  sites[[j]] <- site_df
}
df <- bind_rows(sites)

# plotting and regressing the avg of the previous week
ggplot(data=df,mapping=aes(x=P_30,y=GPP)) + geom_point(alpha=.1) + 
  geom_smooth(method="lm") + ggtitle("Previous month avg prec on NEE") + theme_minimal()
reg30 <- lm(df$NEE~df$P_30)
summary(reg30)

#####################################################################################################################

# loading the new and final data
xVSC <- read.csv("VSC.csv")
xSEG <- read.csv("SEG.csv")
xSES <- read.csv("SES.csv")
xVCP <- read.csv("VCP.csv")
xMPJ <- read.csv("MPJ.csv")
xWJS <- read.csv("WJS.csv")
xSR <- read.csv("SR.csv")

# fixing the santa rita vpd scale
xSR$VPD_avg <- xSR$VPD_avg / 10
xSR$SWC_avg <- xSR$SWC_avg / 100

# merging into one dataset
sites <- list(xVSC,xSEG,xSES,xVCP,xMPJ,xWJS,xSR) 
df <- do.call(rbind,sites)
colnames(df)

# plotting covariate relationships with GPP. precipitation doesnt work since it has too many zeroes?
par(mfrow=c(3,2))

covariates <- c("NEE_int","TA_avg","VPD_avg","SW_IN_avg","SWC_avg","GPP_int")
df_cov <- df[,covariates]
for (i in 1:5){
  var <- covariates[i]
  var_df <- df_cov[complete.cases(df_cov[,i]),]
  dens <- kde2d(var_df[,i],var_df$GPP_int,n=100)
  image(dens,main=var)
  contour(dens,add=T)
  abline(lm(var_df$GPP_int~var_df[,i]),col="red")
}

# plotting covariate relationships with NEE
par(mfrow=c(3,2))
covariates <- c("GPP_int","TA_avg","VPD_avg","SW_IN_avg","SWC_avg","NEE_int")
df_cov <- df[,covariates]
for (i in 1:5){
  var <- covariates[i]
  var_df <- df_cov[complete.cases(df_cov[,i]),]
  dens <- kde2d(var_df[,i],var_df$NEE_int,n=100)
  image(dens,main=var,ylab="NEE",xlab=var)
  contour(dens,add=T)
  abline(lm(var_df$NEE_int~var_df[,i]),col="red")
}

# multiple linear regression
var_df <- df[complete.cases(df),]
reg_full <- lm(data=df,NEE_int ~ GPP_int + TA_avg + VPD_avg + SW_IN_avg + SWC_avg + P_int)
summary(reg_full)
summary(step(reg_full,direction="forward"))
res <- resid(reg_full)

# residual plots, obviously not linear but at least we get info on relationships
plot(fitted(reg_full),res,main="Residuals plot")
abline(0,0,col="red")
qqnorm(res)
qqline(res)

#####################
###### LAGS #########
#####################

# add the lagged covariates to the dataframe
df <- add_lag(df,c("TA_avg","VPD_avg","SW_IN_avg","P_int","SWC_avg"),1)
df <- add_lag(df,c("TA_avg","VPD_avg","SW_IN_avg","P_int","SWC_avg"),7)
df <- add_lag(df,c("TA_avg","VPD_avg","SW_IN_avg","P_int","SWC_avg"),30)
df <- add_lag(df,c("TA_avg","VPD_avg","SW_IN_avg","P_int","SWC_avg"),365)

save(df,file="exploreDF.R")
load("exploreDF.R")

# plot lagged mean effects

for (i in 8:8){
  par(mfrow=c(2,3))
  for (j in seq(0,25,5)){
    plot(df[,i+j],df$NEE,xlab=colnames(df)[i+j],ylab="NEE",pch=4)
    abline(lm(df$NEE~df[,i+j]),col="red")
  }
}

# plotting one at a time so that it's faster
i=9
for (j in seq(0,25,5)){
  plot(df[,i+j],df$NEE,xlab=colnames(df)[i+j],ylab="NEE",pch=4)
  abline(lm(df$NEE~df[,i+j]),col="red")
}

# plotting each group separately so that I can see how each site responds differently

ggplot(data=df,mapping=aes(x=NEE_int,group=SiteID,color=SiteID)) + 
  geom_density() + ggtitle("NEE Density by Site")

ggplot(data=df,mapping=aes(x=GPP_int,group=SiteID,color=SiteID)) +
  geom_density() + ggtitle("GPP Density by Site")

ggplot(df,aes(x=TA_avg_365,y=NEE_int,color=SiteID)) +
  geom_point(alpha=.5,position="jitter") +
  theme_minimal() + ggtitle("Avg Yearly Temp by NEE")

ggplot(df,aes(x=VPD_avg_365,y=NEE_int,color=SiteID)) +
  geom_point(alpha=.5,position="jitter") +
  theme_minimal() + ggtitle("Avg Yearly VPD by NEE")

ggplot(df,aes(x=SW_IN_avg_365,y=NEE_int,color=SiteID)) +
  geom_point(alpha=.5,position="jitter") +
  theme_minimal() + ggtitle("Avg Yearly SW by NEE")

ggplot(df,aes(x=SWC_avg_365,y=NEE_int,color=SiteID)) +
  geom_point(alpha=.5,position="jitter") +
  theme_minimal() + ggtitle("Avg Yearly SWC by NEE")

# exploring precipitation: harder because most of the values are 0
ggplot(df,aes(x=P_int,y=NEE_int,color=SiteID)) +
  geom_point(alpha=.5,position="jitter") +
  theme_minimal() + ggtitle("Avg Yearly P by NEE")

ggplot(data=df[df$P_int != 0,],mapping=aes(x=P_int,group=SiteID,color=SiteID)) +
  geom_density() + ggtitle("P Density by Site")

df %>% 
  group_by(SiteID) %>% 
  summarise(sum(P_int==0),mean(P_int))

##################################
######## NEE QUANTILES ###########
##################################

df$NEE_quantiles <- rank_flux_quantiles(df$NEE_int,.05,.95,.1)

# checking that the quantile function worked: looks good to me!
ggplot(data=df,mapping=aes(x=NEE_quantiles,y=NEE_int,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Verifying NEE quantiles")

NEE_site_table <- df %>% 
  group_by(SiteID,NEE_quantiles) %>% 
  count()
print(NEE_site_table,n=24)

# boxplots of concurrent environmental covariates by each NEE quantile
ta <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=TA_avg,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Temperature by NEE Group") + theme_minimal()
vpd <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=VPD_avg,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("VPD by NEE Group") + theme_minimal()
sw <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SW_IN_avg,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SW by NEE Group") + theme_minimal()
p <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("P by NEE Group") + theme_minimal()
swc <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SWC_avg,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SWC by NEE Group") + theme_minimal()


# boxplots of previous day environmental covariates by each NEE quantile
ta_1 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=TA_avg_1,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Temperature by NEE Group") + theme_minimal()
vpd_1 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=VPD_avg_1,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("VPD by NEE Group") + theme_minimal()
sw_1 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SW_IN_avg_1,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SW by NEE Group") + theme_minimal()
p_1 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int_1,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("P by NEE Group") + theme_minimal()
swc_1 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SWC_avg_1,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SWC by NEE Group") + theme_minimal()

# boxplots of previous week environmental covariates by each NEE quantile
ta_7 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=TA_avg_7,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Temperature by NEE Group") + theme_minimal()
vpd_7 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=VPD_avg_7,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("VPD by NEE Group") + theme_minimal()
sw_7 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SW_IN_avg_7,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SW by NEE Group") + theme_minimal()
p_7 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int_7,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("P by NEE Group") + theme_minimal()
swc_7 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SWC_avg_7,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SWC by NEE Group") + theme_minimal()

# boxplots of previous month environmental covariates by each NEE quantile
ta_30 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=TA_avg_30,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Temperature by NEE Group") + theme_minimal()
vpd_30 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=VPD_avg_30,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("VPD by NEE Group") + theme_minimal()
sw_30 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SW_IN_avg_30,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SW by NEE Group") + theme_minimal()
p_30 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int_30,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("P by NEE Group") + theme_minimal()
swc_30 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SWC_avg_30,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SWC by NEE Group") + theme_minimal()

# boxplots of previous year environmental covariates by each NEE quantile
ta_365 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=TA_avg_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Temperature by NEE Group") + theme_minimal()
vpd_365 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=VPD_avg_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("VPD by NEE Group") + theme_minimal()
sw_365 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SW_IN_avg_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SW by NEE Group") + theme_minimal()
p_365 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("P by NEE Group") + theme_minimal()
swc_365 <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=SWC_avg_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("SWC by NEE Group") + theme_minimal()


# playing around with a weighted mean
df <- add_weighted_lag(df,c("P_int","TA_avg"),30)
df <- add_weighted_lag(df,c("P_int","TA_avg"),365)

p_365_weighted <- ggplot(data=df,mapping=aes(x=NEE_quantiles,y=P_int_weight_365,group=NEE_quantiles)) +
  geom_boxplot() + ggtitle("Yearly weighted prec by NEE Group")

# comparing all the boxplots
grid.arrange(ta,ta_1,ta_7,ta_30,ta_365)
grid.arrange(vpd,vpd_1,vpd_7,vpd_30,vpd_365)
grid.arrange(sw,sw_1,sw_7,sw_30,sw_365)
grid.arrange(p,p_1,p_7,p_30,p_365,p_365_weighted)
grid.arrange(swc,swc_1,swc_7,swc_30,swc_365)

# creating the prior states for NEE
df <- add_lag(df,c("NEE_quantiles","P_int"),1)

# comparing concurrent NEE with previous days
table(df$NEE_quantiles_1,df$NEE_quantiles)

