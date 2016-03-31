
# Step 0 - prep env -------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(tidyr)
library(GGally)

theme_jim <-  theme(legend.position = "bottom",
                    axis.text.y = element_text(size = 16, colour = "black"),
                    axis.text.x = element_text(size = 16, colour = "black"),
                    legend.text = element_text(size = 16),
                    legend.title = element_text(size = 16),
                    title = element_text(size = 16),
                    strip.text = element_text(size = 16, colour = "black"),
                    strip.background = element_rect(fill = "white"),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
                    panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
                    panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
                    panel.margin.y = unit(0.1, units = "in"),
                    panel.background = element_rect(fill = "white", colour = "lightgrey"),
                    panel.border = element_rect(colour = "black", fill = NA))

# Step 1 - get data -------------------------------------------------------

source("./project/r/files/000_clean_and_filter.R")

# Step 2 - plots over time ------------------------------------------------
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


prop_sales_over_time <- coffee_clean %>% 
                        group_by(relweek, shop_desc_clean) %>% 
                        summarise(total_packs = sum(packs),
                                  total_vol = sum(volume)) %>% 
                        group_by(relweek) %>% 
                        mutate(prop = total_packs / sum(total_packs),
                               prop_vol = total_vol / sum(total_vol)) %>% 
                        ggplot(aes(x = relweek, y = prop)) +
                        geom_area(aes(fill = shop_desc_clean), colour = "white") +
                        scale_fill_brewer(palette = "Dark2", type = "qual") +
                        theme_jim
                  
delta_sales <- coffee_clean %>% 
                group_by(relweek, shop_desc_clean) %>% 
                summarise(total_packs = sum(packs)) %>% 
                ungroup() %>% 
                arrange(shop_desc_clean, relweek) %>% 
                group_by(shop_desc_clean) %>% 
                mutate(prev_packs = lag(total_packs),
                       diff = total_packs - prev_packs) %>% 
                ggplot(aes(x = relweek, y = diff, group = shop_desc_clean)) +
                geom_line(aes(colour = shop_desc_clean), size = 1) +
                scale_fill_brewer(palette = "Dark2", type = "qual") +
                theme_jim
  

lowerFn <- function(data, mapping, method = "lm", ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_point() +
    geom_smooth(method = method, color = "blue", ...)
  p
}

sales_reln <- coffee_clean %>% 
              group_by(relweek, shop_desc_clean) %>% 
              summarise(total_packs = sum(packs)) %>% 
              ungroup() %>% 
              arrange(shop_desc_clean, relweek) %>% 
              group_by(shop_desc_clean) %>% 
              mutate(prev_packs = lag(total_packs),
                     diff = total_packs - prev_packs) %>% 
              select(relweek, shop_desc_clean, total_packs) %>% 
              spread(shop_desc_clean, total_packs) %>% 
              slice(-1) %>% 
              select(-relweek) %>% 
              setNames(c("discounters", "asda", "morri", "sains", "tesco")) %>% 
    ggpairs(lower = list(continuous = wrap(lowerFn, method = "lm")),
            upper = list(continuous = wrap(lowerFn, method = "lm")),
            title = "Relationship in total sales")

sales_diff_reln <- coffee_clean %>% 
                  group_by(relweek, shop_desc_clean) %>% 
                  summarise(total_packs = sum(packs)) %>% 
                  ungroup() %>% 
                  arrange(shop_desc_clean, relweek) %>% 
                  group_by(shop_desc_clean) %>% 
                  mutate(prev_packs = lag(total_packs),
                         diff = total_packs - prev_packs) %>% 
                  select(relweek, shop_desc_clean, diff) %>% 
                  spread(shop_desc_clean, diff) %>% 
                  slice(-1) %>% 
                  select(-relweek) %>% 
                  setNames(c("discounters", "asda", "morri", "sains", "tesco")) %>% 
                  ggpairs(lower = list(continuous = wrap(lowerFn, method = "lm")),
                          upper = list(continuous = wrap(lowerFn, method = "lm")),
                          title = "Relationships of weekly sales changes")


shares_reln <- coffee_clean %>% 
                group_by(relweek, shop_desc_clean) %>% 
                summarise(total_packs = sum(packs),
                          total_vol = sum(volume)) %>% 
                group_by(relweek) %>% 
                mutate(prop = total_packs / sum(total_packs),
                       prop_vol = total_vol / sum(total_vol)) %>% 
                select(relweek, shop_desc_clean, prop) %>% 
                spread(shop_desc_clean, prop) %>% 
                slice(-1) %>% 
                select(-relweek) %>% 
                setNames(c("discounters", "asda", "morri", "sains", "tesco")) %>% 
                ggpairs(lower = list(continuous = wrap(lowerFn, method = "lm")),
                        upper = list(continuous = wrap(lowerFn, method = "lm")),
                        title = "Relationships of weekly market shares")



# Step 3 - Write plots to file --------------------------------------------
ggsave("./project/vis/rough/sales_over_time.svg", sales_over_time)
ggsave("./project/vis/rough/delta_sales.svg", delta_sales)
ggsave("./project/vis/rough/prop_sales_over_time.svg", prop_sales_over_time)

svg("./project/vis/rough/sales_diff_reln.svg")
sales_diff_reln
dev.off()

svg("./project/vis/rough/sales_reln.svg")
sales_reln
dev.off()

svg("./project/vis/rough/shares_reln.svg")
shares_reln
dev.off()
