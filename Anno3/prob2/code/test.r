nsim <- 10^3
u <- runif(nsim)
sigma <- 1
mu <- 0
x <- sigma * tan(pi * (u - 0.5)) + mu
plot(ecdf(x))
plot(ecdf(x))
print("hello")
