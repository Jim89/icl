# Remove "to" to get unique documents
unqiues <- emails_clean %>% 
            select(-to) %>% 
            distinct()
# Build a corpus
hil_corp <- corpus(unqiues$body, docvars = unqiues[, c(2:6)],
                   docnames = unqiues$DocNumber)

# Tokenise and remove stopwords
hil_tok <- quanteda::tokenize(hil_corp, removeNumbers = T, removePunct = T, 
                              removeSeparators = T, removeHyphens = T) %>% 
            removeFeatures(c(stopwords("english"), "will"))


# Translate to dfm and apply dict to get emotional content
hil_dfm <- dfm(hil_tok, dictionary = liwc)

summary(hil_corp)
