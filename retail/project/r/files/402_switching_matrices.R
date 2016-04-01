# Step 0 - prep env ------------------------------------------------------------

# Step 1 - Generate switching matrices -----------------------------------------
data <- coffee_clean %>% 
        arrange(house, relweek, transaction_id) %>% 
        select(house, relweek, transaction_id, shop_desc_clean) %>% 
        distinct() %>% 
        group_by(house) %>% 
        mutate(prev_shop = lag(shop_desc_clean)) %>% 
        ungroup() %>% 
        arrange(house, transaction_id)

switching_mat <- table(data$shop_desc_clean, data$prev_shop) %>% 
                  as.matrix()

# Step 2 - clean up -------------------------------------------------------

rm(data)
gc(verbose = FALSE)
