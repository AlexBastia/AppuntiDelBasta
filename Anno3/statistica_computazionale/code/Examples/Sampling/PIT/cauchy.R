set.seed(67)
n <- 10^4
U <- runif(n)
sigma <- 1
mu <- 0
X <- sigma * tan(pi * (U - 0.5)) + mu
plot(ecdf(X))
