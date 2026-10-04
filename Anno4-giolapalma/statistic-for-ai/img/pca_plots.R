# Rigenera i grafici della sezione 2.5 (base R, senza ggplot2)
set.seed(123)
n <- 150
x1 <- rnorm(n, sd = 2)
x2 <- 0.6 * x1 + rnorm(n, sd = 0.5)
X <- cbind(x1, x2)

Xc <- scale(X, center = TRUE, scale = FALSE)
S <- crossprod(Xc) / nrow(Xc)
print(S)
eig <- eigen(S); print(eig)
mu <- colMeans(X); P <- eig$vectors; lambda <- eig$values

lim <- range(X)
base_plot <- function(title) {
  plot(X, pch = 19, col = rgb(0, 0, 0, 0.4), asp = 1, xlab = "x1", ylab = "x2",
       main = title, xlim = lim, ylim = lim)
  grid()
}

pdf("img/pca-scatter.pdf", width = 6, height = 5)
base_plot("Simulated data cloud")
dev.off()

pdf("img/pca-directions.pdf", width = 6, height = 5)
base_plot("Principal directions from the covariance matrix")
for (j in 1:2) {
  end <- mu + 2 * sqrt(lambda[j]) * P[, j]
  arrows(mu[1], mu[2], end[1], end[2], lwd = 2.5, lty = j, length = 0.1,
         col = c("firebrick", "steelblue")[j])
}
dev.off()

fit <- prcomp(X, center = TRUE, scale. = FALSE)
Xhat <- fit$x[, 1, drop = FALSE] %*% t(fit$rotation[, 1, drop = FALSE])
Xhat <- sweep(Xhat, 2, fit$center, "+")
print(head(Xhat))

pdf("img/pca-reconstruction.pdf", width = 6, height = 5)
base_plot("Projection onto the first principal component")
segments(X[, 1], X[, 2], Xhat[, 1], Xhat[, 2], col = rgb(0, 0, 0, 0.3))
points(Xhat, pch = 1, col = "firebrick")
dev.off()
