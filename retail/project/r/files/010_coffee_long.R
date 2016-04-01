# Step 0 - prep env -------------------------------------------------------
# Import coalesce function from Hadley: 
# https://github.com/hadley/dplyr/blob/master/R/coalesce.R
coalesce <- function(x, ...) {
  values <- list(...)
  for (i in seq_along(values)) {
    x <- replace_with(x, is.na(x), values[[i]], paste0("Vector ", i))
  }
  x
}

replace_with <- function(x, i, val, name) {
  if (is.null(val)) {
    return(x)
  }
  
  check_length(val, x, name)
  check_type(val, x, name)
  check_class(val, x, name)
  
  if (length(val) == 1L) {
    x[i] <- val
  } else {
    x[i] <- val[i]
  }
  
  x
}

check_length <- function(x, template, name = deparse(substitute(x))) {
  n <- length(template)
  if (length(x) == n) {
    return()
  }
  
  if (length(x) == 1L) {
    return()
  }
  
  stop(name, " is length ", length(x), " not 1 or ", n, ".", call. = FALSE)
}

check_type <- function(x, template, name = deparse(substitute(x))) {
  if (identical(typeof(x), typeof(template))) {
    return()
  }
  
  stop(
    name, " has type '", typeof(x), "' not '", typeof(template), "'",
    call. = FALSE
  )
}

check_class <- function(x, template, name = deparse(substitute(x))) {
  if (!is.object(x)) {
    return()
  }
  
  if (identical(class(x), class(template))) {
    return()
  }
  
  stop(name, " has class ", paste(class(x), collapse = "/"), " not ",
       paste(class(template), collapse = "/"), call. = FALSE)
}

# Step 1 - create transaction level summaries -----------------------------
# Create list of transaction ID to shop to 1/0 choice
# Note this assumes that all households can choose from all shops
trans_store_choice <- coffee_clean %>% 
                      group_by(transaction_id, relweek, day, shop_desc_clean, brand_clean) %>% 
                      summarise(packs = sum(packs)) %>% 
                      select(-packs) %>% 
                      mutate(purchase = 1) %>% 
                      spread(shop_desc_clean, purchase) %>% 
                      gather(shop, choice, -transaction_id, -relweek, -day, -brand_clean) %>% 
                      arrange(transaction_id) %>% 
                      mutate(shop = as.character(shop))

# Create daily prices
avg_prices_daily <- coffee_clean %>% 
                    group_by(relweek, day, brand_clean, shop_desc_clean) %>% 
                    summarise(price = mean(price),
                              promo_price = mean(promo_price),
                              promo_units = mean(promo_units)) %>% 
                    arrange(relweek, day, brand_clean, shop_desc_clean) %>% 
                    rename(shop = shop_desc_clean)

avg_prices_total <- coffee_clean %>% 
                    group_by(shop_desc_clean, brand_clean) %>% 
                    summarise(avg_price = mean(price),
                              avg_promo_p = mean(promo_price),
                              avg_promo_u = mean(promo_units)) %>% 
                    rename(shop = shop_desc_clean)

trans_choice_to_price <- trans_store_choice %>% 
                          left_join(avg_prices_daily) %>% 
                          left_join(avg_prices_total) %>% 
                          rowwise() %>% 
                          mutate(price = coalesce(price, avg_price),
                                 promo_price = coalesce(promo_price, avg_promo_p),
                                 promo_units = coalesce(promo_units, avg_promo_u)) %>% 
                          select(-avg_price, -avg_promo_p, -avg_promo_u) %>% 
                          ungroup()

# Create transaction level statistics
trans_level <- coffee_clean %>% 
                group_by(transaction_id, relweek, day, brand_clean, shop_desc_clean, house, cust_type) %>% 
                summarise(packs = sum(packs),
                          spend = sum(netspend))

# Find previous supermarket choice
last_choice <- coffee_clean %>% 
                select(house, transaction_id, shop_desc_clean) %>% 
                distinct() %>% 
                group_by(house) %>% 
                mutate(prev_shop = lag(shop_desc_clean))



# Step 2 - create long format data ----------------------------------------
coffee_long <- trans_choice_to_price %>% 
                left_join(trans_level) %>% 
                left_join(last_choice) %>% 
                select(transaction_id,
                       house,
                       cust_type,
                       brand_clean,
                       relweek,
                       day,
                       shop_desc_clean,
                       prev_shop,
                       packs,
                       spend,
                       shop,
                       choice,
                       price,
                       promo_price,
                       promo_units) %>% 
                rename(brand = brand_clean,
                       shop_choice = shop_desc_clean,
                       prev_choice = prev_shop) %>% 
                mutate(brand = as.factor(brand),
                       shop_choice = as.factor(shop_choice),
                       prev_choice = as.factor(prev_choice))
                       
# Clean up choice
coffee_long$choice[is.na(coffee_long$choice)] <- 0

# Step 3 - clean up -------------------------------------------------------
rm(trans_store_choice, avg_prices_daily, avg_prices_total, trans_level, 
   last_choice, trans_choice_to_price)
gc()
