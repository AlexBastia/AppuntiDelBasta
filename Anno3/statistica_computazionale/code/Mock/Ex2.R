n <- 10^4 
U <- runif(n)
X <- 3 - sign(U - 0.5) * log(1 - 2 * abs(U - 0.5))

hist(X, freq = F)
acf(X)

E1 <- rexp(n)
E2 <- rexp(n)
L <- E1 - E2

hist(L, freq=F)
acf(X)

Xsim <- L + 3 
hist(X, freq = F)
hist(Xsim, freq = F, add = T, col = 2)
