# plot efficient frontier
ggplot(sims, aes(x = variance, y = returns)) +
    geom_point() +
    xlab("Risk") +
    ylab("Return")