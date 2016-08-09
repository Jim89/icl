# Do some plotting

library(ggplot2)

bakerloo <- rgb(red = 137, green = 78, blue = 36, maxColorValue = 255)
central <- rgb(red = 220, green = 36, blue = 31, maxColorValue = 255)
circle <- rgb(red = 255, green = 206, blue = 0, maxColorValue = 255)
district <- rgb(red = 0, green = 114, blue = 41, maxColorValue = 255)
hc <- rgb(red = 215, green = 153, blue = 175, maxColorValue = 255)
jubilee <- rgb(red = 134, green = 143, blue = 152, maxColorValue = 255)
metropolitan <- rgb(red = 117, green = 16, blue = 86, maxColorValue = 255)
northern <- rgb(red = 0, green = 0, blue = 0, maxColorValue = 255)
picadilly <- rgb(red = 0, green = 25, blue = 168, maxColorValue = 255)
victoria <- rgb(red = 0, green = 160, blue = 226, maxColorValue = 255)
wc <- rgb(red = 118, green = 208, blue = 189, maxColorValue = 255)
dlr <- rgb(red = 0, green = 175, blue = 173, maxColorValue = 255)
overground <- rgb(red = 232, green = 106, blue = 16, maxColorValue = 255)

# Colour df
colour <- c(bakerloo, central, circle, district,
            hc, jubilee, metropolitan, northern, picadilly,
            victoria, wc, dlr, overground)

# Set up theme object for prettier plots
theme_jim <-  theme(legend.position = "bottom",
                    axis.text.y = element_text(size = 16, colour = "black"),
                    axis.text.x = element_text(size = 16, colour = "black"),
                    legend.text = element_text(size = 16),
                    legend.title = element_text(size = 16),
                    title = element_text(size = 16),
                    strip.text = element_text(size = 16, colour = "black"),
                    strip.background = element_rect(fill = "white"),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.major.x = element_line(colour = "grey", linetype = "dotted"),
                    panel.grid.minor.y = element_line(colour = "lightgrey", linetype = "dotted"),
                    panel.grid.major.y = element_line(colour = "grey", linetype = "dotted"),
                    panel.margin.y = unit(0.1, units = "in"),
                    panel.background = element_rect(fill = "white", colour = "lightgrey"),
                    panel.border = element_rect(colour = "black", fill = NA))

station_cluster_stats %>% 
    left_join(station_details %>% 
                  select(name, 
                         latitude, 
                         longitude,
                         zone) %>% 
                  mutate(name = tolower(name),
                         zone = ceiling(zone)),
              by = c("station" = "name")) %>% 
    gather(method, value, -station, -latitude, -longitude) %>% 
    ggplot(aes(x = longitude, y = latitude, label = station, colour = as.factor(value))) +
    geom_point(size = 2, alpha = .75) +
    facet_wrap(~method) +
    scale_colour_manual(values = colour) +
    theme_jim


station_centrality_stats %>% 
    select(station, ends_with("zone")) %>% 
    left_join(station_details %>% 
                  select(name, 
                         latitude, 
                         longitude,
                         zone) %>% 
                  mutate(name = tolower(name),
                         zone = ceiling(zone)),
              by = c("station" = "name")) %>% 
    gather(method, value, -station, -latitude, -longitude) %>% 
    ggplot(aes(x = longitude, y = latitude, label = station, colour = as.factor(value))) +
    geom_point(size = 2, alpha = .75) +
    facet_wrap(~method) +
    scale_colour_manual(values = colour) +
    theme_jim


plot_fares <- function(data) {
pos <- data %>% arrange(downo) %>% select(daytype) %>% sapply(as.character) %>% as.vector()
data %>% 
    ggplot(aes(x = daytype, y = total_fare_rev_scale)) +
    geom_bar(stat = "identity", fill = picadilly) +
    scale_x_discrete(limits = pos) +
    scale_y_continuous(labels = scales::dollar_format(prefix = "£")) +
    xlab("") +
    ylab("Fares") +
    theme_jim 
}

bind_rows(calcualte_daily_fares("current"),
            calcualte_daily_fares("deg")) %>% 
            

methods <- c("current", "deg", "eig", "clo", "bet")
data <- lapply(methods, calculate_daily_fares)
data <- bind_rows(data)

data %>% 
ggplot(aes(x = daytype, y = total_fare_rev_scale)) +
    geom_bar(stat = "identity", fill = picadilly) +
    scale_x_discrete(limits = pos) +
    scale_y_continuous(labels = scales::dollar_format(prefix = "£")) +
    facet_wrap(~how) +
    xlab("") +
    ylab("Fares") +
    theme_jim 

library(leaflet)

vistited %>%
    leaflet() %>%
    addProviderTiles("Stamen.TonerLite",
                     options = providerTileOptions(noWrap = TRUE)) %>%
    setView(lng = -0.1275, lat = 51.5072, zoom = 13) %>%
    addCircles(radius = ~2.2*visits, popup = popup, stroke = T,
               fillColor = DarkBlue,
               fillOpacity = 0.75)  })

pal <- colorFactor(sample(colour, 10), domain = as.character(1:10))

station_centrality_stats %>% 
    gather(measure, value, -station) %>% 
    group_by(measure) %>% 
    mutate(zone = ntile(desc(value), 10)) %>% 
    ungroup() %>% 
    select(-value) %>% 
    spread(measure, zone) %>% 
    left_join(station_details %>% select(name, name_cln, zone_cln, latitude, longitude),
              by = c("station" = "name_cln")) %>% 
    select(-bet, -clo, -deg) %>% 
    rename(lat = latitude,
           long = longitude) %>% 
    leaflet() %>% 
    addProviderTiles("Stamen.TonerLite",
                     options = providerTileOptions(noWrap = TRUE)) %>% 
    setView(lng = -0.1275, lat = 51.5072, zoom = 13) %>% 
    addCircles(radius = ~3, stroke = T, popup = ~name,
               fillColor = ~pal(as.character(zone_cln)),
               fillOpacity = 0.75)
