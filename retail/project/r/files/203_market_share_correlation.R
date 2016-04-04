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
weekly_share <- coffee_clean %>% 
                group_by(relweek, shop_desc_clean) %>% 
                summarise(total_packs = sum(packs)) %>% 
                group_by(relweek) %>% 
                mutate(prop = total_packs / sum(total_packs)) %>% 
                select(relweek, shop_desc_clean, prop) %>% 
                spread(shop_desc_clean, prop) %>% 
                select(-relweek) %>% 
                setNames(c("Discounters", "Asda", "Morrisons", "Sainsburys", "Tesco"))


# Step 2 - calculate correlations -----------------------------------------
weekly_share_cor <- cor(weekly_share)

# Step 3 - pairwise share correlations plot -------------------------------
assignInNamespace("ggally_cor", ggally_cor, "GGally")
share_pairs <- weekly_share %>% 
                ggpairs(lower = list(continuous = wrap(lowerFn, method = "lm")),
                        upper = list(continuous = wrap("cor", size = 10)),
                        diag = list(continuous = wrap(diagFn)))

# Step 4 - clean up -------------------------------------------------------
rm(lowerFn, diagFn, weekly_share)
