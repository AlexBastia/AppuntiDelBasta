#Use of the integrate function
ch <- function(la){
  integrate(function(x){x^(la-1)*exp(-x)},0,Inf)$val
}

curve(lgamma(x), from=0, to=10)
plot(lgamma(seq(0.01,10,le=100)),
     log(apply(as.matrix(seq(0.01,10,le=100)),1,ch)),
     xlab="log(integrate(f))",
     ylab=expression(log(Gamma(lambda))),pch=19,cex=.6)

## Ex. 3.2
#Comparison between integrate and area functions
cac <- rcauchy(10)+350
lik <- function(the){
  u <- dcauchy(cac[1]-the)
  for (i in 2:10) u <- u*dcauchy(cac[i]-the)
  return(u)
}
curve(dcauchy(x,location=350),from = 200, to=400)
integrate(lik,-Inf,Inf)
integrate(lik,200,400)

library(MASS)

cac <- rcauchy(10)
curve(dcauchy(x),from = -6, to=6)
nin <- function(a) integrate(lik,-a,a)$val
nan <- function(a) area(lik,-a,a)
x <- seq(1,10^3,le=10^4)
y <- log(apply(as.matrix(x),1,nin))
z <- log(apply(as.matrix(x),1,nan))
plot(x,y,type="l",ylim=range(cbind(y,z)),lwd=2)
lines(x,z,lty=2,col="red",lwd=2)

#Example 3.3
h <- function(x){
  (cos(50*x)+sin(20*x))^2
}
par(mar=c(2,2,2,1),mfrow=c(2,1))
curve(h,xlab="Function",ylab="",lwd=2)
integrate(h,0,1)

x <- h(runif(10^4))
estint <- cumsum(x)/(1:10^4)
### st. error of h_bar
esterr <- sqrt(cumsum((x-estint)^2))/(1:10^4)
plot(estint,xlab="Mean and error range",type="l",lwd=2, ylim=mean(x)+20*c(-esterr[10^4],esterr[10^4]),ylab="")
## calling for the CLT
lines(estint+2*esterr,col="purple",lwd=2)
lines(estint-2*esterr,col="purple",lwd=2)
par(mfrow=c(1,1))


#Exercise 3.1
curve(dcauchy(x),from=-5, to=5)

# Point a.
num <- function(x,the){(the/(1+the^2))*exp(-(x-the)^2/2)}
den <- function(x,the){(1/(1+the^2))*exp(-(x-the)^2/2)}

num0 <- function(the) num(0,the)
num2 <- function(the) num(2,the)
num4 <- function(the) num(4,the)
den0 <- function(the) den(0,the)
den2 <- function(the) den(2,the)
den4 <- function(the) den(4,the)

par(mfrow=c(2,1))
curve(num0,-20,20,ylim=c(-0.5,0.5))
curve(num2,-20,20,lty=2,add=T)
curve(num4,-20,20,lty=4,add=T)

curve(den0,-20,20)
curve(den2,-20,20,lty=2,add=T)
curve(den4,-20,20,lty=4,add=T)

integrate(num4,-Inf,Inf)

hnum <- function(the) the*exp(-(4-the)^2/2)
x1 <- hnum(rcauchy(10^4))
int_num <- mean(x1)*pi
err_num <- sqrt(sum((x1-int_num)^2))/(10^4)
c(int_num-2*err_num,int_num+2*err_num)

hden <- function(the) exp(-(4-the)^2/2)
x2 <- hden(rcauchy(10^4))
int_den <- mean(x2)*pi
err_den <- sqrt(sum((x2-int_den)^2))/(10^4)
c(int_den-2*err_den,int_den+2*err_den)
integrate(den4,-Inf,Inf)



#Point B
est_num <- cumsum(x1)/(1:10^4)
esterr <- sqrt(cumsum((x1-est_num)^2))/(1:10^4)
plot(est_num,xlab="Mean and error range",type="l",lwd=2, ylim=mean(x1)+20*c(-esterr[10^4],esterr[10^4]),ylab="")
lines(est_num+2*esterr,col="purple",lwd=2)
lines(est_num-2*esterr,col="purple",lwd=2)


est_den <- cumsum(x2)/(1:10^4)
esterr <- sqrt(cumsum((x2-est_den)^2))/(1:10^4)
plot(est_den,xlab="Mean and error range",type="l",lwd=2, ylim=mean(x2)+20*c(-esterr[10^4],esterr[10^4]),ylab="")
lines(est_den+2*esterr,col="purple",lwd=2)
lines(est_den-2*esterr,col="purple",lwd=2)

