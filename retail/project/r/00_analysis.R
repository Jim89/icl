# prep env ---------------------------------------------------------------------
# Load packages
library(countreg)
library(dplyr)
library(tidyr)
library(magrittr)
library(mlogit)
library(ggplot2)
library(GGally)
library(broom)

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

# source extra functions
source("./project/r/functions/toproper.R")
source("./project/r/functions/ggally_cor.R")

# Step 0 - get and clean --------------------------------------------------
source("./project/r/files/000_clean_and_filter.R")
source("./project/r/files/002_clean_brands.R")
source("./project/r/files/004_create_id.R")
source("./project/r/files/001_light_vs_heavy.R")
source("./project/r/files/009_coffee_wide.R")
source("./project/r/files/010_coffee_long.R")

# Step 1 - elasticity modelling ----------------------------------------------
source("./project/r/files/100_elasticity_models.R")
source("./project/r/files/101_clout_and_vuln_stats.R")


# Step 2 - switching matrices ---------------------------------------------
source("./project/r/files/201_cooccurence_matrices.R")
source("./project/r/files/202_switching_matrices.R")
source("./project/r/files/203_market_share_correlation.R")


# Step 3 - user type level modelling --------------------------------------
# shop choice
source("./project/r/files/301_choice_models.R")
# shop traffic
source("./project/r/files/302_traffic_models.R")

# Step 5 - Prepare further visualisations ---------------------------------

source("./project/r/files/501_vis_weekly_share_to_prop_promo.R")
source("./project/r/files/502_clout_and_vuln_map.R")
source("./project/r/files/503_repeat_purchase_rate.R")


