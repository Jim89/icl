# load packages ----------------------------------------------------------------
  library(readxl)
  library(dplyr)
  library(magrittr)


# read in the data and set up variables ----------------------------------------
# read in the metadata about individuals and groups
groups                <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Overview") %>% .[1:12, 1:2]
people                <- read_excel("./data/BA_Anonymised.xlsx", sheet = "Attributes")

# read in network data
albert_hall_links     <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3780")
workshop_links        <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3782")
weekly_meeting_links  <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3781")
urgent_meeting_links  <- read_excel("./data/BA_Anonymised.xlsx", sheet = "relation 3779")

# read in quiz responses
guest_list            <- read_excel("./data/BA_Anonymised.xlsx", sheet = "multiple_choice 1056")
style                 <- read_excel("./data/BA_Anonymised.xlsx", sheet = "multiple_choice 1055")
option1               <- read_excel("./data/BA_Anonymised.xlsx", sheet = "multiple_choice 1054")
option2               <- read_excel("./data/BA_Anonymised.xlsx", sheet = "multiple_choice 1053")  

# clean up crap excel imports
people %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
albert_hall_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
workshop_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
weekly_meeting_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
urgent_meeting_links %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
guest_list %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
style %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
option1 %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()
option2 %<>% apply(2, as.numeric) %>% data.frame() %>% tbl_df()