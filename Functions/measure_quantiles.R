# function that splits gpp and reco into 3 quantiles: high, normal, low
measure_quantiles <- function(measure,lower,upper){
  high_quant <- quantile(measure,upper)
  low_quant <- quantile(measure,lower)
  measure_state <- rep(NA,length(measure))
  for (i in 1:length(measure)){
    if (measure[i] <= low_quant){
      measure[i] <- 1
    } else if (measure[i] >= high_quant){
      measure[i] <- 3
    } else {
      measure[i] <- 2
    }
  }
  return(measure)
}
