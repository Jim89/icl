# -*- coding: utf-8 -*-
"""
Title: Max-Cost Spanning Tree
Author: Jim Leach
Date: 2015-11-22
Requires: pandas, networkx
References: https://www.python.org/doc/essays/graphs/ 
"""

# %% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1

# %% define function to find path(s) in a graph
# based on material referenced on 2015-11-22 
# from: https://www.python.org/doc/essays/graphs/ 
def is_path(graph, start, end, path = []):
    """ 
    This function takes as its input a representation of a graph in the following,
    dictionary-based form:
    
        {node0: [neighbour1, neighbour2, ...],
         node1: [neighbour1, neighbour2, ...],
         ...
        }
        
    Using this it searches for a path from the input start and end nodes via the
    following methodology:
        i. begin with the start node, add it to the path;
        ii. find all neighbours of the start node and add them to the path;
        iii. find all neighbours of all nodes in the path and add _them_ to the 
            path (as long as they are not already there)
    
    It repeats this methodology until it has performed searches equal to the
    total number of nodes in the network (i.e. it is exhaustive). Due to this
    factor, this function should _only_ be used on small, simple networks.
    """
    if not graph.has_key(start):
        return False
    
    if not graph.has_key(end):
        return False
    
    # Define the maximum number of passes over the graph the function should make
    max_iter = len(graph.keys())
    # Add the starting point to the path
    path = path + [start]
    # Set a counter variable to help terminate the while loop
    tested = 0
    # loop - as many times as there are nodes in the network
    while tested < max_iter:
        # add some logic so that if a path is found the loop can be broken
        if start in path and end in path:
            break
        
        # for each node in the path
        for step in path:
            # and for each neighbour of each node
            for node in graph[step]:
                # if the neighbour is in the path, do nothing
                if node in path:
                    pass
                # otherwise add it to the path
                else:
                    path.append(node)
        # increment the counter to help terminate the loop
        tested += 1
        
    # logical condition to return True/False depending on if a path is found
    if start in path and end in path:
        return True
    else:
        return False
      
def spanning_tree(edgelist_data, ascending = False):
    """ 
    This function takes as its input a representation of a graph in the following,
    dataframe-based form (i.e. an edgelist):

    node1, node2, weight,
    node1, node3, weight,
    node2, node1, weight,
    ...        
     
    Using this it sorts the edgelist by increasing/decreasing weight (depending)
    on if the max-cost or min-cost tree is sought then.
    
    It then iterates over all the rows of the sorted edgelist, taking one row at a
    time and adding the edge to the spanning tree as long as it would not form
    a loop in the resulting tree. It determines if a loop would be formed using
    the "is_path()" function defined above to determine if there is already a 
    path between the nodes in the new edge.
    
    In this way it builds the min/max-cost spanning tree for a given edgelist.      
    """     
# set up some containers for use a loop that assesses all edges in a graph
    edges = []          # to keep track of edges added with each iteration
    vertices = []       # to keep track of unique vertices added with each iteration
    edgelist = dict()   # to keep an edgelist going
    graph = dict()      # to keep track of connections formed in graph format
    rows = len(edgelist_data.index) # find the number of rows
    # sort by weights for iteration purposes                     
    edgelist_data = edgelist_data.sort_values("weight", ascending = ascending)     
    
    # iterate over rows of data
    for row in range(rows):
    # extract edge data
        datum = edgelist_data.iloc[row, ]
    # print statement to check things whilst developing
    #    print datum[0], datum[1], find_path(graph, int(datum[0]), datum[1], path = [])
    
    # if the two vertices are included in the current mst:
        if (datum[0] and datum[1] in vertices): 
            # if there is already a path between them, adding the edge would create loop
            if is_path(graph, int(datum[0]), int(datum[1]), path = []) is True:
                # so pass - do not add the edge
                pass
            
            # if there is no path between them
            if is_path(graph, int(datum[0]), int(datum[1]), path = []) is False:
                # add edge to list of edges            
                edges.append(datum[2])
                # add whole row to max-spanning-tree edgelist
                edgelist[row] = [datum[0], datum[1], datum[2]]
                # update vertices list with new unique vertices (just to keep)
                # track of things inside the loop
                if datum[0] not in vertices:
                    vertices.append(datum[0])
                if datum[1] not in vertices:
                    vertices.append(datum[1])
                    
                # update the graph structure that is used to test for paths
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
                
        
    # if the two vertices are not both already present they can be added   
        else:
            # if there is any path between them, adding the edge would create loop
            if is_path(graph, int(datum[0]), int(datum[1]), path = []) is True:
                # so pass
                pass
            
            # if there is no path between them
            if is_path(graph, int(datum[0]), int(datum[1]), path = []) is False:
                # add edge to list of edges            
                edges.append(datum[2])
                # add whole row to mst edgelist
                edgelist[row] = [datum[0], datum[1], datum[2]]
                # update vertices list with new unique vertices
                if datum[0] not in vertices:
                    vertices.append(datum[0])
                if datum[1] not in vertices:
                    vertices.append(datum[1])
                    
                # update the graph structure that is used to test for paths
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
        

# now that all edges have been assessed (by using the loop), the new max-st
# edgelist structure should be complete, so turn it in to a tidy data frame
# and return it
    spanning_tree = pd.DataFrame(edgelist).transpose()
    spanning_tree.columns = ["vx", "vy", "weight"]
    
    return spanning_tree


# %% read in data - use a pandas data frame just for convenience
import pandas as pd
data = pd.read_table("../data/HW1_3.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])


# %% run the function
min_st = spanning_tree(data, ascending = True)
max_st = spanning_tree(data, ascending = False)