library(d3wordcloud)
display.brewer.all()

from_content <- hil_dfm_words %>% 
    as.matrix() %>% 
    data.frame() %>% 
    add_rownames("DocNumber") %>% 
    dplyr::as_data_frame() %>% 
    left_join(to_from %>% select(DocNumber, from) %>% distinct()) %>% 
    gather(word, uses, -DocNumber, -from)
                
make_wordcloud <- function(person, uses_data = from_content, cutoff = 0,
                           scale = "linear") {
    data <- uses_data %>% 
        filter(from == person) %>% 
        group_by(word) %>% 
        summarise(uses = sum(uses)) %>% 
        filter(uses > cutoff)
    
    d3wordcloud(data$word, data$uses, font = "Courier New", padding = 0.5,
                size.scale = scale, colors = brewer.pal(8, name = "Dark2"),
                tooltip = TRUE, spiral = "rectangular")
}

make_wordcloud("Hillary Clinton", cutoff = 0, scale = "linear")
