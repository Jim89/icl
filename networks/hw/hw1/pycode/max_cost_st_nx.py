# -*- coding: utf-8 -*-
"""
Created on Sun Nov 22 15:32:43 2015

@author: jim
"""

import networkx as nx
import pandas as pd

data = pd.read_table("../data/HW1_3.txt",
                     sep = " ",
                     header = None,
                     names = ["vx", "vy", "weights"])
                     
# initialise graph
graph = nx.edgelist()

# %%
for row in range(len(data)):
    weighted_edge =  tuple(data.iloc[row, ])
    graph.add_edge(u = weighted_edge[0],
                   v = weighted_edge[1],
                   key = None,
                   attr_dic = None,
                   weight = weighted_edge[2])
                   
tree = nx.minimum_spanning_tree(graph)                  
                     