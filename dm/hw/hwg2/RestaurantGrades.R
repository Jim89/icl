library(dplyr)
library(magrittr)
library(ggplot2)

# Set up theme object for prettier plots
theme_jim <-  theme(legend.position = "bottom",
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

data <- readxl::read_excel("./data/hw_g2/Advertising-Experiments-at-RestaurantGrades-Spreadsheet-Supplement.xlsx", sheet = 2)

# Define metric
data %<>% 
  mutate(treatment = as.factor(treatment),
         convert_rate = reservations/pageviews)


data %>% 
  ggplot(aes(x = treatment, y = convert_rate)) +
  # geom_boxplot(fill = "white") +
  geom_violin(aes(fill = treatment), draw_quantiles = c(.5)) +
  scale_fill_brewer(type = "qual", palette = "Dark2") +
  scale_y_continuous(labels = scales::percent) +
  xlab("") +
  ylab("Conversion Rate") +
  guides(fill = guide_legend(title = "Treatment")) +
  theme_jim




no_ads <- data %>% filter(treatment == 0) %>% .$convert_rate
current_ads <- data %>% filter(treatment == 1) %>% .$convert_rate
new_ads <- data %>% filter(treatment == 2) %>% .$convert_rate

fit <- aov(convert_rate ~ treatment, data = data)
summary(fit)
# F-stat = 3158, p < 2e-16, therefore clearly reject null that equal mean is present across all groups

# Now we need to understand _how_ the 3 groups differ
fit2 <- pairwise.t.test(data$convert_rate, data$treatment, paired = FALSE,
                        alternative = "greater", p.adjust = "bonferroni")
# See p-values for alternative that each level is greater than the 1 below (so 1 more effective than 0, 2 more effective than 1) - see that 1 actually less effective than 0, but 2 more effective than both

tukey <- TukeyHSD(fit, conf.level = 0.95)
