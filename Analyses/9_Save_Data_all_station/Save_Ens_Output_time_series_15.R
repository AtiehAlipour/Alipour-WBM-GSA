# Reading outputs for one station
# Chnage station number and obs period
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries

library(ncdf4)
library(future.apply)
library(future)

##########################################################

# Function to extract output

outputf <- function(i){
#if (!file.exists(paste0("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/Output_corn_1/all_station/",i,"_","time_series_soilMoistFrac.Rda"))){
if (!file.exists(paste0("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/Output_corn_1/all_station/",i,"_","time_series.Rda"))){

print(i)
# station start and end dates
start_date <- as.Date("2008/01/01")
end_date <- as.Date("2022/12/31")
date_sequence <- seq(start_date, end_date, by = "day")


# load station index file for corn
load("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/allStation_Index.Rda")
station_index = station_index[c(-22,-23), ]

# Station file name path
file = "/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/Selected_SM_xy_4326.txt"
allstations = read.delim(file, header = FALSE, sep = "\t", dec = ".")
allstations= allstations[c(-22,-23), ]


# Calculate the number of days between the dates
num_days <- as.numeric(end_date - start_date) + 1

##########################################################


# Make an array for the output file

# Create an empty array
# Number of copies to create


SM_Output <- array(NA, dim =c(num_days,79))


  # output folder path
Folderpath <- paste0("/gpfs/group/kaf26/default/users/aqa6478/WBM/Corn_1/",i,"/wbm_output/daily/")
  
  d<-1
  dd<-1
  date<- start_date
  pastyear <-"2008"
  ncin<- nc_open(paste0(Folderpath,"wbm_",pastyear,".nc"))
  #SM_Ot<- ncvar_get(ncin, "soilMoistFrac")
  SM_Ot<- ncvar_get(ncin, "soilMoist")

  while (date <= end_date){
    year <- format(date,"%Y")
    
    # check if files changed
    if (year != pastyear) {
      dd<-1
      ncin<- nc_open(paste0(Folderpath,"wbm_",year,".nc"))
      #SM_Ot<- ncvar_get(ncin, "soilMoistFrac")}
      SM_Ot<- ncvar_get(ncin, "soilMoist")}

    
    # save soil moisture in a separate files
    for(s in 1:dim(station_index)[1]){
    SM_Output[d,s] <- SM_Ot[station_index[s,1],station_index[s,2],dd]}
    d=d+1
    date <- date + 1
    dd=dd+1
    pastyear<-year}
#save(SM_Output,file=paste0("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/Output_corn_1/all_station/",i,"_","time_series_soilMoistFrac.Rda"))}}
save(SM_Output,file=paste0("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/Output_corn_1/all_station/",i,"_","time_series.Rda"))}}
  
  
##########################################################


# Selected station 79 stations

# Number of copies to create
code<-15

# Set up parallel processing
plan(multisession)


# Copy the folder in parallel
future_lapply(((code-1)*250+1):((code-1)*250+250), function(i) outputf(i))