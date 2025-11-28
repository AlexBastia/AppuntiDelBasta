# When implementing sampling of a new function,
# check if the name of the function is already used
rbin <- function(n, x, p) {
  # Usually prepare a vector as empty (not 0)
  values <- rep(NA, n)
  # Cumulative sum of a distribution
  P <- cumsum(p)
  for (i in 1:n){
    # draw from unif
    U <- runif(1)
    j <- 1
    # Check each position while the value is larger than p_k
    while (U > P[j]) j <- j + 1
    values[i] <- x[j]
  }
  values
}

# Note: we're not using the same seeds, so the sequences
# won't be identical, but the cdf is the same
x1 <- rbin(10^4, 0:10, dbinom(0:10, 10, 0.3))
plot(ecdf(x1))

x2 <- sample(0:10, 10^4, replace <- TRUE, dbinom(0:10, 10, 0.3))
plot(ecdf(x2))
