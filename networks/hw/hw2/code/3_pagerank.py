# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:32:36 2015

@author: jim
"""

# %% import the data and turn in to weights matrix
import pandas as pd
data = pd.read_table("./data/q3_simple.txt",
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


# get auto-floating point division as I'm in Py 2.7
from __future__ import division      

weights = mat/mat.sum(axis = 1, keepdims = True)

# %% pagerank
# utility functin to normalise
def norm(x):
    x = x/x.sum()
    return x

# set non-zero, random values for r
r = norm(np.array(np.random.rand(4)))


# grab the starting value, just for comparison
r_start = r

# formula is r = W^t r
for i in range(10000000):
    new_r = norm(np.dot(weights.T, r))
    if np.mean(np.round(new_r, 10) == np.round(r, 10)) == 1:
        r = new_r
        break
    else:
        r = new_r
        
# normalise to get r to sum to 1
# r = r/r.sum()        
    
    
# %% attempt networkx soln
import networkx as nx    
graph = nx.from_pandas_dataframe(data, source = 'vx',
                                 target = 'vy')
                                 

# %% pagerank with while
# utility functin to normalise
def norm(x):
    x = x/x.sum()
    return x

# set non-zero, random values for r
r = norm(np.array(np.random.rand(4)))


# grab the starting value, just for comparison
r_start = r

idx = 0
# formula is r = W^t r
while np.mean(np.round(new_r, 10) == np.round(r, 10)) != 1:
    r = norm(np.dot(weights.T, r))
    idx += 1
    print idx
    
#    if np.mean(np.round(new_r, 10) == np.round(r, 10)) == 1:
#        r = new_r
#        break
#    else:
#        r = new_r