# Step 0 - load packages -------------------------------------------------------
library(dplyr)
library(ggplot2)
library(GGally)

# Step 1 - read data -----------------------------------------------------------
data <- read.csv("./data/InstantCoffee.csv", 
                   encoding = "latin1", 
                   stringsAsFactors = FALSE) %>% 
          as_data_frame()

colnames(data) <- tolower(colnames(data))

rows <- nrow(data)
complete_rows <- complete.cases(data) %>% sum

cols <- ncol(data)
complete_cols <- apply(apply(data, 2, complete.cases), 2, sum)


# Step 2 - Create some plots of rows by values ---------------------------------
# Create function to draw histogram
gg_hist <- function(data, field){
  is_num <- is.numeric(data[ , field])
  name <- paste0("./explorations/images/", field, ".svg")
  if (is_num == TRUE) {
    plot <- ggplot(data, aes_string(x = field)) +
      geom_histogram(fill = "steelblue", colour = "white") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = -90))
  } else {
    plot <- ggplot(data, aes_string(x = field)) +
      geom_bar(fill = "steelblue", colour = "white") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = -90))
  }
  # plot <- ggplotly(plot)
  ggsave(file = name, plot = plot, width = 10, height = 8)
}  

columns <- colnames(data)
lapply(columns, function(x) gg_hist(data, x))


