# load packages --------------------------------------------
library(MASS)
library(lsa)
library(igraph)
library(readxl)
library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2)

# get the data and source functions
source("./001_get_data.R")

# data wrangling and extraction ------------------------------------------------

# define key variables
back_bone <- 1:57
dat <- list(albert_hall_links, 
            workshop_links, 
            weekly_meeting_links, 
            urgent_meeting_links)

# create base table
base <- people %>% 
  left_join(guest_list, by = c("id" = "rater")) %>% rename(guest_list = item) %>% 
  left_join(style, by = c("id" = "rater")) %>% rename(style = item) %>% 
  left_join(option1, by = c("id" = "rater")) %>% rename(option1 = item) %>% 
  left_join(option2, by = c("id" = "rater")) %>% rename(option2 = item)


# extract all network properties -----------------------------------------------
# extract in degree centrality
get_degrees <- function (data, type = c("in", "out")) {
  graph <- graph.data.frame(data, directed = TRUE)
  indegrees <- degree(graph, v = V(graph), mode = type, loops = FALSE)
  return(indegrees)
}

# extract betweenness
get_betweenness <- function(data) {
  graph <- graph.data.frame(data, directed = TRUE)
  betweenness <- betweenness(graph, v = V(graph), directed = TRUE, normalized = TRUE)
  return(betweenness)
}  

# get eigen centrality
get_eig <- function(data) {
  graph <- graph.data.frame(data, directed = TRUE)
  eig_cent <- eigen_centrality(graph, directed = TRUE)$vector
  return(eig_cent)
}

# get closeness    
get_closeness <- function(data) {
  graph <- graph.data.frame(data, directed = TRUE)
  close <- closeness(graph, vids = V(graph), mode = "in")
  return(close)
}  

# get properties
indegrees   <- lapply(seq_along(dat), function(x) get_degrees(dat[x], type = "in"))
outdegrees  <- lapply(seq_along(dat), function(x) get_degrees(dat[x], type = "out"))
betweenness <- lapply(seq_along(dat), function(x) get_betweenness(dat[x]))
eigen_cent  <- lapply(seq_along(dat), function(x) get_eig(dat[x]))
closeness   <- lapply(seq_along(dat), function(x) get_closeness(dat[x]))


# create tables for picking from -----------------------------------------------
# create function for turning stats objects in to tidy df
convert_stat_to_df <- function(stat){
  stat %>% 
    data.frame() %>%
    add_rownames() %>% 
    setNames(c("id", "stat")) %>% 
    apply(2, as.numeric) %>% data.frame %>% tbl_df
}

normalise <- function(field){
  mean <- mean(field, na.rm = TRUE)
  sd <- sd(field, na.rm = TRUE)
  value <- (field - mean) / sd
}

vp <- convert_stat_to_df(indegrees[[1]]) %>% rename(vp = stat)

# create base table
base %<>% left_join(vp, by = "id")

# design - grab the network properties and then create a tidy table
des_bet <- convert_stat_to_df(betweenness[[2]])
des_eig <- convert_stat_to_df(eigen_cent[[2]])
des_close <- convert_stat_to_df(closeness[[2]])

design <- base %>% 
          left_join(des_bet, by = "id") %>% rename(bet = stat) %>% 
          left_join(des_eig, by = "id") %>% rename(eig = stat) %>% 
          left_join(des_close, by = "id") %>% rename(close = stat) %>% 
          mutate(bet = normalise(bet),
                 eig = normalise(eig),
                 close = normalise(close))

# implementation - grab network properites and then create tbl
imp_bet <- convert_stat_to_df(betweenness[[3]])
imp_eig <- convert_stat_to_df(eigen_cent[[3]])
imp_close <- convert_stat_to_df(closeness[[3]])

implement <- base %>% 
            left_join(imp_bet, by = "id") %>% rename(bet = stat) %>% 
            left_join(imp_eig, by = "id") %>% rename(eig = stat) %>% 
            left_join(imp_close, by = "id") %>% rename(close = stat) %>% 
            mutate(bet = normalise(bet),
                   eig = normalise(eig),
                   close = normalise(close))

# advocacy - grab network properites and then create tbl
adv_bet <- convert_stat_to_df(betweenness[[4]])
adv_eig <- convert_stat_to_df(eigen_cent[[4]])
adv_close <- convert_stat_to_df(closeness[[4]])

advocacy <- base %>% 
  left_join(adv_bet, by = "id") %>% rename(bet = stat) %>% 
  left_join(adv_eig, by = "id") %>% rename(eig = stat) %>% 
  left_join(adv_close, by = "id") %>% rename(close = stat) %>% 
  mutate(bet = normalise(bet),
         eig = normalise(eig),
         close = normalise(close))

# write files to excel ---------------------------------------------------------
  library(xlsx)

  write.xlsx(data.frame(design), "./pres/picks_tbls/design.xlsx", row.names = FALSE)
  write.xlsx(data.frame(implement), "./pres/picks_tbls/implementation.xlsx", row.names = FALSE)
  write.xlsx(data.frame(advocacy), "./pres/picks_tbls/advocacy.xlsx", row.names = FALSE)
  

  # create base table
  write.csv(base, file = "./data/base_table.csv", row.names = F)
  