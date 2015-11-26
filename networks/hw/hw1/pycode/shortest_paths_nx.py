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
path_dijkstra = nx.all_pairs_dijkstra_path(graph)
path_1_6_dijkstra = path_dijkstra[1][6]

# get the all-pairs shortest path
path_all_pairs = nx.all_pairs_shortest_path(graph)
path_1_6_all_pairs =  path_all_pairs[1][6]

