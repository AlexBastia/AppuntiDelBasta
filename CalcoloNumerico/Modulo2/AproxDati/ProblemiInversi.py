import numpy as np
import matplotlib.pyplot as plt

n = 30
m = n
A = np.random.rand(n, n)
x = np.random.rand(n, 1)
y = A @ x

rng = np.random.default_rng()
delta = rng.normal(0, 0.5, (n, 1))
y_noisy = y + delta

U, s, VT = np.linalg.svd(A, full_matrices=False)
x_calc = np.zeros_like(x)
g = np.zeros([m, 1])
k = np.linalg.matrix_rank(A)
for i in range(k):
    g[i, :] = (U[:, i].T @ y_noisy) / s[i]

for i in range(n):
    x_calc[i, :] = VT[:, i].T @ g

# Truncated SVD
Ut, st, VTt = np.linalg.svd

plt.plot(x)
plt.plot(x_calc)
plt.show()
