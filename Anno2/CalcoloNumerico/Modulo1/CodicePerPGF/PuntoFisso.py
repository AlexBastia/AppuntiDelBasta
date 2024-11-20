import matplotlib
import numpy as np
import matplotlib.pyplot as plt

matplotlib.use("pgf")
matplotlib.rcParams.update({
    "pgf.texsystem": "pdflatex",
    'font.family': 'serif',
    'text.usetex': True,
    'pgf.rcfonts': False,
})

plt.figure(figsize=(3.4, 1.7))


def f_1(x): return x - np.cos(x)
def g_1(x): return np.cos(x)


f = f_1
g = g_1
a = -1
b = 1
x = np.linspace(a, b)
plt.title('$y = f(x) = x - \cos(x)$ and $y=0$')
plt.plot(x, f(x))
plt.plot([a, b], [0, 0])
plt.grid(True)
plt.savefig("../PGF/PuntoFisso1.pgf")

plt.clf()
plt.title('$y = g(x) = \cos (x)$ and $y=x$')
plt.plot(x, g(x))
plt.plot(x, x)
plt.grid(True)
plt.savefig("../PGF/PuntoFisso2.pgf")
