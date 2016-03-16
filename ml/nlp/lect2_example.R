## Code for examples from Day 2 of text analysis
## Ken Benoit <kbenoit@lse.ac.uk>

require(quanteda)

##
## hiearchical clustering
##
data(SOTUCorpus, package = "quantedaData")

# create a DFM after removing stopwords and stemming
presDfm <- dfm(subset(SOTUCorpus, Date > as.Date("1960-01-01")), 
               ignoredFeatures = stopwords("english"), stem = TRUE)

# reduce the feature set through thresholds
presDfm <- trim(presDfm, minCount = 5, minDoc = 3)

## hierarchical clustering
# get distances on normalized dfm
presDistMat <- dist(as.matrix(weight(presDfm, "relFreq")))

# hiarchical clustering the distance object
presCluster <- hclust(presDistMat)

# label with document names
presCluster$labels <- docnames(presDfm)

# plot as a dendrogram
plot(presCluster)

## hierarchical clustering on words
# weight by relative term frequency
wordDfm <- sort(tf(presDfm, "prop"))  # sort in decreasing order of total word freq
wordDfm <- t(wordDfm)[1:100, ]  
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm),
     xlab="", main="Relative Term Frequency weighting")

# repeat without word "will"
wordDfm <- removeFeatures(wordDfm, "will")
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm), 
     xlab="", main="Relative Term Frequency without \"will\"")

# with tf-idf weighting
wordDfm <- sort(tf(presDfm, "prop"))  # sort in decreasing order of total word freq
wordDfm <- removeFeatures(wordDfm, c("will", "year", "s"))
wordDfm <- t(wordDfm)[1:100,]  # because transposed
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm),
     xlab="", main="tf-idf Frequency weighting")




##
## topic models with visualization
##

# load movies and create a dfm
data(movies, package = "quantedaData")

# create a document-feature matrix, without stopwords, and with reduced features
moviesDfm <- dfm(movies, ignoredFeatures = stopwords("SMART"), stem = FALSE)
moviesDfm <- trim(moviesDfm, minCount = 5)

# MCMC and model tuning parameters:
K <- 20
G <- 100
alpha <- 0.02
eta <- 0.02

# convert to lda format
moviesDfmlda <- convert(moviesDfm, to = "lda")

# fit the model
require(lda)
set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = moviesDfmlda$documents, K = K, 
                                   vocab = moviesDfmlda$vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # about 11 minutes on Ken's iMac
# save(fit, file = "Notes/Day 9 - Topic Models/fit.RData")
# load("Notes/Day 9 - Topic Models/fit.RData")

require(LDAvis)
# create the JSON object to feed the visualization:
json <- createJSON(phi = (fit$topics + eta) / rowSums(fit$topics + eta), 
                   theta = (fit$document_sums + alpha) / rowSums(fit$document_sums + alpha), 
                   doc.length = ntoken(moviesDfm), 
                   vocab = features(moviesDfm), 
                   term.frequency = colSums(moviesDfm))
serVis(json)



##
## redo the topic model substituting collocations for words
##

moviesCollocations <- collocations(movies, method = "lr", size = 2)
head(moviesCollocations, 20)
moviesCollocations <- removeFeatures(moviesCollocations, stopwords("SMART"))
head(moviesCollocations, 20)

# replace collocations with top 1000 concatenated phrases
# note: the indexing for moviesCollocations uses the data.table "[" method
moviesCorpusPhrases <- corpus(phrasetotoken(texts(movies), moviesCollocations[1:1000]))
moviesDfmPhrases <- dfm(moviesCorpusPhrases, ignoredFeatures = stopwords("SMART"), stem = TRUE)
set.seed(0315)
# convert to lda format
moviesDfmPhraseslda <- convert(moviesDfmPhrases, to = "lda")
t1 <- Sys.time()
fit2 <- lda.collapsed.gibbs.sampler(documents = moviesDfmPhraseslda$documents, K = K, 
                                   vocab = moviesDfmPhraseslda$vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # about 11 minutes on Ken's iMac
# save(fit2, file = "Notes/Day 9 - Topic Models/fit2.RData")
# load("Notes/Day 9 - Topic Models/fit2.RData")

require(LDAvis)
# create the JSON object to feed the visualization:
json2 <- createJSON(phi = (fit2$topics + eta) / rowSums(fit2$topics + eta), 
                   theta = (fit2$document_sums + alpha) / rowSums(fit2$document_sums + alpha), 
                   doc.length = ntoken(moviesDfmPhrases), 
                   vocab = features(moviesDfmPhrases), 
                   term.frequency = colSums(moviesDfmPhrases))
serVis(json2)



