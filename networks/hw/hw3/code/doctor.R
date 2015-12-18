# set up and load packages -----------------------------------------------------
# clear out working directory
  rm(list = ls())

# load packages   
  library(readr)        # for reading data
  library(dplyr)        # for data manipulations
  library(magrittr)     # for pipelines
  library(minpack.lm)   # for fitting Bass model
  library(ggplot2)      # for plotting
  library(tidyr)        # for reshaping

# get the data------------------------------------------------------------------
# read in data and set names to lower case
  doctor <- read_tsv("../data/doctor.txt")
  names(doctor) <- tolower(names(doctor))

# add lagged cumulative sales which we'll need for the formula
  doctor %<>% mutate(cs_lag = lag(cumulative_revenues))
  doctor[is.na(doctor)] <- 0

# get first 4 periods for predictions
  doctor4 <- head(doctor, 4)

# fit the model ----------------------------------------------------------------
# forcast revenues F_t given by     (p+q(C_{t-1}/m)(m-C_{t-1})
bass_fit <- nlsLM(formula = revenues ~ (p + q * (cs_lag/m))*(m - cs_lag),
                  data = doctor4,
                  start = list(m = 1, p = 1, q = 1))

# get the fitted parameters
  m <- coef(bass_fit)[1]
  p <- coef(bass_fit)[2]
  q <- coef(bass_fit)[3]

  
# calculate forcasted revenues in the whole data set
# add empty field to fill
  doctor$Prediction <- 0
  doctor4$Prediction <- 0

# add customer function to return prediction  
  pred <- function(prev_pred, m, p, q){
    ans <- (p + q * (prev_pred / m)) * (m - prev_pred)
    return(ans)
  }

# estimate on full data
  for (i in 1:nrow(doctor)) {
    if (i == 1) {
    prev_pred <- 0
    doctor[i, "Prediction"] <- pred(prev_pred, m, p, q)
    } else {
       prev_pred <- as.numeric(unlist(cumsum(doctor[1:i, "Prediction"])))[i-1]
       doctor[i, "Prediction"] <- pred(prev_pred, m, p, q)
    }
  }    



# make some plots --------------------------------------------------------------
forecast <-   doctor %>% 
              slice(1:4) %>% 
              select(1, 2, 5) %>%
              rename(Actual = revenues) %>% 
              gather(key = type, value = rev, Actual, Prediction) %>% 
              ggplot(aes(x = week, y = rev, colour = type)) +
              geom_line() +
              geom_point(aes(shape = type)) +
              scale_x_continuous(breaks = seq(from = 0, to =  12, by = 1)) +
              scale_y_continuous(breaks = seq(from = 0, to =  10, by = 1)) +
              labs(x = "Week", y = "Revenue ($m)") +
              theme_minimal() +
              theme(legend.position = "bottom",
                    legend.title = element_blank())

    
    