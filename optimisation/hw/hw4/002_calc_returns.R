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

# attempt to solve minimisation problem ----------------------------------------
# will use general form of quadratic program see here:
# http://www.rinfinance.com/RinFinance2009/presentations/yollin_slides.pdf
# for details

# number of stocks
n <- ncol(returns_data)

# A-matrix - defines constraints - include diagonal for no short selling
Amat <- cbind(1, diag(n))

# b-vector - defines constraint RHS value(s)
bvec <- c(1, rep(0, n))

# set parameters
risk_upper_bound <- 1
risk_increment <- 0.001

# combinations for return risk premium
premiums <- seq(from = 0, to = risk_upper_bound, by = risk_increment)

# initialse tbl to hold solution and 2 cols for variance and return
results <- matrix(nrow = length(premiums), ncol = n + 2) 

# set the names on the results tbl
colnames(results) <- c(stocks, "variance", "returns")

# counter to keep track of iterations
iter <- 1
for (i in premiums) {
    # set the acceptable returns threshold - some fraction of the mean returns
    # that was calculated previously
    dvec <- colMeans(returns_data) * i 
    
    # solve the system with that minimal value of acceptable returns
    sol <- solve.QP(covars, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
    
    # extract the solution, i.e the choices 
    choices <- sol$solution
    
    # get variance and return
    var <- t(choices) %*% covars %*% choices
    ret <- t(avg_returns) %*% choices
    
    # save results to the tbl
    results[iter, 1:n] <- choices
    results[iter, n+1] <- var
    results[iter, n+2] <- ret
    
    # update the iteration counter
    iter <- iter + 1
    
}

results <- data.frame(results)
