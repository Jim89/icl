# Step 0 - prep env -------------------------------------------------------


# Step 1 - set up to and cc fields (from has ID) --------------------------
to <- emails %>% 
    select(DocNumber, MetadataTo, ExtractedTo) %>% 
    rowwise() %>% 
    mutate(pos = str_locate(ExtractedTo, "<")[1],
           ExtractedTo = str_sub(ExtractedTo, start = 1L, end = pos-2)) %>% 
    select(-pos) %>% 
    gather(field, receiver, -DocNumber) %>% 
    select(-field) %>% 
    distinct() %>% 
    na.omit()

cc <- emails %>% 
    select(DocNumber, ExtractedCc) %>% 
    separate(ExtractedCc, into = paste("person", 1:8), sep = ";") %>% 
    gather(field, receiver, -DocNumber) %>% 
    select(-field) %>% 
    distinct() %>% 
    na.omit() 


# Step 2 - build to/from and clean up -------------------------------------
to_from <- bind_rows(to, cc) %>% 
    left_join(emails %>% select(DocNumber, SenderPersonId)) %>% 
    na.omit() %>% 
    left_join(people, by = c("SenderPersonId" = "Id")) %>% 
    select(DocNumber, Name, receiver) %>% 
    mutate(receiver = gsub("[^a-zA-Z0-9\\@\\.\\,]", "", receiver),
           receiver = gsub(",", " ", receiver),
           receiver = str_trim(receiver),
           receiver = tolower(receiver)) %>% 
    left_join(aliases, by = c("receiver" = "Alias")) %>% 
    left_join(people, by = c("PersonId" = "Id")) %>% 
    select(DocNumber, Name.x, Name.y) %>% 
    rename(from = Name.x,
           to = Name.y) 
    
    
    
# Step 3 - gc -------------------------------------------------------------
rm(to, cc)
gc()
