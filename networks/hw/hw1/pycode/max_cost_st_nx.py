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
graph = nx.MultiDiGraph()
for row in range(14):
    graph.add_weighted_edges_from(tuple(data.iloc[row, ]))                     
                     