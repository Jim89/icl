# Step 0 - prep env -------------------------------------------------------


# Step 1 - create transaction level summaries -----------------------------
# Create list of transaction ID to shop to 1/0 choice
# Note this assumes that all households can choose from all shops
trans_store_choice <- coffee_clean %>% 
                      group_by(transaction_id, shop_desc_clean) %>% 
                      summarise(packs = sum(packs)) %>% 
                      select(-packs) %>% 
                      mutate(purchase = 1) %>% 
                      spread(shop_desc_clean, purchase) %>% 
                      gather(shop, choice, -transaction_id) %>% 
                      arrange(transaction_id)


# Create transaction level statistics
trans_level <- coffee_clean %>% 
  group_by(transaction_id, relweek, day, brand_clean, shop_desc_clean, house, cust_type) %>% 
  summarise(packs = sum(packs),
            price_per_pack = mean(price),
            spend = sum(netspend),
            promo_price = mean(promo_price),
            promo_units = mean(promo_units))

# Find previous supermarket choice
last_choice <- coffee_clean %>% 
                select(house, transaction_id, shop_desc_clean) %>% 
                distinct() %>% 
                group_by(house) %>% 
                mutate(prev_shop = lag(shop_desc_clean))

# Step 2 - create long format data ----------------------------------------
coffee_long <- trans_store_choice %>% 
                left_join(trans_level) %>% 
                left_join(last_choice) %>% 
                select(transaction_id,
                       house,
                       cust_type,
                       brand_clean,
                       relweek,
                       day,
                       shop_desc_clean,
                       prev_shop,
                       packs,
                       spend,
                       shop,
                       choice,
                       price_per_pack,
                       promo_price,
                       promo_units) %>% 
                rename(brand = brand_clean,
                       shop_choice = shop_desc_clean,
                       prev_choice = prev_shop)
                       

# Step 3 - clean up -------------------------------------------------------
rm(trans_store_choice, trans_level, last_choice)
gc()
