# Create ts
lettuce_ts <- ts(daily_demand$lettuce, 
                 start = c(2005, 64),
                 frequency = 365.25)

tomato_ts <- ts(daily_demand$tomato,
                start = c(2005, 64),
                frequency = 365.25)

library(ggplot2)

daily_demand %>% 
  ggplot(aes(x = date, y = lettuce), group = 1) +
  geom_line(colour = "steelblue", size = 1) +
  scale_x_date(date_breaks = "1 week") +
  xlab("Date") +
  ylab("Demand for lettuce") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 0.5,
                                   hjust = .5,
                                   debug = F)) +
  theme_jim
  


daily_demand %>% 
  ggplot(aes(x = date, y = tomato), group = 1) +
  geom_line(colour = "steelblue", size = 1) +
  scale_x_date(date_breaks = "1 week") +
  xlab("Date") +
  ylab("Demand for tomato") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 0.5,
                                   hjust = .5,
                                   debug = F)) +
  theme_jim