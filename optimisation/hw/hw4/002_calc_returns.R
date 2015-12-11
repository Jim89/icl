# load packages define some utility functions and get the data------------------
library(dplyr)
library(magrittr)
library(ggplot2)


# define a utlity function to normalise a vector
    norm <- function(vector){
        return(vector/sum(vector))
    }

# define function to calculate returns using only adjusted close
    get_returns <- function(fin_data){
        closes <- fin_data[, 6]
        closes <- as.numeric(closes)
        periods <- length(closes)
        returns <- sapply(2:periods, 
                          function(x) (closes[x] - closes[x-1])/closes[x-1])
        return(returns)
    }     

stocks <- list("RDS-A", "HSBA.L", "BP.L", "VOD.L", "GSK.L", "BTI", "SAB.L", "DGE.L", "BG.L", "RIO.L")    
if (sum(stocks %in% ls()) != length(stocks)) {
    source("hw/hw4/001_get_symbols.R")
}

# prepare data -----------------------------------------------------------------    
# calculate weekly returns
objects <- list(`RDS-A`, HSBA.L, BP.L, VOD.L, GSK.L, BTI, SAB.L, DGE.L, BG.L, RIO.L)
# returns <- lapply(objects, weeklyReturn)
    weekly <- lapply(objects, to.weekly)
    weekly_dfs <- lapply(weekly, data.frame)
    returns <- lapply(weekly_dfs, get_returns)


# combine in to single data frame with tidy names    
returns_data <- lapply(returns, data.frame) %>% 
    bind_cols %>% 
    setNames(stocks)
names(returns_data) <- make.names(names(returns_data))

# calculate mean returns  
avg_returns <- apply(returns_data, 2, mean)

# calcuate return covariances
covars <- cov(returns_data)















