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
hil_dfm <- dfm(hil_tok, dict = liwc)

# Extract just the relevant features
hil_dfm <- hil_dfm[ , c("posemo", "negemo", "anger", "sad", "social", "family",
                        "friend", "feel", "risk", "reward", "work", "money",
                        "relig", "death", "informal", "swear")]
hil_dfm <- tf(hil_dfm, "prop")

# Extract just the relevant features
hil_dfm <- hil_dfm[ , c("posemo", "negemo")]
hil_dfm <- tf(hil_dfm, "prop")
emots <- as.matrix(hil_dfm) %>% 
            as.data.frame() %>% 
            dplyr::as_data_frame() %>% 
            mutate(DocNumber = rownames(hil_dfm))
        
avg_emots <- emails_clean %>% 
                left_join(emots) %>% 
                group_by(from) %>% 
                summarise(pos = mean(posemo, na.rm = T),
                          neg = mean(negemo, na.rm = T)) %>% 
                mutate(neg = -neg) %>% 
                na.omit() 

ggplot() +
    geom_bar(stat = "identity", data = avg_emots, aes(x = from, y = pos), 
             fill = "steelblue", colour = "white") +
    geom_bar(stat = "identity", data = avg_emots, aes(x = from, y = neg), 
             fill = "firebrick", colour = "white") +
    coord_flip() +
    theme_jim +
    theme(axis.text.y = element_text(size = 8))
        
        
