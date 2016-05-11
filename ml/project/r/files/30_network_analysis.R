# Step 0 - prep env -------------------------------------------------------


# Step 1 - prepare edgelist and create igraph -----------------------------
# Summarise to/from data in to edgelist and grab only those pairs who sent/received
# more than 1 email
edgelist <- to_from %>% 
    left_join(emails_clean) %>% 
    select(DocNumber, from, to, redacted) %>% 
    group_by(from, to) %>% 
    summarise(emails = n(),
              prop_redacted = mean(redacted)) %>% 
    na.omit() %>% 
    filter(emails > 1)


# Create the igraph object for further analysis
graph <- graph_from_data_frame(edgelist)


# Step 2 - perform some analysis on the graph -----------------------------
# Centrality
centralities <- eigen_centrality(graph, weights = E(graph)$emails)
V(graph)$eig <- centralities$vector

# Betweenness
betweens <- betweenness(graph, weights = E(graph)$emails)
V(graph)$bet <- betweens

# Closeness
closes <- closeness(graph, weights = E(graph)$emails)
V(graph)$close <- closes

# Step 3 - try to find clusters in the graph ------------------------------

cl_edge_bet <- cluster_edge_betweenness(graph)
cl_walk <- cluster_walktrap(graph)

V(graph)$cl_walk <- membership(cl_walk)
V(graph)$cl_edge_bet <- membership(cl_edge_bet)

# Step 4 - convert back to df ---------------------------------------------

from_stats <- data_frame(from = names(V(graph)),
                         eig = V(graph)$eig,
                         bet = V(graph)$bet,
                         close = V(graph)$close,
                         cl_eb = V(graph)$cl_edge_bet,
                         cl_walk = V(graph)$cl_walk) %>% 
                mutate(eig_norm = normalise(eig),
                       bet_norm = normalise(bet),
                       close_norm = normalise(close))

                         
# Step 5 - clean up -------------------------------------------------------
rm(centralities, betweens, closes, cl_walk, cl_edge_bet)
gc()
