# Step 0 - prep env -------------------------------------------------------


# Step 1 - compute r, f, and m --------------------------------------------
r <- lines %>% 
      group_by(cust_id) %>% 
      summarise(most_recent = max(order_date)) %>% 
      collect() %>% 
      mutate(age = difftime("2008-01-01", most_recent, units = "days"),
             age = as.numeric(age),
             r = ntile(age, 5))

f <- lines %>% 
    group_by(cust_id) %>% 
    summarise(purchases = n()) %>% 
    collect() %>% 
    mutate(f = ntile(purchases, 5))

m <- lines %>% 
  group_by(cust_id) %>% 
  summarise(avg_spend = mean(line_dollars)) %>% 
  collect() %>% 
  mutate(m = ntile(avg_spend, 5))

# Step 2 - combine --------------------------------------------------------
rfm <- r %>% 
        left_join(f) %>% 
        left_join(m) %>% 
        select(cust_id, r, f, m) %>% 
        rowwise() %>% 
        mutate(rfm = paste(r, f, m, sep = ""))

# Step 3 - clean up and gc ------------------------------------------------
rm(r, f, m)
gc()
