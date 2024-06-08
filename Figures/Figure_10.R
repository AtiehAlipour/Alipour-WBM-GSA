# plot boxplot for SA across diffreent stations
# Change the folder path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# List of file names (adjust these according to your file names)
file_folder <- c("AV_SM_Stations", "AV_SM_GS_Stations", "D_Above_AV_SM_Stations", "D_Above_AV_SM_GS_Stations", "AV_SM_Spring_Stations", "AV_SM_Summer_Stations", "AV_SM_Fall_Stations", "AV_SM_Winter_Stations")

file_path_full <- paste0("/Analyses/SA/",file_folder,"/s1_matrix.txt")

# Titles
names <- c("AV_SM", "AV_SM_GS", "D_Above_AV_SM", "D_Above_AV_SM_GS", "AV_SM_Spring", "AV_SM_Summer", "AV_SM_Fall", "AV_SM_Winter")

# Open a PDF device for saving the plot
pdf("Figure_10.pdf", width = 12, height = 7)  # Adjust width and height accordingly

# Set up a 2x4 grid for 8 subplots
par(mfrow = c(2, 4), mar = c(5, 4, 3, 1), oma = c(1, 1, 0, 0),cex=1,cex.main=1.2)  # Adjust oma for outer margins

# Loop through each file
for (i in 1:8) {
  # Read the current file
  data <- read.table(file_path_full[i], header = TRUE, sep = "\t")
  
  # Set the subplot
  par(mfg = c(((i - 1) %/% 4) + 1, ((i - 1) %% 4) + 1))
  
  
  # Define custom colors for each boxplot
  custom_colors <- c("orange", "lemonchiffon", "firebrick", "deepskyblue", "cyan4", "aquamarine3")
  
  
  # Create box plots for all six columns in the current file
  boxplot(data, col = custom_colors, main = names[i],las = 2, lwd = 1, col.box = "white",border =custom_colors, outpch = 16, cex = 0.4)
  
  # Add y-axis label to the leftmost subplots
  if (((i - 1) %% 4) == 0) {
    mtext("Sensitivity Score", side = 2, line = 3, cex = 1)  # Adjust line and cex accordingly
  }
  
}


# Close the PDF device to save the plot
dev.off()

