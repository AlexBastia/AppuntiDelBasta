# Grafici del Modulo 3 (Introduction to Statistics), in base R.
# Uso: dalla cartella maths/, Rscript img/stats_plots.R

# ---------------------------------------------------------------- Venn: 9 configurazioni
draw_circle <- function(x, y, radius, border, fill, label, label_x, label_y) {
  theta <- seq(0, 2 * pi, length.out = 300)
  polygon(x + radius * cos(theta), y + radius * sin(theta), border = border, col = fill, lwd = 2)
  text(label_x, label_y, label, col = border, font = 2, cex = 1.1)
}
draw_configuration <- function(centres, radii, main) {
  plot.new()
  plot.window(xlim = c(-2.15, 2.15), ylim = c(-1.65, 1.65), asp = 1)
  rect(-2.05, -1.55, 2.05, 1.55, border = "grey35", lwd = 1.4)
  text(-1.88, 1.35, expression(Omega), cex = 1.05)
  cols <- c("#2C7FB8", "#D95F0E", "#31A354")
  fills <- grDevices::adjustcolor(cols, alpha.f = 0.20)
  for (i in 1:3) {
    a <- c(145, 35, 90)[i] * pi / 180
    draw_circle(centres[i, 1], centres[i, 2], radii[i], cols[i], fills[i], c("A", "B", "C")[i],
                centres[i, 1] + 0.68 * radii[i] * cos(a), centres[i, 2] + 0.68 * radii[i] * sin(a))
  }
  title(main = main, line = 1.1, cex.main = 0.88)
}
pdf("img/venn-configurations.pdf", width = 8, height = 6.5)
par(mfrow = c(3, 3), mar = c(1.1, 0.7, 2.5, 0.7))
r <- c(0.58, 0.58, 0.58)
draw_configuration(rbind(c(-1.25, 0), c(0, 0), c(1.25, 0)), r, "1. All three pairs are disjoint")
draw_configuration(rbind(c(-0.48, 0), c(0.22, 0), c(1.45, 0)), r, "2. Only A and B overlap")
draw_configuration(rbind(c(-0.48, 0), c(1.45, 0), c(0.22, 0)), r, "3. Only A and C overlap")
draw_configuration(rbind(c(1.45, 0), c(-0.48, 0), c(0.22, 0)), r, "4. Only B and C overlap")
draw_configuration(rbind(c(0, 0), c(-0.77, 0), c(0.77, 0)), c(0.70, 0.62, 0.62), "5. AB and AC overlap")
draw_configuration(rbind(c(-0.77, 0), c(0, 0), c(0.77, 0)), c(0.62, 0.70, 0.62), "6. AB and BC overlap")
draw_configuration(rbind(c(-0.77, 0), c(0.77, 0), c(0, 0)), c(0.62, 0.62, 0.70), "7. AC and BC overlap")
tri <- rbind(c(-0.52, -0.30), c(0.52, -0.30), c(0, 0.60))
draw_configuration(tri, rep(0.57, 3), "8. Every pair overlaps; no triple overlap")
draw_configuration(tri, rep(0.78, 3), "9. A common triple overlap")
dev.off()

# ---------------------------------------------------------------- screening
p_D <- 0.02; p_T <- 0.95 * p_D + 0.05 * (1 - p_D)
print(c(p_T = p_T, p_D_given_T = 0.95 * p_D / p_T))

# ---------------------------------------------------------------- EDF
set.seed(2026)
x <- rnorm(100)
pdf("img/edf.pdf", width = 6, height = 4.2)
plot(ecdf(x), main = "Empirical distribution", xlab = "x", ylab = expression(F^(n)*(x)))
curve(pnorm(x), add = TRUE, lty = 2, col = "firebrick", lwd = 2)
legend("bottomright", legend = c("Empirical distribution", "Population distribution"),
       lty = c(1, 2), col = c("black", "firebrick"), bty = "n")
dev.off()

# ---------------------------------------------------------------- correlated variables
set.seed(123)
n <- 200
x <- rnorm(n); y <- 0.8 * x + rnorm(n, sd = 0.6)
print(c(covariance = cov(x, y), correlation = cor(x, y)))
pdf("img/correlated.pdf", width = 6, height = 4.5)
plot(x, y, pch = 19, col = rgb(0, 0, 0, 0.45), main = "Positively Correlated Variables", xlab = "X", ylab = "Y")
abline(lm(y ~ x), col = "steelblue", lwd = 2)
dev.off()

