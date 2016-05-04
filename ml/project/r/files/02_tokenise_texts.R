
# Step 0 - prep env -------------------------------------------------------


# Step 1 - create corpus and tokenise -------------------------------------
# Use emails clean data and remove "to" to get unique documents
uniques <- emails_clean %>% 
    select(-to) %>% 
    distinct()

# Build a corpus with quanteda
hil_corp <- corpus(uniques$body, docvars = uniques[, c(2:6)],
                   docnames = uniques$DocNumber)

# Tokenise and remove stopwords from the corpus
hil_tok <- quanteda::tokenize(hil_corp, removeNumbers = T, removePunct = T, 
                              removeSeparators = T, removeHyphens = T) %>% 
    removeFeatures(c(stopwords("english"), "will"))

# Step 2 - clean up -------------------------------------------------------
rm(uniques)
gc()
