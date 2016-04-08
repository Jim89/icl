
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
repeat_purchase_rate_all <- cbind(loyalties_h, loyalties_m, loyalties_l) %>% 
  data.frame() %>% 
  add_rownames() %>% 
  rename(shop = rowname) %>% 
  gather(user, loyalty, -shop) %>% 
  mutate(user = as.character(user),
         user = ifelse(grepl("_h", user), "1 - Heavy", user),
         user = ifelse(grepl("_m", user), "2 - Medium", user),
         user = ifelse(grepl("_l", user), "3 - Light", user)) %>% 
  ggplot(aes(x = toproper(shop), y = loyalty)) +
  geom_segment(aes(xend = toproper(shop)), yend = 0.2, linetype = "dashed",
               size = 0.5) +
  geom_point(size = 10, aes(colour = toproper(shop))) +
  facet_grid(user ~ .) +
  scale_y_continuous(limits = c(.2, .8), labels = scales::percent) +
  # scale_x_discrete(limits = data %>% sort() %>% names() %>% toproper())
  guides(colour = guide_legend(title = "")) + 
  geom_hline(yintercept = 0.2, colour = "grey") +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  xlab("") +
  ylab("Repeat purchases (as percentage of total purchases)") +
  coord_flip() +
  theme_jim +
  theme(panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())
