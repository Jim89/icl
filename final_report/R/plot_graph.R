# Step 0 - prep env -------------------------------------------------------
library(readr)
library(stringr)
library(igraph)
library(tidyverse)
library(ggforce)
library(ggraph)

# Step 1 - read data ------------------------------------------------------
# Basic linkage data from Wiki
adjacency <- read_csv("./data/adjacency/adjacency.csv",
                      col_types = cols(station1 = col_integer(),
                                       station2 = col_integer(),
                                       line = col_integer()))

# Line lookup values
lines <- read_csv("./data/adjacency/station_lk.csv",
                  col_types = cols(line = col_integer(),
                                   name = col_character(),
                                   colour = col_character(),
                                   stripe = col_character()))

# Station details
stations <- read_csv("./data/adjacency/stations_geo.csv",
                     col_types = cols(id = col_integer(),
                                      latitude = col_double(),
                                      longitude = col_double(),
                                      name = col_character(),
                                      display_name = col_character(),
                                      zone = col_double(),
                                      total_lines = col_integer(),
                                      rail = col_integer()))

# Sample journey data
journeys <- read_csv("./data/journeys/Nov09JnyExport.csv",
                     col_types = cols(downo = col_integer(),
                                      daytype = col_character(),
                                      SubSystem = col_character(),
                                      StartStn = col_character(),
                                      EndStation = col_character(),
                                      EntTime = col_integer(),
                                      EntTimeHHMM = col_character(),
                                      ExTime = col_integer(),
                                      EXTimeHHMM = col_character(),
                                      ZVPPT = col_character(),
                                      JNYTYP = col_character(),
                                      DailyCapping = col_character(),
                                      FFare = col_integer(),
                                      DFare = col_integer(),
                                      RouteID = col_character(),
                                      FinalProduct = col_character()))

names(journeys) <- names(journeys) %>% tolower()

# Step 2 - clean data -----------------------------------------------------
# Set up clean lower-case name, and rounded zone-number in station details
stations <- stations %>% mutate(name_cln = tolower(name),
                                zone_cln = ceiling(zone))

# Filter to just completed train journeys (i.e. not buses) and clean up names
journeys <- journeys %>% 
    filter(routeid == "XX", 
           startstn != "Unstarted",
           endstation != "Unfinished",
           endstation != "Not Applicable") %>%
    # Start station names
    mutate(start_cln = startstn,
           start_cln = gsub("Earls Court", "Earl's Court", start_cln),
           start_cln = gsub("Highbury", "Highbury & Islington", start_cln),
           start_cln = gsub("St James's Park", "St. James's Park", start_cln),
           start_cln = gsub("St Pauls", "St. Paul's", start_cln),
           start_cln = gsub("Kings Cross [MT]", "King's Cross St. Pancras", start_cln),
           start_cln = gsub("Piccadilly Circus", "Picadilly Circus", start_cln),
           start_cln = gsub("Hammersmith [DM]", "Hammersmith", start_cln),
           start_cln = gsub("Bromley By Bow", "Bromley-By-Bow", start_cln),
           start_cln = gsub("Canary Wharf E2", "Canary Wharf", start_cln),
           start_cln = gsub("Edgware Road [BM]", "Edgware Road (B)", start_cln),
           start_cln = gsub("Great Portland St", "Great Portland Street", start_cln),
           start_cln = gsub("Waterloo JLE", "Waterloo", start_cln),
           start_cln = gsub("Shepherd's Bush Mkt", "Shepherd's Bush (H)", start_cln),
           start_cln = gsub("Shepherd's Bush Und", "Shepherd's Bush (C)", start_cln),
           start_cln = gsub("Harrow On The Hill", "Harrow-on-the-Hill", start_cln),
           start_cln = gsub("Harrow Wealdstone", "Harrow & Wealdston", start_cln),
           start_cln = gsub("Heathrow Term [45]", "Heathrow Terminal 4", start_cln),
           start_cln = gsub("Heathrow Terms 123", "Heathrow Terminals 1, 2 & 3", start_cln),
           start_cln = gsub("Tottenham Court Rd", "Tottenham Court Road", start_cln),
           start_cln = gsub("High Street Kens", "High Street Kensington", start_cln),
           start_cln = gsub("Regents Park", "Regent's Park", start_cln),
           start_cln = gsub("Queens Park", "Queen's Park", start_cln),
           start_cln = gsub("St Johns Wood", "St. John's Wood", start_cln),
           start_cln = gsub("Wood Lane", "White City", start_cln),
           start_cln = gsub("Totteridge", "Totteridge & Whetstone", start_cln),
           start_cln = gsub("Watford Met", "Watford", start_cln),
           start_cln = tolower(start_cln)) %>% 
    # End station names
    mutate(end_cln = endstation,
           end_cln = gsub("Earls Court", "Earl's Court", end_cln),
           end_cln = gsub("Highbury", "Highbury & Islington", end_cln),
           end_cln = gsub("St James's Park", "St. James's Park", end_cln),
           end_cln = gsub("St Pauls", "St. Paul's", end_cln),
           end_cln = gsub("Kings Cross [MT]", "King's Cross St. Pancras", end_cln),
           end_cln = gsub("Piccadilly Circus", "Picadilly Circus", end_cln),
           end_cln = gsub("Hammersmith [DM]", "Hammersmith", end_cln),
           end_cln = gsub("Bromley By Bow", "Bromley-By-Bow", end_cln),
           end_cln = gsub("Canary Wharf E2", "Canary Wharf", end_cln),
           end_cln = gsub("Edgware Road [BM]", "Edgware Road (B)", end_cln),
           end_cln = gsub("Great Portland St", "Great Portland Street", end_cln),
           end_cln = gsub("Waterloo JLE", "Waterloo", end_cln),
           end_cln = gsub("Shepherd's Bush Mkt", "Shepherd's Bush (H)", end_cln),
           end_cln = gsub("Shepherd's Bush Und", "Shepherd's Bush (C)", end_cln),
           end_cln = gsub("Harrow On The Hill", "Harrow-on-the-Hill", end_cln),
           end_cln = gsub("Harrow Wealdstone", "Harrow & Wealdston", end_cln),
           end_cln = gsub("Heathrow Term [45]", "Heathrow Terminal 4", end_cln),
           end_cln = gsub("Heathrow Terms 123", "Heathrow Terminals 1, 2 & 3", end_cln),
           end_cln = gsub("Tottenham Court Rd", "Tottenham Court Road", end_cln),
           end_cln = gsub("High Street Kens", "High Street Kensington", end_cln),
           end_cln = gsub("Regents Park", "Regent's Park", end_cln),
           end_cln = gsub("Queens Park", "Queen's Park", end_cln),
           end_cln = gsub("St Johns Wood", "St. John's Wood", end_cln),
           end_cln = gsub("Wood Lane", "White City", end_cln),
           end_cln = gsub("Totteridge", "Totteridge & Whetstone", end_cln),
           end_cln = gsub("Watford Met", "Watford", end_cln),
           end_cln = tolower(end_cln))

