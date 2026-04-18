# read and store output files in a text file
# Change the folder path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries
library(zoo)
library(xts)
library(lubridate)


##########################################################

# Define the start and end dates

start_date <- as.Date("2008/01/01")
end_date <- as.Date("2022/12/31")

# Calculate the number of days between the dates

num_days <- as.numeric(end_date - start_date) + 1


date_sequence <- seq(start_date, end_date, by = "day")


##########################################################

# Model output folder path

path<-"/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/Output_corn_1/47_stations/"

# Store the model output in a sigle file
output_5000<- array(NA, dim =c(5000,47)) 

for(i in 1:5000){
  for (j in 1:47){
    print(i)
    load(paste0(path,i,"_47_stations_time_series_soilMoistFrac.Rda"))

    indices <- which(format(date_sequence, "%m") %in% c("03", "04", "05"))

    output_5000[i,j]<- mean(SM_Output[indices,j])}}


##########################################################

# Save the output in a text file

write.table(output_5000, file="/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/SA/AV_SM_Spring_Stations/data/model_output.txt", row.names=FALSE, col.names=FALSE)

