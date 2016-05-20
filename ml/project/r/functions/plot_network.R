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

# Add nodesize based on emails sent
networks$nodes <- networks$nodes %>% 
    left_join(emails_clean %>% group_by(from) %>% summarise(sent = n()), 
              by = c("name" = "from")) %>% 
    mutate(sent = ifelse(is.na(sent), 1, sent + 1))

# Plot the network
forceNetwork(Links = networks$links,
             Nodes = networks$nodes,
             colourScale = JS("d3.scale.category10()"),
             Source = "source",
             Target = "target",
             Value = "value",
             NodeID = "name",
             Nodesize = "sent",
             radiusCalculation = JS("Math.log(d.nodesize)+5"),
             Group = "group",
             charge = -1000,
             linkColour = "grey",
             fontSize = 16,
             opacity = 1,
             legend = F,
             bounded = F,
             zoom = TRUE)
}

