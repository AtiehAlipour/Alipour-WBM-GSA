"""
# Ploting  observatinal locations 
# Change output and station index files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

"""

import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from mpl_toolkits.basemap import Basemap

# Load observational data
obs_data_path = "Data/47Obs_data.csv"
obs_data = pd.read_csv(obs_data_path)
new_obs = obs_data.to_numpy()


# Load station data
file_path = "/Data/47stations.txt"
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

# Define the longitude and latitude tick values (these are in degrees)
long_ticks = [-125, -115, -105, -95, -85, -75, -65]
lat_ticks = [25, 30, 35, 40, 45, 50]

# Format the tick labels to include degree symbols and cardinal directions (N/S/E/W)
def format_latitude(lat):
    """Returns formatted latitude with N/S direction."""
    if lat >= 0:
        return f"{abs(lat)}°N"
    else:
        return f"{abs(lat)}°S"

def format_longitude(lon):
    """Returns formatted longitude with E/W direction."""
    if lon >= 0:
        return f"{abs(lon)}°E"
    else:
        return f"{abs(lon)}°W"

# Set the x-ticks and y-ticks using the Basemap conversion function (m(long, lat))
ax.set_xticks(m(long_ticks, [25]*len(long_ticks))[0])  # convert longitudes
ax.set_yticks(m([long_ticks[0]]*len(lat_ticks), lat_ticks)[1])  # convert latitudes

# Set the tick labels to the actual geographical coordinates (lat/lon) with degree symbol and directions
ax.set_xticklabels([format_longitude(lon) for lon in long_ticks], fontsize=18)  # Longitude labels
ax.set_yticklabels([format_latitude(lat) for lat in lat_ticks], fontsize=18)   # Latitude labels

# Use Basemap's `drawparallels` and `drawmeridians` to automatically draw grid lines with lat/lon labels
# Adjusting fontsize for the grid lines labels
#m.drawparallels(lat_ticks, labels=[1, 0, 0, 0], fontsize=18)  # Draw latitude lines (parallels) with larger font size
#m.drawmeridians(long_ticks, labels=[0, 0, 0, 1], fontsize=18)  # Draw longitude lines (meridians) with larger font size


# Save the plot as PNG
plt.savefig("Figure2.png", dpi=300, bbox_inches='tight')
plt.show()
