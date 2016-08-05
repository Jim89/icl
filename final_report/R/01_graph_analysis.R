
# Step 0 - prep env -------------------------------------------------------
# Load packages
library(igraph)


# Step 1 - create graph object --------------------------------------------
tfl_graph <- links %>% 
    select(-line) %>% 
    rename(weight = dist) %>% 
    graph_from_data_frame(directed = FALSE)



# Step 2 - centrality measures --------------------------------------------
# Centrality
eig_cent <- eigen_centrality(tfl_graph, directed = FALSE)
V(tfl_graph)$eig <- eig_cent$vector

# Betweenness
bet_cent <- betweenness(tfl_graph, directed = FALSE)
V(tfl_graph)$bet <- bet_cent

# Closeness
clos_cent <- closeness(tfl_graph)
V(tfl_graph)$close <- clos_cent


# Convert graph to data frame
station_stats <- data_frame(station = names(V(tfl_graph)),
                            eig = V(tfl_graph)$eig,
                            bet = V(tfl_graph)$bet,
                            clo = V(tfl_graph)$close)

# Find total current TFL zones and divide stations based on centrality measures
total_zones <- max(station_details$zone) %>% as.numeric()
station_stats <- station_stats %>% 
    mutate(eig_zone = ntile(-eig, total_zones),
           bet_zone = ntile(-bet, total_zones),
           clo_zone = ntile(-clo, total_zones))

                
                