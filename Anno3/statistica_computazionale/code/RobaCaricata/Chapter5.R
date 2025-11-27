#Example 5.1

xm <- rcauchy(500)

## Maximize Log-Likelihood w.r.t. theta (called 'y')
f <- function(y) {-sum(log(1+(x-y)^2))}
the<- NULL
for (i in 1:500){
  x<- xm[1:i]
  mi<- optimize(f,interval=c(-10,10),maximum=TRUE)$maximum
  the<- c(the,mi)
 
}
## Maximize Likelihood w.r.t. theta
f_lik<- function(y){prod(1/(1+(x-y)^2))}
the_lik<- NULL
for( i in 1:500){
  x<- xm[1:i]
  mi_lik<- optimize(f_lik,interval=c(-10,10),maximum=TRUE)$maximum
  the_lik<- c(the_lik,mi_lik)
  
}
par(mfrow=c(2,2))
plot(the,type="l",ylim=c(-1,1))
lines(the_lik,col="red")


### Plot log-likelihood
f2 <- NULL
x <- xm
for(i in seq(-10,10,le=500)){
  f2=c(f2,f(i))
}
plot(seq(-10,10,le=500),f2,type="l")

### Perturbed log-likelihood
f1 <- function(y){-sin(y*100)^2-sum(log(1+(x-y)^2))}
the1 <- NULL
loglik1 <- NULL
for(i in 1:500){
  x <- xm[1:i]
  mi <- optimize(f1,interval=c(-10,10),maximum=TRUE)
  the1 <- c(the1,mi$maximum)
  loglik1 <- c(loglik1,mi$objective)
}

### Perturbed likelihood
f_lik1 <- function(y){(1/exp(sin(y*100)^2))*prod(1/(1+(x-y)^2))}
the_lik1 <- NULL
for(i in 1:500){
  x <- xm[1:i]
  mi_lik1 <- optimize(f_lik1,interval=c(-10,10),maximum=TRUE)$maximum
  the_lik1 <- c(the_lik1,mi_lik1)
}

plot(the1,type="l",ylim=c(-1,1))
lines(the_lik1,col="red")

f3 <- NULL
x <- xm
for(i in seq(-10,10,le=500)){
  f3 <- c(f3,f1(i))}
plot(seq(-10,10,le=500),f3,type="l")
par(mfrow=c(1,1))

### Check the likelihood behavior when n=500 or n=5
par(mfrow=c(1,2))
x <- rcauchy(500)
f2 <- NULL
for (i in seq(-10,10,le=500)){
  f2 <- c(f2,f(i))}
plot(seq(-10,10,le=500),f2,type="l")

x <- rcauchy(5)
f2 <- NULL
for (i in seq(-10,10,le=500)){
  f2 <- c(f2,f(i))}
plot(seq(-10,10,le=500),f2,type="l")
par(mfrow=c(1,1))



#Example 5.2
#data: mixture of two normals
da <- sample(rbind(rnorm(10^2),2.5+rnorm(3*10^2)))

#minus the log-likelihood function
# mu is a VECTOR
like <- function(mu){
  sum(log((.25*dnorm(da-mu[1])+.75*dnorm(da-mu[2]))))
}

#log-likelihood surface
mu1 <- mu2 <- seq(-2,5,le=250)
lli <- matrix(0,nco=250,nro=250)

for (i in 1:250){
  for (j in 1:250){
    lli[i,j]=like(c(mu1[i],mu2[j]))
  }
}

par(mar=c(4,4,1,1))
image(mu1,mu2,lli,
      xlab=expression(mu[1]),ylab=expression(mu[2]),
      col=hcl.colors(30))
contour(mu1,mu2,lli,nle=100,add=T)

### in 3D (requires the package "plotly")
fig <- plot_ly(z=~lli)
fig <- fig %>% add_surface()
fig
 

#sequence of NR maxima
# Be careful!
# nlm is an R function that MINIMIZES an objective function
# so, use -like, because we want to maximize a (log)likelihood
starts <- matrix(c(1,1,-1,-1,4,-1,4,2.5,1,4,-1,4.5),nrow=2)

like <- function(mu){
  -sum(log((.25*dnorm(da-mu[1])+.75*dnorm(da-mu[2]))))
}

for (j in 1:dim(starts)[2]){
  sta <- starts[,j]
  mmu <- sta
  for (i in 1:(nlm(like,sta)$it)){
    mmu <- rbind(mmu,nlm(like,sta,iterlim=i)$estimate)
  }
  lines(mmu[,1],mmu[,2],lwd=2)
  points(mmu[dim(mmu)[1],1],mmu[dim(mmu)[1],2], col=2, pch=15, cex=1.2)
  ## wait a couple of seconds for the trajectory to appear
  invisible(readline(prompt="Press [enter] to continue"))
}


