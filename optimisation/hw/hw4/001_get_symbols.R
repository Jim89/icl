# set up -----------------------------------------------------------------------
# load packages
library(quantmod)
library(dplyr)
library(magrittr)

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

# prepare data -----------------------------------------------------------------    
# calculate weekly returns
    objects <- list(`RDS-A`, HSBA.L, BP.L, VOD.L, GSK.L, BTI, SAB.L, DGE.L, BG.L, RIO.L)
    returns <- lapply(objects, weeklyReturn)
    returns_data <- lapply(returns, data.frame) %>% 
                    bind_cols %>% 
                    setNames(symbols)
    names(returns_data) <- make.names(names(returns_data))
    
    rdsa_wr <- weeklyReturn(`RDS-A`)
    hsba_wr <- weeklyReturn(HSBA.L)
    bp_wr <- weeklyReturn(BP.L)
    vod_wr <- weeklyReturn(VOD.L)
    gsk_wr <- weeklyReturn(GSK.L)
    bti_wr <- weeklyReturn(BTI)
    sab_wr <- weeklyReturn(SAB.L)
    dge_wr <- weeklyReturn(DGE.L)
    bg_wr <- weeklyReturn(BG.L)
    rio_wr <- weeklyReturn(RIO.L)
    
# combine in to table
    returns <- data_frame(rdsa = rdsa_wr %>% as.numeric(),
                          hsba = hsba_wr %>% as.numeric(),
                          bp = bp_wr %>% as.numeric(),
                          vod = vod_wr %>% as.numeric(),
                          gsk = gsk_wr %>% as.numeric(),
                          bti = bti_wr %>% as.numeric(),
                          sab = sab_wr %>% as.numeric(),
                          dge = dge_wr %>% as.numeric(),
                          bg = bg_wr %>% as.numeric(),
                          rio = rio_wr %>% as.numeric())    
    

    avg_returns <- apply(returns, 2, mean)
    