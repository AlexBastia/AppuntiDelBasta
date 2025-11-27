##### Bootstrap
## Starting sample
# Fixed sample
x<-c(1,5,12,15,20,26,78,145,158,358)
n <- 10
# Random sample (from a Normal)
# n <- 10
# x <- rnorm(n, mean=5, sd=3)
# Random sample (from a Student's t)
# n <- 10
# x <- rt(n,ncp=5,df=3)
library(boot)
x.bar<-mean(x)
plot(ecdf(x),lwd=3)

## Non-Parametric bootstrap
x.bar_np<-function(data,i){
    mean(data[i])
}

bootstrap.np<-boot(x,x.bar_np,R=5000)
x.bar_var<-var(x)

##Non-parametric boostrap VS CLT
plot(density(bootstrap.np$t), main='Non-parametric Boostrap', lwd=2, xlab='')
curve(dnorm(x,mean=x.bar,sd=sqrt(x.bar_var/n)), add=TRUE, col=2, lwd=2, lty=2)
legend(130,0.010,legend=c('Bootstrap','CLT'), lwd=2,lty=c(1:2),col=c(1:2))