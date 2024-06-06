# plot the daily, weekly, monthly, and seasonal performance
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries
library(ggplot2)
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

# Collect the soil moisture observation

load("/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/47Obs_data.Rda")

filecrop = "/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/47corn_obs_years.txt"
corn = read.delim(filecrop, header = FALSE, sep = "\t", dec = ".")


file = "/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/47stations_Saturation.txt"
saturation = read.delim(file, header = FALSE, sep = "\t", dec = ".")


# load station index file
load("/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/47Station_Index.Rda")


##########################################################

# Scale the soil Moisture to zero (min(obs)) and one

# Create an empty array
SM_Obs_newS <- array(NA, dim = c(dim(corn)[1], num_days))  


for (s in 1:dim(corn)[1]){
  if(saturation[s,]>max(SM_Obs[s,], na.rm=TRUE)){
    SM_Obs_newS[s,1:num_days]<-(SM_Obs[s,1:num_days]-min(SM_Obs[s,], na.rm=TRUE))/(saturation[s,]-min(SM_Obs[s,], na.rm=TRUE))
  }else{
    SM_Obs_newS[s,1:num_days]<-(SM_Obs[s,1:num_days]-min(SM_Obs[s,], na.rm=TRUE))/(max(SM_Obs[s,], na.rm=TRUE)-min(SM_Obs[s,], na.rm=TRUE))}}


##########################################################

# Estimate monthly average observation across all the stations

# Create an empty array
SM_obsS_av <- array(NA, dim = 12)  

for (m in 1:12){
  if (m < 10){
    month <- paste0("0",m)}else{
      month <- paste0(m)}
  
  indices <- which(format(date_sequence, "%m") == month)
  
  SM_obsS_av[m]<- mean(SM_Obs_newS[,indices], na.rm = TRUE)
  
}


##########################################################

# Estimate monthly average for each ensemble across all the stations

Ens<- 5000

# Create an empty array
all_SM_Output <- array(NA, dim = c(12,Ens)) 

for(i in 1:Ens) {
  print(i)
  load(paste0("/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/Output_corn_1/47_stations/",i,"_","47_stations_time_series_soilMoistFrac.Rda"))
  for(s in 1:dim(corn)[1]){ 
    indices <- which(is.na(SM_Obs_newS[s,]))
    SM_Output[indices,s] <- NA}
  
  for (m in 1:12){
    if (m < 10){
      month <- paste0("0",m)}else{
        month <- paste0(m)}
    
    indices <- which(format(date_sequence, "%m") == month)
    
    all_SM_Output[m,i]<- mean(SM_Output[indices,], na.rm = TRUE)
    
  }
}




##########################################################
# Create a large array of the observation

# Create an empty array
SM_obsS <- array(NA, dim = num_days*47)  

for (i in 1:47){
  SM_obsS[(((i-1)*num_days)+1):(i*num_days)]<- SM_Obs_newS[i,1:num_days]
  
}

##########################################################
# create large matrix of output 


Ens<- 5000

# Create an empty array

daily_rmse <- array(NA, dim = c(47,Ens)) 
weekly_rmse <- array(NA, dim = c(47,Ens)) 
monthly_rmse <- array(NA, dim = c(47,Ens)) 
seasonal_rmse <- array(NA, dim = c(47,Ens)) 

daily_corr <- array(NA, dim = c(47,Ens)) 
weekly_corr <- array(NA, dim = c(47,Ens)) 
monthly_corr <- array(NA, dim = c(47,Ens)) 
seasonal_corr <- array(NA, dim = c(47,Ens)) 



