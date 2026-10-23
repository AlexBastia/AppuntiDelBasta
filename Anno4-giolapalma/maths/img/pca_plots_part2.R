# Rigenera i grafici delle sezioni 2.6.2, 2.8 e del capitolo high-dimensional (base R)
# Uso: dalla cartella maths/, Rscript img/pca_plots_part2.R

# ---------------------------------------------------------------- 2.6.2
set.seed(123)
n <- 200
z1 <- rnorm(n, sd = 3); z2 <- rnorm(n, sd = 1.5); z3 <- rnorm(n, sd = 0.5)
x1 <- z1 + rnorm(n, sd = 0.2)
x2 <- 0.8 * z1 + rnorm(n, sd = 0.2)
x3 <- z2 + rnorm(n, sd = 0.2)
x4 <- 0.7 * z2 + rnorm(n, sd = 0.2)
x5 <- z3 + rnorm(n, sd = 0.2)
X <- scale(cbind(x1, x2, x3, x4, x5), center = TRUE, scale = FALSE)
pca <- prcomp(X, center = FALSE, scale. = FALSE)
eigenvalues <- pca$sdev^2
print(eigenvalues)
cum_pev <- cumsum(eigenvalues / sum(eigenvalues)); print(round(cum_pev, 4))

pdf("img/pca5-scree.pdf", width = 6, height = 4)
screeplot(pca, type = "lines", main = "Scree Plot from prcomp")
dev.off()

pdf("img/pca5-cumvar.pdf", width = 6, height = 4)
plot(cum_pev, type = "b", pch = 19, ylim = c(0, 1), xlab = "Number of components q",
     ylab = "Cumulative explained variance", main = "Cumulative Explained Variance")
abline(h = c(0.8, 0.9, 0.95), lty = 2)
dev.off()

# ---------------------------------------------------------------- 2.8 iris
data(iris)
species <- iris$Species
pca_iris <- prcomp(iris[, 1:4], center = TRUE, scale. = TRUE)
print(summary(pca_iris)); print(pca_iris$rotation)

pdf("img/iris-biplot.pdf", width = 6, height = 6)
biplot(pca_iris, cex = 0.6)
dev.off()

pdf("img/iris-colored.pdf", width = 6, height = 5)
scores <- pca_iris$x[, 1:2]; loadings <- pca_iris$rotation[, 1:2]
cols <- c("tomato", "steelblue", "darkgreen")[as.numeric(species)]
plot(scores[, 1], scores[, 2], col = cols, pch = 19, xlab = "PC1", ylab = "PC2",
     main = "Iris PCA Latent Scores with Loading Directions")
arrows(0, 0, 2.5 * loadings[, 1], 2.5 * loadings[, 2], length = 0.1, lwd = 2)
text(2.5 * loadings[, 1], 2.5 * loadings[, 2], labels = rownames(loadings), pos = 4)
legend("topright", legend = levels(species), col = c("tomato", "steelblue", "darkgreen"),
       pch = 19, bty = "n")
abline(h = 0, v = 0, lty = 2, col = "lightgray")
dev.off()

# ---------------------------------------------------------------- 3.3 digit 8
img_h <- 28; img_w <- 28
make_digit8 <- function(h = 28, w = 28, top_y = 10, bottom_y = 19, x0 = 14,
                        a1 = 5.0, b1 = 4.0, a2 = 5.5, b2 = 4.5,
                        thickness = 0.35, noise_sd = 0.05) {
  xx <- matrix(rep(1:w, each = h), nrow = h, ncol = w)
  yy <- matrix(rep(1:h, times = w), nrow = h, ncol = w)
  top_loop <- exp(-((sqrt(((xx - x0)/a1)^2 + ((yy - top_y)/b1)^2) - 1)^2) / thickness)
  bottom_loop <- exp(-((sqrt(((xx - x0)/a2)^2 + ((yy - bottom_y)/b2)^2) - 1)^2) / thickness)
  bridge <- exp(-((xx - x0)^2) / 7 - ((yy - (top_y + bottom_y)/2)^2) / 15)
  img <- pmax(top_loop, bottom_loop) + 0.35 * bridge
  img <- img + matrix(rnorm(h * w, sd = noise_sd), nrow = h, ncol = w)
  img <- pmax(img, 0)
  img / max(img)
}
show <- function(m, main, zlim = c(0, 1))
  image(t(m[img_h:1, ]), col = gray.colors(256), zlim = zlim, axes = FALSE, main = main)

set.seed(1234)
img_clean <- make_digit8(noise_sd = 0)

n <- 60; p <- img_h * img_w
images <- vector("list", n); X <- matrix(0, nrow = n, ncol = p)
set.seed(5678)
for (i in 1:n) {
  img <- make_digit8(
    top_y = round(rnorm(1, mean = 10, sd = 0.7)), bottom_y = round(rnorm(1, mean = 19, sd = 0.8)),
    x0 = round(rnorm(1, mean = 14, sd = 0.7)),
    a1 = rnorm(1, mean = 5.0, sd = 0.4), b1 = rnorm(1, mean = 4.0, sd = 0.3),
    a2 = rnorm(1, mean = 5.4, sd = 0.5), b2 = rnorm(1, mean = 4.5, sd = 0.3),
    thickness = abs(rnorm(1, mean = 0.34, sd = 0.05)), noise_sd = 0.04)
  images[[i]] <- img
  X[i, ] <- as.vector(img)
}

