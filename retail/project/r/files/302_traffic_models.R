# Step 0 - prep env -------------------------------------------------------
model_traffic <- function(custs) {
  combos <- expand.grid(relweek = seq(min(coffee_clean$relweek), 
                                      max(coffee_clean$relweek), 1),
                        day = seq(min(coffee_clean$day), max(coffee_clean$day), 1),
                        shop_desc_clean = unique(coffee_clean$shop_desc_clean) %>% as.character(),
                        brand_clean = unique(coffee_clean$brand_clean) %>% as.character(),
                        cust_type = unique(coffee_clean$cust_type) %>% as.character(),
                        stringsAsFactors = FALSE)
  
  # Find reference prices
  ref_prices <- coffee_clean %>% 
    group_by(relweek, day, brand_clean) %>% 
    summarise(min_price = min(price),
              max_price = max(price))
  
  # Find visits and actual prices and promotion props
  visits_data <-  coffee_clean %>% 
    group_by(cust_type, relweek, day, shop_desc_clean, brand_clean) %>% 
    summarise(visits = n())
  
  price_data <- coffee_clean %>% 
    group_by(relweek, day, shop_desc_clean, brand_clean) %>% 
    summarise(avg_price = mean(price),
              promo_price = mean(promo_price),
              promo_units = mean(promo_units))
  
  # For days with no reference price, find min and max price for that brand
  avg_prices <- coffee_clean %>% 
    group_by(shop_desc_clean, brand_clean) %>% 
    summarise(min_min_price = min(price),
              max_max_price = max(price))
  
  # For days with no price/promo data, find overall averages
  avg_promos <- coffee_clean %>% 
    group_by(shop_desc_clean, brand_clean) %>% 
    summarise(avg_price_const = mean(price),
              avg_price_promo = mean(promo_price),
              avg_unit_promo = mean(promo_units))
  
  # Join all combinations with actual data
  combos <- combos %>% 
    left_join(visits_data) %>% 
    left_join(price_data) %>% 
    left_join(ref_prices)
  
  # Add on the "back-up"/placeholder data
  combos <- combos %>% 
    left_join(avg_prices) %>% 
    left_join(avg_promos) %>% 
    mutate(avg_price = coalesce(avg_price, avg_price_const),
           promo_price = coalesce(promo_price, avg_price_promo),
           promo_units = coalesce(promo_units, avg_unit_promo),
           min_price = coalesce(min_price, min_min_price),
           max_price = coalesce(max_price, max_max_price)) %>% 
    select(-c(min_min_price:avg_unit_promo)) %>% 
    rename(shop = shop_desc_clean,
           brand = brand_clean)
  
  # Set visits to 0 if no visits
  combos$visits[is.na(combos$visits)] <-  0
  
  # Create model - many zeros so can do normal poisson
  fit <- combos %>% 
    filter(cust_type %in% custs) %>% 
    glm(visits ~ shop + brand + avg_price + promo_price + promo_units + min_price + max_price,
        data = ., family = "poisson")
}

# Step 1 - fit models -----------------------------------------------------
traffic_heavy <- model_traffic("heavy")
traffic_light <- model_traffic("light")

# Step 2 - clean up -------------------------------------------------------

rm(model_traffic)
gc(verbose = FALSE)
