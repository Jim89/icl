# load packages and source pre-requisite data ----------------------------------
library(ggplot2)
library(tidyr)

if ( !("results" %in% ls()) ) {
    source("hw/hw4/002_calc_returns.R")
}

# grab 3 portfolios ------------------------------------------------------------
low <- results %>% filter(returns == min(results$returns))
med <- results %>% slice(100)
high <- results %>% filter(returns == max(results$returns))

# make some plots --------------------------------------------------------------
# define function to present (graphically) the portfolio contributions
show_proportions <- function(data) {
    gather(data, stock, prop) %>%
        mutate(prop = 100*round(prop, 2)) %>% 
        ggplot(aes_string(x = "stock", y = "prop"))+
        geom_bar(stat = "identity", fill = "steelblue", alpha = .45,
                 colour = "dodgerblue4") +
        labs(x = "Stock", y = "Percentage in Portfolio") +
        ggtitle("Portfolio Composition") +
        theme(panel.background=element_rect(fill="white"),
              text=element_text(color = "black"))
}    

low_plot <- show_proportions(low[, 1:10]) 
med_plot <- show_proportions(med[, 1:10]) 
high_plot <- show_proportions(high[, 1:10]) 

frontier <- ggplot(results, aes(x = variance, y = returns)) + 
            geom_point(alpha = .35, color = "steelblue") +
            scale_x_continuous(breaks = seq(from = 0, 
                                            to = max(results$variance),
                                            by = 0.00005)) +
            # add low risk point
            geom_point(data = low, 
                       aes(x = variance, y = returns), 
                       size = 3.5, 
                       colour = "firebrick",
                       alpha = .75) +
            annotate(geom = "text",
                     label = "Min-Risk/Min-Return\n Portfolio", 
                      x = low$variance + 0.000125,
                      y = low$returns + 0.0001) +
            # add medium risk point
            geom_point(data = med, 
                       aes(x = variance, y = returns), 
                       size = 3.5, 
                       colour = "firebrick",
                       alpha = .75) +
            annotate(geom = "text",
                     label = "Medium-Risk/\nMedium-Return\n Portfolio", 
                     x = med$variance + 0.000095,
                     y = med$returns - 0.00035) +    
            # add high risk point
            geom_point(data = high, 
                       aes(x = variance, y = returns), 
                       size = 3.5, 
                       colour = "firebrick",
                       alpha = .75) +
            annotate(geom = "text",
                     label = "High-Risk/\nHigh-Return\n Portfolio", 
                     x = high$variance - 0.000025,
                     y = high$returns - 0.0005) +
            ggtitle("Efficient Frontier") +
            labs(x="Portfolio Risk", y = "Portfolio Return") +
            theme(panel.background=element_rect(fill="white"),
                  text=element_text(color = "black"),
                  plot.title=element_text(size=24, color="black"),
                  axis.text.x = element_text(angle = -90))