library(readr)
library(dplyr)
library(ggplot2)

bmw <- read_csv("./data/Italy_BMW5Series.csv")

colnames(bmw) <- gsub(" ", "_", colnames(bmw))

# A couple of exploratory plots
qplot(x = trend, y = budget_eur_net, data = bmw, geom = c("line", "point"))
qplot(x = trend, y = registrations, data = bmw, geom = c("line", "point", "smooth"))

# create time series
y <- ts(bmw$registrations, frequency = 12)

# plot Seasonal, Trend and irreguLar (i.e. the remainder) form of the data
plot(stl(y, 'periodic'))


# create time series
z <- ts(bmw$budget_eur_net, frequency = 12)

# plot Seasonal, Trend and irreguLar (i.e. the remainder) form of the data
plot(stl(z, 'periodic'))
