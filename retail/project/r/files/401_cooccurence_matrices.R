# Step 0 - prepare env ---------------------------------------------------------


# Step 1 - prepare data --------------------------------------------------------
# Create function to find unique shops in each week for each house
find_shops <- function(cust){
  coffee_clean %>% 
    filter(cust_type == cust) %>% 
    dplyr::select(relweek, house, shop_desc_clean) %>% 
    distinct() %>% 
    group_by(house, relweek) %>% 
    mutate(prev_shop = lag(shop_desc_clean))
}

# Apply function for heavy and light users
stores_per_week_light <- find_shops("light")
stores_per_week_heavy <- find_shops("heavy")

# Step 2 - reshape to co-occurence ---------------------------------------------
# Get co-occurenc matrix (may be inefficient on large data)
cooccurence_light <- table(stores_per_week_light$shop_desc_clean, stores_per_week_light$prev_shop)
cooccurence_heavy <- table(stores_per_week_heavy$shop_desc_clean, stores_per_week_heavy$prev_shop)

# Step 3 - clean up -------------------------------------------------------

rm(stores_per_week_light, stores_per_week_heavy)
gc()


