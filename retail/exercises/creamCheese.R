# Step 0 - load packages -------------------------------------------------------
library(readr)
library(dplyr)
library(broom)


# Step 1 - load data -----------------------------------------------------------
data <- read_csv("./data/CreamCheeseDataCSV.csv")

# Step 2 - fit models and set up stepwise regression ---------------------------
fit_pl <- lm(sales_pl ~ ., data = data)
fit_philly <- lm(sales_philly ~ ., data = data)

model_pl <- step(fit_pl, direction = "both")
model_philly <- step(fit_philly, direction = "both")

# Step 3 - Set up variales for applying elasticity formulae --------------------
q_pl <- mean(data$sales_pl)
p_pl <- mean(data$price_pl)

q_philly <- mean(data$sales_philly)
p_philly <- mean(data$price_philly)

own_pl <- p_pl/q_pl
own_philly <- p_philly/q_philly

cross_pl <- p_philly/q_pl
cross_philly <- p_pl/q_philly

# Step 4 - Get model coefficients and transform to elasticities ----------------
coef_pl <- tidy(model_pl)
coef_philly <- tidy(model_philly)

pl_pl <- (coef_pl %>% filter(term == "price_pl") %>% select(estimate) %>% as.numeric())*own_pl
pl_philly <- (coef_pl %>% filter(term == "price_philly") %>% select(estimate) %>% as.numeric())*cross_pl

philly_philly <- (coef_philly %>% filter(term == "price_philly") %>% select(estimate) %>% as.numeric())*own_philly
philly_pl <- (coef_philly %>% filter(term == "price_pl") %>% select(estimate) %>% as.numeric())*cross_philly


# Step 5 - Generate elasticity matrix ------------------------------------------
elast <- matrix(c(pl_pl, pl_philly, philly_pl, philly_philly), 
                nrow = 2, ncol = 2, byrow = TRUE)
colnames(elast) <- c("pl", "philly")
rownames(elast) <- c("pl", "philly")

elast_clean <- elast
diag(elast_clean) <- 0
clouts <- colSums(elast_clean)
vuneralibility <- rowSums(elast_clean)