# ---------------------------------------------------------------- quantili
print(c(qnorm(0.95), qbinom(0.95, 10, 0.3), qunif(0.25, -1, 3), qexp(0.5, 2)))
set.seed(123); print(quantile(rnorm(100), c(0.25, 0.5, 0.75)))

# ---------------------------------------------------------------- Gaussian sample
set.seed(2026)
xg <- rnorm(1000)
pdf("img/gaussian-sample.pdf", width = 6, height = 4.2)
hist(xg, breaks = 35, freq = FALSE, col = "grey70", border = "white", main = "Gaussian Sample and Density", xlab = "x")
curve(dnorm(x), add = TRUE, lty = 2, lwd = 2)
dev.off()

# ---------------------------------------------------------------- multivariate Gaussian
set.seed(123)
X <- MASS::mvrnorm(n = 500, mu = c(0, 1), Sigma = matrix(c(1, 0.7, 0.7, 2), 2, byrow = TRUE))
print(round(c(colMeans(X), cov(X)), 3))
pdf("img/mvnormal.pdf", width = 6, height = 5)
plot(X, pch = 19, col = rgb(0, 0, 0, 0.4), main = "Simulated Multivariate Normal Data",
     xlab = expression(X[1]), ylab = expression(X[2]), asp = 1)
dev.off()

# ---------------------------------------------------------------- sampling distribution of the mean
set.seed(123)
B <- 5000; sizes <- c(5, 10, 30, 100, 300); mu <- 2; sigma <- 3
sims <- lapply(sizes, function(n) replicate(B, mean(rnorm(n, mu, sigma))))
print(do.call(rbind, lapply(seq_along(sizes), function(k)
  c(n = sizes[k], mean = mean(sims[[k]]), var = var(sims[[k]]), theo = sigma^2 / sizes[k]))))
lims <- mu + c(-4, 4) * sigma / sqrt(min(sizes))
pdf("img/xbar-sampling.pdf", width = 8, height = 5)
par(mfrow = c(2, 3), mar = c(4, 4, 2.5, 1))
for (k in seq_along(sizes)) {
  se <- sigma / sqrt(sizes[k])
  h <- hist(sims[[k]], breaks = 35, plot = FALSE)
  ymax <- max(h$density, dnorm(mu, mu, se))
  hist(sims[[k]], breaks = 35, freq = FALSE, xlim = lims, ylim = c(0, ymax), col = "steelblue",
       border = "white", main = paste("n =", sizes[k]), xlab = expression(bar(X)[n]))
  curve(dnorm(x, mu, se), add = TRUE, lty = 2, lwd = 2, col = "firebrick", n = 400)
  abline(v = mu, col = "grey30")
}
dev.off()

# ---------------------------------------------------------------- CLT: sum of Gamma
set.seed(123)
n_sum <- 30; alpha <- 2; theta <- 1.5
sum_gamma <- replicate(5000, sum(rgamma(n_sum, shape = alpha, scale = theta)))
mu_sum <- n_sum * alpha * theta; sd_sum <- sqrt(n_sum * alpha * theta^2)
print(c(mu_sum = mu_sum, sd_sum = sd_sum, mc_mean = mean(sum_gamma), mc_sd = sd(sum_gamma)))
pdf("img/clt-gamma.pdf", width = 6, height = 4.2)
hist(sum_gamma, breaks = 40, freq = FALSE, col = "grey70", border = "white",
     main = "Sum of Gamma Random Variables and Gaussian Approximation", xlab = expression(S[n]), cex.main = 0.9)
curve(dnorm(x, mu_sum, sd_sum), add = TRUE, lty = 2, lwd = 2)
dev.off()

# ---------------------------------------------------------------- Monte Carlo: empirical variance
set.seed(123)
sigma2_true <- 4; sizes <- c(3, 5, 10, 20, 50, 100, 500)
s2 <- lapply(sizes, function(n) replicate(5000, { x <- rnorm(n, 0, 2); mean((x - mean(x))^2) }))
res <- data.frame(n = sizes, mean_estimator = sapply(s2, mean), bias = sapply(s2, mean) - 4,
                  sd_estimator = sapply(s2, sd), theo_mean = 4 * (sizes - 1) / sizes)
