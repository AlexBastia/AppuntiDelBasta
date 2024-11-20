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

plt.figure(figsize=(5, 2.5))


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


def g_4(x): return 4*np.cos(x)


a = -4
b = 4
plt.clf()
x = np.linspace(a, b)
plt.title('Fixed points of the map $g_4(x) = 4 \cos(x)$')
plt.plot(x, g_4(x), label='$y=g_4(x)$')
plt.plot(x, x, label='$y=x$')
# Note: the bogus output value "ignore_me" supresses some useless output
ignore_me = plt.legend()
plt.savefig("../PGF/PuntoFisso3.pgf")

a = -1
b = 0
plt.clf()
punti_x = [-0.75, -0.25]
label_x = ['x_1', 'x_2']
plt.xticks(x, )
