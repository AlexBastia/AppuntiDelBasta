import matplotlib.pyplot as plt
import numpy as np
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
m = 1
A = np.zeros([n, 1])
A[:, 0] = xx


# Usiamo minimi quadrati per trovare x che meglio approssima
k = np.linalg.matrix_rank(A)
U, s, VT = np.linalg.svd(A)
x = [0] * m
for i in range(k):
    x[i] = VT[i, :] * (U[:, i].T @ b) / s[i]

print(x)

approx = xx * x[0]

# Visualizzazione
plt.plot(xx, b, 'ro')
plt.plot(xx, approx)
plt.xlabel("Giorno")
plt.ylabel("Numero nuovi contagi")
plt.title("Numero di contagi nel tempo")
plt.show()
