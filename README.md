# Drivers of extreme carbon fluxes
## Introduction

## Objectives
 (1) Determine which environmental variables are important predictors of daily fluxes, and do these important variables differ among different flux components (GPP and Reco). 
 (2) Use flux data to define “extreme flux classes” or “syndromes”, including high/low GPP, high/low Reco, and inactivity (low GPP & Reco). Investigate how important environmental predictors vary between the extreme states of these flux measurements.
 (3) What environmental predictors are the most important for predicting the extreme flux syndromes inside and outside of the growing season, and do these align across flux types (GPP, Reco)? 
 (4) Determine how timescales of importance vary between predicting GPP and Reco extremes and how 

## Workflow
# Identify flux towers sites to focus on.
The fluxnet 2015 dataset was used, along with the addition of 7 seperate sites located in NM and AZ (Seg,Ses,Mpj,Wjs,Vcp,Vcs,& Sr). Sites with less than two years of data were removed. Reco was calculated using as Reco=GPP+NEE, and any dates with autofilled or questionable measurements were removed. Calibration periods for the fluxnet 2015 were present in almost all 50ish sites, so a function (find_calibratin.R) was made that picks up on these patterns and isolates date ranges to be deleted. These dates were manually reviewed and edited in dropDates.R, such that loading this file provides all the dates to be removed from each site. 

* Future note * Ideally, these models will be extended to the next fluxnet release!


