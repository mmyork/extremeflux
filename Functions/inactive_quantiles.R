# this function is for classifying inactive states
inactive_quantiles <- function(nee,gpp,gpp_inactive){
  # first take absolute value of NEE values
  nee_abs <- abs(nee)
  # create dataframe and add id
  data <- data.frame(nee,nee_abs,gpp,id=seq(1,length(gpp),1))
  # add empty column for nee state
  data$nee_state <- rep(0,length(gpp))
  # create inactive threshold for gpp
  gpp_thres_inac <- quantile(data$gpp,gpp_inactive)
  
  # order dataframe by lowest abs nee,then lowest gpp
  data <- data[order(data$nee_abs,data$gpp,decreasing=FALSE),]
  # now loop through and add to inactive state until .05 of data is included
  count = 0
  i = 1
  while ((count / length(gpp)) < .05){
    if (data$gpp[i] <= gpp_thres_inac){
      count = count + 1
      data$nee_state[i] <- 1
    }
    i = i+1
  }
  # reorder data and return
  data <- data[order(data$id),]
  return(data$nee_state)
  
}
