"""
# Ploting  donut plots
# Change output and input files path accordingly
# Author: Atieh Alipour(atieh.alipour@dartmouth.edu)

"""
import matplotlib.pyplot as plt
import numpy as np

# Define number of subplots and categories
num_subplots = 8
num_categories = 6

# SA data
data = [[0.0466, 0.3151, 0.0717, 0.1976, 0.0745, 0.0650],
        [0.0301, 0.0549, 0.0515, 0.0339, 0.6009, 0.0514],
        [0.0407, 0.2867, 0.1287, 0.0898, 0.1648, 0.0633],
        [0.0706, 0.1041, 0.1309, 0.0659, 0.2360, 0.1445],
        [0.0340, 0.1212, 0.0601, 0.0747, 0.4793, 0.0353],
        [0.0636, 0.0478, 0.0621, 0.0572, 0.4688, 0.1101],
        [0.0331, 0.0660, 0.0380, 0.0605, 0.6233, 0.0366],
        [0.0276, 0.1717, 0.0337, 0.1531, 0.3021, 0.0274]]

# Define category labels
categories = ["alpha","AWC","Root Depth-GS","Root Depth-OGS","Planting Day","Crop-Ceofficient"]

# Define custom colors
custom_colors = ['orange', 'lemonchiffon', 'firebrick', 'deepskyblue', 'teal', 'mediumaquamarine']

# Define subplot titles
titles = [ "Mean SM", "Mean SM-GS", "Days Above Mean SM","Days Above Mean SM-GS",
    "Mean SM-Spring", "Mean SM-Summer", "Mean SM-Fall",
    "Min SM-Winter" ]

# Create a figure with 2x4 subplots
fig, axes = plt.subplots(2, 4, figsize=(16, 8))

for i, ax in enumerate(axes.flatten()):
    wedges, _ = ax.pie(
        data[i], labels=None, colors=custom_colors,
        wedgeprops=dict(width=0.5), startangle=-40  # Make inner hole smaller
    )
    ax.set(aspect="equal")
    ax.set_title(titles[i], fontsize=14, fontname='DejaVu Sans')  # Add titles to each subplot with larger font size

# Create a legend outside the subplots
# Create a legend outside the subplots
legend = fig.legend(
    wedges, categories, loc='upper left', bbox_to_anchor=(0.05, 0.8), frameon=False  # Adjust the legend position closer to the plots
)

# Set legend font size and weight
plt.setp(legend.get_texts(), fontsize='14', fontname='DejaVu Sans')

# Adjust space between subplots
plt.subplots_adjust(left=0.2, right=0.97, top=0.9, bottom=0.1, wspace=0.01, hspace=0.01)

plt.savefig("Figure8.png", dpi=300, bbox_inches='tight')
plt.show()
