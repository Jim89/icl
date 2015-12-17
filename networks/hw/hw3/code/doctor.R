library(readr)

doctor <- read_tsv("./hw/hw3/data/doctor.txt")
names(doctor) <- tolower(names(doctor))
doctor1 <- head(doctor, 4)

T79 <- doctor1$week
Tdelt <- (1:100)/10
Sales <- doctor1$revenues
Cusales <- cumsum(Sales)
Bass.nls <- nls(formula = Sales ~ M * (((P + Q)^2/P) * exp(-(P + Q) * T79))/(1 + (Q/P) * exp(-(P + Q) * T79))^2,
                start = list(M = 5, P = 0.03, Q = 0.38))
summary(Bass.nls)



# get coefficient
Bcoef <- coef(Bass.nls)
m <- Bcoef[1]
p <- Bcoef[2]
q <- Bcoef[3]
# setting the starting value for M to the recorded total sales.
ngete <- exp(-(p + q) * Tdelt)

# plot pdf
Bpdf <- m * ((p + q)^2/p) * ngete/(1 + (q/p) * ngete)^2
Bcdf <- m * (1 - ngete)/(1 + (q/p) * ngete)

qplot(x = Tdelt, y = Bpdf) + geom_line()
qplot(x = Tdelt, y = Bcdf) + geom_line() + geom_point(data = doctor, aes(x = week, y = cumulative_revenues))

# this will work - need to check function, though!
library(minpack.lm)
fit <- nlsLM(formula = revenues ~ M * (((P + Q)^2/P) * exp(-(P + Q) * T79))/(1 + (Q/P) * exp(-(P + Q) * T79))^2,
      data = doctor1,
      start = list(M = 1, P = 1, Q = 1))

Bcoef <- coef(fit)
m <- Bcoef[1]
p <- Bcoef[2]
q <- Bcoef[3]      


# setting the starting value for M to the recorded total sales.
ngete <- exp(-(p + q) * Tdelt)

# plot pdf
Bpdf <- m * ((p + q)^2/p) * ngete/(1 + (q/p) * ngete)^2
Bcdf <- m * (1 - ngete)/(1 + (q/p) * ngete)

qplot(x = Tdelt, y = Bpdf) + geom_line()
qplot(x = Tdelt, y = Bcdf) + geom_line() + geom_point(data = doctor, aes(x = week, y = cumulative_revenues))