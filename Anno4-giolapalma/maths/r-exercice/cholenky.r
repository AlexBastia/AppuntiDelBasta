A <- matrix(c(4, 2, 2,
              2, 2, 1,
              2, 1, 3),
            nrow = 3,
            byrow = TRUE)

R <- chol(A)
print(R) #In R, chol(A) returns an upper-triangular factor, so the module transposes it to obtain \(L\).
L <- t(R)
print(L)


print(L %*% t(L))