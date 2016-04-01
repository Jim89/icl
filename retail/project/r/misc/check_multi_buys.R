coffee_clean %>% 
  select(relweek, house, transaction_id, shop_desc_clean)


coffee_clean %>% 
  filter(cust_type != "medium") %>% 
  select(transaction_id, brand_clean) %>% 
  distinct() %>% 
  group_by(transaction_id) %>% 
  tally() %>% 
  ungroup() %>% 
  arrange(-n) %>% 
  filter(n >= 2)


coffee_clean %>% filter(transaction_id == 2766)
