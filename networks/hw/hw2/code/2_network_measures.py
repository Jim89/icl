# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:23:20 2015

@author: jim
"""
import pandas as pd
import numpy as np
import networkx as nx
import scipy as sp

# %% read in the data

#data = pd.read_table("../data/HW2_data.txt",
#                     sep = "\t",
#                     header = None,
#                     names = ['vx', 'vy'])

# %% convert to graphs
graph = nx.karate_club_graph()
                                 
# %% get 3 measures

# order (# vertices) and size (# edges)
order = graph.order()
size = graph.size()
 
                          
# degree distribution
#degrees = nx.degree(graph)
#degrees_data = pd.DataFrame(degrees.items(), columns = ["node", "degree"])
#degrees_data['l_degree'] = np.log(degrees_data['degree'])
#
#degrees_data_grouped = pd.DataFrame(degrees_data.groupby('l_degree').size())
#degrees_data_grouped['l_degree'] = degrees_data_grouped.index
#degrees_data_grouped['l_nodes'] = np.log(degrees_data_grouped[0])
# degrees_data.to_csv("../data/HW2_data_degree_dist.csv")

# density
density = nx.density(graph)

# diameter
diameter = nx.diameter(graph)

# dispersion
dispersion = nx.dispersion(graph)

# betweenness
betweenness = nx.betweenness_centrality(graph)

# flow
flow = nx.centrality.current_flow_betweenness_centrality(graph)

# eigen vector
eigen = nx.eigenvector_centrality(graph)

# pagerank
page = nx.pagerank(graph)



                                 