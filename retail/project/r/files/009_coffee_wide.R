# Step 0 - prepare environment -------------------------------------------------
# In-line function definition used in this script only
# This function takes the coffee data, filters to just one customer type (e.g.
# heavy or light), aggregates to a weekly level and then spreads the data
# in to a wide form suitable for modelling
widen <- function(data) {
  # Filter and widen at brand level
  shop_level <- coffee_clean %>% 
    group_by(cust_type, relweek, day, shop_desc_clean) %>% 
    summarise(sales = sum(packs),
              price = mean(price),
              promo_sales_price = sum(promo_price),
              promo_sales_units = sum(promo_units)) %>% 
    mutate(promo_cost = promo_sales_price/sales,
           promo_units = promo_sales_units/sales) %>% 
    select(-promo_sales_price, -promo_sales_units) %>% 
    gather(variable, value, -(cust_type:shop_desc_clean)) %>%
    mutate(shop_desc_clean = ifelse(shop_desc_clean == "aldi & lidl", 
                                    "aldi", 
                                    shop_desc_clean)) %>% 
    unite(temp, shop_desc_clean, variable, sep = "_") %>% 
    spread(temp, value) %>% 
    ungroup()
  
  colnames(shop_level) <- colnames(shop_level) %>% gsub(" ", "_", .) %>% tolower()

  return(shop_level)
}

# Step 1 - perform the spread --------------------------------------------------
# Filter and spread
coffee_wide <- widen(coffee_clean)

# Clean up missing values with mean-substitution
for(i in 1:ncol(coffee_wide)){
  val <- mean(coffee_wide[,i] %>% sapply(as.numeric), na.rm = TRUE)
  coffee_wide[is.na(coffee_wide[,i]), i] <- val
}

# Clean up
rm(i, val, widen)
gc(verbose = FALSE)
