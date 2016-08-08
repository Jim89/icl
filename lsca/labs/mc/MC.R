# performance of built-in generators - uniform distribution
Nsim=10^4 #number of random numbers
x=runif(Nsim)
x1=x[-Nsim] #vectors to plot
x2=x[-1] #adjacent pairs
par(mfrow=c(1,3))
hist(x,cex.lab=2, cex.axis=2, cex.main=2, cex.sub=2)
plot(x1,x2,cex.lab=2, cex.axis=2, cex.main=2, cex.sub=2)
acf(x,cex.lab=2, cex.axis=2, cex.main=2, cex.sub=2)

# Deterministic sequence based on the seed
set.seed(1)
runif(5)
set.seed(1)
runif(5)
set.seed(2)
runif(5)

# Inverse transform to generate non-standard distributions
Nsim=10^4 #number of random variables
U=runif(Nsim)
X=-log(1-U) #transforms of uniforms
Y=rexp(Nsim) #exponentials from R
par(mfrow=c(1,2)) #plots
hist(X,freq=F,main="Exp from Uniform")
hist(Y,freq=F,main="Exp from R")

# Generating non-standard discrete distributions
Nsim=10^4 #number of random variables
U=runif(Nsim)
U[U<=0.01] = 4
U[0.01<U & U<=0.03] = 5
U[0.03<U & U<=0.07] = 6
U[0.07<U & U<=0.15] = 7
U[0.15<U & U<=0.24] = 8
U[0.24<U & U<=0.35] = 9
U[0.35<U & U<=0.51] = 10
U[0.51<U & U<=0.71] = 11
U[0.71<U & U<=0.82] = 12
U[0.82<U & U<=0.92] = 13
U[0.92<U & U<=0.96] = 14
U[0.96<U & U<=0.98] = 15
U[0.98<U & U<=0.99] = 16
U[0.99<U & U<=1] = 17
hist(U, breaks=4:18, right=F, freq=F)

# Evaluating monthly payments with the new plan
usage_1000 <- rnorm(1000, mean=23, sd=5)
payment_1000 <- 160+15*pmax((usage_1000-20),0)
mean(payment_1000)
par(mfrow=c(1,2)) #plots
hist(usage_1000,breaks=20,freq=F,main="Monthly Usage")
hist(payment_1000,breaks=20,freq=F,main="Monthly Payment")