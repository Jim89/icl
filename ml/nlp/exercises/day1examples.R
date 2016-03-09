## TCD Quantitative Text Analysis 2016
##
## Ken Benoit <kbenoit@tcd.ie>

## be sure to install the latest version from GitHub, using dev branch:
devtools::install_github("kbenoit/quanteda")
## and quantedaData
devtools::install_github("kbenoit/quantedaData")


library(quanteda)
library(quantedaData)

## stemming examples
sampletxt <- "The police with their policing strategy instituted a policy of general 
              iterations at the Data Science Institute."
toks <- tokenize(sampletxt, removePunct = TRUE)
toks
wordstem(toks)

# stopwords examples
toks <- tokenize(exampleString, removePunct = TRUE)
removeFeatures(toks, stopwords("english"))
topfeatures(dfm(exampleString, verbose=FALSE))
topfeatures(dfm(exampleString, ignoredFeatures = stopwords("english"), verbose = FALSE))
topfeatures(dfm(exampleString, ignoredFeatures = stopwords("english"), stem = TRUE, verbose = FALSE))


## demonstrate Zipf's law
mydfm <- dfm(inaugCorpus)
plot(log10(1:100), log10(topfeatures(mydfm, 100)),
     xlab="log10(rank)", ylab="log10(frequency)", main="Top 100 Words")
# regression to check if slope is approx -1.0
regression <- lm(log10(topfeatures(mydfm, 100)) ~ log10(1:100))
abline(regression, col="red")
confint(regression)


## constructing bigrams
a <- ngrams(toks, n = 2)
b <- ngrams(toks, n = 2, k = 3)

## detect collocations in UK party manifestos speeches
data(ukManifestos, package = "quantedaData")
colloc <- collocations(subset(ukManifestos, Year==2001))
head(colloc, 20)

## remove any collocations containing a word in the stoplist
removeFeatures(colloc, stopwords("english"))[1:20, ]


summary(ie2010Corpus)

# add a variable for Govt v. Opposition
docvars(ie2010Corpus, "Govt") <- ifelse(docvars(ie2010Corpus, "party") %in% c("FF", "Green"), "Govt", "Opp")
summary(ie2010Corpus)

# key word in context for Christmas
kwic(ie2010Corpus, "christmas")

# apply a dictionary of sentiment
LIWCdict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2015_English_Flat.dic", format = "LIWC")

# apply to govt v. opposition
dfmLIWCgovtopp <- dfm(ie2010Corpus, groups = "Govt", dictionary = LIWCdict)
dfmLIWCgovtopp[, 1:20]
dfmLIWCgovtopp[, "negemo"] / sum(dfmLIWCgovtopp[, "negemo"])
