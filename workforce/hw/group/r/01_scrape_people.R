# 0 - set up environment -------------------------------------------------------
library(rvest)
library(magrittr)

# 1 - define helper functions --------------------------------------------------
ExtractLinks <-
  function(url) {
    # takes a URL and extracts all links from it
    url %>%
      read_html() %>%
      html_nodes("a") %>%
      html_attr("href")
  }

# function to extract station name
ExtractContent <- function(url) {
  # takes a URL and uses the CSS selector provided by SelectorGadget widget to
  # extract the first header, which in this case is the wikipedia page title
  url %>%
    read_html() %>%
    html_nodes(".contentAndSidebar") %>%
    html_text()
}

# 2 - set up scrape for people -------------------------------------------------
# Set base URL
url <- "http://wwwf.imperial.ac.uk/business-school/people/"

# Grab all links on the page
links <- ExtractLinks(url)
# find those that look like a person
idx <- grep('uk/people/', links)
# select only those that are a person
links <- links[idx]

ptm <- proc.time()
people_summaries <- lapply(links, ExtractContent)
proc.time() - ptm
