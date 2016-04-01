# Step 0 - prepare working environment -----------------------------------------


# Step 1 - Summarise all brands ------------------------------------------------
brand <- coffee_clean %>% 
  group_by(brand_name, total_range_name) %>% 
  tally() %>% 
  rename(sales = n)

# Step 2 - rationalise brands --------------------------------------------------
brand <- brand %>% 
        mutate(brand_clean = ifelse(sales < 5000, "Other brands", brand_name),
                #brand_clean = ifelse(brand_name == "PL_Standard", "Supermarket own", brand_clean),
                #brand_clean = ifelse(brand_name == "PL_Premium", "Supermarket premium", brand_clean),
                #brand_clean = ifelse(brand_name == "PL_Value", "Supermarket value", brand_clean),
                brand_clean = ifelse(grepl("PL_", brand_name), "Supermarket own", brand_clean),
                brand_clean = ifelse(grepl("Nescaf", brand_name), "Nescafe", brand_clean),
                brand_clean = gsub("\\(.*\\)", "", brand_clean)) %>% 
        select(-sales)

# Step 3 - join back to coffee data --------------------------------------------
coffee_clean <- coffee_clean %>% left_join(brand, by = c("brand_name", 
                                                         "total_range_name"))

# Step 4 - clean up ------------------------------------------------------------
rm(brand)
gc()
