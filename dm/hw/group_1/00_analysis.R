
# Step 0 - prep env -------------------------------------------------------

library(dplyr)
library(RPostgreSQL)

db <- src_postgres(dbname = "dm", 
                   host = "localhost",
                   port = "5432",
                   user = "postgres",
                   password = "gy!be1989")


# Step 1 - get the data ---------------------------------------------------

lines <- tbl(db, "lines_clean")
orders <- tbl(db, "orders_clean")
contacts <- tbl(db, "contacts_clean")
sum_tabl <- tbl(db, "summary_table")
