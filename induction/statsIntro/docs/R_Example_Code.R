setwd("D:/portable/Basic Statistics and Probability using R/RBook/")
W <- vector(length = 4);
W[1] = 1
W[2] = 2
W[3] = 1
W[4] = 4
##Data structure
a <- c(1,2,3,4)
b =  c(5,6,7,8)
factor.data = c(1,2,1,2,1,1,2,2)
levels <- factor(factor.data,levels=c(1,2,3),labels=c("M","F","U"))
df <- data.frame(first=a,f=levels)
df
##Logical operation
a = c(TRUE,FALSE)
b = c(FALSE,FALSE)
a|b
##TRUE FALSE
a||b
##TRUE
xor(a,b)
##TRUE FALSE
##Rbind
a <- c(1,2,3,4)
b =  c(5,6,7,8)
rbind(a,W) 
cbind(a,W) 
a[c(-1,-2)]
mat1 = rbind(a,b)
rownames(mat1)
rownames(mat1) = c('first','second')
mat1
mat1['first',]
##column names
mat2 = cbind(a,b)
colnames(mat2)
colnames(mat2) = c('first','second')
mat2
mat2[,'first']
dim(mat2)

a[a>2]
#####List-----------------
x1 <- c(1, 2, 3)
x2 <- c("a", "b", "c", "d")
x3 <- 3
x4 <- matrix(nrow = 2, ncol = 2)
x4[, 1] <- c(1, 2)
x4[, 2] <- c( 3, 4)
Y <- list(x1 = x1, x2 = x2, x3 = x3, x4 = x4)

####operation is element-wise
a <- c(1,2,3,4)
a
a + 5
## 6 7 8 9
a - 10
## -9 -8 -7 -6
a*4
#  4  8 12 16
# a/5
# 0.2 0.4 0.6 0.8
sqrt(a)
#1.000000 1.414214 1.732051 2.000000
exp(a)
#2.718282  7.389056 20.085537 54.598150
log(a)
#0.0000000 0.6931472 1.0986123 1.3862944
exp(log(a))
#1 2 3 4
c <- (a + sqrt(a))/(exp(2)+1)
#0.2384058 0.4069842 0.5640743 0.7152175
########################################
##Sorting the data
########################################
a <- c(4,3,2,1)
ord = order(a)
a = c(2,4,6,3,1,5)
b = sort(a)
c = sort(a,decreasing = TRUE)

########################################
##tapply
#######################################
Veg <- read.table(file="Vegetation2.txt",header= TRUE)
names(Veg)
typeof(Veg)
Veg
##Step 1: Classical method for calculating mean for different Transect
m <- mean(Veg$R)
m1<- mean(Veg$R[Veg$Transect == 1])
m2<- mean(Veg$R[Veg$Transect == 2])
m3<- mean(Veg$R[Veg$Transect == 3])
m4<- mean(Veg$R[Veg$Transect == 4])
m5<- mean(Veg$R[Veg$Transect == 5])
m6<- mean(Veg$R[Veg$Transect == 6])
m7<- mean(Veg$R[Veg$Transect == 7])
m8<- mean(Veg$R[Veg$Transect == 8])
c(m, m1, m2, m3, m4, m5, m6, m7, m8);
##Step 2: do every thing in one go
tapply(Veg$R, Veg$Transect, mean,simplify = FALSE) ##return a list
tapply(Veg$R, Veg$Transect, mean,simplify = TRUE)  ## return a array
sapply(Veg[, 5:20], FUN= mean)
lapply(Veg[, 5:20], FUN= mean)
###################################################
summary(Veg[, 5:20])
##Table############################################
Deer <- read.table(file="Deer.txt", header= TRUE)
table(Deer$Farm)
##The labels 0, 1,2, 3, 4, 5, and 99 in the horizontal direction refer to 2000, 2001, 2002, 2003, 2004,
##2005, and 1999, respectively. In the vertical direction 1 and 2 indicate sex
table(Deer$Sex, Deer$Year)
#################################################
##-------Basic Programming----------------------#
#################################################
###IF statement
x = rnorm(1)
if ( x < 0.2)
{
  x <- x + 1
  cat("increment that number!\n")
} else if ( x < 2.0)
{
  x <- 2.0*x
  cat("not big enough!\n")
} else
{
  x <- x - 1
  cat("nah, make it smaller.\n");
}
x=runif(1,0,1)
###ifelse(condition, condition_is_true, condition is false)
ifelse(x < 0.5, x <- x+1, x <- x+10)

####For loop
for (lupe in seq(0,1,by=0.3))
{
  cat(lupe,"\n");
}
x <- c(1,2,4,8,16)
for (loop in x)
{
  cat("value of loop: ",loop,"\n");
}
####While Loop
lupe <- 1;
x <- 1;
txt = "";
while(x < 4)
{
  x <- rnorm(1,mean=2,sd=3)
  ##cat("trying this value: ",x," (",lupe," times in loop)\n");
  txt=sprintf("%s %f (%d times in loop)","trying this value:",x,lupe)
  print(txt)
  lupe <- lupe + 1
}