# Add on station information
journeys <- journeys %>% 
    left_join(stations %>% select(name_cln, name), 
              by = c("start_cln" = "name_cln")) %>% 
    rename(start_nm = name) %>% 
    left_join(stations %>% select(name_cln, name),
              by = c("end_cln" = "name_cln")) %>% 
    rename(end_nm = name)

# Dedupe journeys
distinct_journeys <- journeys %>% 
    select(start_nm, end_nm) %>% 
    distinct() %>% 
    na.omit()

# Step 3 - find routes ----------------------------------------------------
# Define basic graph to find paths through the network
gr_basic <- graph_from_data_frame(adjacency, directed = FALSE, 
                                  vertices = stations)

# Define a function that will calcualte the path and return it as an ordered list
get_shortest_path <- function(node1, node2, graph = gr_basic) {
    path <- shortest_paths(graph, node1, node2)$vpath
    path <- path[[1]]
    path <- path %>% as.list() %>% names()
    return(path)
}

# Apply the function to get the routes, then unnest routes into long data
routes <- distinct_journeys %>% 
    mutate(path = purrr::map2(start_nm, end_nm, get_shortest_path)) %>% 
    tidyr::unnest(path)

# Set up routes per journey   
routes <- routes %>% 
    group_by(start_nm, end_nm) %>% 
    mutate(to = lead(path, 1)) %>% 
    na.omit() %>% 
    rename(from = path)

# Total up all the routes and summarise trips between stations
tot_routes <- journeys %>% 
    select(start_nm, end_nm) %>% 
    left_join(routes) %>% 
    group_by(from, to) %>% 
    summarise(daily_trips = n(),
              daily_trips = daily_trips / 7,
              daily_trips = ceiling(daily_trips * 20)) %>% 
    ungroup()

# Join in with station details to get IDs
day_routes <- journeys %>% 
    select(downo, start_nm, end_nm) %>% 
    left_join(routes) %>% 
    group_by(downo, from, to) %>% 
    summarise(daily_trips = n(),
              daily_trips = daily_trips / 7,
              daily_trips = ceiling(daily_trips * 20)) %>% 
    ungroup() 

