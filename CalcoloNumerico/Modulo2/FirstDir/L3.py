import matplotlib.pyplot as plt
import numpy as np

a = 0
b = 2*np.pi
N = 50

x = np.linspace(a, b, N)
y1 = np.sin(x)
y2 = np.cos(x)

plt.plot(x, y1, "k--", linewidth=10)
plt.plot(x, y2, "yo--")
plt.legend([r"$f(x)=\sin(x)$", r"$f(x)=\cos(x)$"])
plt.grid()
plt.show()
