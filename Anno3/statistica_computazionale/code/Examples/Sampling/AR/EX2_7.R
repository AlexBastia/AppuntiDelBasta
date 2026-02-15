count <- 0
ar_beta <- function(alpha, beta, M){
  u <- runif(1)
  y <- runif(1)
  count <<- count + 1
  while (dunif(y)*M*u > dbeta(y, alpha, beta)){
    count <<- count + 1
    u <- runif(1)
    y <- runif(1)
  }
  return(y)
}

set.seed(67)
alpha <- 2.7
beta <- 6.3
n <- 10^4 
Y = rep(0, n)
M <- optimize(f=function(x){dbeta(x,alpha, beta)}, interval=c(0,1), maximum=T)$objective
for (i in 1:n){
 Y[i] <- ar_beta(alpha, beta, M) 
}
hist(Y, freq=F)
fx <- function(x){dbeta(x, alpha, beta)}
curve(fx, add=T)
abline(a=M, b=0)
print(1/M)
print(n/count)
print(count/(M*n))
