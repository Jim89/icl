# Set up ------------------------------------------------------------------
# Library
library(ggplot2)

# Colours
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

tfl_colour <- c(bakerloo, central, circle, district,
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


# Network clusters --------------------------------------------------------
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


plot_fares <- function(data) {
pos <- data %>% arrange(downo) %>% select(daytype) %>% sapply(as.character) %>% as.vector()
data %>% 
    ggplot(aes(x = daytype, y = total_fare_rev_scale)) +
    geom_bar(stat = "identity", fill = picadilly) +
    scale_x_discrete(limits = pos) +
    scale_y_continuous(labels = scales::dollar_format(prefix = "£")) +
    xlab("") +
    ylab("Fares") +
    theme_jim 
}

bind_rows(calcualte_daily_fares("current"),
            calcualte_daily_fares("deg")) %>% 
            

methods <- c("current", "deg", "eig", "clo", "bet")
data <- lapply(methods, calculate_daily_fares)
data <- bind_rows(data)

data %>% 
ggplot(aes(x = daytype, y = total_fare_rev_scale)) +
    geom_bar(stat = "identity", fill = picadilly) +
    scale_x_discrete(limits = pos) +
    scale_y_continuous(labels = scales::dollar_format(prefix = "£")) +
    facet_wrap(~how) +
    xlab("") +
    ylab("Fares") +
    theme_jim 

# Distances
# Join on line name
distances <- links %>% 
    left_join(station_lk) %>% 
    mutate(name = gsub(" Line", "", name),
           name = gsub("East London", "Overground", name),
           colour = paste0("#", colour))

# Plot overall hist
distances %>% 
    ggplot(aes(x = dist)) +
    geom_histogram(binwidth = 0.25, colour = "white") +
    theme_jim

distances %>% 
    ggplot(aes(x = name, y = dist, fill = name)) +
    geom_boxplot() +
    coord_flip() +
    scale_fill_manual(values = c(bakerloo, central, circle, district, dlr, 
                                 overground, hc, jubilee, metropolitan, northern,
                                 picadilly, victoria, wc)) +
    ylab("Average interstation distance") +
    xlab("") +
    theme_jim +
    theme(legend.position = "none")


# Get distances
dist <- distances(tfl_graph, 
                  v = V(tfl_graph), 
                  to = V(tfl_graph),
                  weights = E(tfl_graph)$dist) %>% 
    as.data.frame() %>% 
    dplyr::as_data_frame() %>% 
    tibble::rownames_to_column(var = "from") %>% 
    gather(to, distance, -from)

# Tag on to journeys
journey_dist <- journeys %>% 
    left_join(dist, by = c("start_cln" = "from", 
                           "end_cln" = "to")) %>% 
    select(start_cln, end_cln, distance)

journey_dist %>% 
    ggplot(aes(x = distance)) +
    geom_histogram(binwidth = 0.5)
    
              

# Mapping -----------------------------------------------------------------
# Create plotting data
clusters <- station_cluster_stats %>% 
    left_join(station_details %>% 
                  select(name_cln, 
                         latitude, 
                         longitude,
                         zone_cln,
                         name),
              by = c("station" = "name_cln")) %>% 
    select(name, latitude, longitude, eb, walk, sg, zone_cln) %>% 
    gather(method, value, -name, -latitude, -longitude) %>% 
    rename(lat = latitude,
           lon = longitude) %>% 
    mutate(value = as.factor(value),
           popup = paste(name, "- Zone/Cluster", value))

# Leaflet
library(leaflet)
# set.seed(8)
# sample(tfl_colour, 10)

# Set up colours
pal <- colorFactor(c(RColorBrewer::brewer.pal(8, "Dark2"), "#6a3d9a", "#c51b7d"), 
                   domain = levels(clusters$value))

# Make the map
leaflet() %>% 
    addProviderTiles("CartoDB.PositronNoLabels", group = "No area labels") %>% 
    addProviderTiles("CartoDB.Positron", group = "Show/hide area labels") %>% 
    addCircles(data = clusters %>% filter(method == "zone_cln"), radius = 250, 
               stroke = F, fillColor = ~pal(value), fillOpacity = 1, 
               group = "Zones (default)", popup = ~popup) %>% 
    addCircles(data = clusters %>% filter(method == "eb"), radius = 250,
               stroke = F, fillColor = ~pal(value), fillOpacity = 1,
               group = "Edge Betweenness", popup = ~popup) %>%
    addCircles(data = clusters %>% filter(method == "walk"), radius = 250,
               stroke = F, fillColor = ~pal(value), fillOpacity = 1,
               group = "Walktrap", popup = ~popup) %>%
    addCircles(data = clusters %>% filter(method == "sg"), radius = 250,
               stroke = F, fillColor = ~pal(value), fillOpacity = 1,
               group = "Spinglass", popup = ~popup) %>%
    # Layers control
    addLayersControl(
        baseGroups = c("Zones (default)", "Edge Betweenness", "Walktrap",
                       "Spinglass"),
        overlayGroups = c("Show/hide area labels"),
        options = layersControlOptions(collapsed = F)
    ) %>% 
    addLegend("bottomright", pal = pal, values = as.factor(1:10), opacity = 1, 
              title = "Zone/Cluster")
    


# ggmap - http://rpubs.com/RobinLovelace/intro-spatial
library(ggmap)


# Create bounding box
b <- matrix(c(min(clusters$longitude), max(clusters$longitude), 
              min(clusters$latitude), max(clusters$latitude)),
            nrow = 2, ncol = 2, byrow = T, 
            dimnames = list(c("x", "y"), c("min", "max"))) 

# Get the map with stamen toner tiles
map <- get_map(location = b, source = "stamen", maptype = "toner")

# Plot the map
map_plot <- ggmap(map)

# Add points
map_plot +
    geom_point(data = clusters, aes(x = lon, y = lat,
                                    colour = as.factor(value))) +
    facet_wrap(~method) +
    theme_jim




# Basic network diagram ---------------------------------------------------
library(networkD3)

d3_data <- igraph_to_networkD3(tfl_graph, group = rep(1, length(V(tfl_graph))))
d3_data$nodes <- d3_data$nodes %>% 
    left_join(station_details %>% select(name, name_cln, zone_cln),
              by = c("name" = "name_cln")) %>% 
    select(name, name.y, zone_cln) %>% 
    rename(name = name.y,
           name_cln = name,
           group = zone_cln)

# Get estimated visits
daily_visits <- journeys %>% 
    select(start_cln, end_cln) %>% 
    gather(x, name_cln) %>% 
    count(name_cln) %>% 
    mutate(n = n/7,
           n = n*20) %>% 
    ungroup() %>% 
    mutate(n = (n - mean(n))/sd(n))

# Tag stations
d3_data$nodes <- d3_data$nodes %>% left_join(daily_visits)

# Set up custom colour scale
ColourScale <- 'd3.scale.ordinal()
            .domain(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
           .range(["#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", "#A6761D", "#666666", "#6a3d9a", "#c51b7d"]);'

# Make the plot
forceNetwork(Links = d3_data$links, Nodes = d3_data$nodes, #Nodesize = "n",
             Source = 'source', Target = 'target', NodeID = 'name', 
             radiusCalculation = JS("d.nodesize"),
             Group = 'group', colourScale = JS(ColourScale),
             zoom = T, opacity = 1, legend = T)
