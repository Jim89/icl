
# Step 0 - prep env -------------------------------------------------------

library(dplyr)
library(RPostgreSQL)
library(tidyr)
library(ggplot2)

db <- src_postgres(dbname = "dm")

# Set up theme object for prettier plots
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


# Step 1 - get the data ---------------------------------------------------

lines <- tbl(db, "lines_clean")
orders <- tbl(db, "orders_clean")
contacts <- tbl(db, "contacts_clean")
sum_tabl <- tbl(db, "summary_table")
