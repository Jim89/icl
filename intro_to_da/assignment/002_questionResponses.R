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


# q1 ---------------------------------------------------------------------------
# helper functions
  # extract in degree centrality
  get_indegrees <- function (data) {
    graph <- graph.data.frame(data, directed = TRUE)
    indegrees <- degree(graph, v = V(graph), mode = "in", loops = FALSE)
    return(indegrees)
  }

# convert network stat to data frame
  convert_stat_to_df <- function(stat){
    stat %>% 
      data.frame() %>%
      add_rownames() %>% 
      setNames(c("id", "stat")) %>% 
      apply(2, as.numeric) %>% data.frame %>% tbl_df
  }   
  
  # get properties
  indegrees   <- lapply(seq_along(dat), function(x) get_indegrees(dat[x]))

# extract in centrality in node order (1:57) for easier comparisons
  extract_in_order <- function (degrees_obj) {
   sapply(seq_along(back_bone), function(x) degrees_obj[as.character(x)]) 
  }
  ordered_degrees <- sapply(seq_along(indegrees), function(x) 
                          extract_in_order(indegrees[[x]]))

# clean up data in to tidy data frame
  ordered_degrees %<>% data.frame %>% 
                        tbl_df() %>% 
                        add_rownames() %>% 
                        setNames(c("id",
                                   "popularity", 
                                   "design", 
                                   "implementation", 
                                   "advocacy"))
  ordered_degrees[is.na(ordered_degrees)] <- 0

# exploratory plots  
plot <- gather(ordered_degrees[, -1]) %>% 
        ggplot(aes(x = value)) +
        geom_histogram(aes(fill = key), colour = "white", binwidth = 1) +
        facet_grid(key ~ .) +
        xlab("In-Degree node centrality") +
        ylab("Count") +
        theme(legend.position = "bottom")
  
# means & variances
  means <- apply(ordered_degrees[, -1], 2, mean)
  variances <- apply(ordered_degrees[, -1], 2, var)
  diff <- variances > means
  diffs <- variances / means # variances much higher - therefore use negative binomial regression
  
# create models 
# OLS linear models
  fit_pop_to_des <- lm(design ~ popularity, ordered_degrees)  
  fit_pop_to_imp <- lm(implementation ~ popularity, ordered_degrees)  
  fit_pop_to_adv <- lm(advocacy ~ popularity, ordered_degrees)

# negative binomial models
  fit_pop_to_des_nb <- glm.nb(design ~ popularity, ordered_degrees)
  fit_pop_to_imp_nb <- glm.nb(implementation ~ popularity, ordered_degrees)  
  fit_pop_to_adv_nb <- glm.nb(advocacy ~ popularity, ordered_degrees)
  
  
# develop response to q2 -------------------------------------------------------
# set up picks data frame  
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
  
# split picks by ID  
#  picks_split <- split(data.frame(picks), as.factor(id))
  
# function to get cosine similarity for an id
  get_similarities <- function (data, node) {
      data %>% 
          filter(id == node) %>%
          select(-c(1, 2)) %>% 
          as.matrix() %>% 
          cosine
  }
  
# apply for all ids (returns list of lists)
  similarities <- lapply(seq_along(1:max(picks$id)), 
                         function(x) get_similarities(picks, x))
  
# define function to convert cosine list to matrix for use
  get_cosines <- function (cosine_obj) {
    temp <- cosine_obj %>% 
            unlist %>% 
            matrix(nrow = 4, ncol = 4)
    idx <- lower.tri(temp)
    values <- temp[idx]
    return(values)
  }
  
# get the cosine values
  cosine_values <- lapply(seq_along(similarities), 
                          function(x) get_cosines(similarities[x]))
  
# aggregate and simplify to give flexiblity score (median cosine value)
  flex_score <- sapply(seq_along(cosine_values), 
                       function(x) median(cosine_values[[x]])) %>% 
                data.frame() %>%
                add_rownames() %>% 
                setNames(c("id", "flex")) %>% 
                tbl_df() %>% 
                mutate(z = (flex - mean(flex, na.rm = TRUE))/sd(flex, na.rm = TRUE)) %>% 
                arrange(flex) %>% 
                apply(2, as.numeric) %>% 
                data.frame %>% tbl_df
  
# develop response to q3 -------------------------------------------------------
  # use excel of picks to select most flexible leader in each team
  # add other info to flex score table
  flex_score %<>% left_join(base, by = "id") # may want to add other criteria - to discuss
  
# develop response to q4 -------------------------------------------------------
# use dev/imp/adv score as "benefit" for each network and cost = vp's

  
