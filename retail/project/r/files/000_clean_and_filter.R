# Step 0 - prepare working environment------------------------------------------

# Step 1 - read coffee ---------------------------------------------------------
coffee <- read.csv("./data/InstantCoffee.csv", 
                   encoding = "latin1", 
                   stringsAsFactors = FALSE) %>% 
          as_data_frame()

colnames(coffee) <- coffee %>% colnames() %>% tolower()

# Step 2 - filter and clean ----------------------------------------------------
coffee_clean <- coffee %>% # Take coffee data then
                # Filter it
                filter(shop_desc %in% c("1TESCO", # Only take certain shops
                                        "2ASDA", 
                                        "3SAINSBURYS", 
                                        "4MORRISONS", 
                                        "7DICSOUNTERS Aldi", 
                                        "7DISCOUNTERS Lidl")
                       & # And
                       sub_cat_name %in% c("Granules", # Only take certain coffees
                                           "Freeze Dried",
                                           "Decaf Freeze Dried", 
                                           "Micro Ground")) %>% # then...
                mutate(shop_desc_clean = shop_desc %>% # add cleaner shop name
                                          substring(2) %>% 
                                          tolower() %>% 
                                          gsub("discounters ","", .) %>% 
                                          gsub("aldi|lidl", "aldi & lidl", .),
                       # Add identifier field for discounted purchases
                       promo_price = ifelse(grepl("p off", epromdesc), 1, 0),
                       promo_units = ifelse(!grepl("p off", epromdesc) & 
                                            !grepl("No Promotion", epromdesc), 1, 0),
                       # Add price field
                       price = netspend/packs)

