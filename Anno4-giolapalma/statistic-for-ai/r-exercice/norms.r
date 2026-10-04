x <- c(3,-4)

# GIGA NORME!!
norm_l1 <- sum(abs(x))
norm_l2 <- sqrt(sum(x^2))
norm_linf <- max(abs(x))

# p norma

p<-4
p_norm<-(sum(abs(x)^p))^(1/p)

#  reusable distance function is
distance_p <- function(x, y, p = 2) {
  z <- x - y

  if (is.infinite(p)) {
    return(max(abs(z)))
  }

  (sum(abs(z)^p))^(1/p)
}