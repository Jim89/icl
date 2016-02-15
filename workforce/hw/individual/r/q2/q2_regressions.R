library(readr)
library(dplyr)
library(magrittr)
library(caret)
library(randomForest)

q1b <- read_csv("./data/outputs/q1b.csv")
q1b$moved_to %<>% as.logical()
q1b$moved_to %<>% as.numeric() %>% as.factor()
q1b$n_comp %<>% as.numeric()

q1b_clean <- q1b[complete.cases(q1b), ]



idx <- createDataPartition(q1b_clean$moved_to, p = 0.75, list = F)
train <- q1b_clean[idx, ]
test <- q1b_clean[-idx, ]

fit <- glm(moved_to ~ ., data = train %>% select(-firm, -inv), family = "binomial")
fit_rf <- randomForest(factor(moved_to) ~ ., data = train %>% select(-firm, -inv),
                       ntree = 10, importance = T)

logit_pred <- predict(fit, test)
rf_pred <- predict(fit_rf, test)

confMat_logit <- confusionMatrix(as.factor(logit_pred), test$moved_to)
confMat_rf <- confusionMatrix(rf_pred, test$moved_to)

