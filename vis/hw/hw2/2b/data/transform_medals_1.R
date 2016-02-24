library(readr)
library(dplyr)

data1 <- read_tsv("./MedalData1.csv") %>% 
          mutate(Gender = ifelse(grepl("Women", Event), "Female", "Male"))
data1_summary_medals <- data1 %>%
                 mutate(Athlete = Athlete %>% tolower) %>% 
                 group_by(Athlete, CountryName, CountryCode, Gender, Sport) %>% 
                 tally() %>% 
                 rename(Medals = n)
data1_summary_games <- data1 %>% 
                        mutate(Athlete = Athlete %>% tolower) %>%   
                        group_by(Athlete) %>% 
                        summarise(Appearances = length(Games %>% unique))

data1_summary <- data1_summary_medals %>% left_join(data1_summary_games)

write_tsv(data1_summary, "./data1_summary.csv")
