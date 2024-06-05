# Reading and ploting 47 at SM  observatinal locations
# Change output and input files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries

library(grid)


##########################################################

# Define the start and end dates

start_date <- as.Date("2008/01/01")
end_date <- as.Date("2022/12/31")

# Calculate the number of days between the dates

num_days <- as.numeric(end_date - start_date) + 1

load("/Data/47Obs_data.Rda")


##########################################################

# Plot 

# Set the number of rows and columns for the subplot grid
nrows <- 6
ncols <- 8
date_sequence <- seq(start_date, end_date, by = "day")

# Create a new figure with the desired dimensions
png("47_obs_time_series_plot.png", type="cairo",width = 6000, height = 3500, res = 300)

# Set the layout for the subplot grid
par(mfrow = c(nrows, ncols),mar = c(2, 1, 1, 1),oma = c(3, 3, 2, 1),cex = 1.25)

# Loop through each subplot
for (i in 1:(dim(SM_Obs)[1])) {
  plot(date_sequence, SM_Obs[i,], type = "l", xlab = "", ylab = "", 
       labels = FALSE, tick = FALSE,xlim = range(date_sequence), ylim =c(0,0.6),col = "blue" )
  
  # Add a box around the current subplot
  box()
  
  # Add the background grid
  grid()
  
  # Add the title outside the box of the current subplot
  mtext(paste("Station", i), side = 3, line = 0.5, font = 2, cex = 1.5)
  
  # Add x-axis and labels only to the bottom row of subplots
  if (i >39)  {
    years_to_display <- seq(date_sequence[1], date_sequence[length(date_sequence)], by = "2 years")
    axis(side = 1, at = seq(as.Date(date_sequence)[1], as.Date(date_sequence)[length(date_sequence)], by = "years"), labels = FALSE, font = 2, las = 2 ,format = "%Y")
    mtext(format(years_to_display, "%Y"), side = 1, at = years_to_display,font = 2 ,line = 1, las = 2, adj = 1, cex = 1.2)
    mtext("time", side = 1, line = 3.5,font = 2, cex = 1.5)
  }
  else{
    axis(side = 1, labels = FALSE, tick = FALSE)
  }
  
  
  if (i %% 8 == 1) {
    axis(2, font = 2)  # Add y-axis to the first column of each row
    y_label <- expression(bold(paste(m^{3}/m^{3})))
    
    mtext(y_label , side = 2, line = 2.5, adj =0.5,font = 2, cex = 1.5)  # Add y-axis label
    
    
  } else {
    axis(side = 2, labels = FALSE, tick = FALSE)  # Add blank y-axis for other columns
  }
  
  
}


# add a custom legend

# Use grid to add a red line and rectangle
grid.rect(x = 0.92, y = 0.1, width = 0.1, height = 0.1, gp = gpar(fill = NA, lwd = 2, col = "black"))
grid.lines(x = c(0.89, 0.95), y = c(0.07, 0.07), gp = gpar(col = "blue", lwd = 2))



mtext("SM observation", side = 1, line = -0.6, at = 0, adj = -3.5, font = 2, cex = 1.5)


# Save and close the figure
dev.off()

