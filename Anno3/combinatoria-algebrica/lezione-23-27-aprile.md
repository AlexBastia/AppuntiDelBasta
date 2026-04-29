# Combinatoria Algebrica — Lezioni del 23 e 27 aprile

Argomenti: biunivocità di RSK, forma bilineare su $\mathrm{Sym}[X]$, identità di Cauchy, basi duali, prodotto scalare di Hall, funzioni di Schur combinatorie $\hat{s}_\lambda$, numeri di Kostka, regola di Pieri, RSK duale, identificazione $s_\lambda = \hat{s}_\lambda$.

---

## 1. Esercizio 8 — Ricostruzione di $A$ da $(L,R)$

**Dati:** $(L,R)$ coppia di SSYT della stessa forma. **Obiettivo:** ricostruire la $\mathbb{N}$-matrice finita $A$ tale che $\mathrm{RSK}(A) = (L,R)$.

Esempio:
$$
R = \begin{array}{|c|c|} \hline 2 & 3 \\ \hline 1 & 1 & \!3 \\ \hline \end{array}
\qquad
L = \begin{array}{|c|c|} \hline 2 & 3 \\ \hline 1 & 2 & \!3 \\ \hline \end{array}
$$

### Procedura (inversa di RSK)

Costruiamo $w_A$ "spelando" un passo alla volta:

1. **Trovare le caselle con $T$ massimo in $R$**: sono le candidate per essere "ultime aggiunte".
2. **Quella aggiunta per ultima è la più a destra nella riga più bassa** (regola minima del bumping).
3. **Sapendo quale casella è stata aggiunta in $R$**, leggiamo il numero corrispondente in $L$ (è il valore inserito); ricostruiamo poi quale numero, durante il bumping inverso, è stato scacciato dalla riga sopra, e così via.

Applicando la procedura alla coppia di sopra otteniamo
$$
w_A = \begin{pmatrix} 1 & 1 & 2 & 3 & 3 \\ 2 & 3 & 1 & 2 & 3 \end{pmatrix}
\quad\Longrightarrow\quad
A = \begin{pmatrix} 0 & 1 & 1 \\ 1 & 0 & 0 \\ 0 & 1 & 1 \end{pmatrix}
$$

### Proposizione — RSK è biunivoca

Avevamo già mostrato (osservazioni 1–5) che RSK è un'applicazione
$$
\{\mathbb{N}\text{-matrici finite}\}\;\longrightarrow\;\{(L,R)\ \text{SSYT della stessa forma}\}.
$$

**Dim.** Dato $(L,R)$, mostriamo che si può sempre ricostruire $w_A$ (e quindi $A$) per induzione: ad ogni passo, la casella ultima aggiunta è univocamente determinata dai punti (1)–(3) sopra; il numero in $L$ in quella posizione è l'ultimo elemento della parola, e il bumping inverso restituisce gli altri elementi. $\blacksquare$

---

## 2. Ripasso: matrici $(0,1)$ e $\mathbb{N}$

### Proposizione (già dimostrata)

$$
e_\lambda \;=\; \sum_{\mu \vdash n} M_{\lambda,\mu}\, m_\mu,
$$
dove $M_{\lambda,\mu}$ è il coefficiente di $x^\mu$ in $e_\lambda$, ovvero il numero di matrici $(0,1)$ tali che $\mathrm{row}(A) = \lambda$ e $\mathrm{col}(A) = \mu$.

(Per ogni colonna, scelgo $\lambda_i$ posizioni in cui mettere $1$, le altre $0$.)

### Analoga per le $h_\lambda$

$$
h_\lambda \;=\; \sum_{\mu \vdash n} N_{\lambda,\mu}\, m_\mu,
$$
dove $N_{\lambda,\mu}$ è il **numero di $\mathbb{N}$-matrici** con $\mathrm{row}(A) = \lambda$ e $\mathrm{col}(A) = \mu$.

**Dim.** In ciascuna colonna posso scegliere variabili con ripetizione: i monomi $x^\mu$ provenienti dalla colonna $j$ corrispondono a multi-insiemi di taglia $\lambda_j$, ovvero a vettori $(a_{1j}, a_{2j},\dots) \in \mathbb{N}^{\infty}$ con $\sum_i a_{ij} = \lambda_j$. Scelgo gli esponenti riga per riga. $\blacksquare$

