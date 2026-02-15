t <- 0
h <- function(x){x <= t}

n <- 10^4
x <- rnorm(n)
mc <- mean(h(x))
print(mc)
print(integrate(dnorm, -Inf, t))

v <- 1/n * mean((h(x) - mc)^2)
print(sqrt(v))

sigma <- function(n){pnorm(t)*(1-pnorm(t))/n}
print(sigma(n))
