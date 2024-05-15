# Sampling different parameters using LHS
# Change the directory of AWC
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# Load required libraries

#install.packages(c("lhs", "truncnorm","truncdist","stats4","evd","Ecfun"))
library(lhs)
library(truncnorm)
library(sp)
library(raster)
library(evd)
library(stats4)
library(Ecfun)
library(truncdist)
library(ncdf4)


##########################################################

# Define the number of samples and parameters
numSamples <- 5000
numParameters <- 6


##########################################################

# alpha

# Define parameters for the gamma distribution and truncation range
# for alpha parameter, To estiate shape and rate parameter
# We define mean as default alpha value of 5 and %20 error as the variance
# mean = shape/rate and variance = shape/(rate)^2 

shape_alpha <- 25  # Shape parameter of the gamma distribution 
rate_alpha <- 5  # Rate parameter of the gamma distribution 
lower_alpha <- 2  # Lower bound of the truncated gamma distribution
upper_alpha <- 20  # Upper bound of the truncated gamma distribution


##########################################################

# AWC 


# Load the Soil intrinsic available water capacity files
DSM_HARV <- raster("/Users/f006nr6/Desktop/Projects/PCHES/WBM/codes/Data/SSURGO_SoilData_awc_frac_mm_m_CONUS_1km.tif")
print(DSM_HARV)
maxValue(DSM_HARV)

mean_AWC <- 1  # Mean of the truncated normal distribution
sd_AWC <- 0.2*mean_AWC  # Standard deviation of the truncated normal distribution
lower_AWC <- 0.1  # Lower bound of the truncated normal distribution
upper_AWC <- 3  # Upper bound of the truncated normal distribution based onmax AWC of the file, and 600 mm max defined


##########################################################

# Root Depth for CSV file


mean_RD <- 1600  # Mean of the truncated normal distribution
sd_RD <- 0.2*mean_RD  # Standard deviation of the truncated normal distribution
lower_RD <- 0  # Lower bound of the truncated normal distribution
upper_RD <- 2000  # Upper bound of the truncated normal distribution

##########################################################

# Root Depth for tiff file out of crop season

# Load Root Depth fike
#ncin<- nc_open('/Users/f006nr6/Desktop/Projects/PCHES/WBM/codes/Data/Global_Terrain_RootDepthWBM_LTXXXX_30min.nc')

RD2 <- raster("/Users/f006nr6/Desktop/Projects/PCHES/WBM/codes/Data/Effective_Rooting_Depth.tif")

print(RD2)
maxValue(RD2)

mean_RD2 <- 1*1000  # Mean of the truncated normal distribution
sd_RD2 <- 0.2*mean_RD2  # Standard deviation of the truncated normal distribution
lower_RD2 <- 0.1*1000  # Lower bound of the truncated normal distribution
upper_RD2 <- 1.5*1000  # Upper bound of the truncated normal distribution based on data and max defined witch is 2000


##########################################################

# Planting Day

mean_PD <- 114  # Mean of the truncated normal distribution
sd_PD <- 0.2*mean_PD  # Standard deviation of the truncated normal distribution
lower_PD <- 60  # Lower bound of the truncated normal distribution
upper_PD <- 181  # Upper bound of the truncated normal distribution


##########################################################

# KC

mean_KC <- 1  # Mean of the truncated normal distribution # scale factor
sd_KC <- 0.2  # Standard deviation of normal distribution
lower_KC <- 0.5  # Lower bound of the truncated normal distribution  
upper_KC <- 1.2  # Upper bound of the truncated normal distribution


mean_KCi <- 0.3  # Mean of the truncated normal distribution
sd_KCi <- 0.2*mean_KCi  # Standard deviation of the truncated normal distribution
lower_KCi <- 0.1  # Lower bound of the truncated normal distribution
upper_KCi <- 0.5  # Upper bound of the truncated normal distribution


mean_KCm <- 1.2  # Mean of the truncated normal distribution
sd_KCm <- 0.2*mean_KCm  # Standard deviation of the truncated normal distribution
lower_KCm <- 0.8  # Lower bound of the truncated normal distribution
upper_KCm <- 1.2  # Upper bound of the truncated normal distribution


mean_KCe <- 0.4  # Mean of the truncated normal distribution
sd_KCe <- 0.2*mean_KCe  # Standard deviation of the truncated normal distribution
lower_KCe <- 0.25  # Lower bound of the truncated normal distribution
upper_KCe <- 0.79  # Upper bound of the truncated normal distribution


##########################################################

# Generate Latin hypercube samples
set.seed(1234)
lhsSamples <- maximinLHS(n = numSamples, k = numParameters)

# Transform samples based on distributions
sampledValues <- matrix(0, nrow = numSamples, ncol = numParameters)

sampledValues[, 1] <- qtruncdist(lhsSamples[, 1],  shape = shape_alpha, rate = rate_alpha, dist='gamma', truncmin = lower_alpha, truncmax = upper_alpha) # Truncated gamma distribution
sampledValues[, 2] <- qtruncdist(lhsSamples[, 2], mean = mean_AWC, sd = sd_AWC,dist='norm', truncmin = lower_AWC, truncmax = upper_AWC)  # Truncated normal distribution
sampledValues[, 3] <- qtruncdist(lhsSamples[, 3], mean = mean_RD, sd = sd_RD,dist='norm', truncmin = lower_RD, truncmax = upper_RD)  #  Truncated normal distribution
sampledValues[, 4] <- qtruncdist(lhsSamples[, 4], mean = mean_RD2, sd = sd_RD2,dist='norm', truncmin = lower_RD2, truncmax = upper_RD2)  #  Truncated normal distribution
sampledValues[, 5] <- qtruncdist(lhsSamples[, 5], mean = mean_PD, sd = sd_PD,dist='norm', truncmin = lower_PD, truncmax = upper_PD)  #  Truncated normal distribution
sampledValues[, 6] <- qtruncdist(lhsSamples[, 6], mean = mean_KC, sd = sd_KC,dist='norm', truncmin = lower_KC, truncmax = upper_KC)  #  Truncated normal distribution

#sampledValues[, 6] <- qtruncdist(lhsSamples[, 6], mean = mean_KCi, sd = sd_KCi,dist='norm', truncmin = lower_KCi, truncmax = upper_KCi)  #  Truncated normal distribution
#sampledValues[, 7] <- qtruncdist(lhsSamples[, 6], mean = mean_KCm, sd = sd_KCm,dist='norm', truncmin = lower_KCm, truncmax = upper_KCm)  #  Truncated normal distribution
#sampledValues[, 8] <- qtruncdist(lhsSamples[, 6], mean = mean_KCe, sd = sd_KCe,dist='norm', truncmin = lower_KCe, truncmax = upper_KCe)  #  Truncated normal distribution

save(sampledValues,file="LHCSamples.Rda")


