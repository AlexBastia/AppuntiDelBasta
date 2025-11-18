nsim <- 10^4
lambda <- 100
spread <- 3 * sqrt(lambda)
t <- round(seq(max(0, lambda - spread), lambda + spread))
prob <- ppois(t, lambda)
print(prob)
# Initialise with NA
x <- rep(NA, nsim)
for (i in 1:nsim) {
  u <- runif(1)
  # Same as last time, but more compact
  # Sum() counts how many comulative probabilities are below u
  x[i] <- t[i] + sum(prob < u)
}
hist(x, freq <- FALSE)
curve(dpois(x, lambda <- 100), from <- 70, to <- 130)
