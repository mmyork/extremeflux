# Drivers of extreme carbon fluxes
## Introduction

## Objectives
 (1) Determine which environmental variables are important predictors of daily fluxes, and do these important variables differ among different flux components (GPP and Reco). 
 (2) Use flux data to define “extreme flux classes” or “syndromes”, including high/low GPP, high/low Reco, and inactivity (low GPP & Reco). Investigate how important environmental predictors vary between the extreme states of these flux measurements.
 (3) What environmental predictors are the most important for predicting the extreme flux syndromes inside and outside of the growing season, and do these align across flux types (GPP, Reco)? 
 (4) Determine how timescales of importance vary between predicting GPP and Reco extremes and across their growing seasons.

## Workflow
### Identify flux towers sites to focus on.
The fluxnet 2015 dataset was used, along with the addition of 7 seperate sites located in NM and AZ (Seg,Ses,Mpj,Wjs,Vcp,Vcs,& Sr). Sites with less than two years of data were removed. Reco was calculated using as Reco=GPP+NEE, and any dates with autofilled or questionable measurements were removed. Calibration periods for the fluxnet 2015 were present in almost all 50ish sites, so a function (find_calibration.R) was made that picks up on these patterns and isolates date ranges to be deleted. These dates were manually reviewed and edited in dropDates.R, such that loading this file provides all the dates to be removed from each site. Loading and editing of this data in preparation for modeling is done in flux2015.model.R.

* Future note: Ideally, these models will be extended to the next fluxnet release!

### Create growing seasons.
Currently (and in most recent models), seasons are determined based on the seasonSplit.R and assigned at each site separately, NOT OVERALL. This algorithm determines seasonality based on the following guideline: if the average GPP from 3 days prior to 3 days ahead of the date of interest (7 day moving average) is above the 25th percentile of that sites GPP values, the date is assigned as inside the growing season. Otherwise, it is assigned as outside the growing season. This definition is less of a growing season and more a fluctuating indicator of plant activity. This is no longer the intended growing season definition and needs to be changed prior to running the next set of models.

* Future note: The next models will move away from a fluctuating definition of seasonality, and towards an established date range (same for each year of a site) that defines one growing season per year based on the sites GPP levels HISTORICALLY. A function already exists that determines seasons based on historical averages, but it allows for multiple growing seasons as the historical average moves above and below the threshold. Instead, it needs to be updated so that it creates one date range from the first time the historical average passes a GPP threshold to the last time it dips below that threshold.
* need to add the name of this historical function

### Create categorical flux states for GPP and Reco.


