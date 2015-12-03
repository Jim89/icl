# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:23:20 2015

@author: jim
"""

# %% read in the data
import pandas as pd
data = pd.read_table("../data/HW2_data.txt",
                     sep = "\t",
                     header = None,
                     names = ['vx', 'vy'])

# %% convert to graphs
import networkx as nx
graph = nx.from_pandas_dataframe(data, 
                                 source = 'vx',
                                 target = 'vy')    
                                 
# %% get 3 measures

# get graph degree distribution
degrees = nx.degree(graph)
degrees_data = pd.DataFrame(degrees.items(), columns = ["node", "degree"])
# degrees_data.to_csv("../data/HW2_data_degree_dist.csv")

# get the density
density = nx.density(graph)

# get the diameter (longest of the shortest path lengths)
diameter = nx.diameter(graph)


                                 