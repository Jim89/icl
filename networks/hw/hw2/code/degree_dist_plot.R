library(readr)
library(dplyr)
library(ggplot2)

data <- read_csv("./data/HW2_data_degree_dist.csv") %>% 
        select(node, degree) %>% 
        group_by(degree) %>% 
        tally() %>% 
        rename(nodes = n) %>% 
        mutate(l_degree = log(degree),
               l_nodes = log(nodes))

ggplot(data, aes(x = l_degree, y = l_nodes))+
        geom_point(colour = "firebrick") +
        xlab(expression(paste("Node Degree", "(Log"["e"],")"))) +
        ylab(expression(paste("Number of Nodes", "(Log"["e"],")"))) +
        ggtitle("Log-log plot of degree distribution") +
        theme_minimal()
        
fit <- lm(l_nodes~ l_degree, data = data)
exponent <- fit$coefficients[2]
a <- exp(fit$coefficients[1])