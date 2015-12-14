# set up -----------------------------------------------------------------------
# load packages
library(quantmod)

# get data----------------------------------------------------------------------
# symbols <- c("RDSA", "HSBA", "BP", "VOD", "GSK", "BTI", "SAB", "DGE", "BG", "RIO")
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
    getSymbols(symbols, from = "2013-12-01")
   
