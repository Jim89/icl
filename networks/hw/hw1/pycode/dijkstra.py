# -*- coding: utf-8 -*-
"""
Title: Dijkstra's Shortest Path
Author: Jim Leach
Date: 2015-11-23
References:
"""

#%% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1

       
#%% read in data - use a pandas dataframe just for convenience
import pandas as pd
data = pd.read_table("./data/HW1_4.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])

# %% use network x to prepare dictionary structure which can be fed in to the 
# dijkstra function
import networkx as nx
graph = nx.from_pandas_dataframe(data, 'x', 'y', 'weight')
graph_nodes = graph.nodes()
graph_dict = nx.to_dict_of_dicts(graph)
    
# %%
# 1. initialise d and pi to empty
def dijkstra(graph_dict, start, end):
    """
    This is a recursive function that implements Dijkstra's Shortest Path
    algorithm.
    
    It takes as its inputs:
        i. a graph represented by a "dictionary of dictionaries" structure,
            generated using networkx;
        ii. a starting node in that graph; and
        iii. an ending node for that graph
        
    It then performs the following steps:
            i. initialises a set of distances from the start node as infinity;
            ii. initialises a set of 'predecessors' to None (a predecessor is
                defined for each node in the network and it lists the prior node
                in the path from start to end);
            iii. initialises the set of of vertices for which the shortest path
            from start to end has been found to empty; and then
            iv. whilst there are still vertices left to assess:
                a. restricts the set of vertices to those where that still need
                    analysisng;
                b. finds the vertex that is the minimum distance from the start;
                c. "relaxes" the neighbours of this closest vertex to see if the
                    shortest path to that vertex can be improved; and
                d. updates the predecessor vertex for each node in the current path
            
            When all vertices have been assessed, the function defines the path
            and returns it with its associated cost
    """
    distances = {} # empty dict for distances
    predecessors = {} # list of vertices in path to current vertex

    # set all initial distances to infinity and no predecessors
    for node in graph_dict:
        distances[node] = float('inf')
        predecessors[node] = None
    
    # 2. set s to empty
    sp_set = []
    distances[start] = 0

    while len(sp_set) < len(graph_nodes):
        still_in = { node: distances[node] for node in [node for node in to_assess if node not in sp_set] }
        closest = min(still_in, key = distances.get)
        sp_set.append(closest)
        
        for node in graph_dict[closest]:
            # print node, distances[node]
            if distances[node] > distances[closest] + graph[closest][node]['weight']:
                distances[node] = distances[closest] + graph[closest][node]['weight']
                predecessors[node] = closest
                
    # JUST NEED WAY TO EXTRACT THE PATH
    path = [end]
    while start not in path:
        path.append(predecessors[path[-1]])
    
    return path[::-1], distances[end]

# %%
# test cases to ensure it works
print 'Shortest path from node 1 to 6 ' + str(dijkstra(graph_dict, 1, 6))
print 'Shortest path from node 1 to 6 ' + str(dijkstra(graph_dict, 5, 5))
print 'Shortest path from node 1 to 6 ' + str(dijkstra(graph_dict, 6, 5))
print 'Shortest path from node 1 to 6 ' + str(dijkstra(graph_dict, 2, 5))



            
        
