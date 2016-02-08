# 0 - set up environment -------------------------------------------------------
library(rvest)
library(magrittr)
library(stringr)

# 1 - define helper functions --------------------------------------------------
ExtractLinks <-
  function(url) {
    # takes a URL and extracts all links from it
    url %>%
      read_html() %>%
      html_nodes("a") %>%
      html_attr("href")
  }

ExtractLinksText <-
  function(url) {
    # takes a URL and extracts all links text from it
    title <- url %>%
              read_html() %>%
              html_nodes("a") %>%
              html_attr("title")
    link <-     url %>%
                read_html() %>%
                html_nodes("a") %>%
                html_attr("href")
    title_link <- paste(title, link, sep = " : ")
    return(title_link)
  }

# function to extract name
ExtractName <- function(url) {
  # takes a URL and uses the CSS selector provided by SelectorGadget widget to
  # extract the page header - in this case a researcher's name
  url %>%
    read_html() %>%
    html_nodes(".ac_info") %>%
    html_text()
}

# function to extract summary
ExtractContent <- function(url) {
  # takes a URL and uses the CSS selector provided by SelectorGadget widget to
  # extract the content with sidebar - in this case a researcher's summary
  url %>%
    read_html() %>%
    html_nodes(".contentAndSidebar") %>%
    html_text()
}

# 2 - set up scrape for people -------------------------------------------------
ptm <- proc.time()
# Set base URL
url <- "http://wwwf.imperial.ac.uk/business-school/people/"

# Grab all links on the page
links <- ExtractLinks(url)
# find those that look like a person
idx <- grep('uk/people/', links)
# select only those that are a person
links <- links[idx]

# Grab names of individuals
title_links <- ExtractLinksText(url)
idx <- grep('uk/people/', title_links)
title_links <- title_links[idx]
names <- sapply(seq_along(title_links), function(x) unlist(str_split(title_links[[x]], " : "))[1])
names[5] <- "Anandalingam Anand"
names[12] <- "Bruno Biais"
names[21] <- "Claudia Custodio"
names[27] <- "Andreas Eisingerich"
names[34] <- "Joachin Geske"
names[48] <- "Andrei Kirilenko"
names[55] <- "Ian Mackenzie"
names[61] <- "Edgar Meyer"
names[76] <- "Eliana Barrenho"
names[82] <- "Maria Rosa Sanchis-Guarner Herrero"
names[83] <- "Franco Sassi"
names[89] <- "Konstantina Spanaki"
names[96] <- "Angelos Tsoukalas"
names[99] <- "Antoinne Vernet"
names[100] <- "Anu Wadhawa"
names[105] <- "George Yip"
names <- data.frame(names, file = rep(NA, length(names)))
  
# loop over links and grab the summaries
people_summaries <- lapply(links, ExtractContent)

# 3 write data out to files ----------------------------------------------------
for(i in seq_along(links)) {
  # split up URL to get indviduals' name
  split_up <- unlist(str_split(links[i], '/'))
  last_item <- length(split_up)
  individ <- split_up[last_item]
  individ <- gsub("\\.", "_", individ)
  names[i, "file"] <- individ
  
  # make the necessary directory
  if(!dir.exists("./data/researchers_scraped")) {
    dir.create("./data/researchers_scraped")
    }
  
  # make the file
  file <- paste0("./data/researchers_scraped/", individ, ".txt")
  file.create(file)
  
  # clean up scraped data slightly
  people_summaries[i] <- str_trim(gsub("\\r|\\n|\\t", "", people_summaries[i]))
  
  writeLines(people_summaries[[i]], file)
}

write.csv(names, "./data/researchers_scraped/names.csv", row.names = FALSE) 
print(paste0("Complete. Took: ", ceiling(proc.time()[3] - ptm[3]), " seconds"))