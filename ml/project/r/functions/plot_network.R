plot_network <- function(graph_object, clusters = "walk") {

    if (clusters == "walk") {
    # Convert to a networkD3 data structure for D3 plotting
    networks <- igraph_to_networkD3(graph_object, group = V(graph)$cl_walk)
    } else if (clusters == "bet") {
    # Convert to a networkD3 data structure for D3 plotting
    networks <- igraph_to_networkD3(graph_object, group = V(graph)$cl_edge_bet)
    }

# Add link weights and optionally normalise
networks$links$value <- E(graph_object)$emails %>% normalise

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
}

