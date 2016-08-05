url <- "https://raw.githubusercontent.com/oobrien/vis/master/tube/data/tfl_lines.json"
lines <- jsonlite::fromJSON(url)


features <- lines$features

geom <- features$geometry