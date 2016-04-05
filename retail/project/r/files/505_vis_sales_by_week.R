# Step 0 - prep env -------------------------------------------------------


# Step 1 - create plot ----------------------------------------------------
sales_by_week <- coffee_clean %>% 
  select(relweek, transaction_id) %>% 
  distinct() %>% 
  count(relweek) %>% 
  rename(sales = n) %>% 
  mutate(relweek = row_number()) %>% 
  ggplot(aes(x = relweek, y = sales)) +
  geom_point(size = 2.5, colour = "#e6ab02") +
  geom_line(size = 1.5, colour = "#e6ab02") +
  geom_line(data = coffee_clean %>% 
                    select(relweek, shop_desc_clean, transaction_id) %>% 
                    distinct() %>% 
                    count(relweek, shop_desc_clean) %>%
                    rename(sales = n) %>% ungroup() %>%
                    group_by(shop_desc_clean) %>% 
                    mutate(relweek = row_number()) %>% ungroup() %>% 
                    mutate(shop_desc_clean = toproper(shop_desc_clean)),
            aes(x = relweek, y = sales, colour = shop_desc_clean),
            size = 1.5) +
  geom_point(data = coffee_clean %>% 
              select(relweek, shop_desc_clean, transaction_id) %>% 
              distinct() %>% 
              count(relweek, shop_desc_clean) %>%
              rename(sales = n) %>% ungroup() %>%
              group_by(shop_desc_clean) %>% 
              mutate(relweek = row_number()) %>% ungroup() %>% 
              mutate(shop_desc_clean = toproper(shop_desc_clean)),
            aes(x = relweek, y = sales, colour = shop_desc_clean),
            size = 2) +
  guides(colour = guide_legend(title = "Shop")) +
  scale_y_continuous(limits = c(0, 2600), breaks = seq(0, 2600, 500)) +
  scale_colour_brewer(palette = "Dark2", type = "qualitative") +
  geom_smooth(colour = "#e6ab02") + 
  xlab("Week") +
  ylab("Transactions") + 
  theme_jim +
  theme(panel.grid.minor.x = element_line(colour = "grey", linetype = "dotted"))

