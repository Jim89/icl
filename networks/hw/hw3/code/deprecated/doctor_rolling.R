# set up and load packages -----------------------------------------------------
# clear out working directory
rm(list = ls())

# load packages   
library(readr)        # for reading data
library(dplyr)        # for data manipulations
library(magrittr)     # for pipelines
library(minpack.lm)   # for fitting Bass model
library(ggplot2)      # for plotting
library(tidyr)        # for reshaping

# get the data------------------------------------------------------------------
# read in data and set names to lower case
doctor <- read_tsv("./hw/hw3/data/doctor.txt")
names(doctor) <- tolower(names(doctor))

# add lagged cumulative sales which we'll need for the formula
doctor %<>% mutate(cs_lag = lag(cumulative_revenues))
doctor[is.na(doctor)] <- 0

# try to fit rolling model -----------------------------------------------------
# lists for parameters
m_list <- list()
p_list <- list()
q_list <- list()

# loop over 4 week periods and re-fit model
for (i in 1:(nrow(doctor)-3)) {
  j <- i+3
  dat <- doctor %>% slice(i:j) %>% mutate(cs_lag = lag(cumulative_revenues))
  dat[is.na(dat)] <- 0
  fit <- nlsLM(formula = revenues ~ (p + q * (cs_lag/m))*(m - cs_lag),
               data = dat,
               start = list(m = 1, p = 1, q = 1))  
  m_list[i] <- coef(fit)[1]
  p_list[i] <- coef(fit)[2]
  q_list[i] <- coef(fit)[3]
  print(c(m, p , q))
}  

# estimate over data
# create empty fields
results <- doctor %>% select(1, 2)
results$pred1 <- 0
results$pred2 <- 0
results$pred3 <- 0
results$pred4 <- 0
results$pred5 <- 0
results$pred6 <- 0
results$pred7 <- 0
results$pred8 <- 0
results$pred9 <- 0


for (i in 1:nrow(doctor4)) {
  if (i == 1) {
    prev_pred <- 0
    doctor4[i, "Prediction"] <- pred(prev_pred, m, p, q)
  } else {
    prev_pred <- as.numeric(unlist(cumsum(doctor4[1:i, "Prediction"])))[i-1]
    doctor4[i, "Prediction"] <- pred(prev_pred, m, p, q)
  }
}   