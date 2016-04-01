# Step 0 - prep env -------------------------------------------------------
# Load packages
library(countreg)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)
library(GGally)

# Set up theme object
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

# Step 1 - get and clean --------------------------------------------------

source("./project/r/files/000_clean_and_filter.R")
source("./project/r/files/001_light_vs_heavy.R")
source("./project/r/files/002_clean_brands.R")


# Step 2 - switching and cooccurrence -------------------------------------

source("./project/r/files/401_cooccurence_matrices.R")
source("./project/r/files/402_switching_matrices.R")


# Step 3 - Modelling traffic ----------------------------------------------

source("./project/r/files/102_traffic_models.R")