### Osservazione (simmetria)

$$
N_{\lambda,\mu} = N_{\mu,\lambda},
$$
infatti $A \leftrightarrow A^T$ è una biezione che scambia $\lambda$ e $\mu$. Lo stesso vale per $M_{\lambda,\mu}$.

---

## 3. Una forma bilineare su $\mathrm{Sym}[X]$

### Definizione

$\langle\cdot,\cdot\rangle$ è l'unica forma bilineare su $\mathrm{Sym}[X]$ tale che
$$
\langle m_\lambda,\, h_\mu \rangle \;=\; \delta_{\lambda,\mu} \;=\; \begin{cases} 1 & \text{se } \lambda = \mu \\ 0 & \text{altrimenti.}\end{cases}
$$

Dato che $\{m_\lambda\}$ e $\{h_\mu\}$ sono basi, la richiesta le rende **basi duali**. Ogni forma bilineare può essere descritta in questo modo (su un prodotto di basi).

---

## 4. Identità di Cauchy

### Proposizione

$$
\boxed{\;\prod_{i,j} \frac{1}{1 - x_i y_j} \;=\; \sum_{\lambda} m_\lambda(x)\, h_\lambda(y)\;}
$$
e la versione "duale"
$$
\boxed{\;\prod_{i,j} \bigl(1 + x_i y_j\bigr) \;=\; \sum_{\lambda} m_\lambda(x)\, e_\lambda(y)\;}
$$
(la somma è su tutte le partizioni di tutti gli $n \in \mathbb{N}$).

### Dim. (prima identità)

Sviluppando la serie geometrica:
$$
\prod_{i,j} \frac{1}{1 - x_i y_j} \;=\; \prod_{i,j} \bigl(1 + z_{ij} + z_{ij}^2 + \cdots\bigr), \qquad z_{ij} := x_i y_j .
$$
Un monomio $x^\alpha y^\beta$ si ottiene scegliendo una $\mathbb{N}$-matrice $A = (a_{ij})$ tale che $\prod_{i,j}(x_i y_j)^{a_{ij}} = x^\alpha y^\beta$, ovvero $\mathrm{row}(A) = \alpha$ e $\mathrm{col}(A) = \beta$. Quindi
$$
\prod_{i,j}\frac{1}{1-x_i y_j} \;=\; \sum_{\lambda}\sum_\mu N_{\lambda,\mu}\, m_\lambda(x)\, m_\mu(y) \;=\; \sum_\lambda m_\lambda(x)\,\underbrace{\Bigl(\sum_\mu N_{\lambda,\mu}\, m_\mu(y)\Bigr)}_{= h_\lambda(y)} .
$$
La seconda identità è analoga, sostituendo le matrici $\mathbb{N}$ con $(0,1)$-matrici. $\blacksquare$

### Proposizione (caratterizzazione dualità)

Se $\{u_\lambda\}$ e $\{v_\lambda\}$ sono due basi di $\mathrm{Sym}[X]$, allora **sono duali** sse
$$
\prod_{i,j}\frac{1}{1 - x_i y_j} \;=\; \sum_\lambda u_\lambda(x)\, v_\lambda(y).
$$

(Dim. lasciata per esercizio — Macdonald, Capitolo I.)

---

## 5. Simmetria della forma bilineare

### Proposizione

$\langle\cdot,\cdot\rangle$ è simmetrica.

### Dim.

$$
\langle h_\lambda,\, h_\mu \rangle = \Bigl\langle \sum_\nu N_{\lambda,\nu}\, m_\nu,\; h_\mu \Bigr\rangle = \sum_\nu N_{\lambda,\nu}\,\langle m_\nu, h_\mu\rangle = N_{\lambda,\mu}.
$$
Per la simmetria di $N$:
$$
N_{\lambda,\mu} = N_{\mu,\lambda} = \langle h_\mu, h_\lambda\rangle. \qquad\blacksquare
$$

---

## 6. Ripasso 2: le $p_\lambda$

