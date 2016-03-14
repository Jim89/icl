library(conjoint)
library(dplyr)

levels <- read.table("./data/LevelsAppTab.txt")
ratings <- read.table("./data/RatingsAppTab.txt")

# Set up possible attributes
attribute <- list(Brand = c("Brand1","Brand2"),
                  Stars = c("Two","Three","Four"),
                  Price = c("3.49","1.19","0.59", "0"))

# Expand to every possible combination of attributes
profiles <- expand.grid(attribute)

# Set up design - n.b. rownames are number of profile from all possible combos
# builds them from orthogonal (uncorrelated) combinations of attributes.
# Each row in design = combination of features to be rated by the user
design <- caFactorialDesign(data = profiles,
                            type = "fractional",
                            cards = 16)

# Package requires ratings to be stacked in to 1 single, long, column, first n
# rows are the ratings for the first user each of the n cards set up in the design
# second n rows are the ratings for each of the n cards of the second user, and so on.
# Levels

fit <- Conjoint(ratings, design, levels)


first_person_fit <- lm(ratings[1:16, ] ~ design$Price + design$Stars + design$Brand)

ratings %>% 
  mutate(id = rep(1:60, each = 16))
