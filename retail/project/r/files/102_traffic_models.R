# Step 0 - prep env -------------------------------------------------------
model_traffic <- function(custs) {
ref_prices <- coffee_clean %>% 
              group_by(relweek, day, brand_clean) %>% 
              summarise(min_price = min(price),
                        max_price = max(price))  
  
fit <-  coffee_clean %>% 
        filter(cust_type == custs) %>% 
        group_by(relweek, day, shop_desc_clean, brand_clean) %>% 
        summarise(visits = n(),
                  avg_price = mean(price),
                  promo_price = mean(promo_price),
                  promo_units = mean(promo_units)) %>% 
        left_join(ref_prices) %>% 
        ungroup() %>% 
        mutate(shop_desc_clean = as.factor(shop_desc_clean),
               brand_clean = as.factor(brand_clean)) %>% 
        zerotrunc(visits ~ shop_desc_clean + brand_clean + avg_price + promo_price + promo_units + min_price + max_price,
                  data = ., dist = "poisson")
}

# Step 1 - fit models -----------------------------------------------------
traffic_heavy <- model_traffic("heavy")
traffic_medium <- model_traffic("medium")
traffic_light <- model_traffic("light")


