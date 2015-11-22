# -*- coding: utf-8 -*-
"""
Title: Max-Cost Spanning Tree
Author: Jim Leach
Date: 2015-11-22
References: https://www.python.org/doc/essays/graphs/ (for finding path in graph)
"""

#%% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1

# %% define function to find path(s) in a graph
# sourced on 2015-11-22 from: https://www.python.org/doc/essays/graphs/ 
def find_path(graph, start, end, path = []):
    """
    A new function to find paths in a graph. The user provides a dictionary-based
    representation of a graph, specifies a start and end vertex.
    The function then determines if there is a path between the two, if there is
    it prints the path, if there is not it returns "None".
    """
    # Add starting node to the beginning of the path
    path = path + [start]
    # If the start is the same as the end (i.e. is the path complete)
    if start == end:
        return path
    # if the graph does not have that starting key, return None
    if not graph.has_key(start):
        return None
    """
     for each vertex (node) in the graph object, if it is not in the path,
     try to find a path between it and the start of the path (note that this)
     will therefore recursively search all nodes in the graph to try and find a
     path to the initial start value
    """
    for node in graph[start]:
        # Only do this for nodes not already analysed!
        if node not in path:
            newpath = find_path(graph, node, end, path)
            if newpath:
                return newpath
    return None


#%% read in data - use a pandas data frame just for convenience
import pandas as pd
data = pd.read_table("./data/HW1_3.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])

# sort by weights for iteration purposes                     
data = data.sort_values("weight", ascending = False)

# find number of rows in data (for iteration purposes)
rows = len(data.index)


# %% set up empty containers to prepare for looping
edges = []          # to keep track of edges added with each iteration
vertices = []       # to keep track of unique vertices added with each iteration
edgelist = dict()   # to keep an edgelist going
graph = dict()      # to keep track of connections formed in graph format


# %% perform the loop
# iterate over rows of data
for row in range(rows):
# extract edge data
    datum = data.iloc[row, ]
# print statement to check things whilst developing
#    print datum[0], datum[1], find_path(graph, int(datum[0]), datum[1], path = [])

# if the two vertices are included in the current mst:
    if (datum[0] and datum[1] in vertices): 
        # if there is any path between them, adding the edge would create loop
        if find_path(graph, int(datum[0]), datum[1], path = []) is not None:
            # so pass
            pass
        
        # if there is no path between them
        if find_path(graph, int(datum[0]), datum[1], path = []) is None:
            # add edge to list of edges            
            edges.append(datum[2])
            # add whole row to mst edgelist
            edgelist[row] = [datum[0], datum[1], datum[2]]
            # update vertices list with new unique vertices
            if datum[0] not in vertices:
                vertices.append(datum[0])
            if datum[1] not in vertices:
                vertices.append(datum[1])
                
            # update the graph structure
            # if the graph already has a key for that vertex    
            if graph.has_key(int(datum[0])):
                # add the new vertex as a new connection
                graph[int(datum[0])].append(int(datum[1]))
            # if the graph does not have a key for that vertex
            else:
                # add the new vertex as a connection
                graph[int(datum[0])] = [int(datum[1])]
                
            # remember, the graph is undirected so ties go both ways!
            if graph.has_key(int(datum[1])):
                graph[int(datum[1])].append(int(datum[0]))
            else:
                graph[int(datum[1])] = [int(datum[0])]                
            
    
# if the two vertices are not both already present they can be added safely    
    else:
        # if there is any path between them, adding the edge would create loop
        if find_path(graph, int(datum[0]), datum[1], path = []) is not None:
            # so pass
            pass
        
        # if there is no path between them
        if find_path(graph, int(datum[0]), datum[1], path = []) is None:
            # add edge to list of edges            
            edges.append(datum[2])
            # add whole row to mst edgelist
            edgelist[row] = [datum[0], datum[1], datum[2]]
            # update vertices list with new unique vertices
            if datum[0] not in vertices:
                vertices.append(datum[0])
            if datum[1] not in vertices:
                vertices.append(datum[1])
                
            # update the graph structure
            # if the graph already has a key for that vertex    
            if graph.has_key(int(datum[0])):
                # add the new vertex as a new connection
                graph[int(datum[0])].append(int(datum[1]))
            # if the graph does not have a key for that vertex
            else:
                # add the new vertex as a connection
                graph[int(datum[0])] = [int(datum[1])]
                
            # remember, the graph is undirected so ties go both ways!
            if graph.has_key(int(datum[1])):
                graph[int(datum[1])].append(int(datum[0]))
            else:
                graph[int(datum[1])] = [int(datum[0])]       
        
# %% clean up dictionary structure in to tabular edgelist
max_spanning_tree = pd.DataFrame(edgelist).transpose()
max_spanning_tree.columns = ["vx", "vy", "weight"]