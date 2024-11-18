def somma(v: list[float], w: list[float]) -> list[float]:
    if len(v) == len(w):
        x: list[float] = len(v) * [0]
        for i, e in enumerate(v):
            x[i] = e + w[i]
        return x


print(somma([1, 2, 3], [4, 5, 6]))
