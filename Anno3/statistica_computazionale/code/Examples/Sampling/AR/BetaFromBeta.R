### Generating betas from betas
# -----------------------------------------------------------
# OBIETTIVO: Simulare da una Beta(2.7, 6.3) usando una Beta(2, 6)
# come densit`a strumentale (Proposal g).
# -----------------------------------------------------------
# 1. Definizione dei parametri della distribuzione Target f(x)
a = 2.7
b = 6.3
# 2. Definizione della funzione rapporto r(x) = f(x) / g(x)
# f(x) = dbeta(x, a, b) [Target]
# g(x) = dbeta(x, 2, 6) [Proposal]
f <- function(x) dbeta(x, a, b) / dbeta(x, 2, 6)
# 3. Calcolo della costante M
# M deve essere tale che f(x) <= M * g(x) per ogni x.
# Troviamo il massimo del rapporto f(x)/g(x) usando ’optimize’.
# $objective estrae il valore numerico del massimo.
M <- optimize(f, maximum=T, interval=c(0,1))$objective
# 4. Definizione della funzione di generazione (Algoritmo AR)
rbeta3 <- function(n, a, b, M, report=TRUE){
# Inizializzazione del vettore che conterr`a i campioni accettati
x <- rep(0, n)
# Contatore per monitorare l’efficienza (totale tentativi fatti)
ntry <- 0
# Ciclo per generare n valori accettati
for (i in 1:n){
done <- FALSE
# Ciclo while: continua a provare finch´e non accetta un candidato
while (!done){
ntry <- ntry + 1
# A. Generazione del Candidato Y dalla Proposal g ~ Beta(2, 6)
y <- rbeta(1, 2, 6)
# B. Generazione della variabile ausiliaria U
# Qui si usa u scala M: u = M * Uniform(0,1)
u <- M * runif(1)
# C. Test di Accettazione
# La condizione teorica `e: U_raw <= f(y) / (M * g(y))
# Moltiplicando per M, diventa: u <= f(y) / g(y)
if (u < dbeta(y, a, b) / dbeta(y, 2, 6)) done <- TRUE
}
# Se la condizione `e vera, salviamo il candidato y nel vettore x
x[i] <- y
}
# Report sull’efficienza dell’algoritmo (tasso di accettazione)
if (report) cat("I needed ", ntry, " trials to get ", n, " samples.\n")
return(x)
}

# 5. Esecuzione della simulazione
Nsim = 10^4
# Esempio di chiamata (nota: la riga è tagliata nell'immagine)
# campioni <- rbeta3(Nsim, a, b, M)
