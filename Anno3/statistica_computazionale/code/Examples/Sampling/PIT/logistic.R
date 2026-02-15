set.seed(67)
n <- 10^4
U <- runif(n)
beta <- 0.2
mu <- 0
X <- -beta * log((1-U)/U) + mu
plot(ecdf(X))
