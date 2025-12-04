#Example 3.4
### WARNING: it takes some time to run this code
x <- rnorm(10^8)
bound <- qnorm(c(0.5,0.75,0.8,0.9,0.95,0.99,0.999,0.9999))
res <- matrix(0,ncol=8,nrow=7)
for (i in 2:8) for (j in 1:8) res[i-1,j] <- mean(x[1:10^i]<bound[j])
tab.res <- matrix(as.numeric(format(res,digi=4)),ncol=8)
colnames(tab.res) <- as.character(paste("(P<=t)=",c(0.5,0.75,0.8,0.9,0.95,0.99,0.999,0.9999),sep=""))
rownames(tab.res) <- as.character(paste("10^",seq(2:8),"  ",sep=""))
tab.res
