
# Step 0 - prep env -------------------------------------------------------


# Step 1 - make plot ------------------------------------------------------
weekly_price_to_share <- 
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
  ggplot(aes(x = price, y = share)) +
  geom_point(aes(colour = shop_desc_clean), size = 2.5, alpha = .75) +
  geom_smooth(aes(colour = shop_desc_clean), method = "lm", formula = y ~ x + poly(x, 2)) +
  facet_grid(. ~ shop_desc_clean, scales = "free_x") +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  scale_y_continuous(labels = scales::percent) +
  xlab("Average price (£)") +
  ylab("Market Share") +
  guides(colour = "none") +
  theme_jim