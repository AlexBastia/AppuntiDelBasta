import numpy as np


def shaw(n):
    """
    SHAW Test problem: one-dimensional image restoration model.

    Parameters:
    n : int
        The order n must be even.

    Returns:
    A, x : np.array
        Discretization of a first kind Fredholm integral equation with [-pi/2, pi/2]
        as both integration intervals. Produces matrix A, and solution vector x.
    """
    # Check input
    if n % 2 != 0:
        raise ValueError("The order n must be even")

    # Initialization
    h = np.pi / n
    A = np.zeros((n, n))

    # Compute the matrix A
    co = np.cos(-np.pi / 2 + (np.arange(0.5, n, 1) * h))
    psi = np.pi * np.sin(-np.pi / 2 + (np.arange(0.5, n, 1) * h))

    for i in range(n // 2):
        for j in range(i, n - i):
            ss = psi[i] + psi[j]
            A[i, j] = ((co[i] + co[j]) * np.sin(ss) / (ss + 1e-10)) ** 2
            A[n - j - 1, n - i - 1] = A[i, j]
        A[i, n - i - 1] = (2 * co[i]) ** 2

    A = A + np.triu(A, 1).T
    A = A * h

    # Compute the vectors x and b
    a1, c1, t1 = 2, 6, 0.8
    a2, c2, t2 = 1, 2, -0.5

    x = a1 * np.exp(
        -c1 * (-np.pi / 2 + (np.arange(0.5, n, 1) * h - t1) ** 2)
    ) + a2 * np.exp(-c2 * (-np.pi / 2 + (np.arange(0.5, n, 1) * h - t2) ** 2))

    return A, x


def gravity(n, example=1, a=0, b=1, d=0.25):
    """
    GRAVITY Test problem: 1-D gravity surveying model problem.

    Parameters:
    n : int
        The number of discretization points.
    example : int
        The example scenario for the mass distribution f(t). Options: 1, 2, or 3.
    a, b : float
        Integration interval for the surface measurements s.
    d : float
        Depth at which the mass distribution is located.

    Returns:
    A, x : np.array
        Discretization of a 1-D model problem in gravity surveying. Produces matrix A, and solution vector x.
    """
    # Set up abscissas and matrix
    dt = 1 / n
    ds = (b - a) / n
    t = dt * (np.arange(1, n + 1) - 0.5)
    s = a + ds * (np.arange(1, n + 1) - 0.5)

    T, S = np.meshgrid(t, s)

    A = dt * d * np.ones((n, n)) / (d**2 + (S - T) ** 2) ** (3 / 2)

    # Set up solution vector and right-hand side
    nt = round(n / 3)
    nn = round(n * 7 / 8)
    x = np.ones(n)

    if example == 1:
        x = np.sin(np.pi * t) + 0.5 * np.sin(2 * np.pi * t)
    elif example == 2:
        x[:nt] = (2 / nt) * np.arange(1, nt + 1)
        x[nt:nn] = ((2 * nn - nt) - np.arange(nt + 1, nn + 1)) / (nn - nt)
        x[nn:] = (n - np.arange(nn + 1, n + 1)) / (n - nn)
    elif example == 3:
        x[:nt] = 2 * np.ones(nt)
    else:
        raise ValueError("Illegal value of example")

    return A, x
