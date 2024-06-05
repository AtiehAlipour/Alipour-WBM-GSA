# -*- coding: utf-8 -*-
"""
# Ploting  observatinal locations 
# Change output and sttaion index files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

"""

import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from mpl_toolkits.basemap import Basemap

# Load observational data
obs_data_path = "47Obs_data.csv"
obs_data = pd.read_csv(obs_data_path)
new_obs = obs_data.to_numpy()


# Load station data
file_path = "47stations.txt"
stations = pd.read_csv(file_path, header=None, sep="\t", decimal=".")

stations

# Estimate observation data availability
data_availability = np.empty(stations.shape[0])
for i in range(stations.shape[0]):
    data_availability[i] = np.sum(~np.isnan(new_obs[i, :])) / 365

data_availability

# Create dataframe for plotting
point_data = pd.DataFrame({
    'lat': stations[5].astype(float),
    'long': stations[4].astype(float),
    'value': data_availability
})

# Create the CONUS map
fig, ax = plt.subplots(figsize=(20, 10))
m = Basemap(projection='merc', llcrnrlon=-127, llcrnrlat=24, urcrnrlon=-64, urcrnrlat=50, resolution='i', ax=ax)

m.drawcoastlines()
m.drawcountries()
m.drawstates()
m.drawmapboundary(fill_color='lightgray')
m.fillcontinents(color='whitesmoke', lake_color='lightgray')

# Create the color map and breaks
custom_breaks = [3, 6, 9, 12, 15]
colors = ["black", "lime", "cyan", "blue", "deeppink"]
cmap = ListedColormap(colors)
norm = plt.Normalize(vmin=0, vmax=max(custom_breaks))

# Plot data points
sc = m.scatter(point_data['long'], point_data['lat'], latlon=True, c=point_data['value'],
               cmap=cmap, norm=norm, s=90, edgecolor='none')

# Add color bar
cbar = plt.colorbar(sc, ax=ax, orientation='horizontal', fraction=0.036, pad=0.1)
cbar.set_label('Years of Observation', fontsize=18, fontweight='bold')
cbar.ax.tick_params(labelsize=18)
cbar.set_ticks(custom_breaks)
cbar.set_ticklabels([str(x) for x in custom_breaks])

# Save the plot as PNG
plt.savefig("Figure2.png", dpi=300, bbox_inches='tight')
plt.show()