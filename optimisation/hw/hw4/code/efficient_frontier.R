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
symbols <- c("RDSA.L", # Royal Dutch Shell
             "HSBA.L", # HSBC
             "BP.L",   # BP
             "VOD.L",  # Vodafone
             "GSK.L",  # GlaxoSmithKline
             "BATS.L", # British American Tobacco
             "SAB.L",  # SABMiller
             "DGE.L",  # Diageo
             "BG.L",   # BG Group
             "RIO.L")  # Rio Tinto
# get them    
getSymbols(symbols, from = "2013-12-01", src = "yahoo")

# prepare data -----------------------------------------------------------------
objects <- list(RDSA.L, HSBA.L, BP.L, VOD.L, GSK.L, BATS.L, SAB.L, DGE.L, BG.L, RIO.L)

# calculate returns
weekly <- lapply(objects, to.weekly) # convert daily returns data to weekly
weekly_dfs <- lapply(weekly, data.frame) # convert to data frames
returns <- lapply(weekly_dfs, get_returns) # use defined function to get returns


# combine in to single data frame with tidy names    
returns_data <- lapply(returns, data.frame) %>% 
                bind_cols() %>% 
                setNames(symbols)
names(returns_data) <- make.names(names(returns_data))

# calculate mean returns (i.e. mu) 
avg_returns <- apply(returns_data, 2, mean)

# calcuate return covariances (i.e. Sigma)
covars <- cov(returns_data)

# attempt to solve minimisation problem ----------------------------------------
# number of stocks
n <- ncol(returns_data)

# A-matrix - defines constraints - include diagonal for no short selling
Amat <- cbind(1, diag(n))

# b-vector - defines constraint RHS value(s) - first value for proportionality,
# remaining values for no short selling
bvec <- c(1, rep(0, n))

# set parameters
risk_upper_bound <- 10
risk_increment <- 0.001

# generate combinations for return risk premium
premiums <- seq(from = 0, to = risk_upper_bound, by = risk_increment)

# initialse tbl to hold solutions + cols for variance and return
results <- matrix(nrow = length(premiums), ncol = n + 2) 

# set the names on the results tbl
colnames(results) <- c(symbols, "variance", "returns")

# counter to keep track of iterations
iter <- 1

# iterate over the possible return values to generate the efficient frontier
for (i in premiums) {
    # set the returns value - either a fraction or a multiplication of mean returns
    # that were calculated previously
    dvec <- colMeans(returns_data) * i 
    
    # solve the system with that value of returns
    sol <- solve.QP(covars, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
    
    # extract the solution, i.e the choices for stocks
    choices <- sol$solution
    
    # get variance and returns for that set of choices
    var <- t(choices) %*% covars %*% choices
    ret <- colMeans(returns_data) %*% choices
    
    # save results to the tbl
    results[iter, 1:n] <- choices
    results[iter, n+1] <- var
    results[iter, n+2] <- ret
    
    # update the iteration counter
    iter <- iter + 1
    
}

# convert results to a data frame for creating charts
results <- data.frame(results)
 
# grab 3 portfolios ------------------------------------------------------------
low <- results %>% filter(returns >= 0) %>% slice(1) # low risk/return
med <- results %>% slice(100)                               # med risk/return
high <- results %>% filter(returns == max(results$returns)) # high risk/return

# get individual stock results -------------------------------------------------
# set up structure to hold results
single_stocks <- matrix(nrow = length(avg_returns), ncol = 3)
colnames(single_stocks) <- c("stock", "var", "ret")

# find returns for single-stock portfolios
for (stock in seq_along(avg_returns)){
    # set up choices vector
    choices <- rep(0, 10) %>% matrix
    choices[stock] <- 1.0
    
    # get variance and returns for that stock
    var <- t(choices) %*% covars %*% choices
    ret <- avg_returns %*% choices
    single_stocks[stock, 1] <- names(avg_returns)[stock]
    single_stocks[stock, 2] <- var
    single_stocks[stock, 3] <- ret
}
# convert to data frame    
single_stocks <- data.frame(single_stocks, stringsAsFactors = FALSE)
single_stocks$var <- as.numeric(single_stocks$var)
single_stocks$ret <- as.numeric(single_stocks$ret)

# create plots --------------------------------------------------------------
# define function to present (graphically) the portfolio contributions
show_proportions <- function(data) {
    gather(data, stock, prop) %>% # take data from wide to long format
        mutate(prop = 100*round(prop, 2)) %>% # convert proportions to percentage
        ggplot(aes_string(x = "stock", y = "prop"))+ # make the plot
        geom_bar(stat = "identity", # add bars
                 fill = "steelblue", 
                 alpha = .45,
                 colour = "dodgerblue4") +
        labs(x = "Stock", y = "Percentage in Portfolio") + # add axis labels
        ggtitle("Portfolio Composition") + # add title
        theme(panel.background=element_rect(fill="white"), # make it look pretty
              text=element_text(color = "black"))
}    

# create the plots for each portfolio
low_plot <- show_proportions(low[, 1:10]) 
med_plot <- show_proportions(med[, 1:10]) 
high_plot <- show_proportions(high[, 1:10]) 

# plot the efficient frontier from the results
frontier <- ggplot(results, aes(x = variance, y = returns)) + # create the plot
            geom_point(alpha = .35, color = "steelblue") + # add the points
            ggtitle("Efficient Frontier") + # add plot title
            labs(x="Portfolio Risk", y = "Portfolio Return") + # add axis labels
            theme(panel.background=element_rect(fill="white"), # make it pretty
                  text=element_text(color = "black"),
                  plot.title=element_text(size=24, color="black"),
                  axis.text.x = element_text(angle = -90))

# add portfolios
frontier_with_ports <- frontier +
                        # add low risk point with annotation
                        geom_point(data = low, 
                                   aes(x = variance, y = returns), 
                                   size = 3.5, 
                                   colour = "firebrick",
                                   alpha = .75) +
                        annotate(geom = "text",
                                 label = "Low-Risk/Low-Return\n Portfolio", 
                                 x = low$variance + 0.000125,
                                 y = low$returns + 0.0001) +
                        # add medium risk point with annotation
                        geom_point(data = med, 
                                   aes(x = variance, y = returns), 
                                   size = 3.5, 
                                   colour = "firebrick",
                                   alpha = .75) +
                        annotate(geom = "text",
                                 label = "Medium-Risk/\nMedium-Return\n Portfolio", 
                                 x = med$variance + 0.000095,
                                 y = med$returns - 0.00035) +    
                        # add high risk point with annotation
                        geom_point(data = high, 
                                   aes(x = variance, y = returns), 
                                   size = 3.5, 
                                   colour = "firebrick",
                                   alpha = .75) +
                        annotate(geom = "text",
                                 label = "High-Risk/\nHigh-Return\n Portfolio", 
                                 x = high$variance - 0.000025,
                                 y = high$returns - 0.0005) +
                        scale_x_continuous(breaks = seq(from = 0, # set the scale
                                                        to = max(results$variance),
                                                        by = 0.00005)) 

# display single stock portfolios
frontier_with_stocks <- frontier +
                        geom_line() +
                        geom_point(data = single_stocks,
                                   aes(x = var, y = ret, colour = stock),
                                   size = 3.5,
                                   alpha = 1) +
                        scale_colour_brewer(palette="Paired")+
                        theme(legend.position = "bottom",
                              legend.title = element_blank()) +
                        ggtitle("Efficient Frontier with Individual Stock Portfolios")


