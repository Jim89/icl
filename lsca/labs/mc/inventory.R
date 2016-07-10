# given ROP, what is the corresponding CSL?
DL <- rnorm(10000, mean=2*2500, sd=sqrt(2)*500)
CSL1 <- mean(DL<=6000); CSL1
CSL2 <- pnorm(6000, mean=2*2500, sd=sqrt(2)*500); CSL2

# given desired CSL, what is the required ROP?
csl <- 0.9
d <- rnorm(10000, mean=2000, sd=1000)
ROP1 <- qnorm(csl)*500*sqrt(4)+500*4; ROP1
f <- function(Q, d, csl) (mean(d<=Q)-csl)^2
ROP2 <- optimize(f, c(0, 5000), d=rnorm(10000, mean=2000, sd=1000), csl=0.9); ROP2

# Optimal product availability: an example
p <- 250
c <- 100
s <- 80
Cu <- p-c
Co <- c-s
Q1 <- qnorm(Cu/(Cu+Co), mean=350, sd=150); Q1
d <- rnorm(10000, mean=350, sd=150)
f <- function(Q,p,c,s,d) mean(p*pmin(Q,d)+s*pmax((Q-d),0)-c*Q)
Q2 <- optimize(f, c(0, 800), p=250, c=100, s=80, d=rnorm(10000, mean=350, sd=150), maximum=T); Q2

CSL <- mean(d<=Q2$maximum); CSL
profit <- mean(p*pmin(Q2$maximum,d)+s*pmax((Q2$maximum-d),0)-c*Q2$maximum); profit
overstock <- mean(pmax((Q2$maximum-d),0)); overstock
understock <- mean(pmax((d-Q2$maximum),0)); understock

# Value of postponement: Benetton
f <- function(Q,p,c,s,d) mean(p*pmin(Q,d)+s*pmax((Q-d),0)-c*Q)
Qd <- optimize(f, c(0, 2500), p=50, c=20, s=10, d=rnorm(10000, mean=1000, sd=500), maximum=T); Qd
profit_d <- 4*Qd$objective; profit_d
Qa <- optimize(f, c(0, 7000), p=50, c=22, s=10, d=rnorm(10000, mean=4000, sd=1000), maximum=T); Qa
profit_a <- Qa$objective; profit_a

# Tailored postponement: Benetton
p <- 50
s <- 10
ca <- 22
cd <- 20
d1 <- rnorm(100000, mean=1000, sd=500)
d2 <- rnorm(100000, mean=1000, sd=500)
d3 <- rnorm(100000, mean=1000, sd=500)
d4 <- rnorm(100000, mean=1000, sd=500)
qA <- 850
q1 <- 1000
profit <- mean(p*(pmin(q1,d1)+pmin(q1,d2)+pmin(q1,d3)+pmin(q1,d4)+pmin((pmax(d1-q1,0)+pmax(d2-q1,0)+pmax(d3-q1,0)+pmax(d4-q1,0)),qA))
               +s*(pmax((q1-d1),0)+pmax((q1-d2),0)+pmax((q1-d3),0)+pmax((q1-d4),0)
                   +pmax(qA-(pmax(d1-q1,0)+pmax(d2-q1,0)+pmax(d3-q1,0)+pmax(d4-q1,0)),0))-4*cd*q1-ca*qA); profit