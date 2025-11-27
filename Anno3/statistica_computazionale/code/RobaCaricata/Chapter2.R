#### Size of a Lake
require(reshape2)
# Empty field
# field size =12x12=144
field <- matrix(0,12,12)
# let's build a lake!
field[2,c(3:5)] <- 1
field[3,c(2:7)] <- 1
field[4,c(1:7)] <- 1
field[5,c(2:9)] <- 1
field[6,c(3:9)] <- 1
field[7,c(4:8)] <- 1
field[8,c(5:7)] <- 1
field.plot <- melt(field)
plot(field.plot$Var1,
     field.plot$Var2,
     col=field.plot$value,
     cex=1.5,
     pch=16)

## Now, we launch some cannonballs and see if we 'hit'
N <- 200 #number of shots
shots <- matrix(0,N,2)
hit.or.miss <- rep(0,N)
for(i in 1:N){
  shots[i,] <- c(sample(1:12,1,replace=T),sample(1:12,1,replace=T))
  hit.or.miss[i] <- (field[shots[i,1],shots[i,2]]==1)
}
sum(hit.or.miss)
mean(hit.or.miss)
## Size of the lake
mean(hit.or.miss)*144
round(mean(hit.or.miss)*144,0)
sum(field)


## How does the quality 'change' when we throw more cannonballs?
HoM <- function(N,field){
  shots <- matrix(0,N,2)
  hit.or.miss <- rep(0,N)
  for(i in 1:N){
    shots[i,] <- c(sample(1:dim(field)[1],1,replace=T),sample(1:dim(field)[2],1,replace=T))
    hit.or.miss[i] <- (field[shots[i,1],shots[i,2]]==1)
  }
  return(round(mean(hit.or.miss)*prod(dim(field)),0))
}
## Let's visualize the changes with respect to this number
N.shots <- 500
plot.estimate <- rep(0,N.shots)
NN <- seq(1,N.shots, length.out=N.shots)
for(i in 1:N.shots){
  plot.estimate[i] <- HoM(NN[i],field)
} 
plot(NN, plot.estimate,
     cex=0.2,
     pch=16,
     type="b")
abline(h=sum(field),col=2,lwd=2)



### Built-in Random generation
rgamma(3,2.5,4.5)
curve(dgamma(x,2.5,8), from=0, to=4)


#UNIFORM SIMULATION
runif(100,2,5)

Nsim=10^4
x=runif(Nsim)
x1=x[-Nsim]
x2=x[-1]
par(mfrow=c(1,3))
hist(x,freq=F)
plot(x1,x2)
acf(x)
par(mfrow=c(1,1))

# set.seed(1)
runif(5)

set.seed(1)
runif(10)

set.seed(2)
runif(5)


#THE INVERSE TRANSFORM
Nsim=10^4
U=runif(Nsim)
# X=-log(U)
X=-log(1-U)
Y=rexp(Nsim)
par(mfrow=c(1,2))
hist(X,freq=F,main="Exp from Uniform")
curve(dexp(x),col="red",add=TRUE)
hist(Y,freq=F,main="Exp from R")
curve(dexp(x),col="red",add=TRUE)

#Exercise 1
Nsim=10^4
U=runif(Nsim)
beta=0.2
mu=0
X=-beta*log((1-U)/U)+mu
plot(ecdf(X))
## CDF of a Logistic R.V.
plog<-function(x,beta,mu){
  myF<-1/(1+exp(-(x-mu)/beta))
}

curve(plog(x,beta,mu),col="red",add=TRUE)

#Exercise 2
Nsim=10^1
U=runif(Nsim)
sigma=1
mu=0
X=sigma*tan(pi*(U-0.5))+mu
plot(ecdf(X))
pcauchy<-function(x,sigma,mu){
  myF<-0.5+(1/pi)*atan((x-mu)/sigma)
}

curve(pcauchy(x,sigma,mu),col="red",add=TRUE)


#GENERAL TRANSFORM METHODS
U=runif(3*10^4)
U=matrix(data=U,nrow=3)
X=-log(U)
X=2*apply(X,2,sum)
hist(X,freq=F)
curve(dchisq(x,6),col="red",add=TRUE)

