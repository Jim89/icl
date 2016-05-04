
# Step 0 - prep env -------------------------------------------------------
# Load packages
library(readr)
library(dplyr)
library(tidyr)
library(quanteda)
library(countrycode)
library(igraph)
library(networkD3)
library(stringr)
library(countrycode)
library(ggplot2)

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

# Source user-defined functions
source("./r/functions/search_in_emails.R")

# Step 1 - run analysis step by step --------------------------------------

source("./r/files/00_get_data.R")
source("./r/files/01_to_from.R")
source("./r/files/02_tokenise_texts.R")
source("./r/files/03_country_matching.R")
source("./r/files/10_clean_emails.R")
