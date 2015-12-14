# load packages and source pre-requisite data ----------------------------------
library(ggplot2)
library(tidyr)

if ( !("results" %in% ls()) ) {
    source("hw/hw4/002_calc_returns.R")
}

# create plots --------------------------------------------------------------
# define function to present (graphically) the portfolio contributions
show_proportions <- function(data) {
    gather(data, stock, prop) %>% # take data from wide to long format
        mutate(prop = 100*round(prop, 2)) %>% # convert proportions to percentage
        ggplot(aes_string(x = "stock", y = "prop"))+ # make the plot
        geom_bar(stat = "identity", # add bars
                 fill = "steelblue", 
                 alpha = .45,
                 colour = "dodgerblue4") +
        labs(x = "Stock", y = "Percentage in Portfolio") + # add axis labels
        ggtitle("Portfolio Composition") + # add title
        theme(panel.background=element_rect(fill="white"), # make it look pretty
              text=element_text(color = "black"))
}    

# create the plots for each portfolio
low_plot <- show_proportions(low[, 1:10]) 
med_plot <- show_proportions(med[, 1:10]) 
high_plot <- show_proportions(high[, 1:10]) 

# plot the efficient frontier from the results
frontier <- ggplot(results, aes(x = variance, y = returns)) + # create the plot
    geom_point(alpha = .35, color = "steelblue") + # add the points
    ggtitle("Efficient Frontier") + # add plot title
    labs(x="Portfolio Risk", y = "Portfolio Return") + # add axis labels
    theme(panel.background=element_rect(fill="white"), # make it pretty
          text=element_text(color = "black"),
          plot.title=element_text(size=24, color="black"),
          axis.text.x = element_text(angle = -90))

# add portfolios
frontier_with_ports <- frontier +
    # add low risk point with annotation
    geom_point(data = low, 
               aes(x = variance, y = returns), 
               size = 3.5, 
               colour = "firebrick",
               alpha = .75) +
    annotate(geom = "text",
             label = "Low-Risk/Low-Return\n Portfolio", 
             x = low$variance + 0.000125,
             y = low$returns + 0.0001) +
    # add medium risk point with annotation
    geom_point(data = med, 
               aes(x = variance, y = returns), 
               size = 3.5, 
               colour = "firebrick",
               alpha = .75) +
    annotate(geom = "text",
             label = "Medium-Risk/\nMedium-Return\n Portfolio", 
             x = med$variance + 0.000095,
             y = med$returns - 0.00035) +    
    # add high risk point with annotation
    geom_point(data = high, 
               aes(x = variance, y = returns), 
               size = 3.5, 
               colour = "firebrick",
               alpha = .75) +
    annotate(geom = "text",
             label = "High-Risk/\nHigh-Return\n Portfolio", 
             x = high$variance - 0.000025,
             y = high$returns - 0.0005) +
    scale_x_continuous(breaks = seq(from = 0, # set the scale
                                    to = max(results$variance),
                                    by = 0.00005)) 

# display single stock portfolios
frontier_with_stocks <- frontier +
    geom_line() +
    geom_point(data = single_stocks,
               aes(x = var, y = ret, colour = stock),
               size = 3.5,
               alpha = 1) +
    scale_colour_brewer(palette="Paired")+
    theme(legend.position = "bottom",
          legend.title = element_blank()) +
    ggtitle("Efficient Frontier with Individual Stock Portfolios")