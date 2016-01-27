library(readxl)
library(ggplot2)
library(GGally)
data <- read_excel("l01_class_exercise.xlsx", sheet = "Tennis")
names(data) <- make.names(names(data))

data_cln <- data[, 3:8]

means <- apply(data[, 3:8], 2, mean)
stds <- apply(data[, 3:8], 2, sd)
ranges <- apply(data_cln, 2, range)


cors <- cor(data_cln)
covs <- cov(data_cln)

ggpairs(data_cln)
