f <- function(x){exp(-x^2/2)*(sin(6*x)^2+3*cos(x)^2*sin(4*x)^2+1)}
g <- function(x){dnorm(x, 0, 1)} # Standard
rg <- function(x){rnorm(x, 0, 1)}

ratio <- function(x){f(x)/g(x)}

curve(ratio, -10, 10)
M <- optimize(ratio, interval = c(-50, 50), maximum = T)$objective

gM <- function(x){g(x)*M}
curve(f, -4, 4)
curve(gM, -4, 4, add = T)

ar_strange <- function(n, M){
  count <- 0
  X <- rep(0, n)
  for (i in 1:n){
    done <- FALSE
    while(!done){
      count <- count + 1
      u <- runif(1)
      y <- rg(1)
      if (M*u*g(y) <= f(y)) done = TRUE
    }
    X[i] <- y
  }
  return(list(samples = X, ar = n/count))
}

set.seed(67)
n <- 10^5
ret <- ar_strange(n, M)
X <- ret$samples
ar <- ret$ar
norm.const <- 1/(ar*M)
print(norm.const)

nf <- function(x){f(x)*norm.const}
hist(X, breaks = 100, freq = F)
curve(nf, add = T)