test1<-function(Nsim){
  U=runif(3*10^4)
  U=matrix(data=U,nrow=3)
  X=-log(U)
  X=2*apply(X,2,sum)
  return(X)  
}

system.time(test1(Nsim))
system.time(rchisq(Nsim,6))



#Multivariate normal generators

library(MASS)
X=mvrnorm(10^4,rep(0,4),diag(c(1,2,3,4)))

#DISCRETE DISTRIBUTIONS
# To generate X, with X distributed as a Binomial (10, 0.3)
#Binomial
rbin<-function(n,x,p){
  values<-rep(NA,n)
  P<-cumsum(p)
  for (i in 1:n){U<-runif(1)
                 j<-1
                 while (U >P[j]) j<-j+1
                 values[i]<-x[j]}
  values
}

x1=rbin(10^4,0:10,dbinom(0:10,10,0.3))

x2=sample(0:10,10^4,replace=TRUE,dbinom(0:10,10,0.3))

x3=rbinom(10^4,10,0.3)

par(mfrow=c(1,3))
plot(ecdf(x1))
lines(pbinom(0:10,10,0.7),type="h",col="red")
plot(ecdf(x2))
lines(pbinom(0:10,10,0.7),type="h",col="red")
plot(ecdf(x3))
lines(pbinom(0:10,10,0.7),type="h",col="red")
par(mfrow=c(1,1))

system.time(rbin(10^4,0:6,dbinom(0:6,6,0.7)))
system.time(sample(0:6,10^4,replace=TRUE,dbinom(0:6,6,0.7)))
system.time(rbinom(10^4,6,0.7))


#Poisson
Nsim=10^4
lambda=100
spread=3*sqrt(lambda)
t=round(seq(max(0,lambda-spread),lambda+spread,1))
prob=ppois(t,lambda) # Cumulative probs
X=rep(0,Nsim)
for (i in 1:Nsim){
  u=runif(1)
  X[i]=t[1]+sum(prob<u)-1
}

hist(X,freq=FALSE)
curve(dpois(x,lambda=100),from=70, to=130,type="h",col="red",add=TRUE)

acf(X)

### Homework assignments: Direct methods
# Ex. 2.11
# a) Generate a binomial Bin(25; 0.2)
{
  random.binom <- function(n, trial, prob){	
    cf <- pbinom(0:trial, trial,prob)
    x <- rep(0,n)
    for(i in 1:n){
      u <- runif(1)
      x[i] <- sum(cf<u)
    }
    return(x)
  }
  
  # Plot the results
  N.sim <- 10^5
  x <- random.binom(N.sim,25,0.2)
  hist(x, freq=F) 
  lines(1:25, dbinom(1:25,size=25,prob=0.2), col="red")
  
  # Compare with in-built function in R
  system.time(random.binom(N.sim,25,0.2))
  system.time(rbinom(N.sim,25,0.2))
}

# b) For alpha in [0,1], show that the pseudo-code
# u = runif(1)
# while(u>alpha) u=runif(1)
# U=u
# produces a random variable U=Unif(0; alpha)
{
  uni.alpha <- function(n,alpha){
    x <- rep(0,n)
    for(i in 1:n){
      u <- runif(1)
      while(u>alpha) u <- runif(1)
      x[i] <- u
    }
    return(x)
  }
  
  alpha <- 0.3
  hist(uni.alpha(10^5, alpha), freq=F)
  curve(dunif(x, max=alpha),col="red",add=T)
  
  # Compare it with the transformation alpha*U with U=Unif(0,1)
  uni.alpha2 <- function(n, alpha){
    x <- rep(0,n)
    for(i in 1:n){
      x[i] <- alpha*runif(1)
    }
    return(x)
  }
  
  alpha <- 0.3
  hist(uni.alpha2(10^5, alpha), freq=F)
  curve(dunif(x, max=alpha),col="red",add=T)
  
  system.time(uni.alpha(10^5,alpha=1))
  system.time(uni.alpha2(10^5,alpha=1))
}

