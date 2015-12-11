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

# prepare data -----------------------------------------------------------------    
# calculate weekly returns
    objects <- list(`RDS-A`, HSBA.L, BP.L, VOD.L, GSK.L, BTI, SAB.L, DGE.L, BG.L, RIO.L)
    weekly <- lapply(objects, to.weekly)
    weekly_dfs <- lapply(weekly, data.frame)
    returns <- lapply(weekly_dfs, get_returns)
    

# combine in to single data frame with tidy names    
    returns_data <- lapply(returns, data.frame) %>% 
                    bind_cols %>% 
                    setNames(symbols)
    names(returns_data) <- make.names(names(returns_data))
    
# calculate mean returns  
    avg_returns <- apply(returns_data, 2, mean)
    
# calcuate return covariances
    covars <- cov(returns_data)
    
# Markovitz problems -----------------------------------------------------------    
# define a utlity function to normalise a vector
    norm <- function(vector){
        return(vector/sum(vector))
    }
    
# define a function to calculate expected variance and return
    get_return_and_variance <- function(n_stocks, expected_returns, covariances){
        # generate a set of random choices in matrix form
        choices <- seq(0, 1, by = 0.01) %>% sample(n_stocks) %>% norm %>% matrix
        
        # calculate portfolio variance
        var <- t(choices) %*% covariances %*% choices
        
        # calculate expected returns
        ret <- t(expected_returns) %*% choices
        
        return(list("variance" = var, "returns" = ret))
}
    
n_stocks <- ncol(returns_data)
expected_returns <- matrix(avg_returns)
covariances <- covars

iters <- 10000

sims <- sapply(1:iters, 
               function(x) get_return_and_variance(n_stocks, 
                                                   expected_returns, 
                                                   covariances)) %>% 
        t %>% 
        data.frame() %>% 
        apply(2, as.numeric) %>% 
        data.frame()

# plot efficient frontier
    ggplot(sims, aes(x = variance, y = returns)) +
        geom_point() +
        xlab("Risk") +
        ylab("Return")

   
    


    
    
    
    
    
    
    