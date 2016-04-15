# Step 0 - set up environment --------------------------------------------------
model_selection <- function(data, model = c("level", "semi-log", "log-log")) {

if (model == "log-log") {
  subset <- data[ ,grepl("price",colnames(data))]
  data <- cbind(apply(subset, 2, log), data[, !grepl("price", colnames(data))])
} else if (model %in% c("level", "semi-log")) {
  data <- data
} else {
  stop()
}

# Define function to create test and cross-validation indices on data. Sourced from:
# http://stackoverflow.com/questions/7402313/generate-sets-for-cross-validation-in-r
f_K_fold <- function(Nobs,K=5){
  rs <- runif(Nobs)
  id <- seq(Nobs)[order(rs)]
  k <- as.integer(Nobs*seq(1,K-1)/K)
  k <- matrix(c(0,rep(k,each=2),Nobs),ncol=2,byrow=TRUE)
  k[,1] <- k[,1]+1
  l <- lapply(seq.int(K),function(x,k,d) 
    list(train=d[!(seq(d) %in% seq(k[x,1],k[x,2]))],
         cv=d[seq(k[x,1],k[x,2])]),k=k,d=id)
  return(l)
  
}

# Step 1 - set up cross-validation parameters ----------------------------------
# Set k in k-fold
K <- 5

# Set the seed to get reproducible cross-validation partitions
set.seed(19891110)

# Generate train and cross-validation set partition indices
folds <- f_K_fold(nrow(data), K = K)

# Create object ot hold average MSE for the 6 models for each k-fold CV iteration
errors <- rep(NA, K)

# Step 2 - perform k-fold validation -------------------------------------------
for (i in 1:K) {
  
  # Get train and CV-set indices from helper function output
  train_idx <- folds[[i]]$train
  cv_idx <- folds[[i]]$cv
  
  # Split the data in to train and cross-validation set using those indices
  # Drop the first column (the week number) as it is redundant in the model)
  train <- data[train_idx, ]
  cv <- data[cv_idx, ]
  
  # Set up overall regression for each brand using all variables
  # REMEMBER TO CHANGE THE FUNCTIONAL FORM FOR LOG-LEVEL AND LOG-LOG
  # n.b. the dot (".") syntax stands for "all other variables in the data")
  if (model == "semi-log") {
  sains <- lm(log(sainsburys_sales) ~ ., data = train)
  asda <- lm(log(asda_sales) ~ ., data = train)
  tesco <- lm(log(tesco_sales) ~ ., data = train)
  alid <- lm(log(aldi_sales) ~ ., data = train)
  morri <- lm(log(morrisons_sales) ~ ., data = train)

  } else if (model == "log-log") {
    sains <- lm(log(sainsburys_sales) ~ ., data = train)
    asda <- lm(log(asda_sales) ~ ., data = train)
    tesco <- lm(log(tesco_sales) ~ ., data = train)
    alid <- lm(log(aldi_sales) ~ ., data = train)
    morri <- lm(log(morrisons_sales) ~ ., data = train)
    
  } else {
    sains <- lm(sainsburys_sales ~ ., data = train)
    asda <- lm(asda_sales ~ ., data = train)
    tesco <- lm(tesco_sales ~ ., data = train)
    alid <- lm(aldi_sales ~ ., data = train)
    morri <- lm(morrisons_sales ~ ., data = train)
  }
  
  # Stepwise regression to find best model for each brand
  sains_fit <- step(sains, direction = "both", trace = FALSE)
  asda_fit <- step(asda, direction = "both", trace = FALSE) 
  tesco_fit <- step(tesco, direction = "both", trace = FALSE) 
  aldi_fit <- step(alid, direction = "both", trace = FALSE)
  morri_fit <- step(morri, direction = "both", trace = FALSE)

  
  # Generated predicted sales with the cross-validation set for each brand
  sains_pred <- predict(sains_fit, newdata = cv)
  asda_pred <- predict(asda_fit, newdata = cv)
  tesco_pred <- predict(tesco_fit, newdata = cv)
  aldi_pred <- predict(aldi_fit, newdata = cv)  
  morri_pred <- predict(morri_fit, newdata = cv)

  
  # Create a small helper function to compute Mean Squared Error
  mse <- function(actual, predicted) {
    diff <- actual - predicted
    diff_sq <- diff^2
    return(mean(diff_sq, na.rm = TRUE))
  }
  
  if (model == "level") {
    # Compute the cross-validation error (MSE) for each brand
    sains_error <- mse(cv$sainsburys_sales, sains_pred)
    asda_error <- mse(cv$asda_sales, asda_pred)
    tesco_error <- mse(cv$tesco_sales, tesco_pred)
    aldi_error <- mse(cv$aldi_sales, aldi_pred)
    morri_error <- mse(cv$morrisons_sales, morri_pred)

  } else if (model == "semi-log") {
    # Compute the cross-validation error (MSE) for each brand
    sains_error <- mse(cv$sainsburys_sales, exp(sains_pred))
    asda_error <- mse(cv$asda_sales, exp(asda_pred))
    tesco_error <- mse(cv$tesco_sales, exp(tesco_pred))
    aldi_error <- mse(cv$aldi_sales, exp(aldi_pred))
    morri_error <- mse(cv$morrisons_sales, exp(morri_pred))
    
  } else if (model == "log-log") {
    # Compute the cross-validation error (MSE) for each brand
    sains_error <- mse(cv$sainsburys_sales, exp(sains_pred))
    asda_error <- mse(cv$asda_sales, exp(asda_pred))
    tesco_error <- mse(cv$tesco_sales, exp(tesco_pred))
    aldi_error <- mse(cv$aldi_sales, exp(aldi_pred))
    morri_error <- mse(cv$morrisons_sales, exp(morri_pred))
    
  } else {
    stop()
  }
  
  # Compute average error across each of the 6 brands
  avg_error <- mean(sains_error, asda_error, tesco_error, aldi_error,
                    morri_error, na.rm = TRUE)
  
  # Pass average error back to errors object
  errors[i] <- avg_error
}

# Step 3 - Compute single average of errors from accross the CV iterations -----
overall_average_error <- mean(errors, na.rm = TRUE)

return(overall_average_error)

}

results <- data_frame(model = c("level", "semi-log", "log-log")) %>% 
            rowwise() %>% 
            mutate(mse = model_selection(coffee_wide, model))

write.csv(results, "./project/r/misc/cross_val_model_selection.csv")
