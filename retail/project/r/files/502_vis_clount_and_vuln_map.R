# Step 0 - load packages -------------------------------------------------------

# Step 1 - Create base plot ----------------------------------------------------
clout_and_vuln_map <- clout_and_vuln_stats %>%
                      mutate(shop = gsub("sains", "Sainsburys", shop),
                             shop = gsub("asda", "Asda", shop),
                             shop = gsub("tesco", "Tesco", shop),
                             shop = gsub("aldi", "Adli & Lidl", shop),
                             shop = gsub("morrisons", "Morrisons", shop)) %>% 
                      ggplot(aes(x = vulns, y = clouts)) +
                      geom_point(size = 15, aes(colour = shop)) +
                      scale_color_brewer(type = "qual", palette = "Dark2") + 
                      xlab("Vulnerability") +
                      ylab("Clout") +
                      guides(colour = guide_legend(title = "Shop")) +
                      geom_hline(yintercept = 0,
                                 colour = "black", linetype = "dotted") +
                      geom_vline(xintercept = 0,
                                 colour = "black", linetype = "dotted") +
                      theme_jim

