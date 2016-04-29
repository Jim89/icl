# %% Load packages
import pandas as pd
import numpy as np
import scipy as sp
import sklearn
import matplotlib.pyplot as plt

# %% Working with numpy
# Can execute scripts with %run in iPython (as well as % for other "magic" commands, e.g. %timeit)

a = range(1000)

# Can time the execution of functions with %timeit
%timeit [i**2 for i in a]

# Using numpy we can speed up, a LOT
# ?arange - pull up help file
# use np.look_for('[what I'm looking for]') will pull up list of relevant commands 
a = np.arange(1000)
%timeit a**2

# %% Creating arrays
a = np.array([[1, 2, 3], [4, 5, 6]])

# Find the number of dimensions
a.ndim

# Find the shape - returns (rows, columns) for a 2d array
a.shape

# Get the size of the first dimension
len(a)

# find the data type
a.dtype

# Creating arrays using functions:
np.arange(10) # ten first numbers
np.linspace(0, 1, 6) # 6 points evenly-spaced between 0 and 1
np.eye(3) # create diagonal identity matrix
np.diag(np.arange(5)) # put an array on the diagonal of a matrix/array

# %% Generating random numbers

# %% Dtypes (data types) - arrays must be same type of data
a = np.array([1, 2, 3])
a.dtype # automatically coerces to be the same datatype accross the array

b = np.array([1.1, 2, 3])
b.dtype # so if we include a float we get a float

# %% Indexing and slicing
a = np.arange(10)

# accessing end
a[-1]

# read in reverse order
a[::-1]

# slice
a[1:5]

# start:stop:step
a[1:6:2]

# Can create masks (i.e. indexes)
idx = (a>2)
idx

a[idx]

# %% Reshaping data
a = np.arange(12)

# Make in to 3 rows, 4 cols
a.reshape((3, 4))

# re-flatten with ravel
a.ravel()

#%% Simple plots with mpl
# force plots to appear in console, not new window
%matplotlib inline
x = np.linspace(0, 2*np.pi, 100)
y = np.cos(x)

plt.plot(x, y)
plt.show()

# How about a 2d plot?
image = np.random.rand(50, 50)
plt.imshow(image, cmap = plt.cm.hot)
plt.colorbar()
plt.show
