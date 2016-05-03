
# Step 0 - prep env -------------------------------------------------------

library(readr)
library(dplyr)
library(tidyr)
library(quanteda)
library(igraph)
library(networkD3)
library(stringr)
library(countrycode)

# Step 1 - run analysis step by step --------------------------------------

source("./r/files/00_get_data.R")
source("./r/files/01_to_from.R")
source("./r/files/10_clean_emails.R")
