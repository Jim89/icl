library(readr)
library(dplyr)
library(ggplot2)

data <- read_csv("./data/HW2_data_degree_dist.csv") %>% 
        select(node, degree) %>% 
        group_by(degree) %>% 
        tally() %>% 
        rename(nodes = n) %>% 
        mutate(l_degree = log2(degree),
               l_nodes = log2(nodes))

ggplot(data, aes(x = l_degree, y = l_nodes))+
        geom_point(colour = "firebrick") +
        xlab(expression(paste("Node Degree", "(Log"[2],")"))) +
        ylab(expression(paste("Number of Nodes", "(Log"[2],")"))) +
        ggtitle("Log-log plot of degree distribution") +
        theme_minimal()
        
fit <- lm(l_nodes~ l_degree, data = data)        