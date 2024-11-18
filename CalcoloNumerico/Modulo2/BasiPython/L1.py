a = 3
print(a)
f = int(input("Dammi un numero: "))

c = a**f
print(c)

z = None
print(z is None)

# Tipizzazione (debole, e' solo una cosa estetica)
a: int = 4
a = "ciao"
print(a)

# Array: Liste e Tuple
a = ["a", ["b", "c"]]
print(a)
print(a[0])
a[0] = "d"
print(a)

b = (1, 2, 3)   # Tupla che non posso modificare

# Slicing
print(b[0:3])
print(b[::-1])
