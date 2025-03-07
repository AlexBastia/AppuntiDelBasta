## Richiami di teoria degli insiemi
| Simboli| Descrizione |
| --- | --- |
|\(\Omega\)|Insieme di riferimento|
|\(\omega \in \Omega\)|elemento dell'insieme \(\Omega\)|
|\(A \subset \Omega\)|\(A\) sottoinsieme di \(\Omega\). Da notare \(\emptyset \subset \Omega, \Omega \subset \Omega\)|
|\(\mathcal{P}(\Omega)\)|**insieme delle parti di \(\Omega\)**, insieme contenente tutti i sottoinsiemi di \(\Omega\). \(\forall A. A \subset \Omega \Rightarrow A \in \mathcal{P}\)|
|\(\| A \| \) (o \(\# A \))| **cardinalita` di \(A\)**: numero di elementi dell'insieme finito \(A\)|

| Operazioni| Nome| Descrizione dati \(A, B \in \Omega\) |
| --- | --- | --- |
|\(A \cup B\)| \(A\) unito a \(B\)|\( \{ \omega \in \Omega : \omega \in A \lor \omega \in B \} \) |
|\(A \cap B\)|\(A\) intersecato a \(B\) |\( \{ \omega \in \Omega : \omega \in A \land \omega \in B \} \) |
|\(B \backslash A \)| \(B\) meno \(A\)  |\( \{ \omega \in \Omega : \omega \in B \land \omega \not \in A \} \)|
|\( A^c \) | complementare di \(A\)| \( \Omega \backslash A = \{ \omega \in \Omega : \omega \not \in A \}\)| 

### Conseguenze:

#### Cardinalita` dell'insieme delle parti:
dato un insieme \(\Omega\) di cardinalita\` \(|\Omega|\), la cardinalita\` del suo insieme delle parti \(|\mathcal{P}(\Omega)|\) sara\` uguale a \(2^{|\Omega|}\)
Dimostrazione:
sia \(\Omega\) un insieme. Dimostro per induzione sulla sua cardinalita\`
- caso \(|\Omega| = 0\):
    - allora \(\Omega = {\emptyset}\)
    - \(\mathcal{P}(\Omega) = \{\emptyset\}\)
    - \(|\mathcal{P}(\Omega)| = 1 = 2^0 = 2^{|\Omega|}\)
- caso \(|\Omega ^{n+1}| = n + 1\)
    - per induzione so che \(|\mathcal{P}(\Omega ^{n})| = 2^{n} \) 
    - \(\mathcal{P}(\Omega ^{n+1}) \backslash \mathcal{P}(\Omega ^{n})\) contiene tutti i sottoinsiemi di \(\mathcal{P}(\Omega ^{n})\) con l'elemento \(\omega _{n+1}\) concatenato ad essi, quindi tanti elementi quanti ne conteneva l'insieme \(\mathcal{P}(\Omega ^{n})\), ossia \(2^n\)
    - \(|\mathcal{P}(\Omega ^{n+1})| = |\mathcal{P}(\Omega ^{n+1}) \backslash \mathcal{P}(\Omega ^{n})| + |\mathcal{P}(\Omega ^{n})| = 2^n + 2^n = 2*2^n = 2^{n+1}\)

*q.e.d.*

#### Leggi di De Morgan
- \( (A \cap B)^c = A^c \cup B^c \)
- \( (A \cup B)^c = A^c \cap B^c \)

    -Dimostrazione:
    Si mostra che vale \( \left\{ \begin{array}{rcl}  (A \cap B)^c \subseteq A^c \cup B^c \\ (A \cap B)^c \supseteq A^c \cup B^c \end{array}\right.\)
    Ovvero che \( \omega \in (A \cap B)^c \Rightarrow \omega \in ( A^c \cup B^c)\)
    - \( w \in (A \cap B)^c \iff w \not \in A \cap B \iff w \not \in A \lor w \not \in B \iff w \in A^c \lor w \in B^c \iff w \in A^c \cup B^c \)
    (dimostrazione della seconda molto simile alla prima)

*q.e.d.* 

### Proprieta` distributiva
- \( A \cup (B \cap C) = (A \cup B) \cap (A \cap C) \), generalizzato a n insiemi: \[ A \cup (\bigcap_{i=1}^{n}B_i) = \bigcap_{i=1}^{n}(A \cup B_i)\]
- \( A \cap (B \cup C) = (A \cap B) \cup (A \cap C) \), generalizzato a n insiemi: \[ A \cap (\bigcup_{i=1}^{n}B_i) = \bigcup_{i=1}^{n}(A \cap B_i)\]

### Intersezione e unione numerabile
\((A_i)_{i \in \mathbb{N}} \) successione di insiemi
\[ \bigcup_{i=1}^{+ \infty} A_i = \{ \omega \in \Omega : \exists i \in \mathbb{N} . \omega \in A_i \} \quad \text{(\(\omega\) appartiene ad almeno un \(A_i\))} \]
\[ \bigcap_{i=1}^{+ \infty} A_i = \{ \omega \in \Omega : \forall i \in \mathbb{N} . \omega \in A_i \} \quad \text{(\(\omega\) appartiene a tutti gli \(A_i\))} \]

#### Leggi di de Morgan per unioni e intersezioni infinite:
\[ \left( \bigcup_{n=1}^{\infty}A_n \right)^c = \bigcap_{n=1}^{\infty}A_n^c \quad \quad \quad \quad \left( \bigcap_{n=1}^{\infty}A_n \right)^c = \bigcup_{n=1}^{\infty}A_n^c\]


## Modello probabilistico di un esperimento aleatorio
Introduco tre concetti primitivi:
1. **Esperimento aleatorio:**
    : Un **esperimento aleatorio** (detto anche **fenomeno aleatorio** o **prova** o **situazione di incertezza**) e` un esperimento di cui non si conosce con certezza il risultato
2. **Esito:**
    : Ipotetico risultato dell'esperimento aleatorio
3. **Probabilita`:**
    : E` una **quantificaione o misura dell'incertezza**: in matematica si attribuisce il valore numerico 1 a una proposizione sicuramente vera e 0 a una sicuramente falsa

> *Osservazione:*
Un esperimento aleatorio puo\` essere spesso suddiviso in diverse fasi chiamate **sotto-esperimenti aleatori**. Ad esempio, il lancio di due dadi e\` composto da due sotto-esperimenti aleatori.

- **Evento:**
    : Un **evento** e\` un'affermazione riguardante l'esperimento aleatorio, di cui e\` possibile dire con certezza se e\` vera oppure falsa solo una volta noto l'esito.
    Gli esiti per cui un evento e\` vero si chiamano **casi favorevoli** (per tale evento) e gli altri si chiamano **casi contrari**.
    *Esempio:* Si lancia un dado. l'affermazione *A = "esce un numero pari"* e\` un evento. 2, 4, 6 sono casi favorevoli ad A, 1, 3, 5 sono casi contrari.
- **Spazio campionario:**
    : Si chiama **spazio campionario** (indicato con \(\Omega\)) un qualunque insieme che contiene tutti i possibili esiti dell'esp. aleatorio, rappresentati con un opportuno codice.
- **Eventi in \(\Omega\):**
    : Ogni **evento**, inteso come affermazione, e\` rappresentato dal **sottoinsieme di \(\Omega\) costituito dai casi favorevoli ad esso** (\(\emptyset\) se e\` sempre falso).
    Ogni sottoinsieme di \( \Omega \) puo\` essere quindi chiamato **evento**.

**Eventi particolari:**

| Sottoinsieme di \(\Omega\) | Tipo di evento |
| --- | --- |
| \(\Omega\) | **Evento certo**, verificato per ogni esito |
| \(\emptyset\) | **Evento impossibile**, falso per ogni esito |
| \(A = \{\omega\}\) | **Evento elementare**, vero per un solo esito |

**Relazioni tra operazioni su affermazioni e su insiemi:**

|Connettivi logici|Operazioni insiemistiche|
| --- | --- |
| \(A \lor B\) | \(A \cup B\)|
| \(A \land B\) | \(A \cap B\)|
|\(\neg A\)| \(A^c\)|
|\(A \implies B\)|\(A \subset B\)|
|\(A \iff B\)|\(A = B\)|

La chiave per capire queste relazioni e\` pensare alla definizione di evnti in \(\Omega\) appena data: se ad esempio prendo due eventi A e B e voglio fare un or logico tra di loro, sto dicendo per definizione dell'or che sono interessato agli elementi che appartengono ad almeno uno dei due eventi (o insiemi di esiti). quindi per definizione dell'unione quello che sto cercando non e\` altro che \(A \cup B\) !

### Assiomi della probabilita\`:

- Assioma 1:
    : A ciascun sottoinsieme (o evento) \(A\) di \(\Omega\) e\` assegnato un numero \(\mathbb{P}(A)\) che verifica \(\quad \mathbb{P}(A) \in [0, 1] \quad\) ossia \(\quad 0 \leq \mathbb{P}(A) \leq 1\)
- Assioma 2:
    : \(\mathbb{P}(\Omega) = 1 \)
- Assioma 3:
    : Vale la proprieta\` di **additivita\` numerabile**, o **\(\sigma\)-additivita\`**. Sia \(A_{n \in \mathbb{N}}. \quad A_i \cap A_j = \emptyset \quad \forall i\neq j \) cioe\` una successione di sottoinsiemi di \(\Omega\) tra loro disgiunti e sia \[ A = \bigcup_{n=1}^{+\infty}A_n.\]
    Allora: \[\mathbb{P}(A) = \sum_{n=1}^{+\infty}\mathbb{P}(A_n).\]

La probabilita\`   \(\mathbb{P}\) e\` quindi una funzione che fa corrispondere ad ogni sottoinsieme \(A\) di \(\Omega\) un numero in [0, 1]:
\[\mathbb{P}: \mathcal{P}(\Omega) \rightarrow [0, 1]\]
\[A \in \mathcal{P}(\Omega) \mapsto \mathbb{P}(A)\]
dove \(\mathcal{P}(\Omega)\) e\` l'insieme delle parti di \(\Omega\) e rappresenta il dominio della funzione \(\mathbb{P}\) con codominio nell'intervallo [0, 1].

- **Probabilita\` discreta**:
    : Si dice **probabilita\` discreta** una funzione \(\mathbb{P}\) come sopra che assume un numero finito o al piu\` un insieme di cardinalita\` numerabile di valori
- **Probabilita\` uniforme**:
    : Si dice **probabilita\` uniforme** la probabilita\` \(\mathbb{P}\) di un evento in un insieme \(\Omega\) finito, con esiti *equiprobabili*, ed e\` uguale a 1/N, dove N e\` il numero di elementi di \(\Omega\). 
- **Evento quasi certo**:
    : Si dice **evento quasi certo** un evento \(A\) tale che \(\mathbb{P}(A)=1\)
- **Evento quasi impossibile**:
    : Si dice **evento quasi impossibile** un evento \(A\) tale che \(\mathbb{P}(A)=0\)
#### Conseguenze degli assiomi:
1. \(\mathbb{P}(\emptyset)=0\).
2. **Additivita\` finita**: Se \(A\) e \(B\) sono disgiunti allora \[ \mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B)\] o per \(A_1, A_2, \ldots A_n\) insiemi disgiunti \[\mathbb{P}(A_1 \cup \cdots \cup A_n) = \sum_{i=1}^n \mathbb{P}(A_i)\]
3. \(\mathbb{P}(A^c)= 1 - \mathbb{P}(A)\)
4. **Monotonia**: se \( A \subset B\), allora \(\mathbb{P}(A)\leq \mathbb{P}(B)\)
##### Dimostrazioni:
1. Devo dimostrare che \(\mathbb{P}(\emptyset)=0 \) che per semplicita\` di notazione definisco \(p = \mathbb{P}(\emptyset)\). 
Utilizzo la proprieta\` di *additivita\` numerabile*, prendendo come successione di insiemi \(A_{n \in \mathbb{N}}\) un gruppo di insiemi vuoti \(A_n = \emptyset \). 
Tali insiemi verificano la condizione richiesta della disgiunzione, in quanto ovviamente non hanno elementi in comune. si ha quindi che:
\[ A = \bigcup_{n=1}^{\infty}A_n = \emptyset \cup \emptyset \cup \emptyset \ldots = \emptyset \quad \text{da cui segue} \quad \mathbb{P}(A) = \sum_{n=1}^{\infty} \mathbb{P}(A_n)  \quad \text{quindi } A = \emptyset \Rightarrow p = \mathbb{P}(\emptyset) = \mathbb{P}(A) = \mathbb{P}(A_n) \Rightarrow p = \sum_{n=1}^{\infty} p\]
Dato che \(p\) e\` una probabilita\` e quindi un numero compreso tra 0 e 1, posso dire con certezza che l'equazione e\` verificata solo per 0. Infatti:
\[\sum_{n=1}^{\infty} p = \left\{ \begin{array}{rcl} 0, & \text{ se } p = 0 \\ +\infty, & \text{ se } 0 < p \leq 1 \end{array}\right. \]
e il primo termine e\` \(p\), quindi e\` uguale a 0 solo quando lo e\` \(p. \quad \quad \quad q.e.d.\)

2. Dimostro il caso per due insiemi disgiunti \(A\) e \(B\) tramite l'*additivita\` numerabile* scegliendo come successione 
\(A_{n \in \mathbb{N}}:= \quad A_1 = A, A_2 = B, A_n = \emptyset \quad \forall n \geq 3\). 
Tali insiemi sono tutti disgiunti, quindi vale:
\[ A \cup B = \bigcup_{n=1}^\infty A_n \Rightarrow \mathbb{P}(A \cup B) = \sum_{n=1}^\infty \mathbb{P}(A_n) = \mathbb{P}(A) + \mathbb{P}(B) + \mathbb{P}((A_n. \forall n \geq 3) = \emptyset) \]
Ho quindi \(\mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B) + \mathbb{P}(\emptyset) = \mathbb{P}(A) + \mathbb{P}(B) + 0 \quad \quad \quad q.e.d. \)

3. Per dimostrare \(\mathbb{P}(A^c)= 1 - \mathbb{P}(A)\) uso l'*additivita\` finita* appena dimostrata, con \( A = A, B = A^c\). 
I due insiemi sono disgiunti per definizione, inoltre \(A \cup A^c = \Omega\). 
Per l'additivita\` finita so quindi che \(\mathbb{P}(\Omega) = \mathbb{P}(A) + \mathbb{P}(A^c)\) e per l'assioma 2 \(\mathbb{P}(\Omega) = 1\). 
Quindi \(\mathbb{P}(A) + \mathbb{P}(A^c) = 1 \quad \mathbb{P}(A^c)=1 - \mathbb{P}(A) \quad\quad\quad  q.e.d.\)

4. Sapendo che \(A \subset B\) posso scrivere \(B\) come \(A \cup B\backslash A \), che sono due insiemi disgiunti. Quindi, per l'*additivita\` finita* 
\[\mathbb{P}(B) = \mathbb{P}(A \cup B\backslash A) = \mathbb{P}(A) + \mathbb{P}(B\backslash A) \geq \mathbb{P}(A) \] \(q.e.d.\)

#### Formula di Laplace:
Dato un esperimento aleatorio in cui vale la probabilita\` uniforme \(\left(\Omega = \{ \omega_1, \ldots, \omega_N\}, \quad \mathbb{P}(\{\omega_1\}) = \mathbb{P}(\{\omega_2\}) = \cdots = \mathbb{P}(\{\omega_N\})= \frac{1}{N}; \right)\). 
Preso un qualunque evento \(A \subset \Omega\), vale la **formula di Laplace**: \[\mathbb{P}(A) = \frac{n^o \text{ di eventi elementari che compongono }A}{N} = \frac{\text{\bf{casi favorevoli}}}{\text{\bf{casi possibili}}}\]

#### Unione di due eventi qualsiasi:
Abbiamo visto nell'additivita\` finita che la probabilita\` dell'unione di due eventi **disgiunti** e\` uguale alla somma delle probabilita\` dei due eventi; se invece gli eventi non sono disgiunti si ha:
\[ \mathbb{P}(A \cup B) = \mathbb{P}(A) + \mathbb{P}(B) - \mathbb{P}(A\cap B) \]

##### Dimostrazione (IGNORARE, NON SERVE):
Voglio dimostrare innanzitutto che \(A\) sia l'unione di due insiemi disgiunti \(A\backslash B\) e \(A \cap B\) \(\forall A, B.\)
Devo dimostrare che \(\forall A, B. (A = (A\backslash B) \cup (A \cap B))  \) 
Siano \(A\) e \(B\) insiemi. 
Per l'assioma di estensionalita\` mi riduco a dimostrare \( a \in A \iff a \in ((A\backslash B) \cup (A \cap B))  \) 
Per la definizione di Unione ho \( (A\backslash B) \cup (A\cap B) \iff a \in A\backslash B \lor a \in A\cap B\) (H1)
Dalla definizione di sottrazione di insiemi e H1 ho  \( a \in ( (A\backslash B) \cup (A\cap B)) \iff (a \in A \land a \not \in B) \lor a \in A\cap B\)
Dalla definizione di intersezione e H2 ho \( a \in ( (A\backslash B) \cup (A\cap B)) \iff (a \in A \land a \not \in B) \lor a \in A\land a \in B\); (H3)
Per la proprieta\` distributiva dell'or ho \( a \in ( (A\backslash B) \cup (A\cap B)) \iff a \in A \land (\lnot(a \in B) \lor a \in B)\) (H4)
Per EM ho \(\Vdash \lnot (a \in B) \lor (a \in B) \) (HH)
per HH, H4, introduzione dell'and da destra ho \( a \in ( (A\backslash B) \cup (A\cap B)) \iff a \in A\) (H5)
per H5, assioma di estensionalita\` mi riduco a dimostrare \(a \in A \iff a \in A\)
\(q.e.d.\)

Devo ora dimostrare la disgiunzione di questi due insiemi, quindi che \(\forall A, B. a\in A\Rightarrow (a\in A\backslash B \iff \lnot (a \in A\cap B))\)
Siano \(A, B\) insiemi e sia \(a \in A\) (I).
Dalla definizione di sottrazione di insiemi e di intersezione ho \( a \in A \backslash B \iff a \in A \land \lnot (a\in B)\) (H1) e \(a \in A\cap B \iff a \in A \land a \in B\) (H2)
da H1, H2 mi riduco a dimostrare \((a \in A \land \lnot (a \in B)) \iff \lnot (a \in A \land a \in B) \)

LR: \((a \in A \land \lnot (a \in B)) \Rightarrow \lnot (a \in A \land a \in B) \)
per l'introduzione dell'and assumo \((\lnot(a \in B))\) (LH1)
devo dimostrare \(\lnot ( a \in A \land a \in B)\), per l'introduzione del not assumo \(a \in B\) (LH2) e dimostro bottom.
da LH1 e LH2 ho dimostrato il falso, quindi per assurdo fatto.

RL: \(\lnot (a \in A \land a \in B) \Rightarrow (a \in A \land \lnot (a \in B))\)
assumo \(\lnot (a \in A \land a \in B)\), ossia per De Morgan \( (\lnot(a \in A) \lor \lnot(a \in B))\) (RH1)
devo dimostrare \((a \in A \land \lnot (a \in B))\).
dimostro per casi su RH1:
caso \(\lnot (a \in A)\) (RHH1):
per RHH1, I, ho dimostrato il falso, quindi per assurdo fatto.
caso \(\lnot(a\in B)\) (RHH2):
per I, RHH2, definizione dell'and fatto.
\(q.e.d.\)

Partendo da cio\` che ho appena dimostrato (II), dimostro ora la stessa cosa per  \(\forall A, B. (A \cup B = (A\backslash B) \cup (A \cap B) \cup (B\backslash A))\) 
devo quindi dimostrare che \(\forall A, B. (a\in A \lor a\in B) \iff (a\in A \land \lnot (a\in B) \lor (a\in A \land a\in B) \lor (\lnot(a\in A) \land a\in B))\)
siano \(A, B\) insiemi.
LR: suppongo \(a\in A \lor a\in B\)
il caso \(a\in A\) e\` dimostrato per II. il caso \(a\in B\) e\` dimostrato scegliendo \(B\) come primo insieme della proposizione II, con il secondo e terzo membro dell'or da dimostrare.
RK: suppongo \((a\in A \land \lnot (a\in B) \lor (a\in A \land a\in B) \lor (\lnot(a\in A) \land a\in B))\)
caso 1 e caso 2 sono dimostrati per II, il caso 3 si dimostra usando II con B come sopra nella LR.
\(q.e.d.\)

Sempre partendo da II, dimostro che \((A\backslash B), (A \cap B), (B\backslash A)\) sono insiemi indipendenti. Per II, so che i primi due lo sono e che la loro Unione e\` \(A\), quindi e\` sufficiente dimostrare che \(\forall A, B. a\in A\cup B \Rightarrow (a \in A \iff \lnot (a \in B\backslash A))\)
Siano \(A, B\) insiemi e sia \(a\in A \lor a\in B\) (H).
Per definizione della sottrazione tra insiemi mi riduco a dimostrare \(a \in A \iff \lnot (a \in B\land \lnot (a\in A))\)
LR: suppongo \(a \in A\) (L) per l'introduzione del not suppongo \(a\in B\) (L2) e \(\lnot (a\in A)\) (L3) e dimostro Bottom. Da L e L3 ho dimostrato il falso. fatto.
RL: suppongo \(\lnot (a \in B\land \lnot (a\in A))\) (R) e dimostro \(a\in A\) per casi su H. Il caso \(a\in A\) e\` dimostrato per identita\`. Il caso \(a\in B\) (VEL2) si dimostra per casi sull'EM assumendo \(a\in A\lor \lnot (a\in A)\). il caso \(a\in A\) e\` dimostrato, nel caso \(\lnot (a\in A)\), per conj e VEL2 ho \(a\in B\land \lnot (a\in A)\) che con R mi permette di dimostrare il falso. 
\(q.e.d.\)

Dalla proprieta\` dell'**additivita\` finita** so che, avendo provato che l'unione di due insiemi qualsiasi \(A\) e \(B\) e\` formata da tre insiemi disgiunti \(A\backslash B, A\cap B, B\backslash A\) la probabiilita\` della loro unione e\` la somma delle probabilita\` di questi tre, ho \(\mathbb{P}(A\cup B) = \mathbb{P}(A\backslash B) + \mathbb{P}(A\cap B) + \mathbb{P}(B\backslash A) \) e sapendo adesso anche che un insieme e\` formato dall'unione della sua intersezione con un qualsiasi altro e la sottrazione con quest'ultimo, anch'essi disgiunti:
\(\mathbb{P}(A) = \mathbb{P}(A\backslash B) + \mathbb{P}(A\cap B) \Rightarrow \mathbb{P}(A\backslash B) = \mathbb{P}(A) - \mathbb{P}(A\cap B)\) da cui la precedente formula diventa
\[\mathbb{P}(A\cup B) = \mathbb{P}(A) - \mathbb{P}(A\cap B) + \mathbb{P}(A\cap B) + \mathbb{P}(B) - \mathbb{P}(A\cap B)\]
sempificando algebricamente, ho trovato la formula originale. \(q.e.d.\) [^1]

[^1]: Alla faccia di coloro che ci considerano inferiori ai matematici e omettono anche dimostrazioni normali, questo e\` un inno al sommo CSC