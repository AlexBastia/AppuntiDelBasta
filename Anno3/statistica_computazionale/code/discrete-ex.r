### Direct methods Homework
# a) Generate a binomial Bin(25, 0.2)
{
  random_binom <- function(n, trial, prob) {
    cf <- pbinom(0:trial, trial, prob)
    x <- rep(0, n)
    for (i in 1:n) {
      u <- runif(1)
      x[i] <- sum(cf < u)
    }
    return(x)
  }
}

# b) For alpha in [0,1], show that the pseudo-code
# u <- runif(1)
# while (u > alpha) u <- runif(1)
# U <- u
# produces a random variable U = unif(0, alpha)

{
  uni_alpha <- function(n, alpha) {
    x <- rep(NA, n)
    for (i in 1:n) {
      u <- runif(1)
      while (u > alpha) u <- runif(1)
      x[i] <- u
    }
    x
  }

  alpha <- 0.3
  hist(uni_alpha(10^5, alpha), freq <- FALSE)
}

# c) The Pareto distribution is defined with its cdf as F(x) = ... 
# Implement it using the uniform distr

# if you want to compare distr with density, make hist and compare with density curve.
# otherwise use plot ecdf with the prob curve
