### LLN: Law of Large Numbers
{
  n <- 1
  X <- rexp(n, rate=5) # one r.v., E(X)=1/lambda=0.2
  n <- 20
  X.seq <- rexp(n, rate=5) #sequence of X_1, X_2,..X_20, each with E(X)=0.2 and V(X)=0.04
  X.bar <- mean(X.seq)
  ### Let's compute the average X.bar while increasing by 1 
  ### the number of r.v.s each time (we are simulating a n -> inf)
  n <- 5000
  X.seq <- rexp(n, rate=5)
  X.bar <- cumsum(X.seq)/(1:n)
  plot(1:n,X.bar,type="l",col=1, lwd=1, ylim=c(0.1,0.3))
  abline(h=0.2, col=2, lwd=2)
  # what about the variance?
  plot(1:n,0.04/(1:n), type="l",col=1, lwd=1, ylim=c(-0.05,0.05))
  abline(h=0, col=2, lwd=2)
  # what if we actually compute the variance?
  var.X.bar <- cumsum((X.seq-X.bar)^2)/(1:n)
  var.X.bar <- var.X.bar/1:n
  plot(1:n,var.X.bar,type="l",col=1, lwd=1)
  
}  

### CLT: Central Limit Theorem
{
  library(scales)
  set.seed(10)
  clt.sim <- function(N.sim,lam,n){
    X <- matrix(0,N.sim,n)
    for(i in 1:N.sim){
      X[i,] <- rpois(n,lam)
    }
    return(apply(X,1,mean))
  }
  lam <- 15
  n <- 50
  N.sim <- round(seq(10,1000,length.out = 20))
  plot(density(clt.sim(N.sim[1],lam,n)),col=alpha(rgb(0,0,0), 0.5),
         ylim=c(0,0.9))
    for(i in 1:20){
      lines(density(clt.sim(N.sim[i],lam,n)),col=alpha(rgb(i/20,0,0), 0.5))
    }
    abline(v=lam, col=2,lwd=2)
}