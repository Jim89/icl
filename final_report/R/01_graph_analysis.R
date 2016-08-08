# Step 0 - prep env -------------------------------------------------------
# Load packages
library(igraph)


# Step 1 - create graph object --------------------------------------------
# Chop out line and distinct
graph_data <- links %>% 
    distinct() %>% 
    rename(weight = dist) %>% 
    select(-line)

# Make the graph
tfl_graph <- graph_data %>% 
    graph_from_data_frame(directed = FALSE)

# Tidy up
rm(graph_data)

# Step 2 - centrality measures --------------------------------------------
# Degree centrality
deg_cent <- degree(tfl_graph, loops = TRUE)
V(tfl_graph)$deg <- deg_cent

# Betweenness centrality
bet_cent <- betweenness(tfl_graph, directed = FALSE)
V(tfl_graph)$bet <- bet_cent

# Closeness centrality
clo_cent <- closeness(tfl_graph)
V(tfl_graph)$close <- clo_cent

# Eigenvector centrality
eig_cent <- eigen_centrality(tfl_graph, directed = FALSE, scale = T)
V(tfl_graph)$eig <- eig_cent$vector

# Convert to data frame of centrality stats
station_centrality_stats <- data_frame(station = names(V(tfl_graph)),
                            deg = V(tfl_graph)$deg,
                            eig = V(tfl_graph)$eig,
                            bet = V(tfl_graph)$bet,
                            clo = V(tfl_graph)$close) %>% 
    mutate(eig_zone = ntile(desc(eig), 10),
           bet_zone = ntile(desc(bet), 10),
           clo_zone = ntile(desc(clo), 10))

# Step 3 - clustering approaches ------------------------------------------
# Non-hierarchical    
clust_i <- cluster_infomap(tfl_graph, nb.trials = 10)
clust_lp <- cluster_label_prop(tfl_graph)
clust_l <- cluster_louvain(tfl_graph)

# Requires large # communities
clust_le <- cluster_leading_eigen(tfl_graph)


# Fails
# clust_fg <- cluster_fast_greedy(tfl_graph) - there are multiple edges in the graph
# clust_o <- cluster_optimal(tfl_graph) - Only works on small graphs - too large here so fails
    
# Hierarchical methods - use cut_at to chop up
clust_w <- cluster_walktrap(tfl_graph, steps = 10)
clust_eb <- cluster_edge_betweenness(tfl_graph, directed = FALSE)
# n.b. spins sets number of clusters
clust_sg <- cluster_spinglass(tfl_graph, spins = 10)


# Create dataframe of results
station_cluster_stats <- data_frame(station = names(V(tfl_graph)),
                                   eb = cut_at(clust_eb, no = 10),
                                   walk = cut_at(clust_w, no = 10),
                                   sg = membership(clust_sg))


# Do some plotting

library(ggplot2)

bakerloo <- rgb(red = 137, green = 78, blue = 36, maxColorValue = 255)
central <- rgb(red = 220, green = 36, blue = 31, maxColorValue = 255)
circle <- rgb(red = 255, green = 206, blue = 0, maxColorValue = 255)
district <- rgb(red = 0, green = 114, blue = 41, maxColorValue = 255)
hc <- rgb(red = 215, green = 153, blue = 175, maxColorValue = 255)
jubilee <- rgb(red = 134, green = 143, blue = 152, maxColorValue = 255)
metropolitan <- rgb(red = 117, green = 16, blue = 86, maxColorValue = 255)
northern <- rgb(red = 0, green = 0, blue = 0, maxColorValue = 255)
picadilly <- rgb(red = 0, green = 25, blue = 168, maxColorValue = 255)
victoria <- rgb(red = 0, green = 160, blue = 226, maxColorValue = 255)
wc <- rgb(red = 118, green = 208, blue = 189, maxColorValue = 255)
dlr <- rgb(red = 0, green = 175, blue = 173, maxColorValue = 255)
overground <- rgb(red = 232, green = 106, blue = 16, maxColorValue = 255)

# Colour df
# Set up colours
colour_df <- data_frame(line = c("Bakerloo", "Central", "Circle", "District",
                                 "Hammersmit & City", "Jubilee", "Metropolitan",
                                 "Northern", "Piccadilly", "Victoria",
                                 "Waterloo & City", "DLR", "Overground"),
                        colour = c(bakerloo, central, circle, district,
                                   hc, jubilee, metropolitan, northern, picadilly,
                                   victoria, wc, dlr, overground))

colour <- c(bakerloo, central, circle, district,
           hc, jubilee, metropolitan, northern, picadilly,
           victoria, wc, dlr, overground)

# Set up theme object for prettier plots
theme_jim <-  theme(legend.position = "bottom",
                    axis.text.y = element_text(size = 16, colour = "black"),
                    axis.text.x = element_text(size = 16, colour = "black"),
                    legend.text = element_text(size = 16),
                    legend.title = element_text(size = 16),
                    title = element_text(size = 16),
                    strip.text = element_text(size = 16, colour = "black"),
                    strip.background = element_rect(fill = "white"),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
                    panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
                    panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
                    panel.margin.y = unit(0.1, units = "in"),
                    panel.background = element_rect(fill = "white", colour = "lightgrey"),
                    panel.border = element_rect(colour = "black", fill = NA))

station_cluster_stats %>% 
    left_join(station_details %>% 
                  select(name, 
                         latitude, 
                         longitude,
                         zone) %>% 
                  mutate(name = tolower(name),
                         zone = ceiling(zone)),
              by = c("station" = "name")) %>% 
    gather(method, value, -station, -latitude, -longitude) %>% 
    ggplot(aes(x = longitude, y = latitude, label = station, colour = as.factor(value))) +
    geom_point(size = 2, alpha = .75) +
    facet_wrap(~method) +
    scale_colour_manual(values = colour) +
    theme_jim


station_centrality_stats %>% 
    select(station, ends_with("zone")) %>% 
    left_join(station_details %>% 
                  select(name, 
                         latitude, 
                         longitude,
                         zone) %>% 
                  mutate(name = tolower(name),
                         zone = ceiling(zone)),
              by = c("station" = "name")) %>% 
    gather(method, value, -station, -latitude, -longitude) %>% 
    ggplot(aes(x = longitude, y = latitude, label = station, colour = as.factor(value))) +
    geom_point(size = 2, alpha = .75) +
    facet_wrap(~method) +
    scale_colour_manual(values = colour) +
    theme_jim

ggplotly()

                