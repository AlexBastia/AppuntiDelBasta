set.seed(67)
n <- 10^4
U <- runif(n)
X <- -log(1-U)
par(mfrow=c(1,2))
hist(X, freq=F)
curve(dexp(x), add=T)
hist(rexp(n), freq=F)
curve(dexp(x), add=T)
