# Step 0 - prepare working environment -----------------------------------------


# Step 1 - aggregate data ------------------------------------------------------
house_summary <- coffee_clean %>% 
                group_by(visit_id, house) %>% 
                summarise(visits = n(),
                  total_vol = sum(volume)) %>% 
                ungroup() %>% 
                group_by(house) %>% 
                summarise(avg_visit_vol = mean(total_vol))

# Step 2 - classify into light vs heavy ----------------------------------------
quartiles <- quantile(house_summary$avg_visit_vol)
light_vs_heavy <- house_summary %>% 
                  mutate(cust_type = ifelse(avg_visit_vol <= quartiles[2], "light",
                                      ifelse(avg_visit_vol >= quartiles[4], "heavy", 
                                             "medium"))) %>% 
                  select(house, cust_type)

# Step 3 - perform the join ----------------------------------------------------
coffee_clean <- coffee_clean %>% left_join(light_vs_heavy, by = "house")

rm(house_summary, light_vs_heavy, quartiles)
gc(verbose = FALSE)
