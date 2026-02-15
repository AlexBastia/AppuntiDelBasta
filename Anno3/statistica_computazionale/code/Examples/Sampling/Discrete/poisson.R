set.seed(67)
n <- 10^4
lambda <- 99
spread <- 3 * sqrt(lambda)
t <- round(seq(max(0, lambda - spread), lambda + spread, 1))
p <- ppois(t, lambda)
X <- rep(0, n)
for (i in 1:n) {
  u <- runif(1)
  X[i] <- t[1] + sum(p < u)
}
hist(X, freq=F)
lines(t, dpois(t, lambda))
plot(ecdf(X))
lines(t, ppois(t, lambda))
