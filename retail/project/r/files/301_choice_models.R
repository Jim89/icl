# Step 0 - prep env -------------------------------------------------------
# Function to fit choice model for difference customer types
fit_choice_model <- function(custs) {

# Set up data
choice_data <- mlogit.data(coffee_long %>% filter(cust_type == custs),
                           choice = "choice",
                           shape = "long",
                           alt.var = "shop",
                           chid.var = "transaction_id",
                           id.var = "house")

choice_fit <- mlogit(choice ~ price + promo_price + promo_units + loyalty, data = choice_data)

return(choice_fit)

}

# Step 1 - fit models -----------------------------------------------------

choice_heavy <- fit_choice_model("heavy")
choice_light <- fit_choice_model("light")


# Step 2 - clean up -------------------------------------------------------

rm(fit_choice_model)
gc(verbose = FALSE)
