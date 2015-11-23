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

# %% implement dijkstra

start = 1
end = 6

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


#%%  relaxation - update the cost of all vertices connected to vertex under assessment
adjacent = graph[start]
for node in adjacent:
    if distances[node] > distances[start] + graph[start][node]['weight']:
        distances[node] = distances[start] + graph[start][node]['weight']
        predecessors[node] = start

