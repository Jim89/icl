
# Step 0 - prep env -------------------------------------------------------

library(quanteda)
library(twitteR)


# Step 1 - set up twitter access and get data -----------------------------
key <- "iagxJa3GhzqsrSU0Lqta7uBpA"
cons_secret <- "PzGoVxz4KwkyIUsmcOwBwCEnJ7jK5XHp7JxOxsHWQWdTYe8RKE"
token <- "1320130406-bMoefPS3yd71l0D51qtTQxSU3sy7dQlS6uG8CCQ"
access_secret <- "9j1v6dlcr3E6flLJFuYRAXiJINK4sswqqek7BenXJv6P2"

setup_twitter_oauth(key, cons_secret, token, access_secret)

tw <- userTimeline("HillaryClinton", n = 3000, includeRts = TRUE)


# Step 2 - Convert and clean data -----------------------------------------
twDF <- twListToDF(tw)

twCorpus <- corpus(twDF$text, docvars = twDF[, -which(names(twDF) == "text")])

# Remove day to get just time
time.ct <- as.POSIXct(twCorpus[["created"]])
offset <- -5
twCorpus[["time.hour"]] <- as.POSIXlt(time.ct)$hour + offset + as.POSIXlt(time.ct)$min/60

twCorpus[["time.roundhour"]] <- round(twCorpus[["time.hour"]])                                      

# Produce a greouped dfm by time
twDfm <- dfm(twCorpus, what = "fasterword",
             ignoredFeatures = c("@*", "#*", "*.*", "http*", stopwords("english")),
             dictionary = liwc)

# Weight the dfm - ie find the relative frequence of each word in each tweet
twDfmWeighted <- weight(twDfm, "relFreq")









