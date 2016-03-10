library(dplyr)
library(readr)
library(ggplot2)

cars <- read.table("./data/CarExercise1_CodedDataTab.txt") %>% as_data_frame()

cars %<>% mutate(profit = vehicle_price - vehicle_cost)

qplot(cars$profit, fill = I("steelblue"), colour = I("white"))


fit_null <- lm(vehicle_price ~ 1, data = cars)
fit_full <- lm(vehicle_price ~ 1 + as.factor(cylinders) + as.factor(doors) + as.factor(transmission) + as.factor(trim), data = cars)

model <- step(fit_null, scope = list(upper = fit_full), data = car)

levels <- read.table("./data/LevelsAppTab.txt")
ratings <- read.table("./data/RatingsAppTab.txt")

