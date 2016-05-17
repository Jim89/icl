library(readxl)
library(dplyr)
library(randomForest)
library(GGally)
library(ggplot2)

train <- read_excel("./data/hw2/churn.xlsx", sheet = 1, na = "#N/A")
test <- read_excel("./data/hw2/churn.xlsx", sheet = 2, na = "#N/A")


train <- train %>% 
          mutate(retained = as.factor(retained),
                 favday = as.factor(favday),
                 city = as.factor(city),
                 paperless = as.factor(paperless),
                 refill = as.factor(refill),
                 doorstep = as.factor(doorstep)) %>% 
          select(-train) %>% 
          na.omit()


test <- test %>% 
  mutate(retained = as.factor(retained),
         favday = as.factor(favday),
         city = as.factor(city),
         paperless = as.factor(paperless),
         refill = as.factor(refill),
         doorstep = as.factor(doorstep)) %>% 
  select(-train) %>% 
  na.omit()


field_plot <- function(data, field, xlab, bins = 30) {
  data %>% 
    mutate(retained = as.character(retained),
           retained = gsub("0", "Churned", retained),
           retained = gsub("1", "Retained", retained)) %>% 
   ggplot(aes_string(x = field)) +
    geom_histogram(aes(fill = retained), bins = bins, colour = "white") +
    facet_grid(retained ~ .) +
    xlab(xlab) +
    ylab("Records") +
    guides(fill = guide_legend(title = "")) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_brewer(type = "qual", palette = "Dark2") +
    theme(legend.position = "bottom",
          axis.text.y = element_text(size = 16, colour = "black"),
          axis.text.x = element_text(size = 16, colour = "black"),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 16),
          title = element_text(size = 16),
          strip.text = element_text(size = 16, colour = "black"),
          strip.background = element_rect(fill = "white"),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
          panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
          panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
          panel.margin.y = unit(0.1, units = "in"),
          panel.background = element_rect(fill = "white", colour = "lightgrey"),
          panel.border = element_rect(colour = "black", fill = NA))
    
}  
field_plot(train, "created", "Date created", 50)


field_plot_disc <- function(data, field, xlab) {
  data %>% 
    mutate(retained = as.character(retained),
           retained = gsub("0", "Churned", retained),
           retained = gsub("1", "Retained", retained)) %>% 
    ggplot(aes_string(x = field)) +
    geom_bar(aes(fill = retained), stat = "count", colour = "white") +
    facet_grid(retained ~ .) +
    xlab(xlab) +
    ylab("Records") +
    guides(fill = guide_legend(title = "")) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_brewer(type = "qual", palette = "Dark2") +
    theme(legend.position = "bottom",
          axis.text.y = element_text(size = 16, colour = "black"),
          axis.text.x = element_text(size = 16, colour = "black"),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 16),
          title = element_text(size = 16),
          strip.text = element_text(size = 16, colour = "black"),
          strip.background = element_rect(fill = "white"),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
          panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
          panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
          panel.margin.y = unit(0.1, units = "in"),
          panel.background = element_rect(fill = "white", colour = "lightgrey"),
          panel.border = element_rect(colour = "black", fill = NA))
  
}  
field_plot_disc(train, "paperless", "")



# Step 3 - logit ----------------------------------------------------------

logit_all <- glm(retained ~ ., family = "binomial", 
                 data = train %>% select(-custid)


logit_stepped <- step(logit_all, direction = "both", trace = 0)

logit_predict <- predict(logit_stepped, newdata = test, type = "response")
logit_predict[logit_predict >= .5] <- 1
logit_predict[logit_predict < .5] <- 0

logit_conf <- table(logit_predict, test$retained)
logit_accuracy <- sum(diag(logit_conf)) / sum(logit_conf)

# Step 4 - random forest --------------------------------------------------
rf <- randomForest(retained ~ ., 
                   data = train %>% select(-custid), 
                   ntree = 500, 
                   importance = TRUE)

rf_predict <- predict(rf, newdata = test)

rf_conf <- table(rf_predict, test$retained)
rf_accuracy <- sum(diag(rf_conf)) / sum(rf_conf)

varImpPlot(rf)
