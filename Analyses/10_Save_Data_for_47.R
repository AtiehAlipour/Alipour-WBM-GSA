# Save outputfor the 47 stations
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

Ens<- 5000

for (i in 1:Ens){
  print(i)
  load(paste0("/Output/all_station/",i,"_","time_series_soilMoistFrac.Rda"))
  
  SM_Output = SM_Output[ ,c(-36,-50)]   # Not enough data between 2008to 2022 
  SM_Output = SM_Output[ ,c(-1,-2,-12,-14,-15,-18,-23,-25,-26,-28,-30,-32,-33,-39,-40,-42,-43,-45,-47,-50,-52,-53,-55,-56,-58,-68,-70,-74,-75,-77)]    # No obs data or negaitive corr with prec for corn
  
  save(SM_Output,file=paste0("/Output/47_stations/",i,"_","47_stations_time_series_soilMoistFrac.Rda"))
  
}

##########################################################
