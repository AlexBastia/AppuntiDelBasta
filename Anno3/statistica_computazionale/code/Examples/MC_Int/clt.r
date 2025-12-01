### CLT: Central Limit Theorem
{
  library(scales) # Per la gestione della trasparenza nei colori
  set.seed(10)    # Per la riproducibilità

  # Funzione di simulazione
  # N.sim: numero di medie da calcolare (replicazioni)
  # lam: parametro lambda della Poisson
  # n: dimensione del campione per ogni media
  clt.sim <- function(N.sim, lam, n){
    X <- matrix(0, N.sim, n)
    for(i in 1:N.sim){
      X[i,] <- rpois(n, lam) # Genera n variabili Poisson
    }
    # Restituisce un vettore contenente la media di ogni riga
    return(apply(X, 1, mean)) 
  }

  lam <- 15
  n <- 50 # Dimensione del campione fissata (sufficiente per il CLT)
  
  # Sequenza crescente di numero di simulazioni (da 10 a 1000)
  N.sim <- round(seq(10, 1000, length.out = 100))

  # Plot iniziale con il primo numero di simulazioni
  # Nota: il codice originale usa alpha() per la trasparenza
  plot(density(clt.sim(N.sim[1], lam, n)), 
       col=alpha("blue", 0.1), 
       ylim=c(0, 0.9),
       main="Convergenza della Densità (CLT)")

  # Aggiunge le densità per numeri di simulazioni crescenti
  for(i in 2:100){
    lines(density(clt.sim(N.sim[i], lam, n)), col=alpha("blue", 0.1))
    # invisible(readline(prompt="Press [enter] to continue")) 
  }

  # Linea verticale sulla media vera (lambda)
  abline(v=lam, col=2, lwd=2)
}
