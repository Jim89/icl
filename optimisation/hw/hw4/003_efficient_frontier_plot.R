# load necessary packages
ggplot(results, aes(x = variance, y = returns)) + 
    geom_point(alpha = .35, color = "steelblue") +
    ggtitle("Efficient Frontier") +
    labs(x="Portfolio Risk", y = "Portfoli Return") +
    theme(panel.background=element_rect(fill=eallighttan),
          text=element_text(color = "black"),
          plot.title=element_text(size=24, color="black"))