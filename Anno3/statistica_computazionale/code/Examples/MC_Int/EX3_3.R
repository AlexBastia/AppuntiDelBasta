h <- function(x){(cos(50*x) + sin(20*x))^2}

set.seed(67)
n <- 10^4
X <- runif(n)
estint <- cumsum(h(X))/(1:n)
plot(estint, type="l")

esterr <- sqrt(cumsum((X - estint)^2))/(1:n)
lines(estint+2*esterr,col="gold",lwd=2)
lines(estint-2*esterr,col="gold",lwd=2)

print(integrate(h, 0, 1))
print(estint[n])

