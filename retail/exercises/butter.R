library(readr)
library(dplyr)
library(mlogit)
library(broom)

# Read in data
data <- read.table("./data/ButterDataTab.txt") %>% 
        as_data_frame()


# Transform data in to logit data frame (for easy modelling)
data_clean <- mlogit.data(data, 
                          choice = "choice", # tells which brand was chosen
                          shape = "long", # tells R shape of data (could be "wide")
                          alt.var = "brand",  # INdicated the item the line corresponds
                          chid.var = "transaction", # INdicate how transactions are grouped
                          id.var = "id") # Indicates that there are repeat observations per person

# Set up models
model1 <- mlogit(choice ~ price, data = data_clean)

model2 <- mlogit(choice ~ price + display + feature, data = data_clean)


# Group data based on whether spend is above or below median
med <- median(data$spend)
data <- data %>% mutate(big = ifelse(spend >= med, 1, 0))
data_clean <- mlogit.data(data, 
                          choice = "choice", # tells which brand was chosen
                          shape = "long", # tells R shape of data (could be "wide")
                          alt.var = "brand",  # INdicated the item the line corresponds
                          chid.var = "transaction", # INdicate how transactions are grouped
                          id.var = "id") # Indicates that there are repeat observations per person

model1 <- mlogit(choice ~ price + feature + display, data = data_clean[data_clean$big==1,])
model0 <- mlogit(choice ~ price + feature + display, data = data_clean[data_clean$big==0,])
