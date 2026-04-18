
rm(list=ls())
graphics.off()

library(ncdf4)
library(future.apply)
library(future)


Folderpath<- "/Users/f007f8t/Documents/GitHub/Alipour-WBM-GSA/Analyses/SM_Main/wbm_output/daily/"



for(i in 1:16){
  year<- 2006+i
  print(paste0("year= ",year))
  try(ncin<- nc_open(paste0(Folderpath,"wbm_",year,".nc")))
  ##SM_Ot<- ncvar_get(ncin, "soilMoistFrac")
  #SM_Ot<- ncvar_get(ncin, "soilMoist")
}
ncin<- nc_open(paste0(Folderpath,"wbm_",year,".nc"))
#SM_Ot<- ncvar_get(ncin, "soilMoistFrac")
SM_Ot<- ncvar_get(ncin, "soilMoist")



library(terra)

# Try reading your file
wbm_2007 <- rast("/Users/f007f8t/Documents/GitHub/Alipour-WBM-GSA/Analyses/SM_Main/wbm_output/daily/wbm_2007.nc")