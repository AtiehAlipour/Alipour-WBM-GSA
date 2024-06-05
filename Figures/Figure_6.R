# Plot the boxplots
# Change input and output file path 
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries

library(ggplot2)
library(RColorBrewer)

##########################################################

# Define the start and end dates

start_date <- as.Date("2008/01/01")
end_date <- as.Date("2022/12/31")

# Calculate the number of days between the dates

num_days <- as.numeric(end_date - start_date) + 1

date_sequence <- seq(start_date, end_date, by = "day")


##########################################################

# Collect the soil moisture observation

load("/Data/47Obs_data.Rda")

filecrop = "/Data/47corn_obs_years.txt"
corn = read.delim(filecrop, header = FALSE, sep = "\t", dec = ".")


file = "/Data/47stations_Saturation.txt"
saturation = read.delim(file, header = FALSE, sep = "\t", dec = ".")


# load station index file
load("/Data/47Station_Index.Rda")



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


# Estimate RMSE for each ensemble for each station

Ens<- 5000

# Create an empty array
SM_Corr <- array(NA, dim = c(47,Ens)) 

for(i in 1:Ens) {
  print(i)
  load(paste0("/Data/Output_corn_1/47_stations/",i,"_","47_stations_time_series_soilMoistFrac.Rda"))
  for(s in 1:dim(corn)[1]){ 
    # Create an empty array
    SM_Corr[s,i]<-cor(SM_Output[,s],SM_Obs_newS[s,],use="pairwise.complete.obs")}
    
  }



##########################################################

# Estimate RMSE for each ensemble for each station

Ens<- 5000

# Create an empty array
SM_RMSE <- array(NA, dim = c(47,Ens)) 

for(i in 1:Ens) {
  print(i)
  load(paste0("/Data/Output_corn_1/47_stations/",i,"_","47_stations_time_series_soilMoistFrac.Rda"))
  for(s in 1:dim(corn)[1]){ 
    squared_diff <- (SM_Obs_newS[s,] - SM_Output[,s])^2
    SM_RMSE[s,i]<-  mean(squared_diff, na.rm = TRUE) 
    
  }
}


##########################################################

# default

SM_Default<- array(NA, dim =c(num_days,47))

# output folder path
Folderpath <- paste0("/Analyses/SM_Main/wbm_output/daily/")

d<-1
dd<-1
date<- start_date
pastyear <- format(start_date,"%Y")
ncin<- nc_open(paste0(Folderpath,"wbm_",pastyear,".nc"))
SM_Ot<- ncvar_get(ncin, "soilMoistFrac")
while (date <= end_date){
  year <- format(date,"%Y")
  
  # check if files changed
  if (year != pastyear) {
    dd<-1
    ncin<- nc_open(paste0(Folderpath,"wbm_",year,".nc"))
    SM_Ot<- ncvar_get(ncin, "soilMoistFrac")}
  
  # save soil moisture in a separate files
  for (s in 1:47){
    SM_Default[d,s] <- SM_Ot[station_index[s,1],station_index[s,2],dd]}
  d=d+1
  date <- date + 1
  dd=dd+1
  pastyear<-year}


Default_Corr<- array(NA, dim =c(47))


for (s in 1:47){
  Default_Corr[s]<-cor( SM_Default[,s],SM_Obs_newS[s,],use="pairwise.complete.obs")}



Default_RMSE<- array(NA, dim =c(47))


for (s in 1:47){
  squared_diff <- (SM_Obs_newS[s,] - SM_Default[,s])^2
  Default_RMSE[s]<-  mean(squared_diff, na.rm = TRUE) }




##########################################################

# plot

# Create a new figure with the desired dimensions
png(paste0("figure4.png"), width = 12000, height = 14000, res = 300)

# Set the layout for the subplot grid
par(mfrow = c(1, 2),cex = 4, mar = c(4, 4, 2, 2), oma = c(0, 0, 0, 0))  # Adjust the margin values as per your requirement

# plor RMSE

# plot corr
# Convert transposed data to a data frame
df <- data.frame(t(SM_RMSE))

# Replace outliers greater than 0.6 with NA to make the plot nicer
 df[df > 0.5] <- NA

num_colors <- 47
color_palette <- brewer.pal(num_colors, "Set3")  # You can choose a different palette

# Create horizontal box plots
boxplot(df, outpch = 19, cex = 0.25, col = color_palette, xlab = "", ylab = "",
        yaxt = "n", horizontal = TRUE)  # Set horizontal = TRUE

# Customize the tick labels on the y-axis (now it's the y-axis since the plot is horizontal)
y_labels <- 1:47  # Values from 1 to 47

axis(2, at = y_labels, labels = FALSE)  # Turn off default labels
axis(2, at = y_labels[seq(1, length(y_labels), by = 2)], labels = y_labels[seq(1, length(y_labels), by = 2)], font = 2, las = 1)
axis(1, font = 2, cex = 3)  # Add x-axis to the first column of each row

# Add a single point to each subplot
for (i in 1:47) {
  points(x = Default_RMSE[i], y = i, pch = 4, col = "black", cex = 1, lwd = 6)
}

# Add y and x labels (note that they are switched since the plot is horizontal)
mtext("Stations", side = 2, line = 3, font = 2, cex = 4)
mtext("RMSE", side = 1, line = 3, font = 2, cex = 4)

# Add legends with bold font
legend("bottomright", legend = c("Default simulation"), col = c("black"),
       pch = c(4),
       lty = c(NA),
       lwd = c(6),
       pt.cex = c(1),
       cex = 1,
       text.font = 2)  # Set the font of the legend text to bold




# plot corr
# Convert transposed data to a data frame
df <- data.frame(t(SM_Corr))

# Replace outliers greater than 0.6 with NA to make the plot nicer
# df[df > 0.5] <- NA

num_colors <- 47
color_palette <- brewer.pal(num_colors, "Set3")  # You can choose a different palette

# Create horizontal box plots
boxplot(df, outpch = 19, cex = 0.25, col = color_palette, xlab = "", ylab = "",
        yaxt = "n", horizontal = TRUE)  # Set horizontal = TRUE

# Customize the tick labels on the y-axis (now it's the y-axis since the plot is horizontal)
y_labels <- 1:47  # Values from 1 to 47

axis(2, at = y_labels, labels = FALSE)  # Turn off default labels
axis(2, at = y_labels[seq(1, length(y_labels), by = 2)], labels = y_labels[seq(1, length(y_labels), by = 2)], font = 2, las = 1)
axis(1, font = 2, cex = 3)  # Add x-axis to the first column of each row

# Add a single point to each subplot
for (i in 1:47) {
  points(x = Default_Corr[i], y = i, pch = 4, col = "black", cex = 1, lwd = 6)
}

# Add y and x labels (note that they are switched since the plot is horizontal)
mtext("Stations", side = 2, line = 3, font = 2, cex = 4)
mtext("correlation coefficient", side = 1, line = 3, font = 2, cex = 4)

# Add legends with bold font
legend("bottomright", legend = c("Default simulation"), col = c("black"),
       pch = c(4),
       lty = c(NA),
       lwd = c(6),
       pt.cex = c(1),
       cex = 1,
       text.font = 2)  # Set the font of the legend text to bold

# Save and close the figure
dev.off()