##### repeat loop
repeat
{
  x <- rnorm(1)
  if(x < -2.0) break
}
x
###Function
newDef <- function(a,b)
{
  x = runif(10,a,b)
  return(mean(x))
}
newDef(-1,1)


c = c(1,2,3,4,5)
sample <- function(a,b)
{
  value = switch(a,"median"=median(b),"mean"=mean(b),"variance"=var(b))
  largeVals = length(c[c>1])
  return(list(stat=value,number=largeVals))
}
result <- sample("median",c)
result
###function overloading
library(faraway)
data(savings)
g=lm(sr~pop15+pop75+dpi,savings)
plot(g)
#################################################################
###Plot
##################################################################
plot(Veg$BARESOIL, Veg$R) 
##Richness, in this case, is the response, or dependent,
##variable, and BARESOIL is the explanatory, or independent, variable.
plot(R~BARESOIL, data = Veg)
plot(x = Veg$BARESOIL, y = Veg$R, xlab = "Exposed soil",
     ylab = "Species richness", main = "Scatter plot",
     xlim = c(min(Veg$BARESOIL), max(Veg$BARESOIL)), ylim = c(4, 19))
plot(x = Veg$BARESOIL, y = Veg$R,
     xlab = "Exposed soil",
     ylab = "Species richness", main = "Scatter plot",
     xlim = c(0, 45), ylim = c(4, 19), pch = 16)

plot(x = Veg$BARESOIL, y = Veg$R,
     xlab = "Exposed soil",
     ylab = "Species richness", main = "Scatter plot",
     xlim = c(0, 45), ylim = c(4, 19),
     col = 2)
###Adding smooth line
plot(x = Veg$BARESOIL, y = Veg$R,
     xlab = "Exposed soil", ylab = "Species richness",
     main = "Scatter plot", xlim = c(0, 45),
     ylim = c(4, 19))
lines(Veg$R)
hist(Veg$R,breaks=20)
##draw one boxplot for one column
boxplot(cbind(Veg$R,Veg$R),
        main='R in Veg',
        ylab='unit')
###QQ plot 
# Q-Q plots
par(mfrow=c(1,2))
# create sample data 
x <- rt(100, df=3)
# normal fit 
qqnorm(x); qqline(x)  #qqline() adds a line which passes through the first and third quartiles.
abline(0,1) #1st is intercept and 2nd is slope! this is a 45 degree straight line
# t(3Df) fit 
qqplot(rt(1000,df=3), x, main="t(3) Q-Q Plot", 
       ylab="Sample Quantiles")
abline(0,1) #1st is intercept and 2nd is slope! this is a 45 degree straight line
##############################################
####qqline() adds a line which passes through the first and third quartiles.
################################################
par(mfrow=c(1,1))
scores<-matrix(rnorm(100*3),nc=3)
mah_scores = mahalanobis(scores,center=colMeans(scores),cov=cov(scores))
chi_scores = qchisq(ppoints(nrow(scores)),df=3)
qqplot(x=chi_scores,y=mah_scores,asp=1)
abline(a=0,b=1)
qqline(mah_scores, distribution = function(p) qchisq(p,df = 3),col="red")
points(quantile(chi_scores,c(.25,.75)), quantile(mah_scores,c(.25,.75)),col="blue",cex=2,bg="blue",pch=21)
#################################################
###Normal Distribution
#################################################
x <- seq(-5,5,by=.1)
y <- dnorm(x,mean=0,sd=1)
plot(x,y)

x <- seq(-2,2,by=.1)
y <- pnorm(x, mean=0,sd=1)
plot(x,y)

x <- seq(0,1,by=.05)
y <- qnorm(x,mean=0,sd=1)
plot(x,y)

y <- rnorm(2000,mean=0,sd=1)
hist(y, breaks=40)
qqnorm(y)
qqline(y)
##################################################
##t distribution
#################################################
x <- seq(-2,2,by=.1)
y <- dt(x,df=10)
plot(x,y)

pt(3,df=10)

v <- c(0.005,.025,.05)
qt(v,df=10)

rt(3,df=10)
################################################
###Chi-Squared
################################################
x <- seq(0,20,by=.1)
y <- dchisq(x,df=10)
plot(x,y)

x = c(2,4,5,6)
pchisq(x,df=20)

v <- c(0.005,.025,.05)
qchisq(v,df=253)
rchisq(3,df=10)

################################################
###F-Distribution
################################################
x <- seq(0,5,by=.005)
y <- df(x,df1=5,df2=2)
plot(x,y)

x = c(2,4,5,6)
pf(x,df1=5,df2=2)

v <- c(0.005,.025,.05)
qf(v,df1=5,df2=2)
rf(3,df1=5,df2=2)

################################################
library(e1071)
####Skewness and Kurtosis
skewness(y)
kurtosis(y)

########################################################
##Statistics############################################
##Centering#############################################
scale(Veg$R, center = TRUE, scale = FALSE) + mean(Veg$R) 
scale(Veg$R, center = TRUE, scale = TRUE)
median(Veg$R)

