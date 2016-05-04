# https://www.kaggle.com/operdeck/d/kaggle/hillary-clinton-emails/hillary-s-sentiment-about-countries/code
#add "RE" because the iso3 code for Reunion islands.. but it appears a lot in
#emails to indicate the RE(sponses) to previous emails.
#FM 
#TV is ISO2 code for Tuvalu but also refers to Television
#AL is a given name and also ISO2 for Albania
#BEN is a given name and also ISO3 for Benin
#LA is Los angeles and iso 2 for Lao
#AQ is abbreviation of "As Quoted" and iso 2 for Antarctica

# Set up country data - remove records without ISO country code as they are
# regions/no longer in existence and contaminate the data
cntry <- countrycode_data %>% 
            select(country.name, iso2c, iso3c, regex, continent, region) %>% 
            na.omit()

# Find countries that are words that may have been used and exclude them (no major countries)
idx <- cntry$iso2c %in% c("RE", "PM", "FM", "TV", "LA", "AL", "BEN", "AQ")
idx2 <- cntry$iso3c %in% c("RE", "PM", "FM", "TV", "LA", "AL", "BEN", "AQ")
cntry <- cntry[!as.logical(idx + idx2), ]




# Search for countries by name and ISO codes
cntry_results <- search_in_emails(tolower(cntry$country.name))
iso2c_results <- search_in_emails(tolower(cntry$iso2c))
iso3c_results <- search_in_emails(tolower(cntry$iso3c))

# Combine direct results in to one table
match_results <- cntry_results + iso2c_results + iso3c_results
rownames(match_results) <- cntry$country.name
colnames(match_results) <- names(hil_tok)

# Have to use a slightly different method for regex matching, looping over the regex's
regex_results <- lapply(seq_along(cntry$regex), 
                        function(x) search_in_emails(cntry$regex[x], 
                                                     method = "regex"))
# Re-combine in to matrix
regex_results <- do.call(rbind, regex_results)

# Summarise all results
cntry_matches <- match_results + regex_results

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
