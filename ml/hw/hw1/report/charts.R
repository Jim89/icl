# Step 0 - set up environment --------------------------------------------------
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Create some simple functions
normalise <- function(x){(x-mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)}
range_single <- function(x){range(x)[2] - range(x)[1]}
to_proper <- function(x){paste0(toupper(substring(x, 1, 1)), substring(x, 2))}

# Step 1 - load data -----------------------------------------------------------
input <- read_csv("./hw/hw1/data/created/input.csv", col_names = FALSE)
output <- read_csv("./hw/hw1/data/created/output.csv", col_names = FALSE) %>% 
          setNames("label")
data <- bind_cols(input, output)

knn <- read_csv("./hw/hw1/data/created/knn_loss.csv") %>% 
        mutate(k = row_number())

svm <- read_csv("./hw/hw1/data/created/svm_loss.csv") %>% 
  mutate(slack = 1:11)

# Step 2 - transform data ------------------------------------------------------
knn_long <- knn %>% gather(key = "distance", value = "loss", -k) %>% 
                    mutate(distance = to_proper(distance))

svm_long <- svm %>% gather(key = "kernel", value = "loss", -slack) %>% 
            mutate(kernel = to_proper(kernel))

data_long <- data %>% gather(key = "field", value = "value", -label) %>% 
              group_by(field) %>% 
              mutate(value_norm = normalise(value)) %>% 
              ungroup() %>% 
              gather(key = "feature", value = "value", -label, -field)

# Step 3 - create some plots ---------------------------------------------------
theme <-   theme(legend.position = "bottom",
                 axis.text.y = element_text(size = 16, colour = "black"),
                 axis.text.x = element_text(size = 16, colour = "black", angle = -90),
                 legend.text = element_text(size = 16),
                 legend.title = element_text(size = 16),
                 title = element_text(size = 16),
                 panel.grid.minor.x = element_blank(),
                 panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
                 panel.grid.minor.y = element_blank(),
                 panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
                 panel.margin.y = unit(0.1, units = "in"),
                 panel.background = element_rect(fill = "white", colour = "lightgrey"),
                 panel.border = element_rect(colour = "black", fill = NA))

# Create plot that visualises distribution of each field - show normalisation
# is important
data_long %>% 
  arrange(feature, field) %>% 
  filter(feature == "value") %>% 
  ggplot(aes(x = field, y = value)) +
  geom_point(aes(colour = factor(label)), size = 2, alpha = .75) +
  scale_color_brewer(type = "qual", palette = "Dark2") + 
  guides(colour = guide_legend(title = "Output Label")) +
  xlab("Input Feature") +
  ylab("Feature Values") +
  ggtitle("Distribution of values for all non-normalised\n data input features") +
  theme

# Create plot that visualises distribution of each field after normalisation
data_long %>% 
  arrange(feature, field) %>% 
  filter(feature == "value_norm") %>% 
  ggplot(aes(x = field, y = value)) +
  geom_point(aes(colour = factor(label)), size = 2, alpha = .75) +
  scale_color_brewer(type = "qual", palette = "Dark2") + 
  guides(colour = guide_legend(title = "Output Label")) +
  xlab("Input Feature") +
  ylab("Feature Values") +
  ggtitle("Distribution of values for all normalised\n data input features") +
  theme

# Plot of k-NN training
knn_long %>%
  ggplot(aes(x = k, y = loss, colour = distance)) + 
  geom_line(aes(colour = distance), size = 1.25) +
  geom_point(aes(colour = distance), size = 2.75) +
  scale_x_continuous(breaks = seq(from = 0, to = 30, by = 2)) + 
  scale_y_continuous(breaks = seq(from = 0, to = max(knn_long$loss), by = 0.01)) +
  scale_color_brewer(type = "qual", palette = "Dark2") + 
  xlab("k (in k-Nearest Neighbours)") +
  ylab("Loss") +
  ggtitle("Average 10-fold cross-validated loss\n for a range of hyperparameters") +
  guides(colour = guide_legend(title = "Distance Metric")) +
  theme(legend.position = "bottom",
        axis.text.y = element_text(size = 16, colour = "black"),
        axis.text.x = element_text(size = 16, colour = "black"),
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16),
        title = element_text(size = 16),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
        panel.margin.y = unit(0.1, units = "in"),
        panel.background = element_rect(fill = "white", colour = "lightgrey"),
        panel.border = element_rect(colour = "black", fill = NA))


# Plot of SVM training
# Set up axis labels
xlabels <- c("0.00001", "0.0001", "0.001", "0.01", "0.1", "1", "10", "100", "1,000", "10,000", "100,000")

svm_long %>% 
  ggplot(aes(x = slack, y = loss, colour = kernel)) + 
  geom_line(aes(colour = kernel), size = 1.25) +
  geom_point(aes(colour = kernel), size = 2.75) +
  scale_color_brewer(type = "qual", palette = "Dark2") + 
  guides(colour = guide_legend(title = "Kernel Function")) +
  ylab("Loss") + 
  xlab("Slack Parameter Value") +
  ggtitle("Average 10-fold cross-validated loss\n for a range of hyperparameters") +
  scale_x_discrete(labels = xlabels) +
  theme(legend.position = "bottom",
        axis.text.y = element_text(size = 14, colour = "black"),
        axis.text.x = element_text(size = 14, colour = "black"),
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16),
        title = element_text(size = 16),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
        panel.margin.y = unit(0.1, units = "in"),
        panel.background = element_rect(fill = "white", colour = "lightgrey"),
        panel.border = element_rect(colour = "black", fill = NA))