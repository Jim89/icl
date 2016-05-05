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
    filter(emails > 0)


# Create the igraph object for further analysis
graph <- graph_from_data_frame(edgelist)


# Step 2 - perform some analysis on the graph -----------------------------
# Centrality
centralities <- eigen_centrality(graph, weights = E(graph)$emails)

# Betweenness
betweens <- betweenness(graph, weights = E(graph)$emails)

# Closeness
closes <- closeness(graph, weights = E(graph)$emails)


# Step 3 - try to find clusters in the graph ------------------------------

cl_walk <- cluster_walktrap(graph)
members <- membership(cl_walk)

# Convert to a networkD3 data structure for D3 plotting
networks <- igraph_to_networkD3(graph, group = members)

# Add link weights and optionally normalise
networks$links$value <- E(graph)$emails %>% normalise

# Plot the network
forceNetwork(Links = networks$links,
             Nodes = networks$nodes,
             colourScale = JS("d3.scale.category20()"),
             Source = "source",
             Target = "target",
             Value = "value",
             NodeID = "name",
             Group = "group",
             charge = -250,
             linkColour = "grey",
             opacity = 1,
             legend = F,
             bounded = F,
             zoom = TRUE)

