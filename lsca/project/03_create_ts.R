library(forecast)


make_ts <- function(df) {
  series <- ts(df$demand, start = 1, frequency = 1)
  return(series)
}

fit_hw <- function(ts) {
 HoltWinters(ts, alpha = TRUE, beta = TRUE, gamma = FALSE)
}

fit_ets <- function(ts) {
  ets(ts, model = "ZZZ")
}

plot_ets <- function(ets_ob) {
  plot(ets_ob)
}

make_fitted_plot <- function(ets_data) {
  fitted <- ets_data$fitted
  plot <- ggplot(aes(x = fitted)) + geom_histogram()
  return(plot)
}

fit_auto_arima <- function(ts) {
  auto.arima(ts)
}



test <- daily_demand %>% 
  select(store, date, lettuce, tomato) %>% 
  gather(ingredient, demand, c(-store, -date)) %>% 
  nest(-c(store, ingredient), .key = "ts_data") %>% 
  mutate(ts_ob = ts_data %>% purrr::map(make_ts),
         ts_hw = ts_ob %>% purrr::map(fit_ets),
         ts_auto_arime = ts_ob %>% purrr::map(fit_auto_arima))





ob <- test$ts_hw[[1]]

  
ob <- test$ts_hw[1]

test <- daily_demand %>% 
  select(store, date, lettuce, tomato) %>% 
  gather(ingredient, demand, c(-store, -date)) %>% 
  unite(store_ingredient, store, ingredient) %>% 
  mutate(store_ingredient = as.factor(store_ingredient)) %>% 
  split(., .$store_ingredient)
  


serieses <- lapply(test, make_ts)
lapply(serieses, plot)
