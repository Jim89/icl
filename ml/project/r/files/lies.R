hil_dfm_liwc_weighted <- weight(hil_dfm_liwc, type = "relFreq")

hil_dfm_lies <- hil_dfm_liwc_weighted[, c("i", "we", "shehe", "they", "negemo", "conj", "motion")]

# Convert to matrix
hil_dfm_lies <- hil_dfm_lies %>% as.matrix()

# Tidy up NaN values
hil_dfm_lies <- hil_dfm_lies[complete.cases(hil_dfm_lies), ]

# Combine classes
first <- hil_dfm_lies[, "i"] + hil_dfm_lies[, "we"] %>% as.matrix(ncol = 1) 
colnames(first) <- "first"

third <- hil_dfm_lies[, "shehe"] + hil_dfm_lies[, "they"] %>% as.matrix(ncol = 1) 
colnames(third) <- "third"

neg <- hil_dfm_lies[, "negemo"] %>% as.matrix()
colnames(neg) <- "negemo"

exclusive <- hil_dfm_lies[, "conj"] %>% as.matrix()
colnames(exclusive) <- "excl"

motion <- hil_dfm_lies[, "motion"] %>% as.matrix()
colnames(motion) <- "motion"


# Normalise
lies_mat <- cbind(first, third, neg, exclusive, motion) %>% 
            apply(2, normalise) %>% 
            as.data.frame() %>% 
            add_rownames(var = "DocNumber") %>% 
            mutate(lie = .260*first + 
                       .250*third - 
                       .217*negemo + 
                       .419*excl - 
                       .259*motion,
                   odds = exp(lie),
                   prob = odds/(1+odds))


stats <- emails_clean %>% 
    select(DocNumber, from) %>% 
    left_join(lies_mat %>% select(DocNumber, prob)) %>% 
    left_join(from_stats) %>% 
    left_join(emails_clean %>% count(from) %>% arrange(-n) %>% mutate(sent_rank = row_number())) 
    


stats %>% 
    filter(sent_rank <= 15) %>% 
    ggplot(aes(x = from, y = prob)) +
    geom_boxplot()

stats %>% 
    na.omit() %>% 
    ggplot(aes(y = prob)) +
    geom_boxplot()

stats %>% 
    group_by(cl_walk) %>% 
    summarise(emails = n(),
              avg_prob = mean(prob, na.rm = T)) %>% 
    left_join(from_stats %>% group_by(cl_walk) %>% summarise(members = n())) %>% 
    lm(avg_prob ~ members, data = .) 

    
