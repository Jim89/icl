# Step 0 - load packages -------------------------------------------------------
library(dplyr)
library(ggplot2)
library(GGally)

# Step 1 - read data -----------------------------------------------------------
data <- read.csv("./data/InstantCoffee.csv", 
                   encoding = "latin1", 
                   stringsAsFactors = FALSE) %>% 
          as_data_frame()

rows <- nrow(data)
complete_rows <- complete.cases(data) %>% sum

cols <- ncol(data)
complete_cols <- apply(apply(data, 2, complete.cases), 2, sum)


# Step 2 - Create some plots of rows by values ---------------------------------
row_plot <- function(data, field){
  if (!dir.exists("./explorations/images")) {dir.create("./explorations/images")}
  name <- paste0("./explorations/images/", field, ".svg")
  # svg(file = name)
  data %>% 
    group_by_(field) %>% 
    tally() %>% 
    ggplot(aes_string(x = field, y = "n")) +
    geom_bar(stat = "identity", fill = "steelblue", colour = "white") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = -90))
  # dev.off()
}  
  
shops <- row_plot(data, "shop_desc")
brands <- row_plot(data, "brand_name")
brands_higher <- row_plot(data, "total_range_name")
subcats <- row_plot(data, "sub_cat_name")
promotions <- row_plot(data, "epromdesc")

ggsave("./explorations/images/shop_desc.png", shops)
ggsave("./explorations/images/brand_name.png", brands)
ggsave("./explorations/images/total_range_name.png", brands_higher)
ggsave("./explorations/images/sub_cat_name.png", subcats)
ggsave("./explorations/images/epromdesc.png", promotions)

