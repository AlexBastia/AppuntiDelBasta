n <- 10^4
U <- runif(n)
X <- 0.5 * log(1 - log(1-U)/sqrt(2))

hist(X, freq=F)
acf(X)
