
# Step 0 - prep env -------------------------------------------------------


# Step 1 - create dfm from corpus -----------------------------------------
# Create the bare dfm
hil_dfm <- dfm(hil_tok, verbose = FALSE)


# Create a relative-frequency weighted dfm
hil_dfm_rel <- weight(hil_dfm, type = "relFreq")


# Step 2 - extract features for further analysis --------------------------
# Count the appearances of features (words) across all documents
feature_counts <- colSums(hil_dfm) %>% 
                    as.matrix(ncol = 1) %>% 
                    data.frame(count = ., row.names = rownames(.)) %>% 
                    add_rownames("feature") %>% 
                    arrange(-count)

# Find only those words that are not too common, but not too rare
to_keep <- feature_counts %>% filter(count > 5 & count <= 500) %>% .$feature 

# Only keep those words
hil_dfm_words <- hil_dfm[, to_keep]            

# Clean up ----------------------------------------------------------------
rm(feature_counts, to_keep)
gc()
