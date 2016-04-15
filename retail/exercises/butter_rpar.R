library(mlogit)

# Read in data
data <- read.table("./data/ButterDataTab.txt")

# Transform data in to logit data frame (for easy modelling)
data_clean <- mlogit.data(data, 
                          choice = "choice", # tells which brand was chosen
                          shape = "long", # tells R shape of data (could be "wide")
                          alt.var = "brand",  # INdicated the item the line corresponds
                          chid.var = "transaction", # INdicate how transactions are grouped
                          id.var = "id") # Indicates that there are repeat observations per person

# Fit the model
model5 <- mlogit(choice ~ price + feature + display,
                 data = data_clean,
                 rpar = c("2:(intercept)"="n","3:(intercept)"="n","4:(intercept)"="n","5:(intercept)"="n",price="n"),
                 R = 10, halton = NA, print.level = 1)