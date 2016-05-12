
# Step 0 - prep env -------------------------------------------------------

# Step 1 - create data ----------------------------------------------------
# Gather and filter summary table
sum_cln <- sum_tabl %>% 
            select(-c(starts_with("ret"),
                      starts_with("int"),
                      starts_with("cat"),
                      starts_with("gift"),
                      starts_with("email"),
                      starts_with("new")))

# Set up customer types
cust_types <- sum_cln %>% 
  collect() %>% 
  mutate(children = ifelse(child0_2 == "Y" | child3_5 == "Y" | child6_11 == "Y" |
                             child12_16 == "Y" | child17_18 == "Y", "Y", "N")) %>% 
  select(cust_id, acqdate, travel, curraff, currev, wines, finearts, exercise,
         selfhelp, collect, needle, sewing, dogowner, carowner, cooking, pets, 
         fashion, camping, hunting, boating, children) 

# Summarise orders and join in customer types
orders_to_types <- lines %>% 
  left_join(orders) %>% 
  group_by(cust_id, order_method) %>% 
  summarise(orders = n(),
            spend = sum(line_dollars)) %>% 
  mutate(spend_per_order = spend/orders) %>% 
  collect() %>% 
  left_join(cust_types)


# Step 2 - create plots ---------------------------------------------------
# Create plot of overall sales
tot_sales <- orders_to_types %>% 
  ggplot(aes(x = order_method, y = spend)) +
  geom_point(shape = 21, colour = "#666666", fill = "#e6ab02", size = 3.5, 
             stroke = .75, position = "jitter", alpha = .5) +
  scale_y_continuous(labels = scales::comma) +
  xlab("Order method") +
  ylab("Spend (£)") +
  theme_jim

# Spend per order
spend_per <- orders_to_types %>% 
  ggplot(aes(x = order_method, y = spend_per_order)) +
  geom_point(shape = 21, colour = "#666666", fill = "#e6ab02", size = 3.5, 
             stroke = .75, position = "jitter", alpha = .5) +
  scale_y_continuous(labels = scales::comma) +
  xlab("Order method") +
  ylab("Spend per order (£)") +
  theme_jim

# Function to create plot by fields
split_plot <- function(data = orders_to_types, field = "travel") { 
  data %>%  
    ggplot(aes_string(x = "order_method", y = "spend")) +
    geom_point(aes_string(colour = field), alpha = 0.5) +
    scale_colour_brewer(type = "qual", palette = "Dark2") +
    scale_y_continuous(labels = scales::comma) +
    xlab("Order method") + 
    ylab("Total spend (£)") +
    theme_jim
}

# Create plots
travel <- orders_to_types %>% filter(travel %in% c("Y", "N")) %>% 
  split_plot() + facet_grid(.~travel) + guides(colour = guide_legend(title = "Travel"))

children <- orders_to_types %>% filter(children %in% c("Y", "N")) %>% 
  split_plot(field = "children") + facet_grid(.~children) + guides(colour = guide_legend(title = "Children"))


# Step 3 - numerical summaries --------------------------------------------

type_summary <- orders_to_types %>% 
                group_by(order_method) %>% 
                summarise(total_orders = scales::comma(sum(orders)),
                          total_spend = scales::comma(sum(spend)),
                          avg_spend_per = mean(spend_per_order))


