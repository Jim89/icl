# Get the text
extracts <- emails$ExtractedBodyText

# Find commonly-used words
toks <- tokenize(extracts, removeNumbers = T, removePunct = T, 
                 removeSeparators = T, removeHyphens = T)
toks <- removeFeatures(toks, stopwords("english"))
toks <- unlist(toks) 

# find counts and props
count_toks <- table(toks)
prop_toks <- count_toks/sum(count_toks)


# Build dfm
extracts <- emails$ExtractedBodyText
names(extracts) <- emails$DocNumber

email_dfm <- dfm(extracts, ignoredFeatures = stopwords("english"))


