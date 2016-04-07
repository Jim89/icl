# Step 0 - prep env -------------------------------------------------------

lowerFn <- function(data, mapping, method = "lm", ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_point() +
    geom_smooth(method = method, color = "blue", ...) +
    theme_jim +
    theme(axis.text.y = element_text(size = 10, colour = "black"),
          axis.text.x = element_text(size = 10, colour = "black"))
  p
}

diagFn <- function(data, mapping) {
  p <- ggplot(data = data, mapping = mapping) +
       geom_density(fill = "steelblue", colour = "white", alpha = 0.75) +
        theme_jim +
        theme(axis.text.y = element_text(size = 10, colour = "black"),
              axis.text.x = element_text(size = 10, colour = "black"))
  p
}



# Step 1 - prep data ------------------------------------------------------
weekly_sales <- coffee_clean %>% 
                group_by(cust_type, relweek) %>% 
                summarise(total_packs = sum(packs)) %>% 
                gather(key, value, -c(cust_type:relweek)) %>% 
                bind_rows(coffee_clean %>% 
                            group_by(cust_type, relweek, shop_desc_clean) %>% 
                            summarise(value = sum(packs)) %>% 
                            rename(key = shop_desc_clean)) %>% 
                arrange(cust_type, relweek) %>% 
                spread(key, value)%>% 
                #select(-relweek) %>% 
                setNames(c("cust_type", "relweek", "Discounters", "Asda", "Morrisons", "Sainsburys", "Tesco", "Total"))
                

weekly_share <- coffee_clean %>% 
                group_by(cust_type, relweek, shop_desc_clean) %>% 
                summarise(total_packs = sum(packs)) %>% 
                group_by(cust_type, relweek) %>% 
                mutate(prop = total_packs / sum(total_packs)) %>% 
                select(relweek, shop_desc_clean, prop) %>% 
                spread(shop_desc_clean, prop) %>% 
                #select(-relweek) %>% 
                setNames(c("cust_type", "relweek", "Discounters", "Asda", "Morrisons", "Sainsburys", "Tesco"))


# Step 2 - calculate correlations -----------------------------------------
get_cor <- function(data, custs) {
  dat <- data %>% filter(cust_type %in% custs) %>% select(-cust_type, -relweek)
  cors <- cor(dat)
  return(cors)
}  

weekly_sales_cor_l <- get_cor(weekly_sales, "light")
weekly_sales_cor_m <- get_cor(weekly_sales, "medium")
weekly_sales_cor_h <- get_cor(weekly_sales, "heavy")
weekly_sales_cor_all <- get_cor(weekly_sales, c("heavy", "medium", "light"))


weekly_share_cor_l <- get_cor(weekly_share, "light")
weekly_share_cor_m <- get_cor(weekly_share, "medium")
weekly_share_cor_h <- get_cor(weekly_share, "heavy")
weekly_share_cor_all <- get_cor(weekly_share, c("heavy", "medium", "light"))

# Step 3 - pairwise share correlations plot -------------------------------
assignInNamespace("ggally_cor", ggally_cor, "GGally")

make_pairs <- function(data, custs = c("heavy", "medium", "light")) {
  data %>%
    filter(cust_type %in% custs) %>% 
    select(-cust_type, -relweek) %>%
    ggpairs(lower = list(continuous = wrap(lowerFn, method = "lm")),
            upper = list(continuous = wrap("cor", size = 10)),
            diag = list(continuous = wrap(diagFn)))
}  
  
share_pairs_l <- make_pairs(weekly_share, "light")
share_pairs_m <- make_pairs(weekly_share, "medium")
share_pairs_h <- make_pairs(weekly_share, "heavy")
share_pairs_all <- make_pairs(weekly_share)


# Step 4 - Relationship between market share and total market size --------
share_to_total_sales_plot <- weekly_share %>%  
                              left_join(weekly_sales %>% 
                                        select(cust_type, relweek, Total)) %>% 
                              gather(key, value, -cust_type, -relweek, -Total) %>%
                              mutate(key = gsub("Discounters", "Aldi & Lidl", key)) %>% 
                              ggplot(aes(x = Total, y = value)) +
                                geom_point(aes(colour = key), size = 2.5, 
                                           alpha = .75) +
                                geom_smooth(aes(colour = key), method = "lm", 
                                            formula = y ~ x ) +
                                facet_grid(. ~ key) +
                                scale_y_continuous(labels = scales::percent) +
                                scale_colour_brewer(palette = "Dark2", 
                                                    type = "qualitative") +
                                xlab("Total sales") +
                                ylab("Market share") +
                                theme_jim 

share_to_total_sales_cor <- weekly_share %>%  
                            left_join(weekly_sales %>% 
                                      select(cust_type, relweek, Total)) %>% 
                            gather(key, value, -cust_type, -relweek, -Total) %>% 
                            group_by(key) %>% 
                            summarise(correl = cor(value, Total),
                                      correl_p = cor.test(value, Total)$p.value)


# Step 5 - clean up -------------------------------------------------------
rm(lowerFn, diagFn, weekly_share, weekly_sales, get_cor, make_pairs)
