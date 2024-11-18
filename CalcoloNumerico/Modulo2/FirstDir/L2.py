"""
    Attenzione: quando dobbiamo usare la lettera lambda come variabile,
    togliere una lettera (lmda)
"""
def cubo(x): return x**3


def elemento_per_elemento(f, x: tuple[float]) -> list[float]:
    y = [0] * len(x)
    for i in range(len(x)):
        xi = x[i]
        y[i] = f(xi)
    return y


def saluti(cognome: str) -> None:
    print(f"Ciao, {nome} {cognome}.")
    return None


"""
    Questa e' una variabile a livello main,
    quindi e' visibile a qualunque funzione.
    Nel caso di variabili con stesso nome, vince quello
    piu vicino
"""
nome: str = "Davide"
saluti(cognome="Evangelista")


def potenza(p):
    def esecuzione(x):
        return x**p
    return esecuzione


pot = potenza(3)

print(pot(2))
