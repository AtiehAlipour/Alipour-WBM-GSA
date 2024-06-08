# Make all the data that we frequently use just for the 47 stations
# This include, all stations, corn, observation, output, saturation, and index file
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# all stations

file = "/Data/Selected_SM_xy_4326.txt"
allstations = read.delim(file, header = FALSE, sep = "\t", dec = ".")
allstations = allstations[c(-22,-23), ]   # Not enough data and overlap with another station with more observation
allstations = allstations[c(-36,-50), ]   # Not enough data between 2008to 2022 
allstations = allstations[c(-1,-2,-12,-14,-15,-18,-23,-25,-26,-28,-30,-32,-33,-39,-40,-42,-43,-45,-47,-50,-52,-53,-55,-56,-58,-68,-70,-74,-75,-77), ]   # No obs data or negaitive corr with prec for corn

write.table(allstations, file="/Data/47stations.txt", sep = "\t", row.names=FALSE, col.names=FALSE)


##########################################################

# station index

# load station index file
load("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/allStation_Index.Rda")
station_index = station_index[c(-22,-23), ]   # Not enough data and overlap with another station with more observation
station_index = station_index[c(-36,-50), ]   # Not enough data between 2008to 2022 
station_index = station_index[c(-1,-2,-12,-14,-15,-18,-23,-25,-26,-28,-30,-32,-33,-39,-40,-42,-43,-45,-47,-50,-52,-53,-55,-56,-58,-68,-70,-74,-75,-77), ]   # No obs data or negaitive corr with prec for corn

save(station_index,file="/Data/47Station_Index.Rda")


##########################################################

# Observation


# Define the start and end dates

start_date <- as.Date("2008/01/01")
end_date <- as.Date("2022/12/31")

# Calculate the number of days between the dates

num_days <- as.numeric(end_date - start_date) + 1

# Create an empty array
SM_Obs <- array(NA, dim = c(79, num_days))  

for(s in 1:79){
  
  file_path <- paste0("/Data/Obs_gauges/station_",s,"time_series.Rda")
  load(file_path)
  for (d in 1:num_days){
    SM_Obs[s,d]<-SM_WA_Obs[d]
  }
}

SM_Obs = SM_Obs[c(-36,-50), ]   # Not enough data between 2008to 2022 
SM_Obs = SM_Obs[c(-1,-2,-12,-14,-15,-18,-23,-25,-26,-28,-30,-32,-33,-39,-40,-42,-43,-45,-47,-50,-52,-53,-55,-56,-58,-68,-70,-74,-75,-77), ]    # No obs data or negaitive corr with prec for corn

save(SM_Obs,file="/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/47Obs_data.Rda")


##########################################################

# Corn

# Crop file path name
filecrop = "/Data/corn_obs_years.txt"
corn = read.delim(filecrop, header = TRUE, sep = "\t", dec = ".")
corn= corn[c(-17,-18), ] # Not enough data and overlap with another station with more observation

# Create an empty array
index <- array(NA, dim = dim(allstations)[1])  

for(s in 1:dim(allstations)[1]){
  
  # Find the indices of elements that meet both conditions in the column
  index[s] <- which(corn[,1] == allstations[s, 1] & corn[,2] == allstations[s, 2])}

new_corn <- corn[index,]
write.table(new_corn, file="/Data/47corn_obs_years.txt", sep = "\t",row.names=FALSE, col.names=FALSE)


##########################################################

# Output

Ens<- 5000

for (i in 1:Ens){
  print(i)
  load(paste0("/Output/all_station/",i,"_","time_series_soilMoistFrac.Rda"))
  
  SM_Output = SM_Output[ ,c(-36,-50)]   # Not enough data between 2008to 2022 
  SM_Output = SM_Output[ ,c(-1,-2,-12,-14,-15,-18,-23,-25,-26,-28,-30,-32,-33,-39,-40,-42,-43,-45,-47,-50,-52,-53,-55,-56,-58,-68,-70,-74,-75,-77)]    # No obs data or negaitive corr with prec for corn
  
  save(SM_Output,file=paste0("/Output/47_stations/",i,"_","47_stations_time_series_soilMoistFrac.Rda"))
  
}

##########################################################
