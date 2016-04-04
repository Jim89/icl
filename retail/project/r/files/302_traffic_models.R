# Step 0 - prep env -------------------------------------------------------
model_traffic <- function(custs) {
ref_prices <- coffee_clean %>% 
              group_by(relweek, day, brand_clean) %>% 
              summarise(min_price = min(price),
                        max_price = max(price))  
  
fit <-  coffee_clean %>% 
        filter(cust_type %in% custs) %>% 
        group_by(relweek, day, shop_desc_clean, brand_clean) %>% 
        summarise(visits = n(),
                  avg_price = mean(price),
                  promo_price = mean(promo_price),
                  promo_units = mean(promo_units)) %>% 
        left_join(ref_prices) %>% 
        ungroup() %>% 
        mutate(shop = as.factor(shop_desc_clean),
               brand = as.factor(brand_clean)) %>% 
        zerotrunc(visits ~ shop + brand + avg_price + promo_price + promo_units + min_price + max_price,
                  data = ., dist = "negbin")
}

# Step 1 - fit models -----------------------------------------------------
traffic_heavy <- model_traffic("heavy")
traffic_light <- model_traffic("light")

# Step 2 - clean up -------------------------------------------------------

rm(model_traffic)
gc(verbose = FALSE)
