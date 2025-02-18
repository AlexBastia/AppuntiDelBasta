import numpy as np


class TSVD:
    r"""
    Apply Truncated SVD (TSVD) to solve the linear system:

    Ax = y

    where A is a matrix (represented by a 2-dimensional numpy array). In particular, computes:

    x_{TSVD} = \sum_{i=1}^k \frac{u_i^T y}{\sigma_i} v_i
    """

    def __init__(self, A):
        self.A = A

        # Compute SVD of A
        self.U, self.s, self.VT = np.linalg.svd(A)

    def solve(self, y, k):
        # Compute truncated matrix Uk, sk, VkT
        Uk = self.U[:, :k]
        sk = self.s[:k]
        VkT = self.VT[:k, :]

        # Compute TSVD solution
        phi = (Uk.T @ y) / sk
        a = phi[:, None] * VkT
        x_sol = np.sum(a, axis=0)
        return x_sol


class Tikhonov:
    r"""
    Solves the Tikonov-regularized inverse problem:

    \min_{x} 1/2 || Ax - y ||_2^2 + \lambda/2 || Lx ||_2^2

    where A is a matrix (represented by a 2-dimensional numpy array), and L is the Tikhonov matrix. This is done via normal equations, solve through LU decomposition.
    """

    def __init__(self, A):
        self.A = A

    def solve(self, y, lmbda, L=None):
        # If L is None -> L = I
        if L is None:
            L = np.eye(y.shape[0])

        # Compute M = A^T A + lmbda L^T L
        M = self.A.T @ self.A + lmbda * L.T @ L

        # Compute solution to normal equations
        L = np.linalg.cholesky(M)
        z = np.linalg.solve(L, self.A.T @ y)
        x_sol = np.linalg.solve(L.T, z)
        return x_sol


class CGLS:
    r"""
    Solve the linear system:

    Ax = y

    Where the matrix A is represented by a 2-dimensional numpy array. This is done by minimizing the associated Least Square problem via optimized Conjugate Graidient method.
    """

    def __init__(self, A):
        self.A = A

    def solve(self, y, x0, kmax=100, tolf=1e-6, tolx=1e-6):
        # Initialization
        d = y
        r0 = self.A.T @ y
        p = r0
        t = self.A @ p

        x = x0
        r = r0
        k = 0

        condition = True
        while condition:
            x0 = x

            # Update
            alpha = (
                np.linalg.norm(r0.flatten(), 2) ** 2
                / np.linalg.norm(t.flatten(), 2) ** 2
            )
            x = x0 + alpha * p
            d = d - alpha * t
            r = self.A.T @ d
            beta = (
                np.linalg.norm(r.flatten(), 2) ** 2
                / np.linalg.norm(r0.flatten(), 2) ** 2
            )
            p = r + beta * p
            t = self.A @ p

            r0 = r

            # Check convergence
            condition = (
                k < kmax 
                and (np.linalg.norm(r) > tolf)
                and (np.linalg.norm(x - x0) > tolx)
            )
            k = k + 1
        print(f"Terminato dopo {k} iterazioni")
        return x


