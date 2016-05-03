
# Step 0 - prep env -------------------------------------------------------


# Step 1 - prepare clean data set -----------------------------------------

emails_clean <- to_from %>% 
                left_join(emails) %>% 
                mutate(redacted = ifelse(ExtractedReleaseInPartOrFull == "RELEASE IN FULL", 0, 1)) %>% 
                select(DocNumber, 
                       from,
                       to,
                       redacted,
                       MetadataSubject,
                       MetadataDateSent,
                       ExtractedSubject,
                       ExtractedBodyText,
                       RawText) %>% 
                rename(meta_subject = MetadataSubject,
                       sent = MetadataDateSent,
                       extract_subject = ExtractedSubject,
                       body = ExtractedBodyText,
                       raw = RawText)
                       