energy <- rnorm(100)
dens <- density(energy)
##This is a simple integral: Sigma x_i*delt_t
sum(dens$y*diff(dens$x[1:2]))
hist(energy,probability=TRUE)
lines(density(energy),col="red")
#######################################################
###---------------MLE----------------------------------
###----------------------------------------------------
X <- rnorm(1000)
X <- c(2,5,3,7,-3,-2,0)
fn <- function(theta,x) {
  sum ( 0.5*(x - theta[1])^2/theta[2] + 0.5* log(theta[2]) )
}
out0<-optim( theta <- c(2,9), fn, x=X,hessian=TRUE) # minimization, diff R function
out<-nlm(fn, theta <- c(0,2), x=X, hessian=TRUE) # minimization
fisher.Info <- out$hessian
fisher.Info
solve(fisher.Info)

#####Confidence interval
conf.level <- 0.95
crit <- qnorm((1 + conf.level)/2)
inv.fish <- solve(fisher.Info)
theta.hat = out$estimate
theta.hat[1] + c(-1, 1) * crit * sqrt(inv.fish[1, 1])
theta.hat[2] + c(-1, 1) * crit * sqrt(inv.fish[2, 2])

####MLE improvement
fn2 <- function(theta,x) {
  if (length(theta) != 2) stop("length(theta) must be 2")
  mu <- theta[1]
  sigma.2 <- theta[2]
  value=sum ( 0.5*(x - mu)^2/sigma.2 + 0.5* log(sigma.2) )
  n = length(x);
  grad1 <- -sum(x - mu)
  grad2 <- 0.5*n/sigma.2-0.5*sum((x-mu)^2)/sigma.2^2
  attr(value, "gradient") <- c(grad1, grad2)
  return(value)
}
nlm(fn2, theta <- c(0,2), x=X, hessian=TRUE) # minimization

##########################################
#####CLT
##########################################
hist(rexp(1000),breaks=40)  ##Exponential Distribution

nsamples <- 1000
samplesize <- 3
x <- rep(0,nsamples)
for (i in 1:1000) {
  x[i] <- mean(rexp(samplesize))
}
xfit <- seq(min(x), max(x), length=50)
yfit <- dnorm(xfit, mean=mean(x), sd=sd(x))
hist(x, prob=T, main=paste( "1,000 samples of size",  samplesize ))
lines(xfit, yfit, col="red")

hist(x, prob=T, main=paste( "1,000 samples of size",  samplesize ))
lines(xfit, yfit, col="red")

###Now let's see what happens when we take 1,000 samples of size 3, 6, 12 and 24:
# instruct the figure to plot sequentially in a 2x2 grid
par(mfrow=c(2,3))
nsamples <- 2000
x <- rep(0,nsamples)
for (s in c(3,6,12,24,36,48))
{
  for (i in 1:nsamples) 
  {
    x[i] <- mean(rexp(s))
  }
  xfit <- seq(min(x), max(x), length=50)
  yfit <- dnorm(xfit, mean=mean(x), sd=sd(x))
  hist(x, prob=T, main=paste( nsamples," samples of size",  s ))
  empirical.density = density(x)
  lines(xfit, yfit, col="red")
  lines(density(x), col="blue")
}
###############################################
##Test a single case
##############################################
xr <- 25:175
xrl <- length(xr)
iq <- 140
pline <- dnorm(x=xr, mean=100, sd=15)
plot(xr, pline, type="l", xlab="IQ", ylab="probability")
lines(c(min(xr), max(xr)), c(0,0))
lines(c(iq,iq), c(0,.03), col="red")
hb <- max(which(xr<=iq))
polygon(c(x[hb:xrl], rev(x[hb:xrl])), c(pline[hb:xrl], rep(0, xrl-hb+1)), col="red")
##To determine the probability, we can use the pnorm() command:
##The probability equals the area under the normal curve to the right of the IQ=140 point:
p <- 1-pnorm(140, mean=100, sd=15)

#The reason we have to use \texttt{1-pnorm()} is because by default
#\texttt{pnorm()} reports the lower tail of the distribution, and we
#want the upper tail.
###############################################
##Test a single group
##############################################
z <- (115-100)/(15/sqrt(20))
p <- 1-pnorm(z)
###############################################
##Test a single group using t-distribution
##############################################
tobs <- (115-100)/(30/sqrt(20))
p <- 1-pt(tobs, 19)

#############################################
##Confidence interval for the test
############################################
n <- 20
tcrit <- qt(1-(0.05/2), df=n-1)
sxbar <- 30/sqrt(20)
cim <- c(115-(tcrit*sxbar), 115+(tcrit*sxbar))
##The degrees of freedom for the t-statistic are N-1. Note also we
##divide our $\alpha$ by two in order to get both tails of the
##t-distribution.

#############################################
##t test for two independent groups
############################################
g1 <- c(5,4,4,6,5)
g2 <- c(6,7,5,8,7)
t.test(g1, g2, alternative="two.sided", paired=FALSE, var.equal=TRUE)

bartlett.test(c(g1,g2), c(rep(1,5), rep(2,5)))

#############################################
##t test for two correlated groups
############################################
t.test(g1, g2, alternative="two.sided", paired=TRUE, var.equal=TRUE)