# load data --------------------------------------------------------------------
  load("./data/wage1.RData")

# look at description of data provided with the RData file ---------------------
  desc
  summary(data)
  str(data)

# fitting a linear model -------------------------------------------------------
  fit <- lm(wage ~ educ, data = data) 

# look at the output of the model 
  summary(fit)

  