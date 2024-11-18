import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Set data path
data_path = "day_wise.csv"

# Load data
data = pd.read_csv(data_path)

# Estriamo data (x) e nuovi casi (y)
xx = pd.to_datetime(data['Date'])
b = data["New cases"]


# Convertiamo la data (x) in un intero incrementale
xx = (xx - xx.min()).dt.days
n = 188
d_guess = 7


def get_polinomial_vals(a: list[float], xx: list[float]) -> list[float]:
    x_len = len(xx)
    a_len = len(a)
    y = [0] * x_len
    for i in range(x_len):
        for j in range(a_len):
            y[i] += a[j] * xx[i] ** j
    return y


def create_vandermonde(xx: list[float]) -> list[list[float]]:
    n = len(xx)
    V = np.zeros([n, d_guess+1])
    for i in range(n):
        for j in range(d_guess+1):
            V[i][j] = xx[i] ** j
    return V


V = create_vandermonde(xx)
U, s, VT = np.linalg.svd(V)

y = np.zeros([d_guess+1, 1])
for i in range(d_guess+1):
    y[i] = (U.T[i] @ b) / s[i]
a_calc = VT.T @ y

print(a_calc)

plt.plot(xx, b, 'o')
plt.plot(xx, get_polinomial_vals(a_calc, xx))
plt.show()
