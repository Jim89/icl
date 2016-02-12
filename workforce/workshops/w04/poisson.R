library(readr)
library(dplyr)
library(glmmML)

d3 <- read_csv("./data/D3_patents_to_eth.csv")

fit <- glm(performance ~ eth_div + eth_div_2 + cntry_div + cntry_div_2 + team_size,
          data = d3,
          family = "poisson")

fit2 <- glmmboot(performance ~ eth_div + eth_div_2 + cntry_div + cntry_div_2 + team_size + year,
                 data = d3,
                 family = "poisson",
                 cluster = firm)