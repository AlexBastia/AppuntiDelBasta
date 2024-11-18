import numpy as np
import matplotlib.pyplot as plt


def f(x):
    return (x-1) ** 2 + np.exp(x)


def df(x):
    return 2*(x-1) + np.exp(x)


def GD(f, df, x0, alpha, maxit=100):
    r"""
    Implementa il metodo di discesa del gradiente con passo fisso applicato ad una funzione f(x) della quale si conosce la derivata df(x). 

    Parameters:
    f (function): la funzione obiettivo che si vuole minimizzare
    df (function): la derivata (o gradiente) della funzione obiettivo
    x0 (ndarray): valore iniziale dell'algoritmo
    alpha (float): il passo fisso che descrive gli step dell'algoritmo
    maxit (int): numero di iterazioni
    """
    # Inizializzazione
    k = 0

    X = [x0]

    # Ciclo iterativo (uso un ciclo while)
    while k < maxit:
        # Aggiornamento x_{k+1} = x_k - alpha_k df(x_k)
        x = x0 - alpha * df(x0)
        X.append(x)

        # Preparazione per step successivo
        k = k + 1
        x0 = x

    return X


# Fissiamo i parametri dell'algoritmo (iperparametri)
x0 = -1
alpha = 1e-1
maxit = 100

# Calcoliamo la soluzione
X = GD(f, df, x0, alpha, maxit)
x_sol = X[len(X)-1]
print(f"Soluzione calcolata: {x_sol:0.4f}")

# A scopo di analisi di prestazioni, misuriamo l'errore rispetto al minimo (noto)
x_true = 0.31492
rel_err = np.linalg.norm(x_sol - x_true) / np.linalg.norm(x_true)
print(f"Errore Relativo della soluzione calcolata: {rel_err:0.5f}.")

xx = np.linspace(-1, 2, 50)
plt.plot(xx, list(map(f, xx)))
plt.plot(X, list(map(f, X)), 'o')

plt.show()
