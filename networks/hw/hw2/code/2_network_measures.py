# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:23:20 2015

@author: jim
"""
import networkx as nx
import community as cty
import pandas as pd

# %% convert to graphs
graph = nx.karate_club_graph()
                                 
# %% get 3 measures

# order (# vertices) and size (# edges)
order = graph.order()
size = graph.size()
 
                          
# degree distribution
degrees = nx.degree(graph)

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

data = pd.DataFrame(degrees.values(), columns = ['degree'])
data['betweenness'] = betweenness.values()
data['flow'] = flow.values()
data['eigen'] = eigen.values()
data.to_csv('../data/measures.csv')

# %% find communites
partition_estimate = cty.best_partition(graph)
mod = cty.modularity(partition_estimate, graph)

# read in ground truth
partitions = pd.read_table('../data/karate_truth.txt', sep = '\t', header = 0)
mod_ground_truth = cty.modularity(partitions.to_dict()['partition'], graph)

# attach estimate and add comparison
partitions['estimate'] = pd.Series(partition_estimate.values())+1
partitions['compare'] = partitions['partition'] == partitions['estimate']

# write data to csv
partitions.to_csv("../data/partitions.csv")

# %% evaluate
# chose density 

# ground truth ----------------------------------------------------------------
ground_first_group = nx.karate_club_graph()
ground_first_group.remove_nodes_from(partitions[partitions.partition != 1].node-1)

ground_second_group = nx.karate_club_graph()
ground_second_group.remove_nodes_from(partitions[partitions.partition != 2].node-1)

# densities
g1_dens = nx.density(ground_first_group)
g2_dens = nx.density(ground_second_group)


# estimates -------------------------------------------------------------------
estimate_group1 = nx.karate_club_graph()
estimate_group1.remove_nodes_from(partitions[partitions.estimate != 1].node-1)

estimate_group2 = nx.karate_club_graph()
estimate_group2.remove_nodes_from(partitions[partitions.estimate != 2].node-1)

estimate_group3 = nx.karate_club_graph()
estimate_group3.remove_nodes_from(partitions[partitions.estimate != 3].node-1)

estimate_group4 = nx.karate_club_graph()
estimate_group4.remove_nodes_from(partitions[partitions.estimate != 4].node-1)

# get densities
e1_dens = nx.density(estimate_group1)
e2_dens = nx.density(estimate_group2)
e3_dens = nx.density(estimate_group3)
e4_dens = nx.density(estimate_group4)


    
                                 
                                 