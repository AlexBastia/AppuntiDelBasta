A <- matrix(c(1, 2, 3,
              4, 5, 6),
            nrow = 2,
            byrow = TRUE)

B <- matrix(c(1, 0, 1,
              0, 1, 1),
            nrow = 2,
            byrow = TRUE)
print(B)

C= A+ B

print(t(C))


M <- matrix(c(2, 3, 5,
              4, -2, -7,
              9, 5, -3),
            nrow = 3,
            byrow = TRUE)

b <- c(1, 8, 2)

r = solve(M, b)
print(r)

print(qr(M)$rank)

print(kronecker(A, B))