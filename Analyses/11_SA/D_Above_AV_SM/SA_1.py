import sys

from SALib.analyze import delta
from SALib.util import read_param_file
import numpy as np


# Read the parameter range file and generate samples
# Since this is "given data", the bounds in the parameter file will not be used
# but the columns are still expected
problem = read_param_file("./params/WBM.txt")
X = np.loadtxt("./data/model_input.txt")
Y = np.loadtxt("./data/model_output.txt")

# Perform the sensitivity analysis using the model output
# Specify which column of the output file to analyze (zero-indexed)
# Returns a dictionary with keys 'delta', 'delta_conf', 'S1', 'S1_conf'
Si = delta.analyze(
    problem, X, Y, num_resamples=100, conf_level=0.95, print_to_console=True
)

# Save s1_matrix to a text file
np.savetxt('s1_matrix.txt', Si['delta'], fmt='%1.4f', delimiter='\t', header='\t'.join(problem['names']), comments='')
