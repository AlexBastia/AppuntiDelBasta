import numpy as np
import matplotlib.pyplot as plt
from numpy import cos

a = -1
b = 1
x = np.linspace(a, b)  # 50 equally sapce valued from a to b
plt.figure(figsize=(12, 6))  # Create an "empty" graph, 12 wide, 6 high
plt.plot(x, x - cos(x))
plt.plot([a, b], [0, 0], 'g')  # Mark the x-axis in green
plt.grid(True)  # Add a graph paper background

plt.show()
