# Step 0 - prep env -------------------------------------------------------
# Load packages
library(dplyr)
library(readr)


# Step 1 - get data -------------------------------------------------------
# Usage data
journeys <- read_csv("./data/journeys/Nov09JnyExport.csv",
                     col_types = cols(downo = col_integer(),
                                      daytype = col_character(),
                                      SubSystem = col_character(),
                                      StartStn = col_character(),
                                      EndStation = col_character(),
                                      EntTime = col_integer(),
                                      EntTimeHHMM = col_character(),
                                      ExTime = col_integer(),
                                      EXTimeHHMM = col_character(),
                                      ZVPPT = col_character(),
                                      JNYTYP = col_character(),
                                      DailyCapping = col_character(),
                                      FFare = col_integer(),
                                      DFare = col_integer(),
                                      RouteID = col_character(),
                                      FinalProduct = col_character()))
names(journeys) <- names(journeys) %>% tolower()

# Step 2 - clean and prep -------------------------------------------------
# This dataset provides a 5% sample of all Oyster card journeys performed in a
# week during November 2009 on bus, Tube, DLR and London Overground.

# Filter to just completed tube journeys that were PAYG
journeys <- journeys %>%
     filter(subsystem == "LUL",
            startstn != "Unstarted",
            endstation != "Unfinished",
            endstation != "Not Applicable",
            finalproduct == "PAYG")

# Clean up station names
journeys <- journeys %>% 
    # Start station names
    mutate(start_cln = startstn,
           start_cln = gsub("Earls Court", "Earl's Court", start_cln),
           start_cln = gsub("Highbury", "Highbury & Islington", start_cln),
           start_cln = gsub("St James's Park", "St. James's Park", start_cln),
           start_cln = gsub("St Pauls", "St. Paul's", start_cln),
           start_cln = gsub("Kings Cross [MT]", "King's Cross St. Pancras", start_cln),
           start_cln = gsub("Piccadilly Circus", "Picadilly Circus", start_cln),
           start_cln = gsub("Hammersmith [DM]", "Hammersmith", start_cln),
           start_cln = gsub("Bromley By Bow", "Bromley-By-Bow", start_cln),
           start_cln = gsub("Canary Wharf E2", "Canary Wharf", start_cln),
           start_cln = gsub("Edgware Road [BM]", "Edgware Road (B)", start_cln),
           start_cln = gsub("Great Portland St", "Great Portland Street", start_cln),
           start_cln = gsub("Waterloo JLE", "Waterloo", start_cln),
           start_cln = gsub("Shepherd's Bush Mkt", "Shepherd's Bush (H)", start_cln),
           start_cln = gsub("Shepherd's Bush Und", "Shepherd's Bush (C)", start_cln),
           start_cln = gsub("Harrow On The Hill", "Harrow-on-the-Hill", start_cln),
           start_cln = gsub("Harrow Wealdstone", "Harrow & Wealdston", start_cln),
           start_cln = gsub("Heathrow Term [45]", "Heathrow Terminal 4", start_cln),
           start_cln = gsub("Heathrow Terms 123", "Heathrow Terminals 1, 2 & 3", start_cln),
           start_cln = gsub("Tottenham Court Rd", "Tottenham Court Road", start_cln),
           start_cln = gsub("High Street Kens", "High Street Kensington", start_cln),
           start_cln = gsub("Regents Park", "Regent's Park", start_cln),
           start_cln = gsub("Queens Park", "Queen's Park", start_cln),
           start_cln = gsub("St Johns Wood", "St. John's Wood", start_cln),
           start_cln = gsub("Wood Lane", "White City", start_cln),
           start_cln = gsub("Totteridge", "Totteridge & Whetstone", start_cln),
           start_cln = gsub("Watford Met", "Watford", start_cln),
           start_cln = tolower(start_cln)) %>% 
    # End station names
    mutate(end_cln = endstation,
           end_cln = gsub("Earls Court", "Earl's Court", end_cln),
           end_cln = gsub("Highbury", "Highbury & Islington", end_cln),
           end_cln = gsub("St James's Park", "St. James's Park", end_cln),
           end_cln = gsub("St Pauls", "St. Paul's", end_cln),
           end_cln = gsub("Kings Cross [MT]", "King's Cross St. Pancras", end_cln),
           end_cln = gsub("Piccadilly Circus", "Picadilly Circus", end_cln),
           end_cln = gsub("Hammersmith [DM]", "Hammersmith", end_cln),
           end_cln = gsub("Bromley By Bow", "Bromley-By-Bow", end_cln),
           end_cln = gsub("Canary Wharf E2", "Canary Wharf", end_cln),
           end_cln = gsub("Edgware Road [BM]", "Edgware Road (B)", end_cln),
           end_cln = gsub("Great Portland St", "Great Portland Street", end_cln),
           end_cln = gsub("Waterloo JLE", "Waterloo", end_cln),
           end_cln = gsub("Shepherd's Bush Mkt", "Shepherd's Bush (H)", end_cln),
           end_cln = gsub("Shepherd's Bush Und", "Shepherd's Bush (C)", end_cln),
           end_cln = gsub("Harrow On The Hill", "Harrow-on-the-Hill", end_cln),
           end_cln = gsub("Harrow Wealdstone", "Harrow & Wealdston", end_cln),
           end_cln = gsub("Heathrow Term [45]", "Heathrow Terminal 4", end_cln),
           end_cln = gsub("Heathrow Terms 123", "Heathrow Terminals 1, 2 & 3", end_cln),
           end_cln = gsub("Tottenham Court Rd", "Tottenham Court Road", end_cln),
           end_cln = gsub("High Street Kens", "High Street Kensington", end_cln),
           end_cln = gsub("Regents Park", "Regent's Park", end_cln),
           end_cln = gsub("Queens Park", "Queen's Park", end_cln),
           end_cln = gsub("St Johns Wood", "St. John's Wood", end_cln),
           end_cln = gsub("Wood Lane", "White City", end_cln),
           end_cln = gsub("Totteridge", "Totteridge & Whetstone", end_cln),
           end_cln = gsub("Watford Met", "Watford", end_cln),
           end_cln = tolower(end_cln))

# Add on ID-information and zone
journeys <- journeys %>% 
    left_join(station_details %>% select(name_cln, id, zone_cln), 
              by = c("start_cln" = "name_cln")) %>% 
    rename(start_id = id,
           start_zone = zone_cln) %>% 
    left_join(station_details %>% select(name_cln, id, zone_cln),
              by = c("end_cln" = "name_cln")) %>% 
    rename(end_id = id,
           end_zone = zone_cln)

# Group and total
journey_summaries <- journeys %>% 
    group_by(downo,
             daytype,
             start_zone,
             end_zone) %>% 
    summarise(journeys = n(),
              total_rev = sum(dfare, na.rm = TRUE) / 100) %>% 
    ungroup() %>% 
    mutate(journeys_scaled = 20 * journeys,
           total_rev_scaled = 20 * total_rev,
           rough_cpj = total_rev_scaled / journeys_scaled)
    

# Get rough zone-zone costs
zone_costs <- journeys %>% 
    group_by(start_zone,
             end_zone) %>% 
    summarise(journeys = n(),
              total_rev = sum(dfare, na.rm = TRUE) / 100) %>% 
    ungroup() %>% 
    mutate(journeys_scaled = 20 * journeys,
           total_rev_scaled = 20 * total_rev,
           cpj = total_rev_scaled / journeys_scaled) %>% 
    select(start_zone, end_zone, cpj)






