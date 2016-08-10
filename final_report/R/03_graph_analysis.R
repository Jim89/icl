# Step 0 - prep env -------------------------------------------------------
# Load packages
library(igraph)


# Step 1 - create graph object --------------------------------------------
# Chop out line and distinct
graph_data <- links %>% 
    distinct() %>% 
    select(-line)

# Make the graph - retain distance as edge attribute but do not weight edges
tfl_graph <- graph_data %>% 
    graph_from_data_frame(directed = TRUE)

# Clean up
rm(graph_data)

# Step 2 - centrality measures --------------------------------------------
# Degree centrality
deg_cent <- degree(tfl_graph, loops = TRUE)
V(tfl_graph)$deg <- deg_cent

# Betweenness centrality
bet_cent <- betweenness(tfl_graph, directed = T)
V(tfl_graph)$bet <- bet_cent

# Closeness centrality
clo_cent <- closeness(tfl_graph)
V(tfl_graph)$close <- clo_cent

# Eigenvector centrality
eig_cent <- eigen_centrality(tfl_graph, directed = T, scale = T)
V(tfl_graph)$eig <- eig_cent$vector

# Convert to data frame of centrality stats
station_centrality_stats <- data_frame(station = names(V(tfl_graph)),
                            deg = V(tfl_graph)$deg,
                            eig = V(tfl_graph)$eig,
                            bet = V(tfl_graph)$bet,
                            clo = V(tfl_graph)$close)

# Step 3 - clustering approaches ------------------------------------------
# Non-hierarchical    
clust_i <- cluster_infomap(tfl_graph, nb.trials = 10)
clust_lp <- cluster_label_prop(tfl_graph)


# Requires large # communities
clust_le <- cluster_leading_eigen(tfl_graph)


# Fails
# clust_fg <- cluster_fast_greedy(tfl_graph) - there are multiple edges in the graph
# clust_o <- cluster_optimal(tfl_graph) - Only works on small graphs - too large here so fails
# clust_l <- cluster_louvain(tfl_graph) - only works for undirected graphs
    
# Hierarchical methods - use cut_at to chop up
# Use distances to help create clusters
clust_w <- cluster_walktrap(tfl_graph, steps = 10, weights = E(tfl_graph)$dist)
clust_eb <- cluster_edge_betweenness(tfl_graph, directed = T, weights = E(tfl_graph)$dist)
# n.b. spins sets number of clusters
clust_sg <- cluster_spinglass(tfl_graph, spins = 10, weights = E(tfl_graph)$dist)


# Create dataframe of results
station_cluster_stats <- data_frame(station = names(V(tfl_graph)),
                                   eb = cut_at(clust_eb, no = 10),
                                   walk = cut_at(clust_w, no = 10),
                                   sg = membership(clust_sg))






                