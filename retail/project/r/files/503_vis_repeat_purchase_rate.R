
# Step 0 - prep env -------------------------------------------------------
make_repeat_purchase_plot <- function(data) {
  data %>% 
    sort() %>% 
    data_frame() %>% 
    mutate(shop = as.factor(data %>% sort() %>% names() %>% toproper())) %>% 
    setNames(c("loyalty", "shop")) %>% 
    ggplot(aes(x = shop, y = loyalty)) +
    scale_y_continuous(limits = c(.0, .8), labels = scales::percent) +
    geom_segment(aes(xend = shop), yend = 0, linetype = "dashed") +
    geom_point(size = 15, aes(colour = shop)) +
    guides(colour = "none") + 
    scale_x_discrete(limits = data %>% sort() %>% names() %>% toproper()) +
    geom_hline(yintercept = 0.0, colour = "grey") +
    scale_colour_brewer(palette = "Dark2", type = "qual") +
    xlab("Shop") +
    ylab("Repeat purchases (as percentage of total purchases)") +
    coord_flip() +
    theme_jim +
    theme(panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank())
}  


# Step 1 - loyalty dot-plot -----------------------------------------------
repeat_purchase_rate_h <- make_repeat_purchase_plot(loyalties_h)
repeat_purchase_rate_m <- make_repeat_purchase_plot(loyalties_m)
repeat_purchase_rate_l <- make_repeat_purchase_plot(loyalties_l)