# Ex. 2.13
# The Pareto distribution P(alpha) is defined by its density
# f(x)= alpha*x^(alpha-1)
# over the domain x in (1, +inf)
# Show that it can be generated as the (-1/alpha) power of a uniform random variable
# F(x) is the integral from 1 to +inf of f(x), which is equal to: 1-x^(-alpha)
# We set F(x)=u, which means
# 1-x^(-alpha)=u
# -x^(-alpha)=u-1
# x^(-alpha)=1-u
# x=(1-u)^(-1/alpha)
# with u drawn from a uniform distribution in (0,1)
# Code:

dpareto <- function(x, alpha){
  alpha*x^(-alpha-1)
}
random.pareto <- function(n, alpha){
  x <- runif(n)^(-1/alpha)
  return(x)
}
alpha <- 10
x <- random.pareto(10^5,alpha)
hist(x, freq=F)
curve(dpareto(x,alpha),col="red",add=T)


### Mixture representation
## Negative Binomial
Nsim <- 10^4
n <- 6
p <- 0.3
y <- rgamma(Nsim, n,rate=p/(1-p))
x <- rpois(Nsim,y)
hist(x,main="",freq=F,col="grey",breaks=40)
lines(1:50, dnbinom(1:50,n,p), lwd=2, col="sienna")

## Bimodal density (mixture of two Normals)
Nsim <- 10^4
sigma <- 1.5
group <- sample(1:2,Nsim,replace=T,c(0.7,0.3))
mu <- c(-4,4)
x <- rnorm(Nsim,mu[group],sd=sigma)
hist(x,main="",freq=F,col="grey",breaks=40)
lines(-10:10,
      0.7*dnorm(-10:10,mu[1],sd=sigma)+0.3*dnorm(-10:10,mu[2],sd=sigma),
      lwd=2, col="sienna")




#ACCEPT-REJECTION ALGORITHM - R implementation
# This is just a SCHEME/OUTLINE/SKETCH of the algorithm
# DO NOT RUN!
u=runif(1)*M
y=randg(1)
while (u>f(y)/g(y))
{
  u=runif(1)*M
  y=randg(1)
} 

### Intuition on AR algorithm
# Example 2.7
# Very inefficient 'coding' example but it shows the idea behind AR
Nsim <- 1000
x <- NULL
M <- 2.75
curve(dbeta(x,2.0,5.0), col=2, lwd=3, ylim=c(0,3))
abline(h=M, lty=2, lwd=2)
while(length(x)<Nsim){
  y <- runif(1)
  u <- runif(1)
  if (u*M<=dbeta(y,2.0,5.0)){
    x <- c(x,y)
    accepted <- TRUE
  } else {
    accepted <- FALSE
  }
  points(y,u*M, pch=18, cex=0.7, col=ifelse(accepted,2,1))
  # invisible(readline(prompt="Press [enter] to continue"))
}



#Generating normals from double exponentials
# Double exponential = Laplace with alpha=1
dlaplace<-function(x) 0.5*exp(-abs(x))
plaplace<-function(x) 0.5*(1+sign(x)*(1-exp(-x)))
qlaplace<-function(p) -sign(p-0.5)*log(1-2*abs(p-0.5))
rlaplace<-function(n) qlaplace(runif(n))

curve(dlaplace(x),-6,6,ylim=c(0,0.8),lty="dashed")
curve(dnorm(x),-6,6,col="red",add=TRUE)

M<-sqrt(2*exp(1)/pi)

f1<-function(x) dnorm(x)/dlaplace(x)

curve(f1(x), -6, 6)
M1<-optimize(f1, interval=c(-6,6), maximum=TRUE)$objective

curve(M*dlaplace(x),-6,6,ylime=c(0,1),lwd=2)
curve(dlaplace(x),-6,6,lty="dashed", add=TRUE)
curve(dnorm(x),-6,6,col="red",lwd=2,add=TRUE)

