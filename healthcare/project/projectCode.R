# Step 0 - prep env -------------------------------------------------------
# Load packages
library(readr)
library(dplyr)
library(broom)
library(ggplot2)
library(knitr)
library(randomForest)

# Setup theme object for easier plotting
theme_jim <- theme(legend.position = "none",
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
                            levels = c("Young", "Middle-Aged", "Old")),
         readmission = as.factor(readmission)) %>% 
  
  select(-age)

# Clean up patient ID name
colnames(data)[1] <- "patient_id"


# Step 2 - prepare readmission model --------------------------------------
q1a_fit <- glm(readmission ~ . , family = "binomial", data = data[, -c(1:3)]) 
q1a_fit <- step(q1a_fit, trace = 0)

# Perform prediction
preds <- predict(q1a_fit, type = 'response', se = TRUE)
data$pred <- preds$fit

# Tidy up results in to table
tidy_fit <- tidy(q1a_fit)

# Step 3 - visualise rel between time and readmission ---------------------
readmission_vs_time <- data %>% 
                        filter(race != "Unknown") %>% 
                        ggplot(aes(x = time_in_hospital, 
                                   y = pred, 
                                   colour = race)) +
                        geom_point(alpha = 0.25) +
                        facet_grid(age_clean ~ race) +
                        geom_smooth(method = "glm") +
                        scale_x_continuous(breaks = seq(0, 15, 5), 
                                           limits = c(0, 15)) +
                        scale_color_brewer(type = "qual", palette = "Dark2") +
                        xlab("Time in Hospital [days]") +
                        ylab("Predicted probability of readmission") +
                        theme_jim +
                        geom_hline(yintercept = 0.5, colour = "grey",
                                   linetype = "dashed")


# Step 4 - Patient profile differences ------------------------------------
data_clean <- data %>% 
  mutate(readmit = ifelse(readmission_lessthan30 == 1, "Readmitted < 30 days",
                          ifelse(readmission_morethan30 == 1, "Readmitted > 30 days",
                                 "Not readmitted"))) %>% 
  filter(readmit != "Not readmitted") %>% 
  mutate(readmit = as.factor(readmit))

# Function to create barplots
profile_bar <- function(field, x = ""){
  data_clean %>% 
    group_by_("readmit", field) %>% 
    summarise(patients = n()) %>% 
    group_by(readmit) %>% 
    mutate(prop_patients = patients/sum(patients)) %>% 
    ggplot(aes_string(x = field, y = "prop_patients")) +
    geom_bar(stat = "identity", aes(fill = readmit)) +
    facet_grid(. ~ readmit) +
    scale_y_continuous(labels = scales::percent)+
    scale_fill_brewer(type = "qual", palette = "Dark2") +
    xlab(x) +
    ylab("Percentage of patients") +
    theme_jim
}  

# Function to create scatterplots
profile_scatter <- function(field1, field2, x = "", y = "") {
  data_clean %>% 
    ggplot(aes_string(x = field1, y = field2)) +
    geom_point(aes(colour = readmit)) +
    geom_smooth(aes(colour = readmit)) +
    facet_grid(. ~ readmit) +
    xlab(x) +
    ylab(y) +
    scale_colour_brewer(type = "qual", palette = "Dark2") +
    theme_jim
}  
# Single-field distributions
ages <- profile_bar("age_clean", "")
races <- profile_bar("race", "") + theme(axis.text.x = element_text(angle = -90))
gender <- profile_bar("gender", "")
labs <- profile_bar("num_lab_procedures", x = "Number of laboratory procedures")
proc <- profile_bar("num_procedures", x = "Number of procedures")
meds <- profile_bar("num_medications", x = "Number of medications")
time <- profile_bar("time_in_hospital", x = "Time in hospital")

# Pair-wise field comparisons
med_v_proc <- profile_scatter("num_medications", "num_procedures", x = "Medications", y = "Procedures")
med_v_proc_lab <- profile_scatter("num_medications", "num_lab_procedures", x = "Medications", y = "Lab Procedures")
lab_v_proc <- profile_scatter("num_lab_procedures", "num_procedures", x = "Lab procedures", y = "Procedures")


# Step 5 - analytical approach --------------------------------------------
data_model <- data_clean %>% 
  select(-1, -2, -3, -readmission) %>% 
  mutate(race = as.numeric(race),
         gender = as.numeric(gender),
         age_clean = as.numeric(age_clean))

k_clust <- kmeans(data_model %>% select(-readmit), 2, iter.max = 100)
conf <- table(k_clust$cluster, data_model$readmit)
rownames(conf) <- c("Cluster 1", "Cluster 2")
accuracy <- conf %>% diag %>% sum / conf %>% sum

rf <- randomForest(readmit ~ ., data = data_model %>% select(-pred), importance = TRUE, ntree = 100)