for(e in 1:Ens){
  print(e)
  load(paste0("/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/Data/Output_corn_1/47_stations/",e,"_","47_stations_time_series_soilMoistFrac.Rda"))
  
  for (i in 1:47){
    
    #Calculate Weekly, Monthly, and Seasonal RMSE
    data1_ts <- zoo(SM_Output[1:num_days,i], order.by = as.Date(date_sequence))
    data2_ts <- zoo(SM_Obs_newS[i,1:num_days], order.by = as.Date(date_sequence))
    
    
    daily_rmse[i,e] <- sqrt(mean((data1_ts - data2_ts)^2, na.rm = TRUE))
    daily_corr[i, e] <- cor(data1_ts, data2_ts, use = "complete.obs")
    
    
    weekly_data1 <- aggregate(data1_ts, as.integer(floor_date(index(data1_ts), unit = "week")), mean)
    weekly_data2 <- aggregate(data2_ts, as.integer(floor_date(index(data2_ts), unit = "week")), mean)
    weekly_rmse[i,e] <- sqrt(mean((weekly_data1 - weekly_data2)^2, na.rm = TRUE))
    weekly_corr[i, e] <- cor(weekly_data1, weekly_data2, use = "complete.obs")
    
    
    monthly_data1 <- aggregate(data1_ts, as.integer(floor_date(index(data1_ts), unit = "month")), mean)
    monthly_data2 <- aggregate(data2_ts, as.integer(floor_date(index(data2_ts), unit = "month")), mean)
    monthly_rmse[i,e] <- sqrt(mean((monthly_data1 - monthly_data2)^2, na.rm = TRUE))
    monthly_corr[i, e] <- cor(monthly_data1, monthly_data2, use = "complete.obs")
    
    
    
    seasonal_data1 <- aggregate(data1_ts, as.integer(floor_date(index(data1_ts), unit = "quarter")), mean)
    seasonal_data2 <- aggregate(data2_ts, as.integer(floor_date(index(data2_ts), unit = "quarter")), mean)
    seasonal_rmse[i,e] <- sqrt(mean((seasonal_data1 - seasonal_data2)^2, na.rm = TRUE))
    seasonal_corr[i, e] <- cor(seasonal_data1, seasonal_data2, use = "complete.obs")
    
  
  }
  
}




##########################################################

# plot


# Create a new figure with the desired dimensions
png("pdfs_dwms.png", type="cairo", width = 8000, height = 4000, res = 300)

nrows <- 1
ncols <- 2

par(mfrow = c(nrows, ncols),mar = c(5, 8, 4, 2),oma = c(2.5, 3, 2, 1),cex = 1.25)

# Increase the label and tick mark font sizes
par(cex.lab=2, cex.axis=2,font.axis=2)



# Create the density plot for the first dataset
plot(density(daily_rmse), xlab = "",
     ylab = "", col = "blue", ylim=c(0,6),xlim=c(0,1),lwd=2, main="")

y_label="Density"
mtext(y_label, side = 2, line = 4, font = 2, cex = 2)

x_label <- "RMSE"
mtext(x_label, side = 1, line = 4,  font = 2, cex = 2)


#Add the gridlines
abline(h = seq(0,6,1), v= seq(0,1,0.2),lty = "dashed", col = "gray30")


# Add additional density plots on top of the first one
lines(density(weekly_rmse), col = "cyan3",lwd=2)
lines(density(monthly_rmse), col = "darkgreen", lwd=2)
lines(density(seasonal_rmse), col = "darkmagenta", lwd=2)


# Add a box around the current subplot
box()


# Add a legend
legend("topright", legend=c("daily", "weekly", "monthly", "seasonal"),
       col=c("blue", "cyan3", "darkgreen", "darkmagenta"), lwd=2, cex = 2,text.font=2)



# Create the density plot for the first dataset
plot(density(daily_corr), xlab = "",
     ylab = "", col = "blue", ylim=c(0,3),xlim=c(-0.5,1),lwd=2, main="")

y_label="Density"
mtext(y_label, side = 2, line = 4, font = 2, cex = 2)

x_label <- "Correlation Coefficient"
mtext(x_label, side = 1, line = 4,  font = 2, cex = 2)


# Add additional density plots on top of the first one
lines(density(weekly_corr), col = "cyan3",lwd=2)
lines(density(monthly_corr), col = "darkgreen", lwd=2)
lines(density(seasonal_corr), col = "darkmagenta", lwd=2)


#Add the gridlines
abline(h = seq(0,3,0.5), v= seq(-0.5,1,0.3),lty = "dashed", col = "gray30")


# Add a box around the current subplot
box()


# Add a legend
legend("topleft", legend=c("daily", "weekly", "monthly", "seasonal"),
       col=c("blue", "cyan3", "darkgreen", "darkmagenta"), lwd=2, cex = 2,text.font=2)



# Add the area under the curve with transparency
#color_with_transparency <- rgb(0, 1, 0, alpha = 0.2) # green with 0.5 transparency (adjust alpha as needed)
#polygon(dens, col = color_with_transparency)



#mtext("Density", side = 2, line = 3, font = 2, cex = 1.5)
#mtext("correlation coefficient", side = 1, line = 3, font = 2, cex = 1.5)


# Save and close the figure
dev.off()

