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

