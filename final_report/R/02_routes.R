library(purrr)
library(igraph)

# Step 1 - create graph object --------------------------------------------
# Chop out line and distinct
graph_data <- links %>% 
    distinct() %>% 
    select(-line)

# Make the graph - retain distance as edge attribute but do not weight edges
tfl_graph <- graph_data %>% 
    graph_from_data_frame(directed = TRUE)

# Clean up
rm(graph_data)

# Find all distinct journeys, removing backwards journeys
distinct_journeys <- journeys %>% select(start_cln, end_cln) %>% distinct()
# distinct_journeys <- unique(t(apply(df, 1, sort))) %>% dplyr::as_data_frame()
# names(distinct_journeys) <- c("start_cln", "end_cln")

get_shortest_path <- function(node1, node2, graph = tfl_graph) {
    vertices <- V(graph)
    path <- shortest_paths(graph, node1, node2)$vpath
    path <- path[[1]]
    path <- path %>% as.list() %>% names()
    return(path)
}

# Get the paths
t1 <- Sys.time()
paths <- distinct_journeys %>% 
    # slice(1:100) %>% 
    mutate(path = map2(start_cln, end_cln, get_shortest_path)) %>% 
    unnest(path)
Sys.time() - t1    

# Set up routes with lead    
routes <- paths %>% 
    group_by(start_cln, end_cln) %>% 
    mutate(to = lead(path, 1)) %>% 
    na.omit() %>% 
    rename(from = path)
    
# Total up all the routes and summarise trips between stations
total_routes <- journeys %>% 
    select(start_cln, end_cln) %>% 
    left_join(routes) %>% 
    group_by(from, to) %>% 
    summarise(daily_trips = n(),
              daily_trips = daily_trips / 7,
              daily_trips = daily_trips * 20)

# Join in with links data
links <- links %>% 
    left_join(total_routes, by = c("station1" = "from",
                                   "station2" = "to"))

# Fill in the blanks
avg_per_line <- links %>% 
    group_by(line) %>% 
    summarise(avg_trips = mean(daily_trips, na.rm = T))

links <- links %>% left_join(avg_per_line) %>% 
    mutate(daily_trips = coalesce(daily_trips, avg_trips)) %>% 
    select(-avg_trips)
