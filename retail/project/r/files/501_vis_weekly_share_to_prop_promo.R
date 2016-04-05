# Step 0 - prep env -------------------------------------------------------

# Step 1 - create plot ----------------------------------------------------
weekly_share_to_prop_promo <- coffee_clean %>% 
  rowwise() %>% 
  mutate(promo = max(promo_price, promo_units)) %>% 
  ungroup() %>%
  group_by(relweek, shop_desc_clean) %>% 
  summarise(sales = sum(packs),
            prop_promo = mean(promo)) %>% 
  group_by(relweek) %>% 
  mutate(share = sales/sum(sales),
         prop_promo = prop_promo,
         shop_desc_clean = toproper(shop_desc_clean),
         shop_desc_clean = ifelse(shop_desc_clean == "Aldi & lidl", "Adli & Lidl",
                                  shop_desc_clean)) %>% 
  ungroup() %>% 
  group_by(shop_desc_clean) %>% 
  mutate(relweek = row_number()) %>% 
  ggplot(aes(x = relweek, y = share)) +
  geom_point(aes(colour = shop_desc_clean, size = 100*prop_promo)) +
  geom_line(aes(colour = shop_desc_clean), size = 1.25) +
  facet_grid(shop_desc_clean ~ ., scales = "free_y") +
  scale_x_continuous(breaks = seq(0, 55, 5)) +
  scale_y_continuous(labels = scales::percent) +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  xlab("Week") +
  ylab("Market share (note different scales in each facet)") +
  guides(size = guide_legend(title = "Proportion of promotional sales (%)"),
         colour = "none") +
  theme_jim
  