pdf("img/digit-samples.pdf", width = 8, height = 4.4)
par(mfrow = c(2, 4), mar = c(1, 1, 2, 1))
show(img_clean, "Reference (no noise)")
for (i in 1:7) show(images[[i]], paste("Image", i))
dev.off()

X_centered <- scale(X, center = TRUE, scale = FALSE)
mu <- attr(X_centered, "scaled:center")
S_small <- (1 / n) * X_centered %*% t(X_centered)
eig_small <- eigen(S_small)
lambda <- eig_small$values; P_tilde <- eig_small$vectors
print(head(lambda))
keep <- which(lambda > 1e-8)
lambda_pos <- lambda[keep]; P_tilde_pos <- P_tilde[, keep, drop = FALSE]
print(length(lambda_pos))
P <- sapply(seq_along(lambda_pos), function(j)
  as.vector(t(X_centered) %*% P_tilde_pos[, j] / sqrt(n * lambda_pos[j])))
print(dim(P)); print(max(abs(crossprod(P) - diag(ncol(P)))))  # colonne ortonormali

pdf("img/digit-scree.pdf", width = 6, height = 4)
plot(lambda_pos, type = "b", pch = 19, xlab = "Component", ylab = "Eigenvalue",
     main = "Scree plot for the synthetic digit-8 images")
dev.off()

eig_mats <- lapply(1:6, function(j) matrix(P[, j], nrow = img_h, ncol = img_w))
eig_lim <- max(abs(unlist(eig_mats))); print(eig_lim)
pdf("img/digit-eigenimages.pdf", width = 7, height = 4.6)
par(mfrow = c(2, 3), mar = c(1, 1, 2, 1))
for (j in 1:6) show(eig_mats[[j]], paste("PC", j), zlim = c(-eig_lim, eig_lim))
dev.off()

mean_img <- matrix(mu, nrow = img_h, ncol = img_w)
pdf("img/digit-directions.pdf", width = 6, height = 11)
par(mfrow = c(6, 3), mar = c(0.5, 0.5, 2, 0.5))
for (j in 1:6) {
  pj <- matrix(P[, j], nrow = img_h, ncol = img_w)
  clip <- function(m) pmin(pmax(m, 0), 1)
  show(clip(mean_img - 2 * sqrt(lambda_pos[j]) * pj), paste("PC", j, ": mean - 2 sd"))
  show(clip(mean_img), "Mean image")
  show(clip(mean_img + 2 * sqrt(lambda_pos[j]) * pj), paste("PC", j, ": mean + 2 sd"))
}
dev.off()

Z <- X_centered %*% P
print(dim(Z)); print(head(Z[, 1:3]))
print(round(apply(Z[, 1:5], 2, function(z) mean(z^2)), 6)); print(round(lambda_pos[1:5], 6))
pdf("img/digit-scores.pdf", width = 6, height = 5)
plot(Z[, 1], Z[, 2], pch = 19, col = "steelblue", xlab = "PC1", ylab = "PC2",
     main = "Synthetic digit-8 images in the first two PCA coordinates")
abline(h = 0, v = 0, lty = 2, col = "gray70")
dev.off()

reconstruct_image <- function(x, P, q, mu) {
  Pq <- P[, 1:q, drop = FALSE]
  zq <- (x - mu) %*% Pq
  matrix(as.vector(zq %*% t(Pq) + mu), nrow = img_h, ncol = img_w)
}
pdf("img/digit-reconstruction.pdf", width = 7.5, height = 2.2)
par(mfrow = c(1, 5), mar = c(0.5, 0.5, 2, 0.5))
show(matrix(X[1, ], nrow = img_h), "Original")
for (q in c(1, 5, 15, 30)) show(pmin(pmax(reconstruct_image(X[1, ], P, q, mu), 0), 1), paste("q =", q))
dev.off()

qs <- c(1, 2, 5, 10, 15, 20, 30, 40)
recon_error <- sapply(qs, function(q) {
  Pq <- P[, 1:q, drop = FALSE]
  mean(rowSums((X_centered - X_centered %*% Pq %*% t(Pq))^2))
})
print(data.frame(q = qs, reconstruction_error = recon_error,
                 lost_variance = sapply(qs, function(q) sum(lambda_pos[-(1:q)]))))
pdf("img/digit-recon-error.pdf", width = 6, height = 4)
plot(qs, recon_error, type = "b", pch = 19, xlab = "Number of principal components q",
     ylab = "Average reconstruction error", main = "Reconstruction error decreases with q")
dev.off()

# Eckart-Young: errore in norma spettrale = sigma_{q+1}
sv <- svd(X_centered)
q <- 5
Xq <- sv$u[, 1:q] %*% diag(sv$d[1:q]) %*% t(sv$v[, 1:q])
print(c(spectral_error = norm(X_centered - Xq, "2"), sigma_q1 = sv$d[q + 1]))
print(max(abs(sv$d[1:5]^2 / n - lambda_pos[1:5])))
