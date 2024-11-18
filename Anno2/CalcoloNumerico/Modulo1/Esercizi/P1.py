from math import floor


def my_bin_2_dec(b: list[int]) -> int:
    l: int = len(b)
    d: int = 0
    for i, e in enumerate(b):
        d += e*2**(l-i-1)
    return d


def my_dec_2_bin(d: int) -> list[int]:
    if d == 0:
        return [0]

    b: list[int] = []
    while d > 0:
        b.append(d % 2)
        d = floor(d/2)
    b.reverse()
    return b


print(my_bin_2_dec([1, 0, 1, 0, 1, 0, 1]))
print(my_dec_2_bin(23))
print(my_bin_2_dec(my_dec_2_bin(12654)))
