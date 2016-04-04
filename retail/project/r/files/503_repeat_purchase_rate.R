
# Step 0 - prep env -------------------------------------------------------


# Step 1 - loyalty dot-plot -----------------------------------------------
repeat_purchase_rate <- loyalties %>% 
sort() %>% 
data_frame() %>% 
mutate(shop = as.factor(loyalties %>% sort() %>% names() %>% toproper())) %>% 
setNames(c("loyalty", "shop")) %>% 
ggplot(aes(x = shop, y = loyalty)) +
  geom_segment(aes(xend = shop), yend = 0, linetype = "dashed") +
  geom_point(size = 15, aes(colour = shop)) +
  guides(colour = "none") + 
  scale_x_discrete(limits = loyalties %>% sort() %>% names() %>% toproper()) +
  scale_y_continuous(labels = scales::percent) +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  xlab("Shop") +
  ylab("Repeat purchases (as percentage of total purchases)") +
  coord_flip() +
  theme_jim +
  theme(panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())
