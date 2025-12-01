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
