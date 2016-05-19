# Create ts
lettuce_ts <- ts(daily_demand$lettuce, 
                 start = c(2005, 64),
                 frequency = 365.25)

tomato_ts <- ts(daily_demand$tomato,
                start = c(2005, 64),
                frequency = 365.25)


make_ts <- function(data) {
  series <- ts(data$demand, start = c(2005, 64), frequency = 365.25)
  return(series)
}

test <- daily_demand %>% 
  select(store, date, lettuce, tomato) %>% 
  gather(ingredient, demand, c(-store, -date)) %>% 
  nest(-c(store, ingredient), .key = "ts_data") %>% 
  mutate(series = make_ts(ts_data$demand))


  

test <- daily_demand %>% 
  select(store, date, lettuce, tomato) %>% 
  gather(ingredient, demand, c(-store, -date)) %>% 
  unite(store_ingredient, store, ingredient) %>% 
  mutate(store_ingredient = as.factor(store_ingredient)) %>% 
  split(., .$store_ingredient)
  


serieses <- lapply(test, make_ts)
lapply(serieses, plot)
