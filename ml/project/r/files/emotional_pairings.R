emotions <- hil_dfm_senti %>% 
            as.matrix() %>%
            na.omit() %>% 
            data.frame() %>%
            add_rownames("DocNumber") %>% 
            dplyr::as_data_frame() %>% 
            left_join(to_from) %>% 
            mutate(negemo = -1*(negemo + anx + anger + sad)) %>% 
            select(DocNumber, from, to, posemo, negemo) %>% 
            mutate(overall = posemo + negemo) %>% 
            group_by(from) %>% 
            summarise(avg_pos = mean(posemo),
                      avg_neg = mean(negemo),
                      avg_emo = mean(overall),
                      total_sent = n()) 
            
library(ggplot2)
library(lubridate)
emotions %>% 
filter(total_sent >= 5) %>% 
    ggplot(aes(x = from, y = avg_emo)) +
    geom_bar(stat = "identity")

emotions %>% 
    filter(total_sent >= 10) %>% 
    ggplot(aes(x = total_sent, y = avg_neg)) +
    geom_point() +
    geom_smooth() +
    theme_jim

hil_dfm_senti %>% 
    as.matrix() %>%
    na.omit() %>% 
    data.frame() %>%
    add_rownames("DocNumber") %>% 
    mutate(negemo = -1*(negemo + anx + anger + sad)) %>% 
    select(DocNumber, posemo, negemo) %>% 
    left_join(emails_clean) %>% 
    select(DocNumber, posemo, negemo, sent) %>% 
    mutate(sent = as_date(sent)) %>% 
    ggplot(aes(x = sent, y = posemo)) +
    geom_point() +
    geom_smooth() +
    ylim(0, 1)
    