# Join in with station details to get IDs
tot_usage <- tot_routes %>% 
    left_join(stations, by = c("from" = "name")) %>% 
    select(from, to, daily_trips, id) %>% 
    rename(station1 = id) %>% 
    left_join(stations, by = c("to" = "name")) %>% 
    select(from, to, daily_trips, station1, id) %>% 
    rename(station2 = id) %>% 
    select(station1, station2, daily_trips) %>% 
    na.omit()

# Join back in with adjacency
adjacency <- adjacency %>% 
    left_join(usage)

# Add line colour
day_usage <- day_routes %>% 
    left_join(stations, by = c("from" = "name")) %>% 
    select(downo, from, to, daily_trips, id) %>% 
    rename(station1 = id) %>% 
    left_join(stations, by = c("to" = "name")) %>% 
    select(downo, from, to, daily_trips, station1, id) %>% 
    rename(station2 = id) %>% 
    select(downo, station1, station2, daily_trips) %>% 
    na.omit()

# Join back in with adjacency
tot_adjacency <- adjacency %>% 
    left_join(tot_usage)

day_adjacency <- adjacency %>% 
    left_join(day_usage) %>% 
    arrange(downo, station1, station1)

# Add line colour
tot_adjacency <- tot_adjacency %>% 
    left_join(lines) %>% 
    rename(line_name = name) %>% 
    select(-stripe) %>% 
    mutate(colour = paste0('#', colour))

day_adjacency <- day_adjacency %>% 
    left_join(lines) %>% 
    rename(line_name = name) %>% 
    select(-stripe) %>% 
    mutate(colour = paste0('#', colour))


# Step 4 - graph analyses -------------------------------------------------
# Create graph object
gr <- adjacency %>% 
    mutate(line = as.factor(line)) %>% 
    graph_from_data_frame(directed = FALSE, vertices = stations)

# Find importance stations
close <- closeness(gr)
V(gr)$imp <- close

eig <- eigen_centrality(gr)
V(gr)$imp <- eig$vector

# Step 4 - create graph ---------------------------------------------------
# Set up the layout using lat and lon
lay <- stations %>% dplyr::rename(y = latitude, x = longitude)
lay_data <- createLayout(gr, 'manual', node.positions = lay)

tot_gr <- tot_adjacency %>% 
    mutate(line = as.factor(line)) %>% 
    graph_from_data_frame(directed = FALSE, vertices = stations)

day_gr <- day_adjacency %>% 
    mutate(line = as.factor(line)) %>% 
    graph_from_data_frame(directed = FALSE, vertices = stations)

# Step 4 - create graph ---------------------------------------------------

# # Use day #1 for layout
# subGr <- subgraph.edges(day_gr, which(E(day_gr)$downo == 1))
# V(subGr)$degree <- degree(subGr)
# lay <- createLayout(subGr, 'igraph', algorithm = 'lgl')
# 
# # Then we reassign the full graph with edge trails
# attr(lay, 'graph') <- day_gr
# 
# # Set up colours
# line_cols <- paste0('#', lines$colour)
# names(line_cols) <- lines$name
# 
# p <- ggraph(data = lay) +
#     geom_node_point(size = .5) +
#     geom_edge_fan(aes(colour = line_name, edge_width = daily_trips, frame = downo), 
#                   show.legend = F, edge_alpha = 1) +
#     scale_edge_colour_manual(name = "Line", values = line_cols) +
#     theme_void() 
# 
# animation::ani.options(interval=0.1)
# gganimate::gg_animate(p, 'animation.gif', title_frame = FALSE)




# Set up the layout using lat and lon
lay <- stations %>% dplyr::rename(y = latitude, x = longitude)

# Create graph layout
lay_data <- createLayout(tot_gr, 'manual', node.positions = lay)

# Set up colours
line_cols <- paste0('#', lines$colour)
names(line_cols) <- lines$name

tube_map <- ggraph(tot_gr, 'manual', data = lay_data) +
    geom_node_point(size = .5) +
    geom_edge_fan(aes(colour = line_name, edge_width = daily_trips), 
                  show.legend = F, edge_alpha = 1) +
    scale_edge_colour_manual(name = "Line", values = line_cols) +
    theme_void() 

# ggsave("./blog_post/tube_map.png", tube_map, width = 16, height = 13)


library(ggmap)

map <- get_map(location = c(lon = -0.1275, lat = 51.5072), maptype = "toner-lite")
map_plot <- ggmap(map)

# ggraph(tot_gr, 'manual', data = lay_data) +
#     geom_node_point(size = .5) +
#     geom_edge_fan(aes(colour = line_name, edge_width = daily_trips), 
#                   show.legend = F, edge_alpha = 1) +
#     scale_edge_colour_manual(name = "Line", values = line_cols)
# 
# 