class GDTotalVariation:
    r"""
    Solves the optimization problem:

    \min_{x} 1/2 || Ax - y ||_2^2 + \lambda TV_beta(x),

    where A is a 2-dimensional numpy array and:

    TV_beta(x) = \sum_{i=1}^n \sqrt{(D_h x)_i^2 + (D_v x)_i^2 + beta^2}

    is the smoothed Total Variation regularization term. The problem is solved through Gradient Descent.
    """

    def __init__(self, A, beta=1e-3):
        self.A = A
        self.beta = beta

    def solve(self, y, lmbda, x0, kmax=100, tolf=1e-6, tolx=1e-6):
        r"""
        Parameters:
        y (ndarray): the datum of Ax = y
        lmbda (float): the regularization parameter
        x0 (ndarray): starting point of the algorithm
        tolf (float): tollerance of || grad(f) ||_2
        tolx (float): tollerance of || x_{k+1} - x_k ||_2
        """
        # Inizializzazione
        k = 0
        obj_val = np.zeros((kmax + 1,))
        grad_norm = np.zeros((kmax + 1,))

        # Ciclo iterativo (uso un ciclo while)
        condizione = True
        while condizione:
            # Calcolo gradiente
            df = self.grad_f(x0, y, lmbda)

            # Scelta di alpha_k con backtracking
            alpha = self.backtracking(df, x0, y, lmbda, alpha=1)

            # Aggiornamento x_{k+1} = x_k - alpha_k df(x_k)
            x = x0 - alpha * df

            # Salvataggio
            obj_val[k] = self.f(x, y, lmbda)
            grad_norm[k] = np.linalg.norm(df)

            # Check condizioni di arresto
            condizione = (
                (k < kmax)
                and (np.linalg.norm(df) > tolf)
                and (np.linalg.norm(x - x0) > tolx)
            )

            # Se l'algoritmo termina per || x_{k+1} - x_k || < tolx, stampare il warning
            if np.linalg.norm(x - x0) < tolx:
                print(f"Algoritmo terminato per condizione su tolx.")

            # Preparazione per step successivo
            k = k + 1
            x0 = x

        # Se l'algoritmo si ferma prima di kmax, tagliare i valori inutilizzati delle metriche
        if k < kmax:
            obj_val = obj_val[:k]
            grad_norm = grad_norm[:k]

        print(f"Terminato dopo {k} iterazioni")
        return x, obj_val, grad_norm

    def f(self, x, y, lmbda):
        J = 0.5 * np.sum(np.square(self.A @ x - y))
        R = self.TV_beta(x)

        return J + lmbda * R

    def TV_beta(self, x):
        grad_mag = self.gradient_magnitude(x)
        return np.sum(grad_mag)

    def grad_f(self, x, y, lmbda):
        grad_J = self.A.T @ (self.A @ x - y)
        grad_R = self.grad_TV_beta(x)

        return grad_J + lmbda * grad_R

    def grad_TV_beta(self, x):
        # The gradient of smoothed TV is:
        # - div(Dx / gradient_magnitude(x))
        D_h, D_v = self.D(x)
        GM = self.gradient_magnitude(x)

        Dx = np.concatenate((D_h / GM, D_v / GM), axis=0)

        return -self.div(Dx)

    def gradient_magnitude(self, x):
        D_h, D_v = self.D(x)

        return np.sqrt(np.square(D_h) + np.square(D_v) + self.beta**2)

    def D(self, x):
        D_h = np.diff(x, n=1, axis=1, prepend=0)
        D_v = np.diff(x, n=1, axis=0, prepend=0)

        return D_h, D_v

    def div(self, f):
        f1 = f[f.shape[0] // 2 :]
        f2 = f[: f.shape[0] // 2]

        Dh_f1 = np.diff(f1, n=1, axis=1, append=0)
        Dv_f2 = np.diff(f2, n=1, axis=0, append=0)

        return Dh_f1 + Dv_f2

    def backtracking(self, df, x, y, lmbda, alpha=1, rho=0.5, c=1e-4):
        """
        Algoritmo di backtracking per Discesa Gradiente.

        Parameters:
        x       : Iterato x_k.
        alpha   : Stima iniziale di alpha(default 1).
        rho     : Fattore di riduzione (default 0.5).
        c       : Costante delle condizioni di Armijo (default 1e-4).

        Returns:
        alpha   : Learning rate calcolato con backtracking.
        """
        while (
            self.f(x - alpha * df, y, lmbda)
            > self.f(x, y, lmbda) + c * alpha * np.linalg.norm(df) ** 2
        ):
            alpha *= rho

            if alpha < 1e-6:
                return alpha
        return alpha
