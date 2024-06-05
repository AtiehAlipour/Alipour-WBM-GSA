# Plot sample distribution
# Change sample location
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())
graphics.off()

##########################################################

# Import libraries

##########################################################

# Load data

load("/Users/f006nr6/Desktop/Projects/PCHES/WBM/codes/LHCSamples.Rda")

##########################################################

# plot

Parameterlist <-c("alpha","AWC","Root Depth-GS","Root Depth-OGS","Planting Day","Crop Coefficient")
mean_val <- c(5,1,1600,1000,114,1)


# Set the number of rows and columns for the subplot grid
nrows <- 2
ncols <- 3


png("sampledist.png", width = 6000, height = 5000, res = 300)

# Set the layout for the subplot grid
par(mfrow = c(nrows, ncols), mar = c(2, 2, 3, 2), oma = c(7, 3, 1, 2), cex = 1.5,font = 2)

for (i in 1:((nrows * ncols))) {
  
  # Calculate the density estimate
  dens <- density(sampledValues[, i])
  
  # Plot the curve
  plot(dens, type = 'n', xlab = "", ylab = "", xaxt = "n",
       main = "", font = 2, cex = 1.5, xlim = c(min(dens$x), max(dens$x)),
       ylim = c(0, max(dens$y) * 1.2))
  
  # Add the background grid
  grid()
  
  # Add the curve
  #lines(dens, col = "blue", lwd = 2)
  
  # Add the area under the curve with transparency
  color_with_transparency <- rgb(0, 0.8, 0.6, alpha = 0.7) # Blue with 0.5 transparency (adjust alpha as needed)
  polygon(dens, col = color_with_transparency)
  
  # Add a dashed black line for the mean value
  abline(v = mean_val[i], col = "black", lty = 2, lwd = 3)
  
  # Add a box around the current subplot
  box()
  
  if (i %% 3 == 1) {
    mtext("Density", side = 2, line = 3, font = 2, cex = 1.5)
  }
  
  if (i > ncols) {
    mtext("Parameter Value", side = 1, line = 3, font = 2, cex = 1.5)
  }
  
  # Add the title outside the box of the current subplot
  mtext(Parameterlist[i], side = 3, line = 0.5, font = 2, cex = 2)
  
  # Create a legend for first subplot
  if (i == 1) {
    
    
    # Add legend
    legend("topright",
           c("default parameter set","sample distribution"),
           col = c('black',color_with_transparency),
           pt.bg = c(NA,color_with_transparency),
           pch = c(NA, 22),
           lty = c(2,NA),
           lwd = c(2,NA),
           pt.cex = c(NA,2),
           cex=1)
    
    
    
    
  }
  
  # round the labels for selected parameters
  
  if (i == 4) {
    tick_positions <- seq(min(dens$x), max(dens$x), length.out = 5)
    tick_labels <- round(tick_positions / 1000, 1)
    axis(1, at = tick_positions, labels = tick_labels, font = 2, cex = 2)
  } else if (i == 2 | i == 6) {
    tick_positions <- seq(min(dens$x), max(dens$x), length.out = 5)
    axis(1, at = tick_positions, labels = round(tick_positions, 1), font = 2, cex = 2)
  } else {
    tick_positions <- seq(min(dens$x), max(dens$x), length.out = 5)
    axis(1, at = tick_positions, labels = round(tick_positions), font = 2, cex = 2)
  }
  
}

# Save and close the figure
dev.off()

