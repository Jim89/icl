get_cluster_stats <- function(how) {
# Take created zones (clusters) and join in "actual" zones
    tmp_zones <- station_cluster_stats %>% 
        left_join(station_details %>% select(name_cln, zone_cln),
                  by = c("station" = "name_cln")) %>% 
        gather(method, value, -station) %>% 
        filter(method == how) %>% 
        select(station, value) %>% 
        rename(zone = value)
    
    # Get stations per zone
    stations_per_zone <- tmp_zones %>% count(zone)
    
    # Join in "zones"
    tmp_links <- links %>% 
        left_join(tmp_zones, by = c("station1" = "station")) %>% 
        rename(zone1 = zone) %>% 
        left_join(tmp_zones, by = c("station2" = "station")) %>% 
        rename(zone2 = zone)
    
    # Add zone-zone comparisons
    tmp_links <- tmp_links %>% 
        mutate(ms = ifelse(zone1 == zone2, 1, 0),
               cs = ifelse(zone1 != zone2, 1, 0))
    
    # Aggregate across zone
    zone_summary <- tmp_links %>% 
        group_by(zone1) %>% 
        summarise(ms = sum(ms),
                  cs = sum(cs)) %>% 
        left_join(stations_per_zone, by = c("zone1" = "zone"))
    
    # Perform summaries
    zone_summary <- zone_summary %>% 
        mutate(separability = ms / cs,
               density = ms / (n*(n - 1) / 2),
               method = how)
    
    return(zone_summary)
}

methods <- c("zone_cln", "eb", "walk", "sg")
results <- lapply(methods, get_cluster_stats) %>% bind_rows()

results %>% 
    na.omit() %>% 
    select(zone1, separability, density, method) %>% 
    gather(measure, value, -zone1, -method) %>% 
    ggplot(aes(x = method, y = value)) +
    geom_boxplot() +
    facet_grid(measure~., scales = "free_y") +
    theme_jim
    