# Step 0 - prepare environment -------------------------------------------------

# Step 1 - Set up models -------------------------------------------------------
get_elasticities <- function(data, custs = c("heavy", "medium", "light")) {
# Filter data to specific customer groups
  data <- data %>% 
          filter(cust_type %in% custs) %>% 
          select(-cust_type)

  
# Set up overall regression for each brand using all variables
# n.b. the dot (".") syntax stands for "all other variables in the data")
# Log each sales (i.e. units) individual to achieve log-log model
  sains <- lm(sainsburys_sales ~ ., data = data)
  asda <- lm(asda_sales ~ ., data = data)
  tesco <- lm(tesco_sales ~ ., data = data)
  alid <- lm(aldi_sales ~ ., data = data)
  morri <- lm(morrisons_sales ~ ., data = data)


# Stepwise regression to find best model for each brand
  sains_fit <- step(sains, direction = "both", trace = FALSE)
  asda_fit <- step(asda, direction = "both", trace = FALSE) 
  tesco_fit <- step(tesco, direction = "both", trace = FALSE) 
  aldi_fit <- step(alid, direction = "both", trace = FALSE)
  morri_fit <- step(morri, direction = "both", trace = FALSE)

# Step 3 - Compute elasticities ------------------------------------------------
extract_elasticities <- function(model_fit) {
  # Extract tidy coefficients table from model
  coefs <- tidy(model_fit)
  
  # Helper function to extract the parameter for each brand's price
  extract_coef <- function(coef){
    coefs %>% 
      filter(term == coef) %>% 
      select(estimate) %>% 
      as.numeric()
  }
  
  # Use helper function to extract each brand's coefficients for the model
  sains_coef <- extract_coef("sainsburys_price") * mean(data$sainsburys_price)
  asda_coef <- extract_coef("asda_price") * mean(data$asda_price)
  tesco_coef <- extract_coef("tesco_price") * mean(data$tesco_price)
  adli_coef <- extract_coef("aldi_price") * mean(data$aldi_price)
  morri_coef <- extract_coef("morrisons_price") * mean(data$morrisons_price)

  
  # Create matrix that stores results in known order
  results <- matrix(c(sains_coef, asda_coef, tesco_coef, adli_coef, morri_coef), 
                    nrow = 1)
  
  # Set column names
  colnames(results) <- c("sains", "asda", "tesco", "aldi", "morrisons")
  
  # Return results
  return(results)
}

# Compute elasticities for each brand  
sains_elasts <- extract_elasticities(sains_fit) / mean(data$sainsburys_sales)
asda_elasts <- extract_elasticities(asda_fit) / mean(data$asda_sales)
tesco_elasts <- extract_elasticities(tesco_fit) / mean(data$tesco_sales)
aldi_elasts <- extract_elasticities(aldi_fit) / mean(data$aldi_sales)
morri_elasts <- extract_elasticities(morri_fit) / mean(data$morrisons_sales)


# Combine elasticities for each brand into single matrix
elasticities <- rbind(sains_elasts,
                      asda_elasts,
                      tesco_elasts,
                      aldi_elasts,
                      morri_elasts)


# Set rownames to be the same as column names
rownames(elasticities) <- colnames(elasticities)

# Tidy up NA values to be 0
elasticities[is.na(elasticities)] <- 0

# Step 3 - Compute elasticity significances (as some may be insignificant) -----
extract_signifs <- function(model_fit) {
  # Extract tidy coefficients table from model
  coefs <- tidy(model_fit)
  
  # Helper function to extract the parameter for each brand's price
  extract_p <- function(coef){
    coefs %>% 
      filter(term == coef) %>% 
      select(p.value) %>% 
      as.numeric()
  }
  
  # Use helper function to extract each brand's coefficients for the model
  sains_p <- extract_p("sainsburys_price")
  asda_p <- extract_p("asda_price")
  tesco_p <- extract_p("tesco_price")
  aldi_p <- extract_p("aldi_price")
  morri_p <- extract_p("morrisons_price")

  
  # Create matrix that stores results in known order
  results <- matrix(c(sains_p, asda_p, tesco_p, aldi_p, morri_p), nrow = 1)
  
  # Set column names
  colnames(results) <- c("sains", "asda", "tesco", "aldi", "morrisons")
  
  # Return results
  return(results)
}

sains_signifs <- extract_signifs(sains_fit)
asda_signifs <- extract_signifs(asda_fit)
tesco_signifs <- extract_signifs(tesco_fit)
aldi_signifs <- extract_signifs(aldi_fit)
morri_signifs <- extract_signifs(morri_fit)


signifs <- rbind(sains_signifs,
                 asda_signifs,
                 tesco_signifs,
                 aldi_signifs,
                 morri_signifs)

rownames(signifs) <- colnames(signifs)

signifs[signifs > 0.05] <- 0
signifs[signifs <= 0.05] <- 1
signifs[is.na(signifs)] <- 0


# Step 4 - Set elasticities = 0 if they are insignificant in the model, or NA --
elasticities <- elasticities * signifs

return(elasticities)
}

elasticities <- get_elasticities(coffee_wide, custs = c("heavy", "light", "medium"))

# Step 5 - Clean up and garbage collect ----------------------------------------
objects <- ls()
idx <- grep("coffee_clean|coffee_wide|coffee_long|elasticities|theme_jim|toproper|ggally_cor|check_class|check_length|check_type|coalesce|replace_with", objects)
objects <- objects[-idx]

rm(list = objects)
rm(objects, get_elasticities, idx)
gc()
