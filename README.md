# Alipour-WBM-GSA
This repository contains the code used for the paper titled "Characterizing Parameter Uncertainty on Water Balance Model Soil Moisture Estimates over US Agricultural Lands".

## Overview

The repository is organized into four main folders:

1. **Analyses**: Contains the code for various analyses conducted in the paper.
2. **Data**: Includes data files related to observation stations.
3. **Figures**: Code used to generate figures along with associated figure numbers.
4. **Output**: Includes outputs such as Latin hypercube samples and time series drives for 47 stations and 5000 simulations.

## Folder Structure

- **Analyses**:
  
  - `1_Sampling_LHS.R`: Code for performing Latin Hypercube Sampling and saving the result.
  - `2_Copy_file.R`: Code for copying the default setup (SM_Main.zip) to 5000 directories.
  - `3_change_directory.R`: Code for changing directories listed in each setup.
  - `4_change_parameters.R`: Code for changing the parameters based on Latin Hypercube Sampling.
  - `5_run_norun.pbs`: Bash script used for setting up the models.
  - `6_modify_bspool.R`: Code for preparing the WBM files for spooling WBM input and parameters.
  - `7_run_spool.pbs`: Bash script used for running WBM and creating the binary input and parameter files.
  - `8_run_model.pbs`: Bash script used for running 5000 ensemble simulations.
  - `9_Save_Data_all_station.zip`: Series of R scripts and a job array for extracting simulated soil moisture values.
  - `10_Save_Data_for_47.R`: Code for extracting soil moisture data for 47 stations from the result of `9_Save_Data_all_station.zip`.
  - `11_SA.zip`: Set of codes and data related to sensitivity analysis for different indices of interest.

## Citation

If you use the code or data from this repository in your work, please cite the corresponding paper:


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/AtiehAlipour/Alipour-WBM-GSA/blob/main/LICENSE) file for details.
