# Step 0 - prepare env ---------------------------------------------------------
# Create function to find unique shops in each week for each house
find_shops <- function(custs){
  coffee_clean %>% 
    filter(cust_type %in% custs) %>% 
    dplyr::select(relweek, house, shop_desc_clean) %>% 
    distinct() %>% 
    group_by(house, relweek) %>% 
    mutate(prev_shop = lag(shop_desc_clean))
}

# Step 1 - prepare data --------------------------------------------------------
# Apply function for heavy and light users
stores_per_week <- find_shops(custs = c("heavy", "light"))

# Step 2 - reshape to co-occurence ---------------------------------------------
# Get co-occurenc matrix (may be inefficient on large data)
cooccurence <- table(stores_per_week$shop_desc_clean, stores_per_week$prev_shop)

# Step 3 - clean up -------------------------------------------------------

rm(stores_per_week, find_shops)
gc()


