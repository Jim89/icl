hil_dfm <- dfm(hil_tok)
hil_dfm <- hil_dfm[, topfeatures(hil_dfm, 150)]
hil_dfm <- weight(hil_dfm, "relFreq")
hil_mat <- as.matrix(hil_dfm)


cluster <- function(dfm) {
    mat <- as.matrix(dfm)

    ## hierarchical clustering
    # get distances on normalized dfm
    presDistMat <- dist(mat)
    # hiarchical clustering the distance object
    presCluster <- hclust(presDistMat)
    
    # label with document names
    presCluster$labels <- docnames(dfm)
    
    # plot as a dendrogram
    plot(presCluster)
}    

cluster(hil_dfm_senti)
