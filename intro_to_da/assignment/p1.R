
# load packages ----------------------------------------------------------------
  library(igraph)
  library(readxl)
  library(dplyr)
  library(magrittr)

# source data and function -----------------------------------------------------
# read in the data -------------------------------------------------------------
groups <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Overview") %>% .[1:12, 1:2]
people <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Attributes")
albert_hall_links <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3780")
workshop_links <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3782")
weekly_meeting_links <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3781")
urgent_meeting_links <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3779")



# define key variables
back_bone <- 1:57
dat <- list(albert_hall_links, workshop_links, weekly_meeting_links, urgent_meeting_links)

# extract in degree centrality
get_indegrees <- function (data) {
  graph <- graph.data.frame(data, directed = TRUE)
  indegrees <- degree(graph, v = V(graph), mode = "in", loops = FALSE)
  return(indegrees)
}
indegrees <- lapply(seq_along(dat), function(x) get_indegrees(dat[x]))

# extract in order
extract_in_order <- function (degrees_obj) {
 sapply(seq_along(back_bone), function(x) degrees_obj[as.character(x)]) 
}

ordered_degrees <- sapply(seq_along(indegrees), function(x) extract_in_order(indegrees[[x]]))







