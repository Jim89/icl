# set up -----------------------------------------------------------------------
# load packages
library(quantmod)
library(dplyr)
library(magrittr)
library(ggplot2)

# get data----------------------------------------------------------------------
# symbols <- c("RDSA", "HSBA", "BP", "VOD", "GSK", "BTI", "SAB", "DGE", "BG", "RIO")
# set up list of symbols to get
    symbols <- c("RDS-A", 
                 "HSBA.L", 
                 "BP.L", 
                 "VOD.L", 
                 "GSK.L", 
                 "BTI", 
                 "SAB.L", 
                 "DGE.L", 
                 "BG.L", 
                 "RIO.L")
# get them    
    getSymbols(symbols, from = "2013-01-01")
    
    
# define function to calculate returns using only adjusted close
    get_returns <- function(fin_data){
        closes <- fin_data[, 6]
        closes <- as.numeric(closes)
        periods <- length(closes)
        returns <- sapply(2:periods, 
                          function(x) (closes[x] - closes[x-1])/closes[x-1])
        return(returns)
    }        
