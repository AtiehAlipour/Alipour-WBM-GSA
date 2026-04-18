import sys

from SALib.analyze import delta
from SALib.util import read_param_file
import numpy as np


# Read the parameter range file and generate samples
# Since this is "given data", the bounds in the parameter file will not be used
# but the columns are still expected
problem = read_param_file("./params/WBM.txt")
import sys

from SALib.analyze import delta
from SALib.util import read_param_file
import numpy as np


# Read the parameter range file and generate samples
# Read the parameter range file and generate samples
problem = read_param_file("./params/WBM.txt")
X = np.loadtxt("./data/model_input.txt")
Y_matrix = np.loadtxt("./data/model_output.txt")



# Repeat the analysis for each output column and save S1 results in the matrix

Y = np.mean(Y_matrix, axis=1)
Si = delta.analyze(problem, X, Y, num_resamples=100, conf_level=0.95)
s1_matrix = Si['S1']

# Save s1_matrix to a text file
np.savetxt('s1_matrix_test.txt', s1_matrix, fmt='%1.4f', delimiter='\t', header='\t'.join(problem['names']), comments='')
