# Step 0 - prep env -------------------------------------------------------
library(dplyr)


db <- src_postgres("lsca")

# Step 1 - get data -------------------------------------------------------
# Set up sql command to get all relevant tables
sql <- sql("select * from information_schema.tables where table_schema = 'public'")

# Get the set of tables
tbls <- tbl(db, sql) %>% collect() %>% .$table_name

# Loop over table names to pull in the data
for(i in seq_along(tbls)) {
  assign(tbls[i], tbl(db, tbls[i]))
}


# Step 2 - clean up -------------------------------------------------------
rm(sql, tbls, i)




