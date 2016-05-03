
# Step 0 - prep env -------------------------------------------------------


# Step 1 - get data -------------------------------------------------------

# Get Clinton data
emails <- read_csv("./data/Emails.csv")
aliases <- read_csv("./data/Aliases.csv")
receivers <- read_csv("./data/EmailReceivers.csv")
people <- read_csv("./data/Persons.csv")

# Set rownames for easier use later
rownames(emails) <- emails$DocNumber

# Get dictionary
LIWCdict <- dictionary(file = "./data/LIWC2015_English_Flat.dic", format = "LIWC")

# Step 2 - join data ------------------------------------------------------

person_lk <- aliases %>% 
                left_join(receivers, by = c("PersonId" = "PersonId")) %>% 
                select(-c(Id.x, Id.y)) %>% 
                left_join(people, by = c("PersonId" = "Id")) %>% 
                select(PersonId, EmailId, Name, Alias) %>% 
                setNames(c("person_id", "email_id", "name", "alias"))

