
# Step 0 - prep env -------------------------------------------------------
library(readr)
library(dplyr)
library(ggplot2)


# Step 1 - read and clean data --------------------------------------------
bmw <- read_csv("./data/Italy_BMW5Series.csv")

# Set column names
colnames(bmw) <- gsub(" ", "_", colnames(bmw))

data.final <- bmw %>% 
              mutate(budget_eur_net_log = log(budget_eur_net),
                     budget_eur_net_sqr = budget_eur_net^2,
                     buget_eur_net_lag = lag(budget_eur_net, 1)) %>% 
              slice(-1)

# A couple of exploratory plots for seasonality effects
qplot(x = trend, y = budget_eur_net, data = bmw, geom = c("line", "point", "smooth"))
qplot(x = trend, y = registrations, data = bmw, geom = c("line", "point", "smooth"))

# create time series for registrations and ad spend
y <- ts(bmw$registrations, frequency = 12)
z <- ts(bmw$budget_eur_net, frequency = 12)

# plot Seasonal, Trend and irreguLar (i.e. the remainder) form of the data
plot(stl(y, 'periodic'))
plot(stl(z, 'periodic'))


# Step 2 - model selection ------------------------------------------------
# Linear model - test for addition of lag and month dummies
fit_linear <- lm(registrations ~ budget_eur_net, data = data.final)
fit_lag <- lm(registrations ~ budget_eur_net + buget_eur_net_lag, data = data.final)
fit_month_dummy <- lm(registrations ~ budget_eur_net+ buget_eur_net_lag + as.factor(month), data = data.final)

# Find best model - i.e. does adding each new feature improve model?
summary(fit_linear)
summary(fit_lag)
summary(fit_month_dummy) # This model is best, i.e. choose both lag and month dummy

# Find best functional form
fit_month_dummy <- lm(registrations ~ lag_registrations + budget_eur_net + buget_eur_net_lag + as.factor(month), data = data.final)
fit_month_dummy_log <- lm(registrations ~ lag_registrations + budget_eur_net_log + buget_eur_net_lag + as.factor(month), data = data.final)
fit_month_dummy_quad <- lm(registrations ~ lag_registrations + budget_eur_net + budget_eur_net_sqr + as.factor(month), data = data.final)

# Test to find which functional form is best
fit_month_dummy %>% summary
fit_month_dummy_log %>% summary
fit_month_dummy_quad %>% summary


qplot(x = data.final$budget_eur_net, y = fit_month_dummy_quad$fitted.values,
      geom = c("point", "line", "smooth"), data = data.final)

qplot(x = data.final$budget_eur_net, fill = I("steelblue"), colour = I("white"))


# Step 3 - find marginal effects (elasticities) ---------------------------


