# Step 0 - prep env -------------------------------------------------------
# Load packages
library(dplyr)
library(readr)
library(readxl)
library(tidyr)
library(stringr)

# Step 1 - get data -------------------------------------------------------
# Basic linkage data from Wiki
adjacency <- read_csv("./data/geo/adjacency.csv",
                      col_types = cols(station1 = col_integer(),
                                       station2 = col_integer(),
                                       line = col_integer()))

station_lk <- read_csv("./data/geo/station_lk.csv",
                       col_types = cols(line = col_integer(),
                                        name = col_character(),
                                        colour = col_character(),
                                        stripe = col_character()))

station_details <- read_csv("./data/geo/stations_geo.csv",
                            col_types = cols(id = col_integer(),
                                             latitude = col_double(),
                                             longitude = col_double(),
                                             name = col_character(),
                                             display_name = col_character(),
                                             zone = col_double(),
                                             total_lines = col_integer(),
                                             rail = col_integer()))

# Distances data from FOI
dlr_abbr <- read_excel("./data/distances/formatted/FOI Request Station Abbreviations_CLN.xls")
stations_dist <- read_excel("./data/distances/formatted/Inter Station Train Times_CLN.xls")
dlr_dist <- read_excel("./data/distances/formatted/Distance Martix DLR 2013_CLN.xlsx")

# Step 2 - clean data -----------------------------------------------------
# set up clean lower-case name, and rounded zone-number in station details
station_details <- station_details %>% mutate(name_cln = tolower(name),
                                              zone_cln = ceiling(zone))

# Set up adjacency list with names of stations, rather than ID
links <- adjacency %>% left_join(station_details %>% select(id, name),
                                 by = c("station1" = "id")) %>% 
    select(-station1) %>% 
    rename(station1 = name) %>% 
    left_join(station_details %>% select(id, name),
              by = c("station2" = "id")) %>% 
    select(-station2) %>% 
    rename(station2 = name) %>% 
    mutate(station1 = tolower(station1),
           station2 = tolower(station2),
           station1 = str_trim(station1),
           station2 = str_trim(station2))

# DLR distances
dlr_dist_long <- dlr_dist %>% gather(station, dist, -Metres) %>% 
    rename(from = Metres,
           to = station) %>% 
    left_join(dlr_abbr, by = c("from" = "abbr")) %>% 
    select(-from) %>% 
    rename(station1 = station) %>% 
    left_join(dlr_abbr, by = c("to" = "abbr")) %>% 
    select(-to) %>% 
    rename(station2 = station) %>% 
    na.omit() %>% 
    filter(dist > 0) %>% 
    mutate(dist = dist / 1000,
           line = "Docklands Light Railway") %>% 
    select(line, station1, station2, dist) %>% 
    ungroup()

# Clean up stations distances
station_dist_long <- stations_dist %>% 
    group_by(Line, `Station from (A)`, `Station to (B)`) %>% 
    summarise(dist = median(`Distance (Kms)`)) %>% 
    rename(line = Line,
           dist = dist,
           station1 = `Station from (A)`,
           station2 = `Station to (B)`) %>% 
    ungroup()

         
# Create set of clean distances
distances <- bind_rows(dlr_dist_long, station_dist_long) %>% 
    mutate(station1 = tolower(station1),
           station2 = tolower(station2),
           station1 = str_trim(station1),
           station2 = str_trim(station2),
           station1 = gsub("edgware", "edgeware", station1),
           station2 = gsub("edgware", "edgeware", station2),
           station1 = gsub("regents park", "regent's park", station1),
           station2 = gsub("regents park", "regent's park", station2),
           station1 = gsub("piccadilly", "picadilly", station1),
           station2 = gsub("piccadilly", "picadilly", station2),
           station1 = gsub("st james park", "st. james's park", station1),
           station2 = gsub("st james park", "st. james's park", station2),
           station1 = gsub("kings cross|kings cross st pancras", "king's cross st. pancras", station1),
           station2 = gsub("kings cross|kings cross st pancras", "king's cross st. pancras", station2),
           station1 = gsub("earls court", "earl's court", station1),
           station2 = gsub("earls court", "earl's court", station2),
           station1 = gsub("highbury & islington", "highbury", station1),
           station2 = gsub("highbury & islington", "highbury", station2),
           station1 = gsub("paddington \\(.*\\)", "paddington", station1),
           station2 = gsub("paddington \\(.*\\)", "paddington", station2),
           station1 = gsub("st johns wood", "st. john's wood", station1),
           station2 = gsub("st johns wood", "st. john's wood", station2),
           station1 = gsub("queens park", "queen's park", station1),
           station2 = gsub("queens park", "queen's park", station2),
           station1 = gsub("heathrow 123", "heathrow terminals 1, 2 & 3", station1),
           station2 = gsub("heathrow 123", "heathrow terminals 1, 2 & 3", station2),
           station1 = gsub("heathrow four", "heathrow terminal 4", station1),
           station2 = gsub("heathrow four", "heathrow terminal 4", station2),
           station1 = gsub("hammersmith \\(.*\\)", "hammersmith", station1),
           station2 = gsub("hammersmith \\(.*\\)", "hammersmith", station2),
           station1 = gsub("st pauls", "st. paul's", station1),
           station2 = gsub("st pauls", "st. paul's", station2))

# Create "reversed" distances to account for possible different combos of stations
distances <- bind_rows(distances, distances %>% 
                           select(line, station2, station1, dist) %>% 
                           rename(station3 = station1,
                                  station1 = station2) %>% 
                           rename(station2 = station3))

# Add distances to station linkages data
links <- links %>% 
    left_join(distances %>% select(-line), by = c("station1" = "station1",
                                "station2" = "station2"))

# Clean up missing distances - set to average
links <- links %>%
    mutate(dist = ifelse(is.na(dist),  mean(links$dist, na.rm = T), dist)) %>% 
    distinct()

# Clean up mess
rm(dlr_abbr, dlr_dist, dlr_dist_long, station_dist_long, distances, adjacency,
   stations_dist)
