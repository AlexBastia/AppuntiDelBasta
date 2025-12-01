 ### LLN: Law of Large Numbers
    # --- Sezione 1: Esempi preliminari ---
    n <- 1
    X <- rexp(n, rate=5) # generate one r.v., E(X)=1/lambda = 0.2
    n <- 20
    X.seq <- rexp(n, rate=5) # sequence of X_1, X_2, ..., X_n
    X.bar <- mean(X.seq) # sample mean

    ### --- Sezione 2: Convergenza della Media (SLLN) ---
    n <- 5000
    X.seq <- rexp(n, rate=5)
    # Calcola la media cumulativa: (X_1+...+X_n) / n
    X.bar <- cumsum(X.seq)/(1:n)  # sample mean sequence, for 1 we have X.bar[1]=X.seq[1], for 2 we have X.bar[2]=(X.seq[1]+X.seq[2])/2, etc.

    plot(1:n, X.bar, type="l", col=1, lwd=1, ylim=c(0, 0.4)) 
    abline(h=0.2, col=2, lwd=2) 
    # line for E(X) = 1/lambda = 0.2

    # ----------------------------------------------------
    # what about the theoretical variance? (Var(X.bar) = sigma^2 / n)
    # Var(X) = 1/25 = 0.04
    plot(1:n, 0.04/(1:n), type="l", col=1, lwd=1, ylim=c(0, 0.04))
    abline(h=0, col=2, lwd=2) 
    # ----------------------------------------------------

    # what if we actually compute the empirical variance of the process?
    # Calcola la media cumulativa degli scarti quadratici
    var.X.bar <- cumsum((X.seq-X.bar)^2)/(1:n)
    # Scalando ancora per 1/n si ottiene una stima della Var(X.bar)
    var.X.bar <- var.X.bar/1:n 

    plot(1:n, var.X.bar, type="l", col=1, lwd=1)