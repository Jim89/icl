# Step 0 - prep env -------------------------------------------------------
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

data <- read_csv("./group_project/data/group_exercise_data.csv")
colnames(data) <- make.names(colnames(data))        


time_plot <- function(datafield) {
  vals <- datafield
  time <- ts(vals, frequency = 365)
  plot(stl(time, "periodic"))
}

time_plot(data$Number.of.Blood.Tests)
time_plot(data$X..Women)
time_plot(data$X..Children)
time_plot(data$X..Covered.by.insurance)


# Fit model ---------------------------------------------------------------

fit <- lm(Number.of.Blood.Tests ~ Day, data = data)
mad <- mean(abs(data$Number.of.Blood.Tests - predicted))
mse <- mean((data$Number.of.Blood.Tests - predicted)^2)

prediction1 <- fit$coefficients[1] + fit$coefficients[2]*1000
prediction2 <- fit$coefficients[1] + fit$coefficients[2]*1010



