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
            mutate(id = as.numeric(id) -1)

# create a function for plotting the graph -------------------------------------
create_diagram <- function(links_data, nodes_data) {

# set up the graph data frame properly
  links_graph <- graph.data.frame(links) 
  V(links_graph)$name <- 1:57
  links <- as.data.frame(get.edgelist(links_graph))
  links$V1<-as.numeric(as.character(links$V1))
  links$V2<-as.numeric(as.character(links$V2))
  colnames(links)<-c("source","target")  
  link_list<-(links-1)
  
# make basic diagram 
  forceNetwork(Links = link_list, Nodes = nodes, Source = "source",
               Target = "target", NodeID = "id",
               Group = "group", opacity = .8, legend = TRUE, zoom = TRUE)
}



