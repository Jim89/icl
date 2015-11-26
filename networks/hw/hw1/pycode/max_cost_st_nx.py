# -*- coding: utf-8 -*-
"""
Created on Sun Nov 22 15:32:43 2015

@author: jim
"""

# %% read in the data - use pandas for convenience
import pandas as pd

# read in the data
data = pd.read_table("./data/HW1_3.txt",
                     sep = " ",
                     header = None,
                     names = ["vx", "vy", "weights"])

# to find MAX cost spanning tree the (all positive) weights must be multipled
# by -1:
data['weights'] = -data['weights']                      

# %%
import networkx as nx

# convert data frame to graph
graph = nx.from_pandas_dataframe(data, source = 'vx', target = 'vy', edge_attr = 'weights')

# get the max cost tree                   
max_cost_st = nx.minimum_spanning_tree(graph, weight = 'weights')             

# re-invert the weights to get the correct sign on the weights
for edge in range(len(max_cost_st.edges())):
    edge = max_cost_st.edges()[edge]    
    vx = edge[0]
    vy = edge[1]
    max_cost_st.get_edge_data(vx, vy)['weights'] = - max_cost_st.get_edge_data(vx, vy)['weights']
    
                     