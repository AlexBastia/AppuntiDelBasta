# GEnereting beta from uniform
a = 2.7
b = 6.3
curve (dbeta(x,a,b), col="red")
# f is already our ratio cause g(y)=1 (uniform density)
f<-function(x) dbeta(x,a,b)
M <- optimize (f, interval = c(0,1), maximum=T)$objective #
rbeta <- function (n,a,b.M,report = TRUE){
x<- rep(0,n)
ntry <- 0
for(i in 1:n){
done = FALSE
while(!done){
ntry<- ntry +1
y=runif(1)
u=M*runif(1)
if (u<dbeta(y,a,b)/dunif(y)) done = TRUE
}
x[i]<- y
}
if (report) cat("I needed ", ntry, "trials to get", n, return(x))
}
Nsim <- 10^4
set.seed(10)
x - rbeta2(Nsim, a, b, M)
par(mfrow = c(1,2))
hist(x, freq= FALSE)
curve(dbeta(x,a,b), col = "red", add= TRUE)
