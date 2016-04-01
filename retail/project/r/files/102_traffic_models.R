# Step 0 - prep env -------------------------------------------------------
model_traffic <- function(custs) {
 coffee_clean %>% 
    filter(cust_type == custs) %>% 
    group_by(relweek, day, shop_desc_clean, brand_clean) %>% 
    summarise(visits = n(),
              avg_price = mean(price),
              promo_price = mean(promo_price),
              promo_units = mean(promo_units)) %>% 
    zerotrunc(visits ~ as.factor(shop_desc_clean) + as.factor(brand_clean) + avg_price + promo_price + promo_units,
              data = ., dist = "poisson")
}

# Step 1 - fit models -----------------------------------------------------
traffic_heavy <- model_traffic("heavy")
traffic_medium <- model_traffic("medium")
traffic_light <- model_traffic("light")
