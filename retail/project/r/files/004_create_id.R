# Step 3 - create ID -----------------------------------------------------------
# Create visit ID
vis_id <- coffee_clean %>% 
  select(relweek, day, house, shop_desc_clean) %>% 
  distinct() %>% 
  mutate(visit_id = row_number())

# Add back to data
coffee_clean <- coffee_clean %>% left_join(vis_id)

# Step 4 - create transaction ID ------------------------------------------
trans_id <- coffee_clean %>% 
  select(relweek, day, house, shop_desc_clean, brand_clean) %>% 
  distinct() %>% 
  mutate(transaction_id = row_number())

# Add back to data
coffee_clean <- coffee_clean %>% left_join(trans_id)

# Step 4 - clean up ------------------------------------------------------------
rm(coffee, vis_id, trans_id)
gc(verbose = FALSE)