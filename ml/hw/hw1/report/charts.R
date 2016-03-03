library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

input <- read_csv("./hw/hw1/data/created/input.csv", col_names = FALSE)
knn <- read_csv("./hw/hw1/data/created/knn_loss.csv") %>% mutate(k = row_number())

knn_long <- knn %>% gather(key = "distance", value = "loss", -k)


knn_long %>% 
  ggplot(aes(x = k, y = loss, colour = distance)) + 
  geom_line(aes(colour = distance), size = 1) +
  theme_minimal() +
  theme(legend.position = "bottom")


knn_long %>% 
  ggplot(aes(x = distance, y = loss))+
  geom_boxplot()

range_single <- function(x){range(x)[2] - range(x)[1]}
apply(input, 2, range_single)
