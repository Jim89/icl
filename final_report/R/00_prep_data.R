# Step 0 - prep env -------------------------------------------------------
# Load packages
library(igraph)
library(dplyr)
library(readr)
library(readxl)


# Step 1 - get data -------------------------------------------------------
# Basic linkage data from Wiki
adjacency <- read_csv("./data/geo/adjacency.csv")
station_lk <- read_csv("./data/geo/station_lk.csv")
station_details <- read_csv("./data/geo/stations_geo.csv")

# Distances data from FOI
dlr_abbr <- read_excel("./data/distances/formatted/FOI Request Station Abbreviations_CLN.xls")
stations <- read_excel("./data/distances/formatted/Inter Station Train Times_CLN.xls")
dlr_dist <- read_excel("./data/distances/formatted/Distance Martix DLR 2013_CLN.xlsx")

# Step 2 - clean data -----------------------------------------------------
# Set up adjacency list with names of stations, rather than ID
links <- adjacency %>% left_join(station_details %>% select(id, name),
                                 by = c("station1" = "id")) %>% 
    select(-station1) %>% 
    rename(station1 = name) %>% 
    left_join(station_details %>% select(id, name),
              by = c("station2" = "id")) %>% 
    select(-station2) %>% 
    rename(station2 = name)