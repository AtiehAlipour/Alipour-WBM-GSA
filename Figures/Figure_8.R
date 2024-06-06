# plot the daily, weekly, monthly, and seasonal performance
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Import libraries
library(ggplot2)


##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# List of file names (adjust these according to your file names)
file_folder <- c("AV_SM_Summer_Stations", "AV_SM_Fall_Stations", "AV_SM_GS_Stations", "AV_SM_Winter_Stations", "AV_SM_Spring_Stations","AV_SM_Stations", "D_Above_AV_SM_GS_Stations", "D_Above_AV_SM_Stations")

file_path_full <- paste0("/storage/group/pches/default/users/aqa6478/aqa6478/WBM/Codes/SA/",file_folder,"/data/model_output.txt")

# Titles
names <- c( "Mean SM-Summer", "Mean SM-Fall","Mean SM-Growing Season" , "Min SM-Winter" ,"Mean SM-Spring","Mean SM", "Days Above Mean SM-Growing Season","Days Above-Mean SM")


##########################################################

# plot


# Create a new figure with the desired dimensions
png("CV.png", type="cairo", width = 4000, height = 4000, res = 300)


par(mar = c(5, 8, 4, 2),oma = c(2.5, 3, 2, 1),cex = 1.25)


# Define custom colors for each boxplot
custom_colors <- c("red","red", "orange", "orange","black","black","darkgray","darkgray")



# Increase the label and tick mark font sizes
par(cex.lab=2, cex.axis=2,font.axis=2)

# Store the  CV in a sigle file
cv<- array(NA, dim =c(47,8))
cv_all<- array(NA, dim = 8)


data <- read.table(file_path_full[1], header = FALSE)

cv_all[1]=sd(as.numeric(unlist(data)))/mean(as.numeric(unlist(data)))

for (i in 1:47){
cv[i,1] <- sd(as.numeric(unlist(data[,i])))/mean(as.numeric(unlist(data[,i])))}


# Create the density plot for the first dataset
plot(density(cv[,1]), xlab = "",
     ylab = "", col = custom_colors[1], ylim=c(0,10),xlim=c(0,2),lwd=4, main="")

y_label="Density"
mtext(y_label, side = 2, line = 4, font = 2, cex = 3)

x_label <- "Coefficient of Variation"
mtext(x_label, side = 1, line = 4,  font = 2, cex = 3)


#Add the gridlines
#abline(h = seq(0,6,1), v= seq(0,1,0.2),lty = "dashed", col = "gray30")

# Loop through each file
for (i in 2:8) {
 
  data <- read.table(file_path_full[i], header = FALSE)
  
  cv_all[i]=sd(as.numeric(unlist(data)))/mean(as.numeric(unlist(data)))
  
  for (j in 1:47){
    cv[j,i] <- sd(as.numeric(unlist(data[,j])))/mean(as.numeric(unlist(data[,j])))}
  
# Add additional density plots on top of the first one
if (i==2 || i==4 || i==6 || i==8){
lines(density(cv[,i]), col = custom_colors[i],lwd=4,lty=2)}else{
lines(density(cv[,i]), col = custom_colors[i],lwd=4)
}
  }


# Add a box around the current subplot
box()


# Add a legend
legend("topright", legend=names,
       col=custom_colors, lwd=4,lty=c(1,2,1,2,1,2,1,2), cex = 1.5,text.font=2)



# Save and close the figure
dev.off()

