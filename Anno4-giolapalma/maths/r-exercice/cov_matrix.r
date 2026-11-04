nrow <- 3
X <-  matrix(
    
        c(1, 3, 
      5, 6, 
      4, 6),  nrow = nrow,  byrow = TRUE)
Xc <- scale(X, center = TRUE, scale=FALSE)

S=(1/nrow) * crossprod(Xc)

print(S)

