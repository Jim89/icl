# Summarise to/from data in to edgelist
edgelist <- to_from %>% 
    group_by(from, to) %>% 
    summarise(emails = n()) 

# Create a function to plot the network
create_network_plot <- function(data, messages = 0, normalise = TRUE) {
    # Filter the data
    data <- data %>% filter(emails >= messages)
    
    # Set up the graph object and make some clusters (for colour for now)
    graph <- graph_from_data_frame(data)
    wc <- cluster_walktrap(graph)
    members <- membership(wc)

    # Convert to a networkD3 data structure for D3 plotting
    networks <- igraph_to_networkD3(graph, group = members)

    # Add link weights and optionally normalise
    networks$links$value <- data$emails
    
    if (normalise == TRUE) {
    networks$links$value <- (networks$links$value - mean(networks$links$value)) / sd(networks$links$value)
    }

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

create_network_plot(edgelist, messages = 1, normalise = TRUE)
