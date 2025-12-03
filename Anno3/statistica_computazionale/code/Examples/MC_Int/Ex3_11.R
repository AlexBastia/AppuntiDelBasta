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
