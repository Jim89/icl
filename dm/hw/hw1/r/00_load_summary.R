# Load necessary packages
library(dplyr)
library(readr)
library(RPostgreSQL)

# Read in summary data
sum <- read_csv("./data/hw1/DMEFExtractSummaryV01.CSV",
                col_types = cols(Cust_ID = col_character(),
                                 SCF_Code = col_character()))

names(sum) <- names(sum) %>% tolower() 

# Connect to database
db <- src_postgres(dbname = "dm")
                 

# Copy summary table to database
summary_db <- copy_to(db, sum, name = "summary_table",
                      temporary = FALSE, indexes = list("cust_id"))






