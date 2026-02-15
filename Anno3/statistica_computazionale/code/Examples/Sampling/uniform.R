set.seed(2)
n <- 10^4
x <- runif(n)
hist(x)
x1 <- x[-n]
x2 <- x[-1]
plot(x1, x2)
acf(x)
