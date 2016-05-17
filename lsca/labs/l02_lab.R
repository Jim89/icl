library(readr)
library(dplyr)
library(ggplot2)
library(forecast)


shampoo <- read_csv("./data/shampoo.csv") %>% setNames(c("month", "sales"))
fancy <- read_delim("./data/fancy.dat", delim = "", col_names = F)


shampoo %>% 
  ggplot(aes(x = month, y = sales, group = 1)) +
  geom_line() +
  geom_smooth() +
  theme(axis.text.x = element_text(angle = 45, size = 8))

shampoo_ts <- ts(shampoo[,2], frequency = 12, start = c(2000, 1))
plot.ts(shampoo_ts)

# Fit HW model
shampoo_hw1 <- HoltWinters(shampoo_ts, gamma = F)
plot(shampoo_hw1)


# Fit ets
s_ets <- ets(shampoo_ts, model = "ZZZ") # let the algo choose the model type (ZZZ)
plot(s_ets)


plot(shampoo_hw1)
lines(s_ets$fitted, col = "green")

# Calculate errors
sqrt(shampoo_hw1$SSE / length(shampoo_ts))

accuracy(s_ets)


# Fancy data --------------------------------------------------------------

f_ts <- fancy %>% na.omit() %>% setNames("sales") %>% 
  ts(frequency = 12, start = c(1987, 1))

plot(f_ts)

f_ets <- ets(f_ts, "ZZZ")
f_hw <- HoltWinters(f_ts, alpha = T, beta = T, gamma = T,
                    seasonal = "multiplicative", 
                    start.periods = 6,
                    l.start = f_ets$par["l"],
                    b.start = f_ets$par["b"],
                    optim.start = c(alpha = f_ets$par["alpha"],
                                    beta = f_ets$par["beta"],
                                    gamma = f_ets$par["gamma"]))


# Measure the accuracy
acc_hw <- sqrt(f_hw$SSE / length(f_ts))
acc_ets <- accuracy(f_ets)

# Do some forecasting
forecast_hw <- forecast.HoltWinters(f_hw, h = 12)
forecast_ets <- forecast.ets(f_ets, h = 12)

plot(forecast_hw)
plot(forecast_ets)


# Residual analysis
plot.ts(forecast_hw$residuals)
lines(fitted(forecast_hw), col = "steelblue")
lines(forecast_hw$mean, col = "firebrick")


plot.ts(forecast_ets$residuals)

# ACF plots
acf(forecast_hw$residuals, lag.max = 50)
acf(forecast_ets$residuals, lag.max = 50)

# Bos tests
Box.test(forecast_hw$residuals, lag = 20, type = "Ljung-Box")
Box.test(forecast_ets$residuals, lag = 20, type = "Ljung-Box")
