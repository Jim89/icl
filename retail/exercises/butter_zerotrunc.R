library(dplyr)
library(magrittr)
library(countreg)

data <- read.table("./data/ButterDataTab.txt") 

data.pois <- read.table("./data/ButterDataTab.txt") %>% 
        as_data_frame() %>% 
        filter(choice == 1)

# Add average price 
data.pois %<>% mutate(avgp = (aggregate(data$price, by = list(data$transaction), FUN = mean))[,2])


fit <- zerotrunc(units ~ price + factor(brand) + factor(store) + size + mwork + fwork + spend, data = data.pois)

predict0 <- fit$fitted # get predictions

data.sim <- data.pois # set up test data

data.sim$price <- data.pois$price*1.1 # new frame with 10% change in price

predict1 <- predict(fit, newdata = data.sim) # simulate new quantities using model object

elast <- mean((predict1 - predict0) / predict0) / .1 # calculate average % change in quantity to get elasticity


data.pois %<>% group_by(id) %>% mutate(lag_purchase = lag(brand_choice)) %>% ungroup()

data.pois %<>% slide("brand_choice", "transaction", "id", "lag_purchase1")

data.pois.comple <- data.pois[complete.cases(data.pois), ]

# Create switching matrix
table(data.pois$brand_choice, data.pois$lag_purchase) %>% as.matrix()

# Switching matrix in long form
data.pois %>% 
  group_by(brand_choice, lag_purchase) %>% 
  tally()