Avevamo definito
$$
z_\lambda \;=\; \prod_i \bigl(m_i!\, \cdot\, i^{m_i}\bigr), \qquad m_i = \#\{j : \lambda_j = i\}.
$$

**Esempio.** $\lambda = (2,1,1)$: $m_1 = 2,\ m_2 = 1$, quindi $z_\lambda = 2!\cdot 1!\cdot 1^2 \cdot 2^1 = 4$.

E avevamo dimostrato
$$
h_n \;=\; \sum_{\lambda \vdash n} \frac{1}{z_\lambda}\, p_\lambda .
$$

### Proposizione (dualità delle $p_\lambda$)

$$
\boxed{\;\prod_{i,j}\frac{1}{1-x_i y_j} \;=\; \sum_\lambda \frac{p_\lambda(x)\, p_\lambda(y)}{z_\lambda}\;}
$$
$$
\prod_{i,j}\bigl(1 + x_i y_j\bigr) \;=\; \sum_\lambda (-1)^{|\lambda| - \ell(\lambda)}\,\frac{p_\lambda(x)\, p_\lambda(y)}{z_\lambda}.
$$

Quindi $\{p_\lambda\}$ e $\bigl\{\dfrac{p_\lambda}{z_\lambda}\bigr\}$ sono **basi duali**.

### Dim. (prima identità)

Sia $z_{ij} = x_i y_j$. Ragionando con la serie geometrica e $|t| = 1$:
$$
\prod_{i,j}\frac{1}{1 - x_i y_j t} = \prod_{i,j}\bigl(1 + z_{ij} t + z_{ij}^2 t^2 + \cdots\bigr) = \sum_{n \in \mathbb{N}} h_n(z)\, t^n = \sum_{n\in\mathbb{N}}\Bigl(\sum_{\lambda \vdash n}\frac{1}{z_\lambda}\, p_\lambda(z)\Bigr)\, t^n .
$$
Valutando in $t = 1$:
$$
\prod_{i,j}\frac{1}{1 - x_i y_j} = \sum_\lambda \frac{p_\lambda(z)}{z_\lambda}.
$$
Resta da osservare che, con $z_{ij} = x_i y_j$, vale per ogni $n$:
$$
p_n(z) = \sum_{i,j} (x_i y_j)^n = \Bigl(\sum_i x_i^n\Bigr)\Bigl(\sum_j y_j^n\Bigr) = p_n(x)\, p_n(y) .
$$
Quindi $p_\lambda(z) = p_\lambda(x)\, p_\lambda(y)$, da cui la tesi. $\blacksquare$

### Corollario A

$\langle\cdot,\cdot\rangle$ è un **prodotto scalare** (definito positivo) e $\{p_\lambda\}$ è una base ortogonale.

**Dim.** Dalla dualità di $\{p_\lambda\}$ e $\{p_\lambda/z_\lambda\}$:
$$
\Bigl\langle p_\lambda,\, \frac{p_\mu}{z_\mu}\Bigr\rangle = \delta_{\lambda,\mu} \;\Longrightarrow\; \langle p_\lambda, p_\mu\rangle = z_\lambda\, \delta_{\lambda,\mu}.
$$
Quindi è ortogonale e definito positivo (gli $z_\lambda$ sono numeri positivi). $\blacksquare$

### Corollario B (involuzione $\omega$)

$$
\omega: h_\lambda \;\longleftrightarrow\; e_\lambda
$$
è un'**isometria**.

**Dim.** Basta verificare $\langle\omega(p_\lambda), \omega(p_\mu)\rangle = \langle p_\lambda, p_\mu\rangle$. Si ricorda che $\omega(p_n) = (-1)^{n-1} p_n$, quindi $\omega(p_\lambda) = (-1)^{|\lambda|-\ell(\lambda)} p_\lambda$ e
$$
\langle \omega(p_\lambda), \omega(p_\mu)\rangle = (\pm 1)^2\, z_\lambda\, \delta_{\lambda,\mu} = \langle p_\lambda, p_\mu\rangle. \quad\blacksquare
$$

---

## 7. Funzioni di Schur **combinatorie** $\hat{s}_\lambda$

### Definizione

