library(readr)

doctor <- read_tsv("./hw/hw3/data/doctor.txt")
names(doctor) <- tolower(names(doctor))


T79 <- doctor$week
Tdelt <- (1:100)/10
Sales <- doctor$revenues
Cusales <- cumsum(Sales)
Bass.nls <- nls(Sales ~ M * (((P + Q)^2/P) * exp(-(P + Q) * T79))/(1 + (Q/P) * 
                                                                       exp(-(P + Q) * T79))^2, start = list(M = 60630, P = 0.03, Q = 0.38))
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
