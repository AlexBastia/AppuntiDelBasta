import numpy as np
import matplotlib.pyplot as plt

N = 200

x1 = np.random.normal(0, 1, (N,))
y1 = np.random.normal(0, 1, (N,))

plt.figure(figsize=(10, 4))
plt.subplot(1, 2, 1)
plt.plot(x1, y1, 'o', color='red')
plt.grid()

plt.subplot(1, 2, 2)
plt.plot(x1, y1, 'o', color='blue')
plt.grid()


plt.show()
