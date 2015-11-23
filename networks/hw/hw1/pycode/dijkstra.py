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
# dijstra function
# use networkx to create graph object
import networkx as nx
graph = nx.from_pandas_dataframe(data, 
                                 source = "vx", 
                                 target = "vy", 
                                 edge_attr = "weight")

# nx.dijkstra_path(graph, 1, 6)
graph = nx.to_dict_of_dicts(graph)  

# %% define dijkstra function
def dijkstra(graph, start, end, visit = [], dist = {}, pre_vis = {}):
    
    # if the end node is start node, the function is complete
    # i.e. either user-input start is the same as the user-input end, or
    # the recursion that occurs within the function (see later) is complete
    # and the shortest path has been found
    if start == end:
        # define an empty list to hold the path
        path = []
        # before the end of the path is reached
        while end != "End of path":
            path.append(end)
            end = pre_vis.get(end, "End of path")
        # return the total distance from the start until the end
        # (recalling that as this is a recursive function, on the last
        # iteration the "start" is the end and so the distance is from the
        # initially provided (i.e. user-input) start, also return the complete
        # path (the [::-1] syntax returns it start -> end arranged)
        return dist[start], path[::-1]
    
    # check if it is the first time through:
    if not visit:
        # if it is the first point in the algorithm loop, set the distance to 0
        # (i.e. set the permanent label on the starting node to 0)
        dist[start] = 0
        
    # check each neighbouring node of the starting node
    for neighbour_node in graph[start]:
        # check if that node has been visited before        
        if neighbour_node not in visit:
            # set up the temporary distance measure            
            temp_dist = dist[start] + graph[start][neighbour_node]['weight']
            # check if the temporary distance is closer than that already
            # present, or infinity            
            if temp_dist < dist.get(neighbour_node, float('inf')):
                # update distances
                dist[neighbour_node] = temp_dist
                pre_vis[neighbour_node] = start
                
    # all the neighbours have been check, so note that the node has been visit
    visit.append(start)
    
    # find all unvisited nodes
    unvisited = []
    # for all nodes in the graph
    for node in graph:
        # if the node has not been visited
        if node not in visit:
            # add it to the list of unvisited nodes!
            unvisited.append(node)
            
    # find those adjacent to the start node
    adjacent = []
    # for all unvisited nodes
    for node in unvisited:
        # if the node is adjacent to the starting node
        if node in graph[start]:
            # add it to the set of adjacent nodes            
            adjacent.append(node)
    
    # find the distance of the adjacent nodes
    adjacent_dists = {}
    # for all adjacent nodes
    for node in adjacent:
        # set the distance
        adjacent_dists[node] = dist.get(node)
            
    # find the closest adjacent node
    closest = min(adjacent_dists, key = adjacent_dists.get)
    
    # the closest node becomes the new "start" and the function recurses
    # on itself until the initial condition (i.e. start == end) is met and
    # then (and only then) will the function terminate
    return dijkstra(graph, closest, end, visit, dist, pre_vis)
    


            
        
