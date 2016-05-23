library(d3wordcloud)
words <- hil_dfm_words %>% 
    as.matrix() %>% 
    data.frame() %>% 
    add_rownames("DocNumber") %>% 
    dplyr::as_data_frame() %>% 
    gather(word, uses, -DocNumber) %>% 
    filter(uses > 0) %>% 
    left_join(dishonesty %>% select(DocNumber, prob_lie))
    
make_wordcloud <- function(lies1 = 0, lies2 = 1, uses_data = words, cutoff = 0,
                       scale = "linear") {
    data <- uses_data %>% 
        filter(between(prob_lie, lies1, lies2)) %>% 
        group_by(word) %>% 
        summarise(uses = sum(uses)) %>% 
        filter(uses > cutoff)
    
    d3wordcloud(data$word, data$uses, font = "Courier New", padding = 0.5,
                size.scale = scale, 
                tooltip = TRUE, spiral = "rectangular")
}


    