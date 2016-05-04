# Step 0 - prep env -------------------------------------------------------
# Inspired by: https://www.kaggle.com/operdeck/d/kaggle/hillary-clinton-emails/hillary-s-sentiment-about-countries/code
#add "RE" because the iso3 code for Reunion islands.. but it appears a lot in
#emails to indicate the RE(sponses) to previous emails.
#FM 
#TV is ISO2 code for Tuvalu but also refers to Television
#AL is a given name and also ISO2 for Albania
#BEN is a given name and also ISO3 for Benin
#LA is Los angeles and iso 2 for Lao
#AQ is abbreviation of "As Quoted" and iso 2 for Antarctica
# Certain ISO codes will actually be words that may be found in the emails.
# Luckily, they're all for very minor countries, so we'll get rid of them:
to_remove <- c("RE", # Reunion Islands, but also RE: (reply)
               "PM", # Saint Pierre and Miquelon and "afternoon"
               "FM", 
               "TV", # Tuvalu and television
               "LA", # Lao and Los Angeles
               "AL", # Albania and a given name
               "BEN", # Benin and a given name
               "AQ") # Antarctica and "as quoted"


# Step 1 - Source data and clean up ---------------------------------------
# Set up country data - remove records without ISO country code (na.omit) as 
# they are regions/no longer in existence and contaminate the data
cntry <- countrycode_data %>% 
            select(country.name, iso2c, iso3c, regex, continent, region) %>% 
            na.omit()

# Find countries that are words that may have been used and exclude them (no major countries)
idx <- cntry$iso2c %in% to_remove
idx2 <- cntry$iso3c %in% to_remove
cntry <- cntry[!as.logical(idx + idx2), ]



# Step 2 - search for countries ------------------------------------------------
# Search for countries by name and ISO codes
cntry_results <- search_in_emails(tolower(cntry$country.name))
iso2c_results <- search_in_emails(tolower(cntry$iso2c))
iso3c_results <- search_in_emails(tolower(cntry$iso3c))

# Have to use a slightly different method for regex matching, looping over them
regex_results <- lapply(seq_along(cntry$regex), 
                        function(x) search_in_emails(cntry$regex[x], 
                                                     method = "regex"))
# Re-combine in to matrix
regex_results <- do.call(rbind, regex_results)


# Step 3 - combine results ------------------------------------------------
# Combine direct results in to one table
cntry_matches <- cntry_results + iso2c_results + iso3c_results + regex_results

# Set row and column names
rownames(cntry_matches) <- cntry$country.name
colnames(cntry_matches) <- names(hil_tok)

# Clean up into tidy table
cntry_matches <- t(cntry_matches)
cntry_matches <- cntry_matches %>% 
                    as.data.frame() %>% 
                    dplyr::as_data_frame() %>% 
                    mutate(doc = names(hil_tok)) %>% 
                    gather(cntry, matches, -doc) %>% 
                    filter(matches > 0) %>% 
                    select(-matches) %>% 
                    left_join(cntry, by = c("cntry" = "country.name")) %>% 
                    select(-c(iso2c, iso3c, regex))


# Step 4 - clean up -------------------------------------------------------
rm(cntry_results, iso2c_results, iso3c_results, regex_results, idx, idx2,
   cntry, to_remove)
gc()
