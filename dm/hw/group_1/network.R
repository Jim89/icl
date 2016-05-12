library(networkD3)
library(igraph)

graph_data <- lines %>%
              select(cust_id, ordernum, recipnum) %>% 
              filter(recipnum != '' &
                     cust_id != recipnum) %>% 
              group_by(cust_id, recipnum) %>% 
              summarise(weight = n()) %>% 
              collect()

to_plot <- graph_data %>% filter(weight >= 5) %>% 
            bind_rows(graph_data %>% filter(cust_id == "33784549")) %>% 
            distinct()

graph <- graph_from_data_frame(to_plot)

# cl_walk <- cluster_walktrap(graph)
# members <- membership(cl_walk)

nw <- igraph_to_networkD3(graph, group = rep(1, V(graph) %>% length()))
nw$links$value <- E(graph)$weight

# Plot the network
forceNetwork(Links = nw$links,
             Nodes = nw$nodes,
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