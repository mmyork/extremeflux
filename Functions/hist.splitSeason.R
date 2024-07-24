# writing function to split data into growing and not growing seasons by
# the historical yearly averages

split.season.hist <- function(gpp,Date,month,day){
  
  # calculating historical avg gpp for each day
  all_data <- data.frame(gpp,Date,month,day)
  colnames(all_data) <- c("gpp","Date","Month","Day")
  avg_data <- all_data %>% group_by(Month,Day) %>% summarise(mean(gpp))
  avg_data <- data.frame(avg_data)
  colnames(avg_data) <- c("Month","Day","avg_gpp")
  
  # making all dates day/month double digit for consistency
  avg_data$Month <- mapply(function(a){ifelse(nchar(a)==1,paste0("0",a),a)},avg_data$Month)
  avg_data$Day <- mapply(function(a){ifelse(nchar(a)==1,paste0("0",a),a)},avg_data$Day)
  # combining month and day into one date
  avg_data$avg_date <- paste0(avg_data$Month,"-",avg_data$Day)
  # dropping year from all the dates in gpp dataframe
  all_data$Date <- substr(all_data$Date,start=6,stop=10)
  
  # setting gpp threshold as total average of all gpp data
  grow_season <- rep(NA,length(avg_data$avg_gpp))
  gpp_thresh <- mean(gpp)
  
  # identifying dates that are above the gpp threshold for the previous week
  for (i in 7:length(avg_data$avg_gpp)){
    if (mean(avg_data$avg_gpp[(i-6):i]) > gpp_thresh){
      grow_season[i] <- 1
    } else {
      grow_season[i] <- 0
    }
  }
  
  # assigning values for the first week
  for (i in 1:6){
    j <- 6-i
    last_year <- sum(avg_data$avg_gpp[(366-j):366])
    this_year <- sum(avg_data$avg_gpp[1:i])
    if (((last_year+this_year) / 7)>gpp_thresh){
      grow_season[i] <- 1
    } else {
      grow_season[i] <- 0
    }
  }
  avg_data$grow_season <- grow_season
  # finding the grow/not grow dates
  g <- avg_data[avg_data$grow_season == 1,]
  grow <- ifelse(all_data$Date %in% g$avg_date,1,0)
  
  # assign growing season to those with date in g
  return(grow)
}

