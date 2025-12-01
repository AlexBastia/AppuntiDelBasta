#Use of the integrate function
ch <- function(la){
  integrate(function(x){x^(la-1)*exp(-x)},0,Inf)$val
}

curve(lgamma(x), from=0, to=10)
plot(lgamma(seq(0.01,10,le=100)),
     log(apply(as.matrix(seq(0.01,10,le=100)),1,ch)),
     xlab="log(integrate(f))",
     ylab=expression(log(Gamma(lambda))),pch=19,cex=.6)
