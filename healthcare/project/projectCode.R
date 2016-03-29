# Step 0 - prep env -------------------------------------------------------
# Load packages
library(readr)
library(dplyr)
library(broom)
library(ggplot2)
library(GGally)

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
                                     levels = c("Young", "Middle-Aged", "Old"))) %>% 

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
                        theme_jim


# Step 4 - Patient profile differences ------------------------------------
data_clean <- data %>% 
              mutate(readmit = ifelse(readmission_lessthan30 == 1, "< 30",
                                ifelse(readmission_morethan30 == 1, "> 30",
                                        "Not readmitted"))) %>% 
              filter(readmit != "Not readmitted")

# Barplots
profile_bar <- function(field, x = ""){
    data_clean %>% 
      ggplot(aes_string(x = field)) +
      geom_bar(stat = "count", aes(fill = readmit)) +
      facet_grid(. ~ readmit) +
      scale_fill_brewer(type = "qual", palette = "Dark2") +
      xlab(x) +
      ylab("Patients") +
      theme_jim
}  

ages <- profile_bar("age_clean", "")
races <- profile_bar("race", "") + theme(axis.text.x = element_text(angle = -90))
gender <- profile_bar("gender", "")

# Histograms
profile_hist <- function(field, x = "", binwid = 5){
                data_clean %>% 
                  ggplot(aes_string(x = field)) +
                  geom_histogram(aes(fill = readmit), colour = "white", binwidth = binwid) +
                  facet_grid(.~readmit) +
                  scale_fill_brewer(type = "qual", palette = "Dark2") +
                  xlab(x) +
                  ylab("Patients") +
                  theme_jim
}  

labs <- profile_hist("num_lab_procedures", x = "Number of laboratory procedures")
proc <- profile_hist("num_procedures", x = "Number of procedures", binwid = 1)
meds <- profile_hist("num_medications", x = "Number of medications", binwid = 2)
time <- profile_hist("time_in_hospital", x = "Time in hospital", binwid = 1)

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

med_v_proc <- profile_scatter("num_medications", "num_procedures", x = "Medications", y = "Procedures")
time_v_pred <- profile_scatter("time_in_hospital", "pred", x = "Time in hospital", y = "Probability readmission")
lab_v_proc <- profile_scatter("num_lab_procedures", "num_procedures", x = "Lab procedures", y = "Procedures")
