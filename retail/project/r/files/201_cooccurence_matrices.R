# Step 0 - prepare env ---------------------------------------------------------
# Create function to find unique shops in each week for each house
find_shops <- function(custs){
  coffee_clean %>% 
    filter(cust_type %in% custs) %>% 
    dplyr::select(relweek, house, shop_desc_clean) %>% 
    distinct() %>% 
    group_by(house, relweek) %>% 
    mutate(prev_shop = lag(shop_desc_clean),
           shop_desc_clean = toproper(shop_desc_clean),
           prev_shop = toproper(prev_shop))
}

# Step 1 - prepare data --------------------------------------------------------
# Apply function for heavy and light users
stores_per_week_l <- find_shops(custs = c("light")) %>% filter(prev_shop != "NANA")
stores_per_week_m <- find_shops(custs = c("medium")) %>% filter(prev_shop != "NANA")
stores_per_week_h <- find_shops(custs = c("heavy")) %>% filter(prev_shop != "NANA")

# Step 2 - reshape to co-occurence ---------------------------------------------
# Get co-occurenc matrix (may be inefficient on large data)
cooccurence_l <- table(stores_per_week_l$shop_desc_clean, stores_per_week_l$prev_shop)
cooccurence_m <- table(stores_per_week_m$shop_desc_clean, stores_per_week_m$prev_shop)
cooccurence_h <- table(stores_per_week_h$shop_desc_clean, stores_per_week_h$prev_shop)

# Step 3 - clean up -------------------------------------------------------

rm(stores_per_week_l, stores_per_week_m, stores_per_week_h, find_shops)
gc()


