# load packages ---------------------------------------------------------------
import networkx as nx
import numpy as np
import scipy as sp
import pandas as pd

# get graph structure from networkx -------------------------------------------
graph = nx.karate_club_graph()
nodes = graph.nodes()
graph_adj = graph.adjacency_list()

# set up laplacian ------------------------------------------------------------

adjacency = np.zeros(shape = (34, 34))

for row in range(len(graph_adj)):
    neighbours = graph_adj[row]
    for neighbour in neighbours:
        adjacency[row][neighbour] = 1
    
    
degree = np.zeros(shape = (34, 34))
for i in range(len(degrees)):
    degree[i][i] = graph.degree().values()[i]
    
laplacian = degree - adjacency

# get eigenvalues/vectors (just the two smallest) -----------------------------
eigenvals, eigenvecs = sp.sparse.linalg.eigs(laplacian, k = 2, which = 'SM')
eigenvec_for_assignment = eigenvecs.T[1]

# perform assignment ----------------------------------------------------------
partition = np.zeros(34)
for i in range(len(eigenvec_for_assignment)):
    if eigenvec_for_assignment[i] < 0:
        partition[i] = 1
    else:
        partition[i] = 2

# create tables for comparison ------------------------------------------------
spectral_method = pd.DataFrame(data = {'node': nodes, 'partition': partition})

# read in ground truth
ground_truth = pd.read_table('../data/karate_truth.txt', sep = '\t', header = 0)

compare = spectral_method
compare['groundtruth'] = ground_truth['partition']
compare['node'] = compare['node'] + 1
compare.to_csv('../data/spectral_to_truth.csv')

    
