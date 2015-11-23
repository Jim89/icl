# -*- coding: utf-8 -*-
"""
Title: Dijkstra's Shortest Path
Author: Jim Leach
Date: 2015-11-23
References:
"""

#%% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1

#%% Define class for a graph object
# %%
class Graph:
    def __init__(self):
        self._edges = []
        self._nodes = set()
        self._weights = []
        
    def add_edge(self,u,v,weight=1):
        self._nodes.add(u)
        self._nodes.add(v)
        self._edges.append((u,v))
        self._weights.append(weight)
        
    def add_node(self, n):
        self._nodes.add(n)
        
    def sort(self, reverse=False):
        self._edges = [edge for (weight, edge) in sorted(zip(self._weights, self._edges), key = lambda pair : pair[0], reverse=reverse)]
        
    def edges(self):
        return self._edges
        
    def nodes(self):
        return list(self._nodes)
        
    def weights(self):
        return list(self._weights)
        

#%% read in data - use a pandas data frame just for convenience
import pandas as pd
import networkx as nx
data = pd.read_table("./data/HW1_4.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])

data_rev = pd.DataFrame([data["vy"], data["vx"], data["weight"]]).transpose()


# find number of rows in data (for iteration purposes)
rows = len(data.index)


# use networkx to create graph object
graph = nx.from_pandas_dataframe(data, 
                                 source = "vx", 
                                 target = "vy", 
                                 edge_attr = "weight")

# nx.dijkstra_path(graph, 1, 6)
graph_dict = nx.to_dict_of_dicts(graph)  

# %% create graph dictionary from dataframe
g = Graph()

for row in range(rows):
    datum = data.iloc[row, ]
    g.add_edge(str(datum[0]), str(datum[1]), datum[2])                    
    
# need to define dijkstra within class - takes two nodes and defines dijkstra algo
# or create a function that takes graph as input and runs it
    
