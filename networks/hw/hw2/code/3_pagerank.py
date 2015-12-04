# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:32:36 2015

@author: jim
"""

# get auto-floating point division as I'm in Py 2.7
from __future__ import division    


# %% import the data and turn in to weights matrix
import pandas as pd
data = pd.read_table("../data/q3_simple.txt",
                     header = None,
                     names = ['vx', 'vy', 'weight'])
                     
# %% create weights matrix                     
import numpy as np

mat = np.zeros(shape=(max(data['vx']), max(data['vy'])))

for row in range(len(data)):
    datum = data.iloc[row, ]
    row = datum[0]-1
    col = datum[1]-1
    mat[row][col]=1

  

weights = mat/mat.sum(axis = 1, keepdims = True)

# %% utility functin to normalise
def norm(x):
    x = x/x.sum()
    return x
    
# %% pagerank with while
# set non-zero, random values for r
r = norm(np.array(np.random.rand(4)))

threshold = 1E-30
error = 1000

# formula is r = W^t r
while error > threshold:
    new_r = norm(np.dot(weights.T, r))
    error = sum(np.square(new_r - r))
    r = new_r
    