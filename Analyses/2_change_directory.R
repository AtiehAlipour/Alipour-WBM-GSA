# Reading scripts and changing directories 
# Change output and sttaion index files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())
graphics.off()

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
  
  for (file in source_folder){
    
  # Read the content of the text file
  file_path <- file.path(destination_path, file)
  
  file_content <- readLines(file_path)
  
  # Specify the string you want to find and replace
  search_string <- "SM_Main"
  replacement_string <- paste0("Corn_1/",as.character(file_number))
  
  
  # Find and replace the search string in the content
  modified_content <- gsub(search_string, replacement_string, file_content)
  
  # Write the modified content back to the text file
  writeLines(modified_content, file_path)
  }}


# Destination folder path
destination_folder <- "/gpfs/group/kaf26/default/users/aqa6478/WBM/Corn_1"


# folders that need to change
source_folder <- c("run_norun.pbs",
                   "run_spool.pbs",
                   "run_WBM_fd.pbs",
                   "wbm_init/US_CDL_OL.init",
                   "data_init/CropParameters.csv",
                   "data_init/MC_crop1.init",
                   "data_init/MC_fallow_fr.init",
                   "data_init/MC_maize_1_rfd_Kc.init",
                   "data_init/AWC.init",
                   "data_init/rootdepth.init")


# Number of copies to create
num_copies <- 5000

# Set up parallel processing
plan(multisession)


# Copy the folder in parallel
future_lapply(1:num_copies, function(i) Changefiles(source_folder, destination_folder, i))

