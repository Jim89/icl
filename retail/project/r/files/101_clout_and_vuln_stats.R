# Step 0 - prepare environment -------------------------------------------------
# Define function to calculate brand clout(s) from elasticity matrix (sum of 
# column values, ignoring diagonal)
compute_clouts <- function(elast_mat) {
  diag(elast_mat) <- 0
  elasticities[elast_mat < 0] <- 0
  clouts <- colSums(elast_mat)
  return(clouts)
}

# Define function to calculate brand vulnerability(s) from elasticity matrix (sum of 
# row values, ignoring diagonal)
compute_vulns <- function(elast_mat) {
  diag(elast_mat) <- 0
  elasticities[elast_mat < 0] <- 0
  vulns <- rowSums(elast_mat)
  return(vulns)
}  

# Step 1 - Compute stats for heavy users ---------------------------------------
clouts <- compute_clouts(elasticities)
vulns <- compute_vulns(elasticities)

# Step 3 - Create data frame for light and heavy users -------------------------
# Step 4 - Create single data frame with stats for both sets of users ----------
clout_and_vuln_stats <- cbind(clouts, vulns) %>% 
                        data.frame() %>% 
                        add_rownames() %>% 
                        rename(shop = rowname)

# Step 5 - Clean up ------------------------------------------------------------
rm(clouts, vulns, compute_clouts, compute_vulns)
gc()


