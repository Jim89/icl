"""
Created on Tue Dec 1 2015

@author: Jim Leach
"""
# load packages and get auto-floating point division as I'm in Py 2.7
from __future__ import division    
import numpy as np
import pandas as pd

#  import the data
data = pd.read_table("../data/q3_simple.txt",
                     header = None,
                     names = ['vx', 'vy', 'weight'])
                     
# create weights matrix                     
# create all zeros matrix                     
mat = np.zeros(shape=(max(data['vx']), max(data['vy'])))

# fill in 1's to make adjaceny matrix
for row in range(len(data)):
    datum = data.iloc[row, ]
    row = datum[0]-1
    col = datum[1]-1
    mat[row][col]=1

# convert to stochastic weights matrix (all rows sum to 1)
weights = mat/mat.sum(axis = 1, keepdims = True)

# define a utility functin to normalise the vector r
def norm(x):
    x = x/x.sum()
    return x
    
# set up pagerank using while loop
# set non-zero, random values for r
r = norm(np.array(np.random.rand(4)))

# set some threshold and an initial error value that is a long way above it
threshold = 1E-30
error = 1000

# while the error is greater than the threshold, keep doing power iteration
while error > threshold:
    # calculate the new r using r = W^Tr
    new_r = norm(np.dot(weights.T, r))
    # get the sum of L2 norm error (i.e. sum of squares)
    error = sum(np.square(new_r - r))
    # set the r to be the new r
    r = new_r
    