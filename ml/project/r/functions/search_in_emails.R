# Function: search_in_emails ---------------------------------------------------
# Simple function that will search for an item in the emails extracted body
# text. Two methods are possible, "in" which is used for simple %in% matching,
# and "regex" which will perform a regular expression search for the item in each
# email. 
search_in_emails <- function(item, method = "in") {
    # Perform basic text matching
    if (method == "in") {
        ans <- sapply(seq_along(hil_tok), function(x) item %in% hil_tok[[x]])
    }
    # Perform regex matching
    if (method == "regex") {
        ans <- sapply(seq_along(hil_tok), function(x) grepl(item, paste(hil_tok[[x]], collapse = " "), perl = T))
    }
    return(ans)
}



