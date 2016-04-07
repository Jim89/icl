# Step 0 - prep env -------------------------------------------------------

# Step 1 - create plot ----------------------------------------------------
weekly_share_to_prop_promo <- 
  coffee_clean %>% 
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
  ggplot(aes(x = prop_promo, y = share)) +
  geom_point(aes(colour = shop_desc_clean, size = 100*prop_promo), alpha = .75) +
  facet_grid(. ~ shop_desc_clean, scales = "fixed") +
  geom_smooth(aes(colour = shop_desc_clean), method = "lm", formula = y ~ x + poly(x, 2)) +
  geom_vline(xintercept = .5, linetype = "dashed", colour = "grey") + 
  scale_x_continuous(labels = scales::percent) +
  scale_y_continuous(labels = scales::percent) +
  scale_colour_brewer(palette = "Dark2", type = "qual") +
  xlab("Proportion of promotional sales") +
  ylab("Market share") +
  guides(size = guide_legend(title = "Proportion of promotional sales (%)"),
         colour = "none") +
  theme_jim
  



