library(readr)
library(dplyr)
library(mlogit)


data <- read.table("./data/ButterDataTab.txt") %>% 
        as_data_frame()