print(res)
pdf("img/variance-bias.pdf", width = 6, height = 4.2)
plot(res$n, res$mean_estimator, type = "b", pch = 19, log = "x", ylim = c(2.5, 4.2),
     main = "Bias and Consistency of the Empirical Variance", xlab = "Sample size n (log scale)",
     ylab = expression(E[MC](hat(sigma)[n]^2)))
lines(res$n, res$theo_mean, lty = 3, col = "firebrick")
abline(h = sigma2_true, lty = 2)
legend("bottomright", c("Monte Carlo mean", "(n-1)/n * 4", "true variance"),
       lty = c(1, 3, 2), pch = c(19, NA, NA), col = c("black", "firebrick", "black"), bty = "n")
dev.off()
pdf("img/variance-sampling.pdf", width = 8, height = 6)
par(mfrow = c(3, 3), mar = c(4, 4, 2.5, 1))
for (k in seq_along(sizes)) {
  hist(s2[[k]], breaks = 35, col = "grey70", border = "white", main = paste("n =", sizes[k]),
       xlab = expression(hat(sigma)[n]^2))
  abline(v = sigma2_true, lty = 2, lwd = 2)
}
dev.off()

# ---------------------------------------------------------------- central region N(0,1)
pdf("img/ci-normal-region.pdf", width = 6, height = 3.8)
z <- seq(-4, 4, length.out = 1000); zl <- qnorm(0.025); zr <- qnorm(0.975)
plot(z, dnorm(z), type = "l", lwd = 2, main = "Central Probability Region of N(0,1)", xlab = "z", ylab = "Density")
inside <- z >= zl & z <= zr
polygon(c(zl, z[inside], zr), c(0, dnorm(z[inside]), 0), col = "grey70", border = NA)
lines(z, dnorm(z), lwd = 2)
abline(v = c(zl, zr), lty = 2)
text(0, 0.15, expression(1 - alpha))
dev.off()

# ---------------------------------------------------------------- bootstrap median
set.seed(123)
n <- 50; x <- rexp(n, rate = 2)
theta_hat <- median(x)
set.seed(456)
theta_boot <- replicate(10000, median(sample(x, size = n, replace = TRUE)))
ci <- unname(quantile(theta_boot, c(0.025, 0.975)))
print(c(theta_true = qexp(0.5, 2), theta_hat = theta_hat, mean = mean(theta_boot), se = sd(theta_boot), ci = ci))
pdf("img/bootstrap-median.pdf", width = 6, height = 4.2)
hist(theta_boot, breaks = 40, freq = FALSE, col = "#9ECAE1", border = "white",
     main = "Bootstrap Distribution of the Sample Median", xlab = "Bootstrap median")
abline(v = ci, lty = 2, col = "#D95F0E", lwd = 2)
abline(v = theta_hat, col = "#238B45", lwd = 2)
dev.off()
set.seed(789)
bf <- boot::boot(x, function(d, i) median(d[i]), R = 10000)
print(boot::boot.ci(bf, conf = 0.95, type = "perc")$percent[4:5])

# ---------------------------------------------------------------- coverage (risultati del modulo)
cov_n <- c(10, 20, 30, 50, 100)
cov_tab <- rbind(asym = c(0.8665, 0.8975, 0.9210, 0.9450, 0.9395),
                 bnorm = c(0.8535, 0.8885, 0.9180, 0.9435, 0.9380),
                 bperc = c(0.8620, 0.8930, 0.9190, 0.9410, 0.9375))
pdf("img/coverage.pdf", width = 6, height = 4.2)
matplot(cov_n, t(cov_tab), type = "b", pch = 19, lty = 1, col = c("firebrick", "darkgreen", "steelblue"),
        ylim = c(0.84, 0.96), xlab = "Sample size n", ylab = "Estimated coverage",
        main = "Coverage as a Function of the Sample Size")
abline(h = 0.95, lty = 2)
legend("bottomright", c("Asymptotic normal", "Bootstrap normal", "Bootstrap percentile"),
       col = c("firebrick", "darkgreen", "steelblue"), pch = 19, lty = 1, bty = "n")
dev.off()
