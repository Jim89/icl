
library(readr)
library(dplyr)
library(forecast)
library(tseries)

# Read the data
sales <- scan("../data/fancy.dat")

# Look at the time-series
salests <- ts(sales, frequency=12, start=c(1987,1))
plot.ts(salests)
# Looks like will need to remove trend, de-seasonalise and get a constant variance
# (var appears to be in increasing over time)

# transform in to ts with constanct variance - take the log!
sales_log <- log(salests)
plot.ts(sales_log)

# perform differencing to de-seasonalise
sales_diff1 <- diff(sales_log, 
                    differences=1, # one difference
                    lag=12) # monthly
plot.ts(sales_diff1)

# check if stationary
adf.test(sales_diff1) # null is that ts is non-stationary - here we fail to reject
kpss.test(sales_diff1) # null is that ts is non-stationary - here we only have weak evidence to reject
pp.test(sales_diff1) # null is that x has unit root (non-stationary) - this results says it is stationary

# Formal tests give slightly different answers - so use some subjectivity - look at the ts

# take the 2nd difference
sales_diff2 <- diff(sales_diff1, differences=1)
plot.ts(sales_diff2) # looks more stationary (no obvious trend)


# Tells us how many differences we need to make ts stationary, based on a signif and test
forecast::ndiffs(sales_diff1, # ts object
                 alpha=0.05, # significance level of test
                 test="kpss", # which test to use
                 max.d=2) # max differences willing to apply

# how many seasonal differences to apply to get stationary ts
forecast::nsdiffs(sales_diff2, 
                  m=12,  # length of seasonal period
                  test="ocsb", # test to use
                  max.D=1) # max. number of seasonal differences allowed

# Determine p and q
acf(sales_diff2, lag.max=40) # plot ACF for this data after transformation
# With lag of 1, ACF is close to -0.5 - this indicates potential over-differencing
# larger values in ACF indicate seasonality
# This shows that order of moving average (q) should be \leq than 1 (otherwise the longer lag ACF values would be significant)

pacf(sales_diff2, lag.max=40) # plot PACF for this data after transformation
# Only the PACF with lag of 1 is significant - this tells us that order of auto-regressive (p) should be \leq 1

# Therefore can have the following models
# ARMA (1, 1)
# ARMA (0, 1)
# ARMA (1, 0)
# Don't know which one for certain

model1 <- forecast::auto.arima(sales_log, 
                               d=1, # order of first-differencing
                               D=1, # order of seasonal differencing
                               trace=TRUE, # print steps
                               ic='aicc') # which method to use for model selection

# forecast
model1_f <- forecast::forecast.Arima(model1, h=12)
plot.forecast(model1_f)
lines(fitted(model1), col="red")

# verification
plot.ts(model1$residuals) # residuals have mean approx 0 and roughly contsant variance
acf(model1$residuals, lag.max=40) # no ACF (other than 0) lies outside of 1.96/sqrt(n)
Box.test(model1$residuals, lag=40, type="Ljung-Box") # Null is that variable is independent over time - don't have evidence to reject - therefore no serial/auto-correlation in residuals

# Can also let algo choose the values for differencing
model2 <- auto.arima(sales_log, trace = T, ic = "aicc")
model2_f <- forecast.Arima(model2, h = 12)
plot.forecast(model2_f)
lines(fitted(model2), col = "red")


# Perform the same analysis on shampoo data
shampoo <- read_csv("./data/shampoo.csv")

# Make ts
shamp_ts <- ts(shampoo[, 2], frequency = 12, start = c(2001, 01))
plot.ts(shamp_ts)

# Take log to transform to constant variance
shamp_ts_l <- log(shamp_ts)
plot.ts(shamp_ts_l)

# No obvious seasonality in the data so just check if stationary
# check if stationary
adf.test(shamp_ts) # null is that ts is non-stationary - here we fail to reject
kpss.test(shamp_ts) # null is that ts is non-stationary - here we have evidence to reject
pp.test(shamp_ts) # null is that x has unit root (non-stationary) - this results says it is stationary

# ADF test says non-stationary and series doesn't look stationary, therefore let's find differences
ndiffs(shamp_ts, # ts object
                 alpha=0.05, # significance level of test
                 test="adf", # which test to use
                 max.d=2) # max differences willing to apply
# Says we need 1 difference

# how many seasonal differences to apply to get stationary ts
nsdiffs(shamp_ts, 
                  m=12,  # length of seasonal period
                  test="ocsb", # test to use
                  max.D=1) # max. number of seasonal differences allowed
# Says 0 differences

# Difference the ts
# perform differencing to de-seasonalise
shamp_diffed <- diff(shamp_ts,
                    differences=1) # monthly
plot.ts(shamp_diffed)

# Determine p and q
acf(shamp_diffed, lag.max=40) # plot ACF for this data after transformation
# With lag of 1, ACF is close to -0.5 - this indicates potential over-differencing
# larger values in ACF indicate seasonality
# This shows that order of moving average (q) should be \leq than 2 (otherwise the longer lag ACF values would be significant)

pacf(shamp_diffed, lag.max=40) # plot PACF for this data after transformation
# Only the PACF with lag of 1 is significant - this tells us that order of auto-regressive (p) should be \leq 1

# See what the auto-method comes up with
s_mod_1 <- auto.arima(shamp_diffed, trace = T, ic = "aicc")

s_mod_1_f <- forecast(s_mod_1, h = 12)
plot(s_mod_1_f)
lines(fitted(s_mod_1_f), col = "red")
