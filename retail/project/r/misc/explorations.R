
# Step 0 - prep env -------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)

# Step 1 - get data -------------------------------------------------------

coffee <- read.csv("./data/InstantCoffee.csv",
                   stringsAsFactors = FALSE) %>% as_data_frame()
colnames(coffee) <- colnames(coffee) %>% tolower() %>% stringr::str_trim()


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

# Step 2 - sales over time ------------------------------------------------
sales_over_time <- coffee_clean %>% 
                    group_by(relweek) %>% 
                    summarise(total_packs = sum(packs)) %>% 
                    ggplot(aes(x = relweek, y = total_packs)) +
                    geom_line() +
                    geom_smooth() +
                    geom_line(data = coffee_clean %>% 
                                group_by(relweek, shop_desc_clean) %>% 
                                summarise(total_packs = sum(packs)),
                              aes(x = relweek, y = total_packs, 
                                  colour = shop_desc_clean)) +
                    scale_colour_brewer(palette = "Dark2", type = "qual")

ggsave("./project/vis/rough/sales_over_time.svg", sales_over_time)
                  
                  
