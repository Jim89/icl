# Step 0 - load packages -------------------------------------------------------
library(readr)
library(dplyr)
library(magrittr)
library(glmmML)

# Step 1 - load and clean data -------------------------------------------------
# load
q1a <- read_csv("./data/outputs/q1a.csv")

q1a %<>%
  mutate(cross_cntry = as.factor(cross_cntry))

q1a <- q1a[, -1]


# Step 2 - fit models ----------------------------------------------------------
fit <- glm(performance ~ eth_div + eth_div_2 + cntry_div + cntry_div_2 + team_size + cross_cntry + collab1,
           data = q1a,
           family = "poisson")

fit2 <- glmmboot(performance ~ eth_div + eth_div_2 + cntry_div + cntry_div_2 + team_size + factor(year) + cross_cntry + collab1,
                 data = q1a,
                 family = "poisson",
                 cluster = factor(firm))