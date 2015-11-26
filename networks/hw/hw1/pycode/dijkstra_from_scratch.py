# -*- coding: utf-8 -*-
"""
Created on Mon Nov 23 17:55:45 2015

@author: jim
"""

# %% import data
import pandas as pd

data = pd.read_table("./data/HW1_4.txt", sep = " ", header = None, names = ['x','y','weight'])

# %% turn data in to graph with networkx
import networkx as nx

graph = nx.from_pandas_dataframe(data, 'x', 'y', 'weight')
graph_nodes = graph.nodes()
graph_dict = nx.to_dict_of_dicts(graph)

start = 1
end = 6

# %% implement dijkstra

# set up
sp_set = [] # vertices who's shortest path from source already found
to_assess = graph_nodes  # get all the nodes in the graph

distances = {} # empty dict for distances
predecessors = {} # list of vertices in path to current vertex

# set all initial distances to infinity
for node in graph:
    distances[node] = float('inf')
    
for node in graph:
    predecessors[node] = None
    
  
# set distance for starting node   
distances[start] = 0

while len(sp_set) < len(to_assess):

# find closest node to current start (it will be the start)    
closest_to_current = min(distances, key = distances.get)
   
# add start to sp_set
sp_set.append(start)


#%%  relaxation - update the cost of all vertices connected to vertex under assessment
def relax(adjacent_nodes):
    for node in adjacent_nodes:
        if distances[node] > distances[start] + graph[start][node]['weight']:
            distances[node] = distances[start] + graph[start][node]['weight']
            predecessors[node] = start
            
relax(graph[closest_to_current])

# nodes_left = [{key: value} for key, value in distances.items() if key not in sp_set]

distances = { node: distances[node] for node in [node for node in to_assess if node not in sp_set] }
