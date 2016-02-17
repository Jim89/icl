# Step 0 - load packages -------------------------------------------------------
library(readr)
library(dplyr)
library(magrittr)
library(logistf)

# Step 1 - load and clean data -------------------------------------------------
# load
q1b <- read_csv("./data/outputs/q1b.csv")

# transform certain columns
q1b$moved_to %<>% as.logical()
q1b$n_comp %<>% as.numeric()

# Step 1 - fit models ----------------------------------------------------------
# Standard logit
fit <- glm(moved_to ~ ., data = q1b %>% select(-firm, -inv), family = "binomial")

# Firth logit (penalised likelihood)
fit_f <- logistf(moved_to ~ ., data = q1b %>% select(-firm, -inv))