rnorm2<-function(n,g,rg,M,report=TRUE){
  x<-rep(0,n)
  ntry<-0
  for (i in 1:n){
    done<-FALSE
    while (!done){
      ntry<-ntry+1
      y<-rg(1)
      u<-M*runif(1)
      if (u < (dnorm(y)/g(y))) done<-TRUE
    }
    x[i]<-y
  }
  if (report) cat("I needed ", ntry, " trials to get ", n, "pseudo-numbers from a Standard Normal distribution")
  return(x)
}

Nsim <- 10^4
M<-sqrt(2*exp(1)/pi)
x<-rnorm2(Nsim,dlaplace,rlaplace,M)

par(mfrow=c(1,2))
hist(x,freq=FALSE,ylim=c(0,0.5))
curve(dnorm(x),col="red",add=TRUE)
acf(x)

### Generating beta from uniform
a=2.7
b=6.3
curve(dbeta(x,a,b),col="red")

f<-function(x) dbeta(x,a,b)
M<-optimize(f,interval=c(0,1),maximum=T)$objective

rbeta2<-function(n,a,b,M,report=TRUE){
  x<-rep(0,n)
  ntry<-0
  for (i in 1:n){done=FALSE
    while (!done){ntry<-ntry+1
    y=runif(1)
    u=M*runif(1)
    if (u< dbeta(y,a,b)/dunif(y)) done=TRUE
    }
  x[i]<-y                              
  }
if (report) cat("I needed ", ntry, " trials to get ", n, "pseudo-numbers from a Beta distribution")
return(x)  
}

Nsim <- 10^4
x<-rbeta2(Nsim,a,b,M)

par(mfrow=c(1,2))
hist(x,freq=FALSE)
curve(dbeta(x,a,b),col="red",add=TRUE)

acf(x)

#alternatively_1
{
Nsim=10^4
a=2.7
b=6.3
u=runif(Nsim,max=M)
y=runif(Nsim)
x=y[u<dbeta(y,a,b)]

par(mfrow=c(1,2))
hist(x,freq=FALSE)
curve(dbeta(x,a,b),col="red",add=TRUE)

acf(x)
}
#alternatively_2
{
x=NULL
while (length(x)<Nsim){
  y=runif(Nsim*M)
  x=c(x,y[runif(Nsim*M)*M<dbeta(y,a,b)])
}
x=x[1:Nsim]

par(mfrow=c(1,2))
hist(x,freq=FALSE)
curve(dbeta(x,a,b),col="red",add=TRUE)

acf(x)
}


###Generating betas from betas
a=2.7
b=6.3
f<-function(x) dbeta(x,a,b)/dbeta(x,2,6)

M<-optimize(f, maximum=T, interval=c(0,1))$objective

rbeta3<-function(n,a,b,M,report=TRUE){
  x<-rep(0,n)
  ntry<-0
  for (i in 1:n){
    done=FALSE
    while (!done){
      ntry<-ntry+1
      y=rbeta(1,2,6)
      u=M*runif(1)
      if (u< dbeta(y,a,b)/dbeta(y,2,6)) done=TRUE
    }
  x[i]<-y                              
  }
  if (report) cat("I needed ", ntry, " trials to get ", n, "pseudo-numbers from a Beta distribution")
  return(x)  
}

Nsim=10^4
x<-rbeta3(Nsim,a,b,M)

par(mfrow=c(1,2))
hist(x,freq=FALSE)
curve(dbeta(x,a,b),col="red",add=TRUE)

acf(x)

#alternative_1
{
x=NULL
while (length(x)<Nsim){
  y=rbeta(Nsim*M,2,6)
  x=c(x,y[runif(Nsim*M)*M<(dbeta(y,a,b)/dbeta(y,2,6))])
}
x=x[1:Nsim]

par(mfrow=c(1,2))
hist(x,freq=FALSE)
curve(dbeta(x,a,b),col="red",add=TRUE)

acf(x)
}



### Homework assignments: Accept-Reject methods
## Ex. 2.18
# A
fx <- function(x){
  exp(-x^2/2)*(sin(6*x)^2 + 3*(cos(x)^2)*(sin(4*x)^2)+1)
}
fx.over.g <- function(x){
  fx(x)/dnorm(x)
}
m <- optimize(fx.over.g, interval=c(-6,6),maximum = T)$objective
curve(fx,-6,6, ylim=c(-1,7))
curve(m*dnorm(x),-6,6, col="red",add=T)
curve(15*dnorm(x),-6,6, col="blue",add=T)

