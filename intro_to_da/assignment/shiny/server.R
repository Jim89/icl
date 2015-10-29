
# load packages ----------------------------------------------------------------
  library(shiny)
  library(networkD3)
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


# combine and clean the nodes data ---------------------------------------------
nodes <- people %>% 
  mutate(group = as.character(group)) %>% 
  left_join(groups, by = c("group" = "group_id")) %>% 
  mutate(id = as.numeric(id))

# create a function for plotting the graph -------------------------------------
create_diagram <- function(links_data, nodes_data) {
  
  # set up the graph data frame properly
  links_data_cln <- links_data %>% 
    mutate(rater_id = as.numeric(rater_id) - 1,
           rated_id = as.numeric(rated_id) - 1,
           rating = as.numeric(rating))
  
  nodes_cln <- nodes_data %>% select(id, group)
  
  # make basic diagram 
  forceNetwork(Links = links_data_cln, Nodes = nodes_cln, 
               Source = "rater_id", Target = "rated_id", Value = "rating", 
               NodeID = "id", Group = "group", 
               zoom = T, opacity = .8, legend = TRUE)
}


# Define server logic  ---------------------------------------------------------
shinyServer(function(input, output) {
  output$albert_hall <- renderForceNetwork({create_diagram(albert_hall_links, nodes_data = nodes)})
  output$workshop <- renderForceNetwork({create_diagram(workshop_links, nodes_data = nodes)})
  output$weekly_meeting <- renderForceNetwork({create_diagram(weekly_meeting_links, nodes_data = nodes)})
  output$urgent_meeting <- renderForceNetwork({create_diagram(urgent_meeting_links, nodes_data = nodes)})
})
