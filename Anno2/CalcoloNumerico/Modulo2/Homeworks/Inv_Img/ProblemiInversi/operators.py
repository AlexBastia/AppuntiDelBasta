import numpy as np
from numpy.fft import fftshift, fftn, ifftn


class Operator:
    r"""
    The main class of the library. It defines the abstract Operator that will be subclassed for any specific case.
    """

    def __call__(self, x):
        return self._matvec(x)

    def __matmul__(self, x):
        return self._matvec(x)

    def __transpose__(self):
        return self._transpose()

    @property
    def T(self):
        return self.__transpose__()


class ConvolutionOperator(Operator):
    def __init__(self, kernel):
        r"""
        Represent the action of a convolution matrix A. A is obtained by a convolution operator K
        of dimension k x k and variance sigma, applied to an image x of shape n x n.
        """
        super().__init__()
        self.kernel = kernel
        self.output_shape = "same"

    def pad_kernel(self, kernel, target_shape):
        """
        Pad a PSF of shape k x k and returns a psf of dimension n x n, ready to be applied to x.
        """
        K_full = np.zeros(target_shape)
        K_full[
            (target_shape[0] - kernel.shape[0] + 1)
            // 2 : (target_shape[0] + kernel.shape[0] + 1)
            // 2,
            (target_shape[1] - kernel.shape[1] + 1)
            // 2 : (target_shape[1] + kernel.shape[1] + 1)
            // 2,
        ] = kernel

        return K_full

    def _matvec(self, x):
        """
        1 - Pad the kernel K to match the shape of x
        2 - Lunch fft_convolve between x and K
        """
        K_full = self.pad_kernel(self.kernel, x.shape)

        return self.fftconvolve(K_full, x)

    def _transpose(self):
        return ConvolutionOperator(self.kernel.T)

    def fftconvolve(self, x, y):
        xhat = fftn(x)
        yhat = fftn(y)

        return np.real(fftshift(ifftn(xhat * yhat)))


class Identity(Operator):
    r"""
    Defines the Identity operator (i.e. an operator that does not affect the input data).
    """

    def __init__(self, *args, **kwargs):
        super().__init__()
        self.output_shape = "same"

    def _matvec(self, x):
        return x

    def _transpose(self):
        return Identity()


class Gradient(Operator):
    def __init__(self):
        super().__init__()
        self.output_shape = "double"

    def _matvec(self, x):
        D_h = np.diff(x, n=1, axis=1, prepend=0)
        D_v = np.diff(x, n=1, axis=0, prepend=0)
        return np.concatenate((D_h, D_v), axis=0)

    def _transpose(self):
        return GradientTranspose()


class GradientTranspose(Operator):
    def __init__(self):
        super().__init__()
        self.output_shape = "half"

    def _matvec(self, y):
        D_h = y[: y.shape[0] // 2]
        D_v = y[y.shape[0] // 2 :]

        D_h_T = np.fliplr(np.diff(np.fliplr(D_h), n=1, axis=1, prepend=0))
        D_v_T = np.flipud(np.diff(np.flipud(D_v), n=1, axis=0, prepend=0))
        return D_h_T + D_v_T

    def _transpose(self):
        return Gradient()


class TikhonovOperator(Operator):
    """
    Given matrices A and L, returns the operator that acts like [A; L], concatenated vertically.
    """

    def __init__(self, A, L, lmbda):
        super().__init__()
        self.A = A
        if L is None:
            self.L = Identity()
        else:
            self.L = L
        self.lmbda = lmbda

    def _matvec(self, x):
        Ax = self.A @ x
        Lx = self.lmbda * (self.L @ x)

        return np.concatenate([Ax, Lx], axis=0)

    def _transpose(self):
        return TikhonovTransposedOperator(self.A.T, self.L.T, self.lmbda)


class TikhonovTransposedOperator(Operator):
    def __init__(self, AT, LT, lmbda):
        super().__init__()
        self.AT = AT
        self.LT = LT
        self.lmbda = lmbda

    def _matvec(self, x):
        if (self.AT.output_shape == "same") and (self.LT.output_shape == "same"):
            x1 = x[: x.shape[0] // 2, :]
            x2 = x[x.shape[0] // 2 :, :]
        elif (self.AT.output_shape == "same") and (self.LT.output_shape == "half"):
            x1 = x[: x.shape[0] // 3, :]
            x2 = x[x.shape[0] // 3 :, :]

        ATx1 = self.AT @ x1
        LTx2 = self.LT @ x2

        return ATx1 + self.lmbda * LTx2

    def _transpose(self):
        return TikhonovOperator(self.AT.T, self.LT.T)