#Example 5.3
h <- function(x){(cos(50*x)+sin(20*x))^2}
rangom <- h(matrix(runif(10^6),ncol=10^3))
monitor <- t(apply(rangom,1,cummax))
plot(monitor[1,],type="l",col="white",xlab="Iterations",ylab=expression(h(theta)))
polygon(c(1:10^3,10^3:1),c(apply(monitor,2,max),rev(apply(monitor,2,min))),col="grey")
abline(h=optimise(h,int=c(0,1),maximum=TRUE)$objective,col="red")



#Example 5.4 
ref <- 0.1*rnorm(5001)
f <- function(y){-y^2*.1-sum(log(1+(x-y)^2))}

maxv <- loc <- truv <- trul <- NULL

for (i in seq(10,length(ref),le=50)){
  
  prop <- runif(10^3,-5,5)
  x <- ref[1:i]
  tru <- optimise(f,c(-5,5),maximum=T)
  trul <- c(trul,tru$maximum)
  truv <- c(truv,tru$objective)
  vale <- apply(as.matrix(prop),1,f)
  loc <- c(loc,prop[order(-vale)[1]])
  maxv <- c(maxv,max(vale))
}

par(mar=c(4,4,1,1),mfrow=c(2,1))
plot(trul,loc,cex=.5,pch=19,xlab=expression(theta^0),ylab=expression(hat(theta)))
abline(a=0,b=1,col="grey")
plot(seq(10,length(ref),le=50),(truv-maxv)/abs(truv),type="l",lwd=2,xlab="Sample size",ylab="Relative error")


#Example 5.6
ha <- function(x,y){-(x*sin(20*y)+y*sin(20*x))^2*cosh(sin(10*x)*x)-
                   (x*cos(10*y)-y*sin(10*x))^2*cosh(cos(20*y)*y)}

x <- y <- seq(-3,3,le=435)
z <-  -outer(x,y,ha)
par(bg = "wheat",mar=c(1,1,1,1))
persp(x, y, z, theta=155, phi=30, col="green4",
      ltheta=-120, shade=0.75, border =NA, box=FALSE)



#Example 5.7
ha <- function(x,y){
  -(x*sin(20*y)+y*sin(20*x))^2*cosh(sin(10*x)*x)-
    (x*cos(10*y)-y*sin(10*x))^2*cosh(cos(20*y)*y)
}

start <- c(0.65,0.8)
theta <- matrix(start,ncol=2)
dif <- iter <- alpha <- beta <- 1
hcur <- hval <- ha(start[1],start[2])

while (dif>10^-5){
  
  zeta <- rnorm(2)
  zeta <- zeta/c(sqrt(t(zeta)%*%zeta))
  grad <- alpha*zeta*(ha(theta[iter,1]+beta*zeta[1],theta[iter,2]+beta*zeta[2])-
                        ha(theta[iter,2]-beta*zeta[2],theta[iter,2]+beta*zeta[2]))/beta
  #safety condition  
  scale <- sqrt(t(grad)%*%grad)
  while (scale>1){
    zeta <- rnorm(2)
    zeta <- zeta/c(sqrt(t(zeta)%*%zeta))
    grad <- alpha*zeta*(ha(theta[iter,1]+beta*zeta[1],theta[iter,2]+beta*zeta[2])-
                          ha(theta[iter,2]-beta*zeta[2],theta[iter,2]+beta*zeta[2]))/beta
    scale <- sqrt(t(grad)%*%grad)
  }
  #
  theta <- rbind(theta,theta[iter,]+grad)
  dif <- scale
  iter=iter+1
  alpha <- 1/(iter+1)
  beta <- 1/sqrt(iter+1)
}


x <- y <- seq(-1,1,le=435)
z <- outer(x,y,ha)
image(x,y,z,col=terrain.colors(150))
lines(theta,lwd=2)
points(theta[1,1],theta[1,2],col="gold",pch=19)
title(main=paste("min",format(-max(hval),dig=3),sep=" "))


# Example 5.8
library(mcsm)
h <- function(x){(cos(50*x)+sin(20*x))^2}
par(mar=c(4,4,1,1),mfrow=c(2,2))
for (tt in 1:4){
  curve(h,from=0,to=1,n=10001,col="grey",lwd=2)
  sam <- maximple()
  xgo <- sam$x
  hgo <- sam$y
  lines(xgo,hgo,col="steelblue4",lwd=2)
  points(xgo,hgo,col="steelblue4",cex=.5,pch=19)
}

