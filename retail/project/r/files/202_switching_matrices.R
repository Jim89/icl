# Step 0 - prep env ------------------------------------------------------------
# Function to compute switching matrix
switching_mat <- function(custs) {
  data <- coffee_clean %>% 
    filter(cust_type %in% custs) %>% 
    arrange(house, relweek, visit_id) %>% 
    select(house, relweek, visit_id, shop_desc_clean) %>% 
    distinct() %>% 
    group_by(house) %>% 
    mutate(prev_shop = lag(shop_desc_clean)) %>% 
    ungroup() %>% 
    arrange(house, visit_id)
  
  switching_mat <- table(data$shop_desc_clean, data$prev_shop) %>% 
    as.matrix()
  
  return(switching_mat)
}  

# Function to approximate repeat-purchase loyalties from switching mat
get_loyalties <- function(mat) {
  rep <- diag(mat)
  current <- rowSums(mat)
  mat2 <- mat
  diag(mat2) <- 0
  old <- colSums(mat2)
  
  loy <- rep / (current + old)
  
  return(loy)
}

# Step 1 - Generate switching matrices -----------------------------------------
switch_mat_l <- switching_mat(c("light"))
switch_mat_m <- switching_mat(c("medium"))
switch_mat_h <- switching_mat(c("heavy"))

# Compute repeat-purchase loyalty
loyalties_l <- get_loyalties(switch_mat_l)
loyalties_m <- get_loyalties(switch_mat_m)
loyalties_h <- get_loyalties(switch_mat_h)

# Step 2 - clean up -------------------------------------------------------

rm(switching_mat, get_loyalties)
gc(verbose = FALSE)
