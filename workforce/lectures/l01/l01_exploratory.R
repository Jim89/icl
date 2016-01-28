library(readxl)
library(ggplot2)
library(GGally)
tennis <- read_excel("l01_class_exercise.xlsx", sheet = "Tennis")
names(tennis) <- make.names(names(tennis))

tennis_cln <- tennis[, 3:8]

means <- apply(tennis[, 3:8], 2, mean, na.rm = T)
stds <- apply(tennis[, 3:8], 2, sd, na.rm = T)
ranges <- apply(tennis_cln, 2, range, na.rm = T)


cors <- cor(tennis_cln)
covs <- cov(tennis_cln)

ggpairs(tennis_cln) 

football <- read_excel("l01_class_exercise.xlsx", sheet = "Football")
names(football) <- make.names(names(football))
ggpairs(football)
