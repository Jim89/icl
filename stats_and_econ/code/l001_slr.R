# load data --------------------------------------------------------------------
  load("./data/wage1.RData")

# look at description of data provided with the RData file ---------------------
  desc

# fitting a linear model
fit <- lm(wage ~ educ, data = data)

summary(fit)
