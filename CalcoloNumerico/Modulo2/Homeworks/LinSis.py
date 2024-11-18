import numpy as np
import scipy as sp

n = 3
A = np.random.randn(n, n)
# H = sp.linalg.hilbert(n)
x_real = np.random.randn(n, 1)
y = A@x_real

# LU
P, L, U = sp.linalg.lu(A)

z = np.linalg.solve(U, y)
x_calc = np.linalg.solve(L, z)

C = np.linalg.cond(A)
E_rel = np.linalg.norm(x_real - x_calc) / np.linalg.norm(x_real)
print("Numero di condizionamento di A: ", C)
print("Errore relativo LU: ", E_rel)


print("Errore relativo Cholesky: ", E_rel)
