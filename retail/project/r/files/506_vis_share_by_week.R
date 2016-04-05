# Step 0 - prep env -------------------------------------------------------

# Step 1 - create plot ----------------------------------------------------
share_by_week <- coffee_clean %>% 
  select(relweek, shop_desc_clean, transaction_id) %>% 
  distinct() %>% 
  count(relweek, shop_desc_clean) %>% 
  group_by(relweek) %>% 
  mutate(prop = n /sum(n)) %>% 
  select(-n) %>% 
  mutate(shop_desc_clean = toproper(shop_desc_clean)) %>% 
  group_by(shop_desc_clean) %>% 
  mutate(relweek = row_number()) %>% 
  ggplot(aes(x = relweek, y = prop)) +
  geom_area(aes(fill = shop_desc_clean), colour = "white") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Dark2", type = "qualitative") +
  guides(fill = guide_legend(title = "Shop")) +
  xlab("Week") +
  ylab("Market share") +
  theme_jim



