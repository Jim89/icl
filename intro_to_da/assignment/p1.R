
# load packages ----------------------------------------------------------------
  library(MASS)
  library(lsa)
  library(igraph)
  library(readxl)
  library(dplyr)
  library(magrittr)
  library(tidyr)
  

# read in the data and set up variables ----------------------------------------
# read in the data
  groups                <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Overview") %>% .[1:12, 1:2]
  people                <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Attributes")
  albert_hall_links     <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3780")
  workshop_links        <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3782")
  weekly_meeting_links  <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3781")
  urgent_meeting_links  <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3779")

# clean up crap excel imports
  albert_hall_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
  workshop_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
  weekly_meeting_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
  urgent_meeting_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()

# define key variables
  back_bone <- 1:57
  dat <- list(albert_hall_links, 
              workshop_links, 
              weekly_meeting_links, 
              urgent_meeting_links)


# data wrangling and extraction ------------------------------------------------
# extract in degree centrality
  get_indegrees <- function (data) {
    graph <- graph.data.frame(data, directed = TRUE)
    indegrees <- degree(graph, v = V(graph), mode = "in", loops = FALSE)
    return(indegrees)
  }
  indegrees <- lapply(seq_along(dat), function(x) get_indegrees(dat[x]))

# extract in centrality in node order (1:57) for easier comparisons
  extract_in_order <- function (degrees_obj) {
   sapply(seq_along(back_bone), function(x) degrees_obj[as.character(x)]) 
  }
  ordered_degrees <- sapply(seq_along(indegrees), function(x) 
                          extract_in_order(indegrees[[x]]))

# clean up data in to tidy data frame
  ordered_degrees %<>% data.frame %>% 
                        setNames(c("popularity", 
                                   "design", 
                                   "implementation", 
                                   "advocacy"))
  ordered_degrees[is.na(ordered_degrees)] <- 0

# exploratory plots  
  gather(ordered_degrees) %>% 
    ggplot(aes(x = value)) +
    geom_histogram(aes(fill = key), colour = "white", binwidth = 1) +
    facet_grid(key ~ .) +
    xlab("In-Degree node centrality") +
    ylab("Count") +
    theme(legend.position = "bottom")
  
# means & variances
  means <- apply(ordered_degrees, 2, mean)
  variances <- apply(ordered_degrees, 2, var)
  diff <- variances > means
  diffs <- variances / means # variances much higher - therefore use negative binomial regression
  
# create models ----------------------------------------------------------------
# OLS linear models
  fit_pop_to_des <- lm(design ~ popularity, ordered_degrees)  
  fit_pop_to_imp <- lm(implementation ~ popularity, ordered_degrees)  
  fit_pop_to_adv <- lm(advocacy ~ popularity, ordered_degrees)

# negative binomial models
  fit_pop_to_des_nb <- glm.nb(design ~ popularity, ordered_degrees)
  fit_pop_to_imp_nb <- glm.nb(implementation ~ popularity, ordered_degrees)  
  fit_pop_to_adv_nb <- glm.nb(advocacy ~ popularity, ordered_degrees)

# develop response to q2 -------------------------------------------------------
  picks <- data_frame(id = rep(1:57, each = 57), pick = rep(1:57, 57)) %>% 
            left_join(albert_hall_links, by = c("id" = "rater_id", 
                                                "pick" = "rated_id")) %>% 
            rename(popularity = rating) %>% 
            left_join(workshop_links, by = c("id" = "rater_id", 
                                             "pick" = "rated_id")) %>% 
            rename(design = rating) %>%
            left_join(weekly_meeting_links, by = c("id" = "rater_id", 
                                             "pick" = "rated_id")) %>% 
            rename(implementation = rating) %>%
            left_join(urgent_meeting_links, by = c("id" = "rater_id", 
                                             "pick" = "rated_id")) %>% 
            rename(advocacy = rating)
  
  picks[is.na(picks)] <- 0
  
# extract responses
  get_similarities <- function (data, id) {
      data %>% 
          filter(id == id) %>% 
          select(-c(1, 2)) %>% 
          as.matrix() %>% 
          cosine
  }
  
  similarities <- lapply(seq_along(1:max(picks$id)), 
                         function(x) get_similarities(picks, x))
  
  
  
  
      
      
  
 
  
  

  
  