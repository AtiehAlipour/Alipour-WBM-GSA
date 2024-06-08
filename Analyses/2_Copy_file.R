# Copy the setup files in multiple folders in parallel
# Change reference and destination files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment

rm(list = ls())

##########################################################

# Load required libraries
library(future.apply)
library(future)

##########################################################

# Function to copy a folder and its contents
copyFolder <- function(source_folder, destination_folder, copy_number) {
  # Create the destination folder path
  destination_path <- file.path(destination_folder, paste0(copy_number))
  
  # Create the destination folder if it doesn't exist
  dir.create(destination_path, recursive = TRUE, showWarnings = FALSE)
  
  # Copy the files from the source folder to the destination folder
  files <- list.files(source_folder, full.names = TRUE)
  file.copy(files, destination_path, recursive = TRUE)
}

##########################################################

# Source folder path
source_folder <- "/gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main"

# Destination folder path
destination_folder <- "/gpfs/group/kaf26/default/users/aqa6478/WBM/Corn_1"

# Number of copies to create
num_copies <- 5000

# Set up parallel processing
plan(multisession)


# Copy the folder in parallel
future_lapply(1:num_copies, function(i) copyFolder(source_folder, destination_folder, i))