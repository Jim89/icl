
# Step 0 - prep env -------------------------------------------------------


# Step 1 - create dfm from corpus -----------------------------------------
# Apply the dictionary in a new dfm
hil_dfm_liwc <- dfm(hil_tok, dictionary = liwc, verbose = FALSE)


# Step 2 - extract further features for analysis --------------------------
# Emotional content
emot <- c("posemo", "negemo", "anx", "anger", "sad")
hil_dfm_senti <- hil_dfm_liwc[, emot]
hil_dfm_senti <- weight(hil_dfm_senti, type = "relFreq")


# Past vs. present vs. future
tenses <- c("focuspast", "focuspresent", "focusfuture")
hil_dfm_focus <- hil_dfm_liwc[ , tenses]
hil_dfm_focus <- weight(hil_dfm_focus, type = "relFreq")

# Word use
pos_tags <- c("pronoun", "article", "prep", "auxverb", "adverb", "conj", 
              "verb", "adj", "netspeak")
hil_dfm_pos <- hil_dfm_liwc[ , pos_tags]
hil_dfm_pos <- weight(hil_dfm_pos, type = "relFreq")


# Clean up ----------------------------------------------------------------
rm(emot, tenses, pos_tags)
gc()
