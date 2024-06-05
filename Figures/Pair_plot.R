# Pair plot for model parameters
# Change output and input files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# Load required libraries


##########################################################

num_parameters<- 6

# load required data
load("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/Data/LHCSamples.Rda")


##########################################################

# prepare data for plot

# create sample_data
alpha <- sampledValues[,1]
AWC <- sampledValues[,2]
RootDepth_GS <- sampledValues[,3]
RootDepth_OGS <- sampledValues[,4]
PlantingDay <- sampledValues[,5]
CropCoefficient <- sampledValues[,6]

# Want to show parameter set 833
group <-array(1, dim =dim(sampledValues)[1] )

group[1]<-2

parameters <- data.frame(alpha,AWC,RootDepth_GS,RootDepth_OGS,PlantingDay,CropCoefficient,group)

parameters_names = c("alpha", "AWC", "Root Depth-GS", "Root Depth-OGS","Planting Day","Crop Coefficient")

##########################################################

# plot


# Create a new figure with the desired dimensions
png("Pairplot.png" , width = 5000, height = 5000, res = 300)

# Set the number of rows and columns for the subplot grid

nrows <- num_parameters
ncols <- num_parameters

# Modify graphical parameters for axis text
par(mfrow = c(nrows, ncols), mar = c(1.25, 1.25, 1, 1),oma = c(3, 3, 1, 1),cex.axis = 2, font.axis = 2, cex.lab =2,font.lab = 2)  # Increase font size and set it to bold

#pairs.panels(parameters[,1:6], 
#             bg = c(alpha(factor(parameters$group),0.2),"red"), #Change color based on group
#             pch = c( 21,19)[factor(parameters$group)],
#             method = "pearson", # correlation method
#             hist.col = "#00AFBB",
#             rug = FALSE,
#             density = TRUE,  # show density plots
#             ellipses = FALSE, # show correlation ellipses
#             smooth = FALSE,
#             digits = 3,
#             labels = c("alpha", "AWC", "Root Depth-GS", "Root Depth-OGS","Planting Day","Crop Coefficient"),
#             cex.labels=2.5,
#             font.labels = 2,
#             cex = 2,
#          )




# making custom pairplot

for (i in 1:num_parameters){
  for (j in 1:num_parameters){

    if (i==j){
      if (i==1 & j==1){
        
        # Create a histogram
        hist(parameters[,i],
             col="cadetblue1",
             border="black",
             prob = TRUE,
             main = "",
             xlab = "",
             ylab="",
             yaxt="n",
             xaxt="n",
             ylim=c(0,1.35*max(density(parameters[,i])$y)))
        
        # fit a curve
        
        lines(density(parameters[,i]),
              lwd = 2,
              col = "black")
        
        # Add lable
        
        text(median(density(parameters[,i])$x), 1.2*max(density(parameters[,i])$y), parameters_names[i], cex = 2.5, font=2)
        
        axis(2, font = 2)  # Add y-axis to the first column of each row
        
        
      }else if(i==6|j==6){
        
        # Create a histogram
        hist(parameters[,i],
             col="cadetblue1",
             border="black",
             prob = TRUE,
             main = "",
             xlab = "",
             ylab="",
             yaxt="n",
             xaxt="n",
             ylim=c(0,1.35*max(density(parameters[,i])$y)))
      
        axis(1, font = 2)  # Add x-axis to the last  row
        
        
        # fit a curve
        
        lines(density(parameters[,i]),
              lwd = 2,
              col = "black")
        
        # Add lable
        
        text(median(density(parameters[,i])$x), 1.2*max(density(parameters[,i])$y), parameters_names[i], cex = 2.5, font=2)
        
      }else{
      
      # Create a histogram
      hist(parameters[,i],
           col="cadetblue1",
           border="black",
           prob = TRUE,
           main = "",
           xlab = "",
           ylab="",
           yaxt="n",
           xaxt="n",
           ylim=c(0,1.35*max(density(parameters[,i])$y)))
      
      # fit a curve
      
      lines(density(parameters[,i]),
            lwd = 2,
            col = "black")
      
      # Add label
      
      text(median(density(parameters[,i])$x), 1.2*max(density(parameters[,i])$y), parameters_names[i], cex = 2.5, font=2)
      
      
      
      }
      
      
      #Create scatter plots
      
      }else if(i>j){
     
        # Create a white plot area
        plot(parameters[,j], parameters[,i], pch = 16,main = "", xlab = "", ylab="",yaxt="n",xaxt="n" ,cex=1, col="orange")
        
        #points(parameters[833,j],parameters[833,i], pch = 19,col="black",cex=2)
        
        if(j==1){
         axis(2, font = 2)  # Add x-axis to the last  row
          
        }
        if(i==6){
          
         axis(1, font = 2)  # Add x-axis to the last  row
        }
        
        
        #Correlations
        
        
        }else if(j>i){
          
        # Create a white plot area
        plot(1, main = "", xlab = "", ylab="",yaxt="n",xaxt="n", xlim=c(0,1), ylim=c(0,1),col="white")
        text(0.5, 0.5, format(round(cor(parameters[,j], parameters[,i]),2), nsmall = 2), cex = 4, font=2)
          
          
          }
          
          
    box()
}}


# Save and close the figure
dev.off()




