# Reading scripts and changing directories 
# Change output and station index files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# Load required libraries
library(future.apply)
library(future)


##########################################################

# Function 
Changefiles <- function(source_folder, destination_folder, file_number) {

  print(file_number)
  
  # Create the destination folder path
  destination_path <- file.path(destination_folder, paste0(file_number))
    
  # Read the content of the text file
  file_path <- file.path(destination_path, source_folder)
  print(file_path)
  file_content <- readLines(file_path)
  
  # Identify the lines you want to remove
  lines_to_remove <- c(28,29,30,31,32,33,34,35)

  # Filter out the unwanted lines
  filtered_text <- file_content[-lines_to_remove]

  # Write the modified content back to the text file
  writeLines(filtered_text, file_path)
  }


# Destination folder path
destination_folder <- "/gpfs/group/kaf26/default/users/aqa6478/WBM/Corn_1"


# folders that need to change
source_folder <- "wbm_output/build_spool_batch.pl"


# Number of copies to create
num_copies <- 5000

# Set up parallel processing
plan(multisession)


# Copy the folder in parallel
future_lapply(4701:num_copies, function(i) Changefiles(source_folder, destination_folder, i))

