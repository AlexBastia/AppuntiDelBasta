#UNNORMALIZED (you have proportional to in the text of the exer)
# A
fx <- function(x){
exp(-x^2/2)*(sin(6*x)^2 + 3*(cos(x)^2)*(sin(4*x)^2)+1)
}

fx.over.g <- function(x){
fx(x)/dnorm(x) # if we have a differente propoasal dnorm is gonna change
}

m <- optimize(fx.over.g, interval=c(-6,6), maximum = T)$objective
curve(fx, -9,9, ylim=c(-1,7)) # this is the density
curve(m*dnorm(x), -5,5, col="red", add=T)
curve(15*dnorm(x), -6,6, col="blue", add=T)

# B
AR.sampling <- function(n, f, g, rg, m, report=TRUE){
x <- rep(0,n)
tries <- 0
for(i in 1:n){
done <- FALSE
while(!done){
y <- rg(1)
u <- runif(1)*m
if (u <= f(y) / (g(y))) {
done <- TRUE
}
tries <- tries + 1
}
x[i] <- y
}
if(report) cat("Total tries:", tries, "\n")
return(list(x=x, tries = tries))
}
