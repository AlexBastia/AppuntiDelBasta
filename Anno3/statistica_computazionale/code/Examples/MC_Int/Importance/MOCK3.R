h <- function(x){exp(-x^2 + 5)}
f <- function(x){dcauchy(x, 0, 1)}
g <- function(x){dnorm(x, 0, 15)}
rg <- function(n){rnorm(n, 0, 15)}

f.g <- function(x){f(x)/g(x)}
curve(f.g, -10, 10)


n <- 10^5
x <- rg(n)

boxplot(f.g(x)/sum(f.g(x)))

m <- cumsum(h(x)*f(x)/g(x))/(1:n)
plot(1:n, m, type="l")

h.f <- function(x){h(x)*f(x)}
print(integrate(h.f, -10, 10))

v <- cumsum(((h(x)*f(x)/g(x)) - m)^2)/(1:n)^2
pe <- m + 2*sqrt(v)
ne <- m - 2*sqrt(v)
lines(pe)
lines(ne)


# What is Importance Sampling
# L'importance sampling e' un metodo per aumentare l'efficenza dello stimatore di Monte Carlo 
