# Markovitz problems -----------------------------------------------------------    
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

# set up simulation parameters        
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