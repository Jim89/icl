# set up -----------------------------------------------------------------------
# load packages
library(quantmod)
library(dplyr)
library(quadprog)
library(ggplot2)
library(tidyr)

# define function to calculate returns using only adjusted close
get_returns <- function(fin_data){
    closes <- fin_data[, 6]
    closes <- as.numeric(closes)
    periods <- length(closes)
    returns <- sapply(2:periods, 
                      function(x) (closes[x] - closes[x-1])/closes[x-1])
    return(returns)
}    

# get data----------------------------------------------------------------------
# set up list of symbols to get
symbols <- c("RDSA.L", 
             "HSBA.L", 
             "BP.L", 
             "VOD.L", 
             "GSK.L", 
             "BATS.L", 
             "SAB.L", 
             "DGE.L", 
             "BG.L", 
             "RIO.L")
# get them    
getSymbols(symbols, from = "2014-01-01", src = "yahoo")


 

