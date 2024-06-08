# Reading scripts and changing directories 
# Change output and sttaion index files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

##########################################################

# Clear the working environment
rm(list = ls())

##########################################################

# Load required libraries
library(future)
library(future.apply)
library(ncdf4)

##########################################################

# Function 
Changeparameters <- function(destination_folder,sample, file_number) {

  print(file_number)
  
  # Create the destination folder path
  destination_path <- file.path(destination_folder, paste0(file_number))
  
  ###### change alpha
  file <-  "wbm_init/US_CDL_OL.init"

  # Read the content of the text file
  file_path <- file.path(destination_path, file)

  file_content <- readLines(file_path)
  
  # Specify the string you want to find and replace
  search_string <- " 5}"
  replacement_string <- paste0(" ", sample[1],'}')
  
  # Find and replace the search string in the content
  modified_content <- gsub(search_string, replacement_string, file_content)
  
  # Write the modified content back to the text file
  writeLines(modified_content, file_path)

  ###### Change AWC

  file2 <-  "data_init/AWC.init"

  # load raster 

  file_path2 <- file.path(destination_path, file2)

  file_content2 <- readLines(file_path2)
  
  # Specify the string you want to find and replace
  search_string2 <- "Var_Scale	=> 1,"
  replacement_string2 <- paste0("Var_Scale	=> ",sample[2],",")
  
  # Find and replace the search string in the content
  modified_content2 <- gsub(search_string2, replacement_string2, file_content2)
  
  # Write the modified content back to the text file
  writeLines(modified_content2, file_path2)

  ###### Root Depth 
  file3 <- "data_init/CropParameters.csv"

  # Read the content of the text file
  file_path3 <- file.path(destination_path, file3)

  file_content3 <- readLines(file_path3)
  
  # Specify the string you want to find and replace
  search_string3 <- "1600"
  replacement_string3 <- sample[3]
  
  # Find and replace the search string in the content
  modified_content3 <- gsub(search_string3, replacement_string3, file_content3)
  
  # Write the modified content back to the text file
  writeLines(modified_content3, file_path3)

  ###### Root Depth 2

  file4 <-  "data_init/rootdepth.init"


  file_path4 <- file.path(destination_path, file4)

  file_content4 <- readLines(file_path4)
  
  # Specify the string you want to find and replace
  search_string4 <- "1000"
  replacement_string4 <- paste0(sample[4])
  
  # Find and replace the search string in the content
  modified_content4 <- gsub(search_string4, replacement_string4, file_content4)
  
  # Write the modified content back to the text file
  writeLines(modified_content4, file_path4)

  ###### change planting date

  # Crop planting specification

  PlantDay <-round(sample[5],0)  # change planting date
  SeasonLength <-173
  L_ini <-0.17
  L_dev <-0.28
  L_mid <-0.33
  L_late <-0.22
  Kci <-0.3
  Kcm <-1.2
  Kce <-0.4

  d_ini <- round (SeasonLength*L_ini)
  d_dev <- round (SeasonLength*L_dev)
  d_mid <- round (SeasonLength*L_mid)
  d_late <- round (SeasonLength*L_late)

  SeasonLength_new <- d_ini+d_dev+d_mid+d_late

  file_kc <- "data/KC/MC_maize_1_rfd_Kc.nc"

  # Read and change kc
  file_pathkc <- file.path(destination_path, file_kc)
  ncin<- nc_open(file_pathkc,write = TRUE)


  T2<- ncvar_get(ncin, "MC_maize_1_rfd_Kc")


  for (d in 1:(PlantDay-1)) {
  T2[,,d]<-0
  }


  for (d in PlantDay:(PlantDay+d_ini-1)) {
  T2[,,d] <- Kci
  }

  k=1
  for (d in (PlantDay+d_ini):(PlantDay+d_ini+d_dev-1)) {
  T2[,,d] <-Kci+k*(Kcm-Kci)/d_dev
  k=k+1
  }


  for (d in (PlantDay+d_ini+d_dev):(PlantDay+d_ini+d_dev+d_mid-1)) {
  T2[,,d] <-Kcm 
  k=k+1
  }


  k=1
  for (d in (PlantDay+d_ini+d_dev+d_mid):(PlantDay+d_ini+d_dev+d_mid+d_late)) {
  T2[,,d]<-Kcm-k*(Kcm-Kce)/d_late
  k=k+1
  }


  for (d in (PlantDay+d_ini+d_dev+d_mid+d_late+1):dim(T2)[3]) {
  T2[,,d]<-0
  }

  ncvar_put(ncin, "MC_maize_1_rfd_Kc", T2)
  nc_close(ncin)


  # Load crop1_extent Data and modify that

  file_crop1_extent <- "data/extent/crop1_extent.nc"
  file_crop0_extent <- "data/extent/crop0_extent.nc"

  filename_crop1_extent <- file.path(destination_path, file_crop1_extent)
  filename_crop0_extent <- file.path(destination_path, file_crop0_extent)

  file.copy(file_pathkc,filename_crop1_extent, overwrite = TRUE)
  file.copy(file_pathkc,filename_crop0_extent, overwrite = TRUE)


  # Load crop1_extent Data and modify that

  ncin<- nc_open(filename_crop1_extent ,write = TRUE)

  T2<- ncvar_get(ncin, "MC_maize_1_rfd_Kc")


  for (d in 1:(PlantDay-1)) {
  T2[,,d]<-0
  }

  for (d in PlantDay:(PlantDay+d_ini+d_dev+d_mid+d_late)) {
  T2[,,d] <- 1
  }

  for (d in (PlantDay+d_ini+d_dev+d_mid+d_late+1):dim(T2)[3]) {
  T2[,,d]<-0
  }

  ncvar_put(ncin, "MC_maize_1_rfd_Kc", T2)
  ncvar_rename(ncin,"MC_maize_1_rfd_Kc", "Band1")
  nc_close(ncin)

  # Load crop0_extent Data and modify that

  ncin<- nc_open(filename_crop0_extent ,write = TRUE)

  T2<- ncvar_get(ncin, "MC_maize_1_rfd_Kc")


  for (d in 1:(PlantDay-1)) {
  T2[,,d]<-1
  }

  for (d in PlantDay:(PlantDay+d_ini+d_dev+d_mid+d_late)) {
  T2[,,d] <- 0
  }

  for (d in (PlantDay+d_ini+d_dev+d_mid+d_late+1):dim(T2)[3]) {
  T2[,,d]<-1
  }

  ncvar_put(ncin, "MC_maize_1_rfd_Kc", T2)
  ncvar_rename(ncin,"MC_maize_1_rfd_Kc", "Band1")
  nc_close(ncin)

  ###### Change KC

  file6 <-  "data_init/MC_maize_1_rfd_Kc.init"



  file_path6 <- file.path(destination_path, file6)

  file_content6 <- readLines(file_path6)
  
  # Specify the string you want to find and replace
  search_string6 <- "Var_Scale	=> 1,"
  replacement_string6 <- paste0("Var_Scale	=> ",sample[6],",")
  
  # Find and replace the search string in the content
  modified_content6 <- gsub(search_string6, replacement_string6, file_content6)
  
  # Write the modified content back to the text file
  writeLines(modified_content6, file_path6)



}


# Destination folder path
destination_folder <- "/gpfs/group/kaf26/default/users/aqa6478/WBM/Corn_1"


# read sampledata 
load("/gpfs/group/kaf26/default/users/aqa6478/WBM/Codes/LHCSamples.Rda")


# Number of copies to create
num_copies <- 5000

# Set up parallel processing
plan(multisession)


# change parameters in parallel
future_lapply(1:num_copies, function(i) Changeparameters(destination_folder,sampledValues[i,], i))

