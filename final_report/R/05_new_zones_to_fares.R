calculate_daily_fares <- function(how = "deg") {
# Return "normal" fares if requested
if ( how == "current" ) {
    ans <- journey_summaries %>%
            group_by(downo, daytype) %>% 
            summarise(total_fare_rev = sum(total_rev),
                      total_fare_rev_scale = sum(total_rev_scaled)) %>% 
            mutate(how = "current") %>% 
            ungroup()
} else {
    # Calculate temporary zones
    temp_zones <- station_centrality_stats %>% 
        gather(measure, value, -station) %>% 
        group_by(measure) %>% 
        mutate(zone = ntile(desc(value), 10)) %>% 
        filter(measure == how) %>% 
        ungroup() %>% 
        select(station, zone)

    # Get journies data
    temp_journeys <- journeys %>% 
        select(start_cln, end_cln, ffare, dfare, downo, daytype)

    # Join on new zones
    temp_journeys_to_zones <- temp_journeys %>% 
        left_join(temp_zones, by = c("start_cln" = "station")) %>% 
        rename(start_zone = zone) %>% 
        left_join(temp_zones, by = c("end_cln" = "station")) %>% 
        rename(end_zone = zone)     
        
    # Join on pricing info
    temp_journeys_to_zones_to_prices <- temp_journeys_to_zones %>% 
        left_join(zone_costs, by = c("start_zone", "end_zone"))
    
    # Create summary
    ans <- temp_journeys_to_zones_to_prices %>% 
        group_by(downo, daytype) %>% 
        summarise(total_fare_rev = sum(cpj)) %>% 
        mutate(total_fare_rev_scale = 20 * total_fare_rev) %>% 
        ungroup() %>% 
        mutate(how = how)
}    

# Push back the summary
return(ans)
}

