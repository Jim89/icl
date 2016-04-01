# Step 0 - prep env ------------------------------------------------------------
switching_mat <- function(custs) {
  data <- coffee_clean %>% 
    filter(cust_type == custs) %>% 
    arrange(house, relweek, transaction_id) %>% 
    select(house, relweek, transaction_id, shop_desc_clean) %>% 
    distinct() %>% 
    group_by(house) %>% 
    mutate(prev_shop = lag(shop_desc_clean)) %>% 
    ungroup() %>% 
    arrange(house, transaction_id)
  
  switching_mat <- table(data$shop_desc_clean, data$prev_shop) %>% 
    as.matrix()
  
  return(switching_mat)
}  

# Step 1 - Generate switching matrices -----------------------------------------
switch_heavy <- switching_mat("heavy")
switch_light <- switching_mat("light")