# B
AR.sampling <- function(n, f, g, rg, m, report=TRUE){
  x <- rep(0,n)
  tries <- 0
  for(i in 1:n){
    done <- FALSE
    while(!done){
      tries <- tries+1
      y <- rg(1)
      u <- m*runif(1)
      if(u< (f(y)/g(y))) done <- TRUE
    }
    x[i] <- y
  }
  if (report) cat("Performed", tries, "attempts to get \n", n, "(pseudo)random numbers from density f")
  return(list(x=x,tries=tries))
}
n <- 2500
x <- AR.sampling(n,f=fx,g=dnorm,rg=rnorm,m=m)
# C
### pay attention! here, norm.c = 1/k from the lectures
### see also curve() command below: we use f/norm.c and not f*norm.c
### so indeed, norm.c=1/k
norm.c <- m*(n/x$tries)
norm.c

hist(x$x, freq=F, breaks=30)
curve(fx(x), c(-6,6), add=T, col="red")
curve(fx(x)/norm.c,c(-6,6),add=T,col="blue")


## Ex. 2.19
ratio.fg <- function(x,alpha){
  ((2/pi)^0.5)*(1/alpha)*exp(alpha*abs(x)-x^2/2)
}
alpha <- 3
curve(ratio.fg(x,alpha),from=-10,to=10)
# max at +alpha or -alpha
### Laplace distribution generation
dlap <- function(x,alpha){
  alpha*0.5*exp(-alpha*abs(x))
}
plap <- function(x,alpha){
  0.5(1+sign(x)*(1-exp(-alpha*abs(x))))
}
qlap <- function(p,alpha){
  (1/alpha)*sign(p-0.5)*log(1-2*abs(p-0.5))
}
rlap <- function(n,alpha){
  qlap(runif(n),alpha)
}

alpha <- 0.5
curve(dlap(x,alpha),from = -5, to=5)

fx.over.g <- function(x){
  dnorm(x)/dlap(x,alpha)
}
m <- optimize(fx.over.g,interval=c(-6,6),maximum = T)$objective


many.alpha <- c(0.1,0.2,0.3,0.5,1,1.5,2)
many.m <- rep(0,length(many.alpha))
for(i in 1:length(many.m)){
  alpha <- many.alpha[i]
  many.m[i] <- optimize(fx.over.g,interval=c(-6,6),maximum = T)$objective
}
plot(many.alpha,many.m,pch=17,cex=0.9,type="b")


## Ex 2.20
# a) generate a Normal r.v. using a Cauchy candidate in Accept-Reject

fx.over.g <- function(x) dnorm(x)/dcauchy(x)
AR.sampling <- function(n, f, g, rg, m, report=TRUE){
  x <- rep(0,n)
  tries <- 0
  for(i in 1:n){
    done <- FALSE
    while(!done){
      tries <- tries+1
      y <- rg(1)
      u <- m*runif(1)
      if(u< (f(y)/g(y))) done <- TRUE
    }
    x[i] <- y
  }
  if (report) cat("Performed", tries, "attempts to get \n", n, "(pseudo)random numbers from density f")
  return(list(x=x,tries=tries))
}
m <- optimize(fx.over.g,interval=c(-6,6),maximum = T)$objective
x <- AR.sampling(10^4, dnorm,dcauchy,rcauchy,m)
hist(x$x,freq=F)
curve(dnorm(x),add=T,col="red")

# b) 
fx.over.g <- function(x) dgamma(x,4.3,6.2)/dgamma(x,4,7)
m <- optimize(fx.over.g,interval=c(0,1),maximum = T)$objective
f <- function(x) dgamma(x,4.3,6.2)
g <- function(x) dgamma(x,4,7)
rg <- function(n) rgamma(n,4,7)
x <- AR.sampling(10^4,f,g,rg,m)
hist(x$x,freq=F)
curve(f,add=T,col="red")

