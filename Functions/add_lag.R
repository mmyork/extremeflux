# trying to fix this lag so that it can include a hreshold number of acceptable missing days
add_lag <- function(df,var,days){
  df_lag <- df
  df_lag$Date <- as.Date(df_lag$Date)
  
  # initialize empty list
  df_lag_list <- list()
  
  # loop through each site
  for (site in unique(df_lag$site)){
    dat <- df_lag[df_lag$site==site,]
    
    # create mean variable and sd variable (if applicable)
    lag_var_name <- paste0(var,"_",days)
    dat[,lag_var_name] <- rep(NA,nrow(dat))
    if (days > 1){
      # this is the name for the sd variable
      lag_sd_name <- paste0(var,"_sd_",days)
      # initializing its values
      dat[,lag_sd_name] <- rep(NA,nrow(df_lag))
    }
    
    # loop through each entry in the site dataset
    for (i in 1:nrow(dat)){
      # find the lag date range for that entry
      end_date <- dat$Date[i] - 1
      start_date <- dat$Date[i] - days
      date_range <- seq(start_date,end_date,by="day")
      # find entries in dat that fall in this range
      in_lag <- dat[dat$Date %in% date_range,]
      # if theres <.7 of the data, assign as NA
      count <- nrow(in_lag)
      if ((count/days) < .7){
        dat[i,lag_var_name] <- NA
        if (days>1){
          dat[i,lag_sd_name] <- NA
        }
      }
      # if not, calculate mean of in_lag columns and assign
      else {
        dat[i,lag_var_name] <- colMeans(in_lag[,var])
        # if more than one day, calculate and add sd
        if (days > 1){
          dat[i,lag_sd_name] <- apply(in_lag[,var],2,sd)
        }
      }
    }
    # add dat to list
    df_lag_list <- append(df_lag_list,list(dat))
  }
  df_final <- do.call(rbind,df_lag_list)
  return(df_final)
}







add_lag_old <- function(df,var,days){
  df_lag <- df
  df_lag$Date <- as.Date(df_lag$Date)
  
  # create new mean variable 
  lag_var_name <- paste0(var,"_",days)
  df[,lag_var_name] <- rep(NA,nrow(df_lag))
  
  # create sd variable if lag is greater than 1 day
  if (days > 1){
    
    # this is the name for the sd variable
    lag_sd_name <- paste0(var,"_sd_",days)
    
    # itializing its values
    df[,lag_sd_name] <- rep(NA,nrow(df_lag))
  }
  
  # loop through each row and isolate the previous number of days that are included in the lag
  for (i in (days+1):nrow(df_lag)){
    lag_dates <- df_lag$Date[(i-days):i]
    
    # verify these days are in order as back to back days
    if (all(diff(lag_dates)==1)==TRUE){
      
      # isolate the days included in the lag and calculate mean
      lag_values <- df_lag[(i-days):(i-1),var]
      df_lag[i,lag_var_name] <- colMeans(lag_values)
      
      # calculate sd of the lag days if the lag is greater than 1 day
      if (days > 1) {
        df_lag[i,lag_sd_name] <- apply(lag_values,2,sd)
      }
      
      # if there are missing or out of order days, sub NA   
    } else {
      df_lag[i,lag_var_name] <- NA
    }
  }
  return(df_lag)
}

add_weighted_lag <- function(df,var,days){
  df_lag <- df
  df_lag$Date <- as.Date(df_lag$Date)
  
  # create new mean variable 
  lag_var_name <- paste0(var,"_weight_",days)
  df[,lag_var_name] <- rep(NA,nrow(df_lag))
  
  # loop through each row and isolate the previous number of days
  for (i in (days+1):nrow(df_lag)){
    lag_dates <- df_lag$Date[(i-days):i]
    
    # if these days are all in order and from the same site, calculate mean
    if (all(diff(lag_dates)==1)==TRUE){
      lag_values <- df_lag[(i-days):(i-1),var]
      
      # calculate linearly decreasing weights
      lin_weights <- seq(days,1) / sum(seq(days,1))
      
      # calculate weighted mean
      df_lag[i,lag_var_name] <- sapply(1:ncol(lag_values),function(i) weighted.mean(lag_values[,i],lin_weights))
      
      # if there are missing or out of order days, sub NA   
    } else {
      df_lag[i,lag_var_name] <- NA
    }
  }
  return(df_lag)
}

