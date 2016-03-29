# Step 0 - prep env -------------------------------------------------------
library(readr)
library(dplyr)
library(broom)
library(ggplot2)

# Step 1 - get & clean data ----------------------------------------------------
data <- read_csv("./project/data/asg_readmission_data.csv") %>% 
        mutate(readmission = ifelse(readmission_lessthan30 == 1 |
                                      readmission_morethan30 == 1, 1, 0),
               race = ifelse(race %in% c("?", "Other"), "Unknown", 
                             ifelse(race == "AfricanAmerican", "Black", race)),
               race = as.factor(race),
               gender = as.factor(gender),
               age_clean = ifelse(age %in% c("[0-10]", "[10-20]", "[20-30]"), "Young",
                                  ifelse(age %in% c("[30-40]", "[40-50]", "[50-60]"),
                                         "Middle-Aged", "Old")),
               age_clean = factor(age_clean, 
                                     levels = c("Young", "Middle-Aged", "Old"))) %>% 
        select(-age)


# Step 2 - prepare readmission model --------------------------------------
q1a_fit <- glm(readmission ~ . , family = "binomial", data = data[, -c(1:3)]) %>% 
            step()

preds <- predict(q1a_fit, type = 'response',se = TRUE)

data$pred <- preds$fit
data$ymin <- data$pred - 2*preds$se.fit
data$ymax <- data$pred + 2*preds$se.fit  

tidy_fit <- tidy(q1a_fit)

# Step 3 - visualise rel between time and readmission ---------------------
data %>% 
  ggplot(aes(x = time_in_hospital, y = pred, colour = race)) +
  geom_point() +
  facet_grid(age_clean ~ race) +
  geom_smooth(method = "glm") +
  scale_x_continuous(breaks = seq(0, 16, 4)) +
  scale_color_brewer(type = "qual", palette = "Dark2") +
  xlab("Time in Hospital [days]") +
  ylab("Predicted probability of readmission") +
  theme(legend.position = "none",
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
