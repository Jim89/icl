coffee_clean %>% 
  group_by(relweek, shop_desc_clean) %>% 
  summarise(sales = sum(packs),
            price = mean(price)) %>% 
  group_by(relweek) %>% 
  mutate(share = sales/sum(sales),
         price = price,
         shop_desc_clean = toproper(shop_desc_clean),
         shop_desc_clean = ifelse(shop_desc_clean == "Aldi & lidl", "Adli & Lidl",
                                  shop_desc_clean)) %>% 
  ungroup() %>% 
  group_by(shop_desc_clean) %>% 
  mutate(relweek = row_number()) %>% 
  select(-sales) %>% 
  gather(key, value, -relweek, -shop_desc_clean) %>% 
  ggplot(aes(x = relweek, y = value, group = key)) +
  geom_point(aes(colour = shop_desc_clean)) +
  geom_line(aes(colour = shop_desc_clean), size = 1.25) +
  facet_grid(key ~ shop_desc_clean, scales = "free_y") +
  scale_x_continuous(breaks = seq(0, 55, 5)) +
  scale_y_continuous() +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  xlab("Week") +
  ylab("Average price (£)") +
  guides(colour = "none") +
  theme_jim