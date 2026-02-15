dlaplace <- function(x) 0.5 * exp(-abs(x)) # this is the Laplace density
curve(dlaplace(x), -6,6) # BE CAREFUL, if you dont specify the range curve will assume [0,1]
plaplace <- function(x) ifelse(x < 0, 0.5 * exp(x), 1 - 0.5 * exp(-x)) # Laplace CDF
qlaplace <- function(u) ifelse(u < 0.5, log(2 * u), -log(2 * (1 - u))) # Laplace Quantile function -> INVERSE OF CDF
rlaplace <- function(n) qlaplace(runif(n)) # n random variables from Laplace distribution, using PIT
# Accept-Reject algorithm to sample from N(0,1) using Laplace(1) as candidate
rnorm_ar <- function(n, g, rg, M, report = TRUE){ # g is the density of candidate, rg is the random generator
x<- rep(0,n) # vector to store accepted values
ntry <- 0 # number of tries
for (i in 1:n){
done <- FALSE
while (!done){
# FOUR STEPS OF AR ALGHORITHM
ntry <- ntry + 1
y <- rg(1) # sample from the Proposal
u<- M * runif(1) # sample from Uniform
if (u < (dnorm(y)/g(y))) done <- TRUE # accept
# PAY ATTENTION: dnorm is the density of the target distribution SO IT MUST BE CHANGED IF THE TARGET IS DIFFERENT
}
x[i] <- y # store accepted value
}
if (report){
cat("Acceptance Rate:", n / ntry, "\n")
}
return(x)
}
Nsim <- 10^4
M <- sqrt(2*exp(1)/pi)
x<- rnorm_ar (Nsim, dlaplace, rlaplace, M)
