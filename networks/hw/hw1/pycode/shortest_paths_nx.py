# -*- coding: utf-8 -*-
"""
Title: Dijkstra's Shortest Path with NetworkX
Author: Jim Leach
Date: 2015-11-23
"""

#%% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1

      

#%% read in data - use a pandas data frame just for convenience
import pandas as pd
data = pd.read_table("./data/HW1_4.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])

# %% networkx section
import networkx as nx

# use networkx to create graph object
graph = nx.from_pandas_dataframe(data, 
                                 source = "vx", 
                                 target = "vy", 
                                 edge_attr = "weight")

# get the dijkstra shortest path
path = nx.dijkstra_path(graph, 1, 6)


