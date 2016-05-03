
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
liwc <- dictionary(file = "./data/LIWC2015_English_Flat.dic", format = "LIWC")