#POINT C
x <- 4

hnum1 <- function(the) the/(1+the^2)
x11 <- hnum1(rnorm(10^4,mean=x))
int_num1 <- mean(x11)*sqrt(2*pi)
err_num1 <- sqrt(sum((x11-int_num1)^2))/(10^4)
c(int_num1-2*err_num1,int_num1+2*err_num1)
integrate(num4,-Inf,Inf)

hden1 <- function(the) 1/(1+the^2)
x21 <- hden1(rnorm(10^4,mean=x))
int_den1 <- mean(x21)*sqrt(2*pi)
err_den1 <- sqrt(sum((x21-int_den1)^2))/(10^4)
c(int_den1-2*err_den1,int_den1+2*err_den1)
integrate(den4,-Inf,Inf)



#Example 3.4
### WARNING: it takes some time to run this code
x <- rnorm(10^8)
bound <- qnorm(c(0.5,0.75,0.8,0.9,0.95,0.99,0.999,0.9999))
res <- matrix(0,ncol=8,nrow=7)
for (i in 2:8) for (j in 1:8) res[i-1,j] <- mean(x[1:10^i]<bound[j])
tab.res <- matrix(as.numeric(format(res,digi=4)),ncol=8)
colnames(tab.res) <- as.character(paste("(P<=t)=",c(0.5,0.75,0.8,0.9,0.95,0.99,0.999,0.9999),sep=""))
rownames(tab.res) <- as.character(paste("10^",seq(2:8),"  ",sep=""))
tab.res

#Example 3.5
Nsim <- 10^4 
y <- rexp(Nsim)+4.5
weit <- dnorm(y)/dexp(y-4.5)
plot(cumsum(weit)/(1:Nsim),type="l")
abline(a=pnorm(-4.5),b=0,col="red")



#Exercise 3.4

h<-function(x) exp(-(x-3)^2/3)+exp(-(x-6)^2/2)
curve(h,-5,10,col="red")
f2<-function(x) h(x)*dnorm(x)
curve(f2,-5,5)
integrate(f2,-Inf,Inf)

#point a.
# It's a mathematical analysis exercise: useful but lengthy.
# Insights of the results: search for "Product of two normal DENSITIES"


#point b.
Nsim <- 10^3
x=rnorm(Nsim)
hn <- mean(h(x))
err <- mean((h(x)-hn)^2)/Nsim

#point c.
Nsim <- 10^3
x <- runif(Nsim,min=-8,max=-1)
weit <- dnorm(x)/dunif(x,-8,-1)
hnIS <- mean(h(x)*weit)
errIS <- mean((h(x)*weit-hnIS)^2)/Nsim

hn
hnIS
err
errIS



#Example 3.8
x <- rnorm(10^6)
wein <- dcauchy(x)/dnorm(x)
boxplot(wein/sum(wein))
plot(cumsum(wein*(x>2)*(x<6))/cumsum(wein),type="l")
abline(h=pcauchy(6)-pcauchy(2),col="purple")


#Example from the Notes (pp.51)
int1<-function(n){
  x=rnorm(n)
  fn=rep(0,n)
  fn[x>0]=exp(-x[x>0]^3)/dnorm(x[x>0])
  fn
}

int2<-function(n){
  x=rexp(n)
  fn=rep(0,n)
  fn=exp(-x^3)/dexp(x)
  fn
}

integrate(function(x) exp(-x^3),0,Inf)
Nsim=10^4
i1=int1(Nsim)
i2=int2(Nsim)
mean(i1)
v1=(mean(i1^2)-mean(i1)^2)/Nsim

mean(i2)
v2=(mean(i2^2)-mean(i2)^2)/Nsim


est1=cumsum(i1)/(1:Nsim)
est2=cumsum(i2)/(1:Nsim)
sd1=sqrt((cumsum(i1^2)/(1:Nsim)-est1^2)/(1:Nsim))
sd2=sqrt((cumsum(i2^2)/(1:Nsim)-est2^2)/(1:Nsim))
u1=est1+2*sd1
l1=est1-2*sd1
u2=est2+2*sd2
l2=est2-2*sd2

plot(1:Nsim,est1,type="l")
lines(1:Nsim,l1)
lines(1:Nsim,u1)
lines(1:Nsim,est2,col=2)
lines(1:Nsim,l2,col=2)
lines(1:Nsim,u2,col=2)