$$
\boxed{\;\hat{s}_\lambda(x) \;=\; \sum_{T \in \mathrm{SSYT}(\lambda)} x^T\;}
$$
dove $x^T = \prod_i x_i^{\#\{i \in T\}}$. (La definizione si estende a forme skew $\lambda/\mu$.)

### Teorema

Le $\hat{s}_\lambda$ formano una **base ortonormale** di $\mathrm{Sym}[X]$.

### Dim.

Dobbiamo mostrare $\langle \hat{s}_\lambda, \hat{s}_\mu\rangle = \delta_{\lambda,\mu}$. Equivalentemente (una base è duale a sé stessa $\Leftrightarrow$ è ortonormale):
$$
\sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_\lambda(y) \;\stackrel{?}{=}\; \prod_{i,j}\frac{1}{1 - x_i y_j} .
$$
Un monomio $x^\alpha y^\beta$ nel **secondo** membro si ottiene scegliendo una $\mathbb{N}$-matrice $A$ con $\mathrm{row}(A) = \alpha$, $\mathrm{col}(A) = \beta$.

Nel **primo** membro è il numero di coppie $(L,R)$ di SSYT della stessa forma $\lambda$ con $\mathrm{type}(R) = \alpha$ e $\mathrm{type}(L) = \beta$.

Ma RSK è una biezione tra le due collezioni, quindi i coefficienti coincidono. $\blacksquare$

---

## 8. Numeri di Kostka

### Definizione

Siano $\lambda/\mu$ una forma skew (eventualmente $\mu = \emptyset$) e $\alpha \vDash n$ una composizione (con $\alpha_1 + \alpha_2 + \cdots = n$). Si pone
$$
K_{\lambda/\mu,\, \alpha} \;=\; \#\{T\ \text{SSYT di forma } \lambda/\mu \mid \mathrm{type}(T) = \alpha\}.
$$

**Caso particolare.** Per $\alpha = (1^n) = (1,1,\dots,1)$:
$$
f^{\lambda/\mu} \;:=\; K_{\lambda/\mu,\, 1^n} \;=\; \#\{\text{tableaux \emph{standard} di forma } \lambda/\mu\}.
$$

### Proposizione

$$
\boxed{\;\sum_{\lambda \vdash n} (f^\lambda)^2 \;=\; n!\;}
$$

**Dim.** Restringo la biezione RSK alle **matrici di permutazione** ($\sigma \in S_n$ corrisponde ad $A_\sigma$ con $w_{A_\sigma} = \binom{1\ 2\cdots n}{\sigma(1)\,\sigma(2)\cdots\sigma(n)}$). Si ottiene così una biezione
$$
S_n \;\stackrel{\mathrm{RSK}}{\longleftrightarrow}\; \bigsqcup_{\lambda \vdash n}\,\mathrm{SYT}(\lambda) \times \mathrm{SYT}(\lambda).
$$
Confrontando le cardinalità: $n! = \sum_\lambda (f^\lambda)^2$. $\blacksquare$

> **Curiosità.** Per $n = 4$: $f^{(4)} = 1$, $f^{(1^4)} = 1$, $f^{(2,2)} = 2$, $f^{(3,1)} = 3$, $f^{(2,1,1)} = 3$, e $1^2 + 1^2 + 2^2 + 3^2 + 3^2 = 24 = 4!$. (Coincide con la somma dei quadrati delle dimensioni delle rappresentazioni irriducibili di $S_n$ — non è un caso!)

### Teorema

$$
e_\mu \;=\; \sum_{\substack{\lambda \vdash |\mu| \\ \lambda \,\trianglerighteq\, \mu'}} K_{\lambda'/\mu}\, s_\lambda
$$
(le coordinate sono numeri di Kostka indicizzati dalla **trasposta**). La dimostrazione non fa parte del programma.

### Corollario (regola di Pieri)

$$
\boxed{\; s_\nu\, e_n \;=\; \sum_\lambda s_\lambda\;}
$$
dove la somma è sulle partizioni $\lambda$ tali che $\lambda/\nu$ è una **striscia verticale** ($n$ caselle, mai due nella stessa riga).

**Esempio.** $\nu = (3,3,1)$, $n = 2$. Le possibili strisce verticali a 2 caselle aggiungibili al diagramma di $\nu$ producono (visualizzando):
$$
s_\nu \cdot e_2 \;=\; s_{(4,4,1)} + s_{(3,3,1,1,1)} + s_{(4,3,2)} + s_{(4,3,1,1)} + s_{(3,3,2,1)} .
$$

> Stiamo trovando relazioni fra le $s$ e altre basi.

---

## 9. Simmetria delle $\hat{s}_\lambda$

### Proposizione

Le $\hat{s}_\lambda$ sono **funzioni simmetriche**.

### Dim.

Le trasposizioni adiacenti $(i,\,i+1)$ generano $S_\infty$, quindi basta mostrare $(i,i+1)\cdot \hat{s}_{\lambda/\mu} = \hat{s}_{\lambda/\mu}$ per ogni $i$, dove l'azione scambia le occorrenze di $i$ e $i+1$ nei tableaux.

Costruiamo una biezione $\varphi$ sui SSYT di forma $\lambda/\mu$ che scambia il numero di $i$ con il numero di $i+1$:

- Le **colonne** che non contengono né $i$ né $i+1$ non cambiano.
- Le **colonne che contengono entrambi** sono già "incastrate verticalmente" ($i$ sopra, $i+1$ sotto): non possiamo modificarle senza rompere la stretta crescenza in colonna.
- Restano le **colonne con solo uno tra $i$ e $i+1$**. In ciascuna riga, queste celle si presentano in blocchi del tipo
$$
\underbrace{i\ i\ \cdots\ i}_{r}\;\underbrace{i{+}1\ \cdots\ i{+}1}_{s}
$$
e $\varphi$ trasforma $(r,s) \mapsto (s,r)$ — sostituiamo cioè $r$ entrate $i$ e $s$ entrate $i{+}1$ con $s$ entrate $i$ e $r$ entrate $i{+}1$ nello stesso blocco. La condizione di SSYT è preservata: il blocco resta debolmente crescente in riga, e nelle colonne adiacenti la stretta crescenza in verticale è garantita perché stiamo lavorando solo in colonne dove il "partner" nella colonna sopra/sotto è $\le i-1$ o $\ge i+2$.

Otteniamo così una biezione fra tableaux che scambia il tipo, da cui la simmetria di $\hat{s}_{\lambda/\mu}$. $\blacksquare$

### Corollario

$$
\boxed{\; s_{\lambda/\mu}(x) \;=\; \sum_{\nu \,\vdash\, |\lambda/\mu|} K_{\lambda/\mu,\, \nu}\, m_\nu(x)\;}
$$

In particolare, per $\mu = \emptyset$:
$$
\hat{s}_\lambda(x) \;=\; \sum_{\nu \vdash |\lambda|} K_{\lambda,\nu}\, m_\nu(x).
$$

**Dim.** Per definizione, $\hat{s}_{\lambda/\mu} = \sum_\alpha K_{\lambda/\mu,\alpha}\, x^\alpha$, dove $\alpha$ varia sulle composizioni. Ma essendo simmetrica, le composizioni che differiscono solo per permutazione contribuiscono con lo stesso coefficiente $K_{\lambda/\mu, \nu}$ (con $\nu$ riordinamento decrescente di $\alpha$): ricomponendo si ottiene la base dei monomi simmetrici $m_\nu$. $\blacksquare$

---

## 10. Ordine di dominanza e proprietà fondamentali di $K_{\lambda,\mu}$

### Definizione (ordine di dominanza)

Dati $\mu, \lambda \vdash n$:
$$
\mu \;\trianglelefteq\; \lambda \;\;\Longleftrightarrow\;\; \forall i \ge 1,\quad \sum_{j=1}^{i} \mu_j \;\le\; \sum_{j=1}^{i} \lambda_j .
$$

### Proposizione

Siano $\lambda, \mu \vdash n$. Se $K_{\lambda,\mu} \ne 0$ allora $\mu \trianglelefteq \lambda$. Inoltre $K_{\lambda,\lambda} = 1$.

### Dim.

Supponiamo $K_{\lambda,\mu} \ne 0$: esiste un SSYT $T$ di forma $\lambda$ e tipo $\mu$. In un SSYT tutti gli $1$ stanno nella prima riga (più sotto violerebbero la stretta crescenza in colonna), quindi
$$
\mu_1 \;=\; \#\{1 \in T\} \;\le\; \lambda_1 \qquad (\text{una riga ha al massimo } \lambda_1 \text{ caselle}).
$$
Allo stesso modo, gli $1$ e i $2$ devono comparire solo nelle prime due righe, quindi
$$
\mu_1 + \mu_2 \;\le\; \lambda_1 + \lambda_2.
$$
Iterando:
$$
\mu_1 + \cdots + \mu_i \;\le\; \lambda_1 + \cdots + \lambda_i \qquad \forall i,
$$
ovvero $\mu \trianglelefteq \lambda$.

**$K_{\lambda,\lambda} = 1$:** esiste un unico SSYT di forma $\lambda$ e tipo $\lambda$, quello in cui la riga $i$ contiene solo $i$ (super-standard):
$$
\begin{array}{|c|c|c|c|}\hline 1 & 1 & 1 & \cdots \\ \hline 2 & 2 & \cdots \\\hline 3 & \cdots \\ \hline \vdots \end{array}
$$
È l'unico per induzione sul numero di righe. $\blacksquare$

### Corollario

Le $\hat{s}_\lambda$, al variare di $\lambda \vdash n$, formano una **base** di $\mathrm{Sym}^n[X]$.

**Dim.** Dalla relazione $\hat{s}_\lambda = \sum_\mu K_{\lambda,\mu}\, m_\mu$, la matrice di cambio di base $K = (K_{\lambda,\mu})_{\lambda,\mu \vdash n}$ è (in ordine di dominanza opportuno) **triangolare** con $1$ sulla diagonale: dunque invertibile. $\blacksquare$

> **Riassumendo:** $\hat{s}_\lambda$ con $\lambda \vdash n$ sono una base **ortonormale** di $\mathrm{Sym}^n[X]$.

---

## 11. Sviluppi nelle $\hat{s}_\lambda$

### Corollario

$$
\boxed{\; h_\mu \;=\; \sum_\lambda K_{\lambda,\mu}\, \hat{s}_\lambda \;}
$$

**Dim.** Sia $h_\mu = \sum_\lambda a_{\lambda,\mu}\, \hat{s}_\lambda$. Per ortonormalità delle $\hat{s}_\lambda$ e dualità $\langle h_\mu, m_\nu\rangle = \delta_{\mu,\nu}$:
$$
a_{\lambda,\mu} \;=\; \langle h_\mu,\, \hat{s}_\lambda\rangle \;=\; \Bigl\langle h_\mu,\, \sum_\nu K_{\lambda,\nu}\, m_\nu \Bigr\rangle \;=\; \sum_\nu K_{\lambda,\nu}\, \delta_{\mu,\nu} \;=\; K_{\lambda,\mu}. \qquad\blacksquare
$$

### Corollario

$$
h_1^n \;=\; \sum_{\lambda \vdash n} f^\lambda\, \hat{s}_\lambda .
$$

**Dim.** $h_1^n = h_{(1^n)}$, e applicando il corollario precedente con $\mu = (1^n)$:
$$
h_{(1^n)} = \sum_\lambda K_{\lambda,\,1^n}\, \hat{s}_\lambda = \sum_\lambda f^\lambda\, \hat{s}_\lambda. \qquad\blacksquare
$$

---

## 12. Trasposta e simmetria di RSK

### Fatto (dim. lasciata a Morbidelli)

Sia $A$ una $\mathbb{N}$-matrice finita, e $A \xrightarrow{\mathrm{RSK}} (L,R)$. Allora
$$
A^T \;\xrightarrow{\mathrm{RSK}}\; (R,L).
$$

### Corollario

$$
A\ \text{simmetrica} \;\Longleftrightarrow\; R = L .
$$
Inoltre RSK ristretta è una **biezione** tra
$$
\{\mathbb{N}\text{-matrici simmetriche con } \mathrm{row}(A) = \alpha\}\;\longleftrightarrow\;\{\mathrm{SSYT}\ \text{di tipo}\ \alpha\}.
$$

### Corollario (involuzioni di $S_n$)

$$
\boxed{\;\sum_{\lambda \vdash n} f^\lambda \;=\; \#\{\sigma \in S_n \mid \sigma^2 = \mathrm{id}\}\;}
$$

**Dim.** Le matrici di permutazione sono ortogonali, quindi
$$
A^{-1} = A^T \;\Longleftrightarrow\; \sigma = \sigma^{-1} \;\Longleftrightarrow\; \sigma^2 = \mathrm{id}.
$$
Restringendo la biezione RSK alle matrici di permutazione **simmetriche** otteniamo la biezione tra involuzioni di $S_n$ e SYT (singoli) di forma $\lambda \vdash n$. $\blacksquare$

**Esempio ($n = 4$).** $\sum_\lambda f^\lambda = 1+3+2+3+1 = 10$. Le involuzioni di $S_4$: $6 \cdot (\text{trasposizioni}) + 3 \cdot (\text{doppie trasposizioni}) + 1 \cdot \mathrm{id} = 10$. ✓

---

## 13. RSK duale ($\mathrm{RSK}^*$)

**Algoritmo.** Biezione fra $(0,1)$-matrici finite e coppie $(L,R)$ di tableaux della stessa forma tali che $L'$ è SSYT e $R$ è SSYT (cioè $L$ è SSYT trasposto: strettamente crescente in riga, debolmente crescente in colonna).

L'algoritmo funziona nello stesso modo di RSK ma con una regola di bumping diversa: quando si inserisce un numero $j$ in una riga, scaccia il primo elemento $> j$ (anziché $\ge j$) — più precisamente, $j$ scaccia l'elemento più a sinistra che è $\le j$.

### Identità di Cauchy duale

Così come abbiamo dimostrato (con RSK)
$$
\prod_{i,j}\frac{1}{1 - x_i y_j} \;=\; \sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_\lambda(y),
$$
analogamente, con $\mathrm{RSK}^*$:
$$
\boxed{\;\prod_{i,j}\bigl(1 + x_i y_j\bigr) \;=\; \sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_{\lambda'}(y)\;}
$$

### Corollario — azione di $\omega$ su $\hat{s}_\lambda$

$$
\boxed{\; \omega(\hat{s}_\lambda) \;=\; \hat{s}_{\lambda'} \;}
$$

**Dim.** Indichiamo con $\omega_y$ l'involuzione che agisce solo sulle variabili $y$ (gli $x$ diventano costanti). Calcoliamo:
$$
\sum_\lambda \hat{s}_\lambda(x)\, \omega_y\bigl(\hat{s}_\lambda(y)\bigr)
= \omega_y\Bigl(\sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_\lambda(y)\Bigr)
\stackrel{\text{Cauchy}}{=} \omega_y\Bigl(\prod_{i,j}\frac{1}{1 - x_i y_j}\Bigr).
$$
Espandendo l'identità di Cauchy nelle basi $\{m_\lambda(x)\}$ e $\{h_\lambda(y)\}$:
$$
\omega_y\Bigl(\sum_\lambda m_\lambda(x)\, h_\lambda(y)\Bigr) = \sum_\lambda m_\lambda(x)\, e_\lambda(y) = \prod_{i,j}\bigl(1 + x_i y_j\bigr) = \sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_{\lambda'}(y).
$$
Confrontando primo e ultimo membro:
$$
\sum_\lambda \hat{s}_\lambda(x)\, \omega(\hat{s}_\lambda)(y) \;=\; \sum_\lambda \hat{s}_\lambda(x)\, \hat{s}_{\lambda'}(y) .
$$
Dato che vale grado per grado e in ogni grado $\{\hat{s}_\lambda\}$ è una base, i coefficienti coincidono: $\omega(\hat{s}_\lambda) = \hat{s}_{\lambda'}$. $\blacksquare$

---

## 14. Identificazione $s_\lambda = \hat{s}_\lambda$

### Teorema

$$
\boxed{\; s_\lambda \;=\; \hat{s}_\lambda \qquad \forall\,\lambda. \;}
$$

Cioè la funzione di Schur "algebrica" (definita ad esempio come quoziente di determinanti à la Jacobi-Trudi, o tramite la formula bialternante di Cauchy) coincide con quella **combinatoria** somma su SSYT.

### Dim.

Dal teorema sui Kostka (regola di sviluppo di $e_\mu$ nelle $s_\lambda$):
$$
e_\mu = \sum_\lambda K_{\lambda',\mu}\, s_\lambda .
$$
Dall'analoga relazione combinatoria $h_\mu = \sum K_{\lambda,\mu}\,\hat{s}_\lambda$, applicando $\omega$:
$$
e_\mu \;=\; \omega(h_\mu) \;=\; \omega\Bigl(\sum_\lambda K_{\lambda,\mu}\,\hat{s}_\lambda\Bigr) \;=\; \sum_\lambda K_{\lambda,\mu}\,\hat{s}_{\lambda'} \;=\; \sum_{\lambda'} K_{\lambda',\mu}\,\hat{s}_{\lambda} .
$$
(Stiamo solo riordinando: $\lambda$ e $\lambda'$ percorrono entrambi $\{\text{partizioni di } |\mu|\}$.)

Confrontando le due espressioni per $e_\mu$:
$$
\sum_\lambda K_{\lambda',\mu}\, s_\lambda \;=\; \sum_\lambda K_{\lambda',\mu}\, \hat{s}_\lambda .
$$
Poiché la matrice $(K_{\lambda',\mu})_{\lambda,\mu}$ è triangolare con $1$ sulla diagonale (quindi **invertibile**), abbiamo un sistema lineare con unica soluzione: $s_\lambda = \hat{s}_\lambda$ per ogni $\lambda$. $\blacksquare$

---

## Riepilogo finale

| Oggetto | Definizione / Proprietà |
|---|---|
| $\langle m_\lambda, h_\mu\rangle = \delta_{\lambda,\mu}$ | basi duali; estende a prodotto scalare di Hall |
| Cauchy | $\prod_{i,j}\dfrac{1}{1-x_i y_j} = \sum_\lambda m_\lambda(x) h_\lambda(y)$ |
| Cauchy duale | $\prod_{i,j}(1+x_i y_j) = \sum_\lambda m_\lambda(x) e_\lambda(y)$ |
| Cauchy in $p$ | $\prod \frac{1}{1-x_i y_j} = \sum_\lambda \frac{p_\lambda(x) p_\lambda(y)}{z_\lambda}$, $\langle p_\lambda, p_\mu\rangle = z_\lambda \delta_{\lambda,\mu}$ |
| $\omega$ | isometria, $\omega(h_\lambda)=e_\lambda$, $\omega(p_n)=(-1)^{n-1}p_n$, $\omega(s_\lambda)=s_{\lambda'}$ |
| $\hat{s}_\lambda$ | $\sum_{T \in \mathrm{SSYT}(\lambda)} x^T$, base ortonormale di $\mathrm{Sym}[X]$ |
| Kostka | $K_{\lambda,\mu} = \#\{\mathrm{SSYT}(\lambda) \text{ di tipo } \mu\}$, $K_{\lambda,\mu} \ne 0 \Rightarrow \mu \trianglelefteq \lambda$, $K_{\lambda,\lambda}=1$ |
| $\hat{s}_\lambda$ in $m_\mu$ | $\hat{s}_\lambda = \sum_\mu K_{\lambda,\mu}\, m_\mu$ |
| $h_\mu$ in $\hat{s}_\lambda$ | $h_\mu = \sum_\lambda K_{\lambda,\mu}\, \hat{s}_\lambda$ |
| $h_1^n$ | $\sum_\lambda f^\lambda\, \hat{s}_\lambda$ |
| Pieri | $s_\nu \cdot e_n = \sum_\lambda s_\lambda$ con $\lambda/\nu$ striscia verticale |
| RSK ↔ trasposta | $A \mapsto (L,R) \Rightarrow A^T \mapsto (R,L)$ |
| Involuzioni | $\sum_\lambda f^\lambda = \#\{\sigma \in S_n : \sigma^2=1\}$ |
| Quadrati SYT | $\sum_\lambda (f^\lambda)^2 = n!$ |
| RSK* | biezione $(0,1)$-matrici $\leftrightarrow$ $(L,R)$ con $L'$ e $R$ SSYT |
| Identità conclusiva | $s_\lambda = \hat{s}_\lambda$ per ogni $\lambda$ |
