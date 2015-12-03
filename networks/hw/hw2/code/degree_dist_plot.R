library(readr)
library(dplyr)
library(ggplot2)

data <- read_csv("./data/HW2_data_degree_dist.csv") %>% 
        select(node, degree) %>% 
        mutate(log_dist = log2(dist))

plot <- qplot(x = -log_dist, y = log_dist, data = data)