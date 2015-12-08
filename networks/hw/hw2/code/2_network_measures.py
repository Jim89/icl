# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:23:20 2015

@author: jim
"""
import networkx as nx
import community as cty
import pandas as pd
import igraph as ig
import louvain

# networkx approach -----------------------------------------------------------
# get karate club graph 
graph = nx.karate_club_graph()
                                 
# get graph measures --------------------------
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

# push to data frame and CSV for pretty printing in report
data = pd.DataFrame(degrees.values(), columns = ['degree'])
data['betweenness'] = betweenness.values()
data['flow'] = flow.values()
data['eigen'] = eigen.values()
data.to_csv('../data/measures.csv')

# find communities --------------------------
# use community to estimate partition
partition_estimate = cty.best_partition(graph)

# read in ground truth
partitions = pd.read_table('../data/karate_truth.txt', sep = '\t', header = 0)

# calculate modularities (as that is what community package uses)
mod = cty.modularity(partition_estimate, graph)
mod_ground_truth = cty.modularity(partitions.to_dict()['partition'], graph)

# attach estimate and add comparison to ground truth
partitions['estimate'] = pd.Series(partition_estimate.values())+1
partitions['compare'] = partitions['partition'] == partitions['estimate']

# write data to csv for pretty printing in report
partitions.to_csv("../data/partitions.csv")

# evaluate based on density -----------------------------------
# ground truth first partition
ground_first_group = nx.karate_club_graph()
ground_first_group.remove_nodes_from(partitions[partitions.partition != 1].node-1)

# ground truth second partition
ground_second_group = nx.karate_club_graph()
ground_second_group.remove_nodes_from(partitions[partitions.partition != 2].node-1)

# estimate partition 1 
estimate_group1 = nx.karate_club_graph()
estimate_group1.remove_nodes_from(partitions[partitions.estimate != 1].node-1)

# estimate partition 2
estimate_group2 = nx.karate_club_graph()
estimate_group2.remove_nodes_from(partitions[partitions.estimate != 2].node-1)

# estimate partition 3
estimate_group3 = nx.karate_club_graph()
estimate_group3.remove_nodes_from(partitions[partitions.estimate != 3].node-1)

# estimate partition 4
estimate_group4 = nx.karate_club_graph()
estimate_group4.remove_nodes_from(partitions[partitions.estimate != 4].node-1)

# calculate densities
g1_dens = nx.density(ground_first_group)
g2_dens = nx.density(ground_second_group)
e1_dens = nx.density(estimate_group1)
e2_dens = nx.density(estimate_group2)
e3_dens = nx.density(estimate_group3)
e4_dens = nx.density(estimate_group4)

# igraph approach -------------------------------------------------------------
# read and format the karate data
karate = ig.Graph.Read_GraphML("../data/karate.GraphML")
#
## find some partitions with different methods
partM = louvain.find_partition(karate, method = "Modularity")
partRBConfig = louvain.find_partition(karate, method = "RBConfiguration", resolution_parameter = 0.25)
partRBER = louvain.find_partition(karate, method = "RBER")
partDens = louvain.find_partition(karate, method = "CPM", resolution_parameter = 0.25)
partSignif = louvain.find_partition(karate, method = "Significance")
partSurp = louvain.find_partition(karate, method = "Surprise")

# view paritions by printing
# print partM    
                                 
                                 