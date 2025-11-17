library(MASS)
x <- mvrnorm(10^4, rep(0, 4), diag(c(1, 2, 3, 4)))
# It's usually best to sample from a standard gaussian and then transform
print(x[1, ])
