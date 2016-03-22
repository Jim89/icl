# Step 0 - prep env -------------------------------------------------------
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

data <- read_csv("./group_project/data/group_exercise_data.csv")
colnames(data) <- make.names(colnames(data))     


# Create exploratory plots ------------------------------------------------
field_plot <- function(field) {
  ggplot(data, aes_string(x = "Day", y = field)) +
    geom_line(colour = "grey") +
    geom_smooth() +
    theme(legend.position = "bottom",
          axis.text.y = element_text(size = 16, colour = "black"),
          axis.text.x = element_text(size = 16, colour = "black"),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 16),
          title = element_text(size = 16),
          strip.text = element_text(size = 16, colour = "black"),
          strip.background = element_rect(fill = "white"),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
          panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
          panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
          panel.margin.y = unit(0.1, units = "in"),
          panel.background = element_rect(fill = "white", colour = "lightgrey"),
          panel.border = element_rect(colour = "black", fill = NA))
}

field_plot("Number.of.Blood.Tests") + ylab("Blood tests")
field_plot("X..Women") + ylab("Women tested (%)")
field_plot("X..Children") + ylab("Children tested (%)")
field_plot("X..Covered.by.insurance") + ylab("Insurance covered (%)")

# Fit model ---------------------------------------------------------------
fit <- glm(Number.of.Blood.Tests ~ ., data = data, family = "poisson")
fit <- step(fit)
predicted <- predict(fit)

# Estimate model error
mad <- mean(abs(data$Number.of.Blood.Tests - predicted))
mse <- mean((data$Number.of.Blood.Tests - predicted)^2)


# Create new data ---------------------------------------------------------
means <- colMeans(data)
new <- data_frame(Day = c(1000, 1010),
                  Number.of.Blood.Tests = rep(means[2], 2),
                  X..Women = rep(means[3], 2),
                  X..Children = rep(means[4], 2),
                  X..Covered.by.insurance = rep(means[5], 2))

# Predict new points ------------------------------------------------------
predictions <- predict(fit, newdata = new)


