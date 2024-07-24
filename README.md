# Drivers of extreme carbon fluxes
## Introduction

## Objectives
 (1) Determine which environmental variables are important predictors of daily fluxes, and do these important variables differ among different flux components (GPP and Reco). 
 (2) Use flux data to define “extreme flux classes” or “syndromes”, including high/low GPP, high/low Reco, and inactivity (low GPP & Reco). Investigate how important environmental predictors vary between the extreme states of these flux measurements.
 (3) What environmental predictors are the most important for predicting the extreme flux syndromes inside and outside of the growing season, and do these align across flux types (GPP, Reco)? 
 (4) Determine how timescales of importance vary between predicting GPP and Reco extremes and across their growing seasons.

## Workflow
### Identify flux towers sites to focus on.
The fluxnet 2015 dataset was used, along with the addition of 7 seperately loaded sites located in NM and AZ (Seg,Ses,Mpj,Wjs,Vcp,Vcs,& Sr). Loading and editing of this data in preparation for modeling is done in **flux2015.model.R** and datasets can be found under the Data folder. Variables of interest are temperature (TA), precipitation (P), vapor pressure deficit (VPD), shortwave radiation (SW), net ecosystem exchange (NEE), and gross primary production (GPP). Sites with less than two years of data were removed. Reco was calculated using as Reco=GPP+NEE, and any dates with autofilled or questionable measurements were removed. Calibration periods for the fluxnet 2015 were present in almost all 50ish sites, so a function (**find_calibration.R**) was made that picks up on these patterns and isolates date ranges to be deleted. These dates were manually reviewed and edited in **dropDates.R**, such that loading this file provides all the dates to be removed from each site.

* **Future note**: Fluxnet 2015 does not include soil water content (SWC) data, so we need to find and include that in the next model. Additionally, we obtained site average climate measures from PRISM to incorporate into the dataset and model. The goal here is to eliminate importance of year lags that is due to site differentiation. Go to the lags section for more information. Ideally, these models will be extended to the next fluxnet release!
* **Future note 2**: Since the last running of models, new dates that need to be dropped were discovered. Bear in mind, currently saved datasets include these dates and the flux2015.model.R should ultimately be rerun and data sets re-saved to remove this. The dates to be dropped have already been added to dropDates.R.

### Create growing seasons.
Currently (and in most recent models), seasons are determined based on the **seasonSplit.R** and assigned at each site separately, NOT OVERALL. This algorithm determines seasonality based on the following guideline: if the average GPP from 3 days prior to 3 days ahead of the date of interest (7 day moving average) is above the 25th percentile of that sites GPP values, the date is assigned as inside the growing season. Otherwise, it is assigned as outside the growing season. This definition is less of a growing season and more a fluctuating indicator of plant activity. This is no longer the intended growing season definition and needs to be changed prior to running the next set of models. The dataset was split into 3 different sets: one being the complete dataset (**bindat.all.R**), one with only the dates in each sites growing season (**bindat.in.R**), and one with only the dates for each site that are out of season (**bindat.out.R**).

* **Future note**: The next models will move away from a fluctuating definition of seasonality, and towards an established date range (same for each year of a site) that defines one growing season per year based on the sites GPP levels HISTORICALLY. A function already exists, called hist.season.split() in **hist.splitSeason.R**, that determines seasons based on historical averages, but it allows for multiple growing seasons as the historical average moves above and below the threshold. Instead, it needs to be updated so that it creates one date range from the first time the historical average passes a GPP threshold to the last time it dips below that threshold.

### Create categorical flux states for GPP and Reco.
GPP and Reco are divided into low/typical/high categories using the function in **measure_quantiles.R**. This is setting a threshold such that anything below the 5th quantile for that measure is low and above the 95th quantile is high. This is done for both measures at each site LOCALLY, and performed separately on the combined, in-season, and out-of-season data. Additionally, an inactive state is determined using the function in **inactive_quantiles.R**. This function defines an inactive state in the following way: (1) isolate all dates where GPP is <25th percentile for that site, (2) take the absolute value of these dates NEE values and order decreasingly, (3) label dates with smallest abs(NEE) values as inactive until the inactive state contains 5% of the entire sites data. Binary variables were then made for strong source (reco state==3), strong sink (gpp state==3), and inactive states (inactive state==1). Overall, you should have the following:
- strong sink, strong source, and inactive which were defined at the level of each site for all combined data (bindat.all.R)
- strong sink, strong source, and inactive which were defined at the level of each site using data only in the growing season (bindat.in.R)
- strong sink, strong source, and inactive which were defined at the level of each site using data only outside the growing season (bindat.out.R)
Something to keep in mind is that, logistically, the out of season strong sink doesn't provide meaningful information since both these terms are defined by GPP; it just picks up on shoulder seasons. Additionally, inactive states only makes sense over the combined data.
* **Future note**: With the previous statement in mind, we will be redirecting out focus to running models on low AND high GPP and Reco across all the seasonal and combined datasets, rather than just high. The definition of inactive state may receive a revamp, since its current definition could allow Reco values to vary significantly. Instead, this function needs to be rewritten to place hard thresholds on GPP and Reco, whether or not that results in 5% of the data being in the inactive state or not.

### 