### Homework assignments: Monte Carlo integration
## Ex 3.13 - revised
## Same text as in the book, but the questions are:
# A) simulate values from f(x) with the three different candidates
# and estimate the probability of acceptance. Use this probability
# to compute the normalizing constant.
# B) given the support of f(x), provide a better candidate function
# C) use Importance Sampling to approximate E_f(X) using the 
# the previous distribution (at point B)
### A
fx <- function(x){
  value <- rep(0, length(x))
  value[x>0] <- exp(-x[x>0]^2*sqrt(x[x>0]))*sin(x[x>0])^2
  value
}

g1 <- function(x) 0.5*exp(-abs(x))
g2 <- function(x) dcauchy(x, scale=2)
g3 <- function(x) dnorm(x)

m1 <- optimize(function(x) fx(x)/g1(x),
               interval=c(0,10), maximum=T)$objective
m2 <- optimize(function(x) fx(x)/g2(x),
               interval=c(0,10), maximum=T)$objective
m3 <- optimize(function(x) fx(x)/g3(x),
               interval=c(0,10), maximum=T)$objective

res1 <- function(n, m1){
  y <- p <- NULL
  while(length(y)<n){
    x <- rexp(n)*(-1)^rbinom(n,1,1/2)
    keep <- (m1*g1(x)*runif(n))<fx(x)
    y <- c(y,x[keep])
    p <- c(p, keep)
  }
  list(y=y[1:n],p=mean(p))
}
res2 <- function(n, m2){
  y <- p <- NULL
  while(length(y)<n){
    x <- rcauchy(n,scale=2)
    keep <- (m2*g2(x)*runif(n))<fx(x)
    y <- c(y,x[keep])
    p <- c(p, keep)
  }
  list(y=y[1:n],p=mean(p))
}
res3 <- function(n, m3){
  y <- p <- NULL
  while(length(y)<n){
    x <- rnorm(n)
    keep <- (m3*g3(x)*runif(n))<fx(x)
    y <- c(y,x[keep])
    p <- c(p, keep)
  }
  list(y=y[1:n],p=mean(p))
}
## Generate values
x1 <- res1(10^4,m1)
x2 <- res1(10^4,m2)
x3 <- res1(10^4,m3)
## Empirical probs. of accept.
x1$p
x2$p
x3$p
## Normalizing constants
k1 <- (m1*x1$p)^(-1)
k2 <- (m2*x2$p)^(-1)
k3 <- (m3*x3$p)^(-1)

hist(x1$y, freq=F)
curve(fx,from=0,to=10, add=T, col="red")
curve(k1*fx(x),from=0,to=10, add=T, col="blue")

hist(x2$y, freq=F)
curve(fx,from=0,to=10, add=T, col="red")
curve(k2*fx(x),from=0,to=10, add=T, col="blue")

hist(x3$y, freq=F)
curve(fx,from=0,to=10, add=T, col="red")
curve(k3*fx(x),from=0,to=10, add=T, col="blue")

### B
# Maybe use an exponential with parameter lambda=1

res4 <- function(n){
  m4 <- optimize(function(x) fx(x)/dexp(x),
                 interval=c(0,10), maximum = T)$objective
  y <- p <- NULL
  while(length(y)<n){
    x <- rexp(n)
    keep <- (m4*dexp(x)*runif(n))<fx(x)
    y <- c(y,x[keep])
    p <- c(p,keep)
  }
  list(y = y[1:n], p=mean(p), m4=m4)
}

x4 <- res4(10^4)
x4$p
k4 <- (x4$m4*x4$p)^(-1)
hist(x4$y, freq=F)
curve(fx,from=0,to=10, add=T, col="red")
curve(k4*fx(x),from=0,to=10, add=T, col="blue")

### C
x <- rexp(10^5)
w <- fx(x)/dexp(x)
sum(x*w)/sum(w)

# or
w1 <- w/mean(w)
mean(x*w1)


#### Ex. 3.18 revised
## Same text as in the book but the questions are:
# A) use a function to generate from a Gumbel using the Inverse Transform method
# B) use a Monte Carlo method to compute E(exp{X})
# C) use Importance Sampling, with instrumental a standard Normal,
# to compute E(exp{X})
## a

rgumb <- function(n){
  log(-log(runif(n)))
  ## or log(rexp(n))
}

## b
x <- rgumb(10^4)
m <- mean(exp(x))
v <- (mean(exp(2*x) - m^2))/10^4
cbind(Mean=m,Var=v)

## c
x1 <- rnorm(10^4)
w <- exp(x1-exp(x1))/dnorm(x1)
m1 <- mean(exp(x1)*w)
v1 <- (mean(exp(2*x1)*(w^2))-m1^2)/(10^4)
cbind(Mean=m1,Var=v1)
