# Lezione 17 -- Independent Set, Vertex Cover e Clique: tre problemi NP-completi su grafi

---

## Introduzione

Questa lezione segna il passaggio dalla teoria astratta della NP-completezza alla sua applicazione concreta su problemi classici della teoria dei grafi. Dimostreremo che tre problemi fondamentali -- Independent Set, Vertex Cover e Clique -- sono tutti NP-completi. La cosa notevole e che le dimostrazioni si concatenano in modo elegante: partiamo da 3SAT per Independent Set, poi sfruttiamo due lemmi strutturali (il lemma del complemento insiemistico e il lemma del grafo complemento) per "propagare" la NP-hardness a Vertex Cover e Clique con riduzioni quasi immediate.

La catena di riduzioni che costruiremo e:

$$\text{3SAT} \leq_P \text{IS} \leq_P \text{VC}$$
$$\text{IS} \leq_P \text{CLIQUE}$$

---

## Parte I -- Independent Set

### 1. Definizione

Dato un grafo non diretto $G = (V, E)$, un **independent set** (insieme indipendente) e un sottoinsieme $S \subseteq V$ tale che nessuna coppia di nodi in $S$ sia collegata da un arco. In altre parole, i nodi di $S$ sono tutti "isolati" tra loro all'interno del grafo.

**Esempio**: nel grafo con nodi $\{1, 2, 3, 4, 5\}$ e archi $\{1,2\}, \{1,3\}, \{2,3\}, \{2,4\}, \{3,4\}, \{3,5\}$, l'insieme $S_1 = \{2, 4, 5\}$ e un independent set (nessuna coppia e collegata), cosi come $S_2 = \{1, 4, 5\}$. Invece $\{1, 3, 5\}$ non lo e, perche i nodi 1 e 3 sono collegati.

Si noti che l'insieme vuoto e banalmente un independent set, cosi come qualsiasi singoletto. La domanda interessante e quindi: quanto *grande* puo essere un independent set?

Il problema decisionale e:

$$\text{IS} = \{\langle G, k \rangle \mid G \text{ e un grafo non diretto con un independent set } S \text{ tale che } |S| \geq k\}$$

### 2. IS e in NP (Membership)

La membership in NP si dimostra con il classico schema "guess and check":

1. **Guess**: una NTM genera non deterministicamente un sottoinsieme $S \subseteq V$, decidendo per ogni nodo $v$ se includerlo o meno in $S$.
2. **Check**: verifica che $|S| \geq k$ e che per ogni coppia di nodi $u, v \in S$, l'arco $\{u, v\}$ non appartenga a $E$.

La verifica richiede al piu $O(|S|^2)$ controlli di adiacenza, dunque tempo polinomiale. Percio IS $\in$ NP.

### 3. IS e NP-hard (riduzione da 3SAT)

Questa e la riduzione piu articolata della lezione, e vale la pena capirla bene perche costituisce il fondamento su cui poggiano le altre.

#### 3.1 L'idea

Vogliamo trasformare una formula booleana $\varphi$ in 3-CNF in una coppia $\langle G, k \rangle$ tale che:

$$\varphi \text{ e soddisfacibile} \iff G \text{ ha un independent set di taglia} \geq k$$

L'intuizione chiave e che c'e un'analogia profonda tra soddisfare una formula e trovare un independent set:
- Per soddisfare una formula, dobbiamo **scegliere** quali letterali rendere veri, con il vincolo che un letterale e la sua negazione non possono essere entrambi veri.
- Per trovare un independent set, dobbiamo **scegliere** quali nodi includere, con il vincolo che due nodi collegati non possono essere entrambi nell'insieme.

#### 3.2 La costruzione

Data una formula $\varphi = C_1 \wedge C_2 \wedge \ldots \wedge C_m$ con $m$ clausole, ciascuna di esattamente 3 letterali, su variabili $x_1, \ldots, x_n$, costruiamo il grafo $G$ come segue.

**Esempio di riferimento**:

$$\varphi = (x_1 \vee x_2 \vee \neg x_3) \wedge (\neg x_2 \vee x_4 \vee x_3) \wedge (\neg x_4 \vee x_5 \vee \neg x_3)$$

**Passo 1 -- Nodi**: per ogni *occorrenza* di un letterale nella formula, creiamo un nodo. Se lo stesso letterale compare in clausole diverse, creiamo nodi distinti. Per l'esempio sopra, abbiamo 9 nodi (3 per ogni clausola), raggruppabili in tre "triangoli":
- Clausola $C_1$: nodi $x_1$, $x_2$, $\neg x_3$
- Clausola $C_2$: nodi $\neg x_2$, $x_4$, $x_3$
- Clausola $C_3$: nodi $\neg x_4$, $x_5$, $\neg x_3$

**Passo 2 -- Archi intra-clausola (triangoli)**: colleghiamo tra loro tutti e tre i nodi di ogni clausola, formando un triangolo. Questo garantisce che da ogni clausola possiamo scegliere *al piu un nodo* per l'independent set (in un triangolo, un independent set puo contenere al piu un vertice).

**Passo 3 -- Archi inter-clausola (consistenza)**: aggiungiamo un arco tra ogni coppia di nodi etichettati con letterali complementari (ad esempio tra un nodo $x_2$ di una clausola e un nodo $\neg x_2$ di un'altra clausola). Questo impedisce di selezionare simultaneamente un letterale e la sua negazione nell'independent set -- esattamente come un assegnamento di verita non puo rendere veri sia $x_i$ che $\neg x_i$.

**Passo 4 -- Soglia**: poniamo $k = m$ (il numero di clausole).

#### 3.3 Correttezza ($\Rightarrow$): da assegnamento soddisfacente a independent set

Supponiamo che esista un assegnamento $\tau$ che soddisfa $\varphi$. Allora in ogni clausola $C_j$ almeno un letterale e vero. Scegliamo uno di questi letterali veri (uno per clausola) e sia $\ell^{C_j}$ il letterale scelto per la clausola $C_j$. Definiamo:

$$S = \{v(\ell^{C_j}) \mid C_j \text{ e una clausola di } \varphi\}$$

L'insieme $S$ ha esattamente $m = k$ nodi (uno per clausola). Verifichiamo che e un independent set:

- **Archi intra-clausola**: abbiamo scelto un solo nodo per triangolo, quindi nessun arco intra-clausola collega due nodi di $S$.
- **Archi inter-clausola**: questi archi collegano nodi con letterali complementari. Ma $\tau$ e un assegnamento consistente: se $\ell^{C_i} = x_j$ (vero), allora non possiamo aver scelto $\neg x_j$ in un'altra clausola come letterale vero. Dunque nessun arco di consistenza collega due nodi di $S$.

Quindi $S$ e un independent set di taglia $k$.

#### 3.4 Correttezza ($\Leftarrow$): da independent set a assegnamento soddisfacente

Supponiamo che $G$ abbia un independent set $S$ con $|S| \geq k = m$. Poiche ogni triangolo (clausola) contribuisce al piu un nodo a $S$, e ci sono $m$ triangoli, $S$ contiene *esattamente* un nodo per triangolo.

Costruiamo l'assegnamento $\tau$:
- Per ogni nodo in $S$ etichettato $x_i$: poniamo $\tau(x_i) = \text{true}$.
- Per ogni nodo in $S$ etichettato $\neg x_i$: poniamo $\tau(x_i) = \text{false}$.
- Per le variabili restanti: assegniamo un valore arbitrario.

$\tau$ e ben definito perche $S$ non contiene nodi con letterali complementari (sarebbero collegati da un arco di consistenza). Inoltre $\tau$ soddisfa $\varphi$: per ogni clausola $C_j$, il nodo scelto in $S$ corrisponde a un letterale reso vero da $\tau$, quindi $C_j$ e soddisfatta.

#### 3.5 Complessita della riduzione

La costruzione aggiunge $3m$ nodi, 3 archi per clausola (i triangoli) e al piu un arco per ogni coppia variabile-negazione tra clausole diverse, per un totale di al piu $3m + n$ archi. Tutto polinomiale.

> **Teorema**: IS e NP-completo.

---

## Parte II -- Vertex Cover

### 4. Definizione

Dato un grafo non diretto $G = (V, E)$, un **vertex cover** e un sottoinsieme $C \subseteq V$ che "tocca" tutti gli archi del grafo: per ogni arco $\{u, v\} \in E$, almeno uno tra $u$ e $v$ appartiene a $C$.

Un vertex cover esiste sempre (basta prendere $C = V$), quindi la domanda interessante e: esiste un vertex cover di taglia *piccola*?

**Esempio pratico**: immaginiamo che gli archi del grafo rappresentino corridoi di un edificio e i nodi gli incroci. Un vertex cover e un insieme di incroci in cui posizionare telecamere di sicurezza in modo che ogni corridoio sia sorvegliato da almeno una telecamera. Vogliamo minimizzare il numero di telecamere.

Il linguaggio e:

$$\text{VC} = \{\langle G, k \rangle \mid G \text{ e un grafo non diretto con un vertex cover } C \text{ tale che } |C| \leq k\}$$

### 5. Il Lemma del Complemento: IS e VC sono due facce della stessa medaglia

Prima di dimostrare la NP-completezza di VC, stabiliamo un risultato strutturale fondamentale che lega Independent Set e Vertex Cover in modo diretto.

**Lemma (Complemento IS-VC)**: Sia $G = (V, E)$ un grafo non diretto e $S \subseteq V$ un sottoinsieme di nodi. Allora:

$$S \text{ e un independent set di } G \iff V \setminus S \text{ e un vertex cover di } G$$

In parole povere: i nodi che *non* scegli per l'independent set formano un vertex cover, e viceversa.

#### 5.1 Dimostrazione

**($\Rightarrow$)** Supponiamo che $S$ sia un independent set e, per assurdo, che $C = V \setminus S$ non sia un vertex cover. Allora esiste un arco $\{u, v\} \in E$ non coperto da $C$: ne $u$ ne $v$ stanno in $C$. Ma allora entrambi stanno in $S$, e sono collegati da un arco -- contraddicendo il fatto che $S$ e un independent set.

**($\Leftarrow$)** Supponiamo che $C = V \setminus S$ sia un vertex cover e, per assurdo, che $S$ non sia un independent set. Allora esistono $u, v \in S$ con $\{u, v\} \in E$. Ma se $u, v \in S$, allora $u, v \notin C$, il che significa che l'arco $\{u, v\}$ non e coperto da $C$ -- contraddicendo il fatto che $C$ e un vertex cover.

#### 5.2 Conseguenza

Il lemma ci dice che se un grafo con $|V|$ nodi ha un independent set di taglia $k$, allora ha un vertex cover di taglia $|V| - k$, e viceversa. Questa e una corrispondenza biunivoca perfetta.

### 6. VC e NP-completo

#### 6.1 Membership in NP

Una NTM genera non deterministicamente un sottoinsieme $C \subseteq V$, poi verifica che $|C| \leq k$ e che ogni arco $\{u,v\} \in E$ abbia almeno un estremo in $C$. Il controllo richiede tempo $O(|E| \cdot |C|)$, polinomiale.

#### 6.2 NP-hardness: riduzione IS $\leq_P$ VC

Grazie al Lemma del Complemento, la riduzione e sorprendentemente semplice. Data un'istanza $\langle G, k \rangle$ di IS, costruiamo l'istanza $\langle H, \ell \rangle$ di VC ponendo:

$$H = G, \quad \ell = |V| - k$$

**Correttezza**: 

$\langle G, k \rangle \in \text{IS}$ significa che $G$ ha un independent set $S$ con $|S| \geq k$. Per il Lemma, $V \setminus S$ e un vertex cover con $|V \setminus S| = |V| - |S| \leq |V| - k = \ell$. Dunque $\langle H, \ell \rangle \in \text{VC}$.

Viceversa, $\langle H, \ell \rangle \in \text{VC}$ significa che $G$ ha un vertex cover $C$ con $|C| \leq \ell = |V| - k$. Per il Lemma, $S = V \setminus C$ e un independent set con $|S| = |V| - |C| \geq |V| - (|V| - k) = k$. Dunque $\langle G, k \rangle \in \text{IS}$.

La riduzione e banalmente polinomiale (non modifica nemmeno il grafo, cambia solo il parametro).

> **Teorema**: VERTEX COVER e NP-completo.

---

## Parte III -- Clique

### 7. Definizione

Dato un grafo non diretto $G = (V, E)$, una **clique** e un sottoinsieme $C \subseteq V$ in cui *ogni* coppia di nodi distinti e collegata da un arco: per ogni $u, v \in C$ con $u \neq v$, si ha $\{u, v\} \in E$. In altre parole, una clique e un sottografo completo.

**Esempio**: se i nodi rappresentano persone e gli archi amicizie, una clique e un gruppo di persone che si conoscono *tutte* tra loro -- un gruppo di amici stretti.

**Esempio numerico**: nel grafo con nodi $\{1,2,3,4,5\}$ e archi $\{1,2\}, \{1,3\}, \{1,4\}, \{2,3\}, \{2,4\}, \{3,4\}, \{3,5\}$, l'insieme $C_1 = \{1,2,4\}$ e una clique (tutti collegati tra loro), cosi come $C_2 = \{2,3,4\}$. Invece $\{1,2,3,4\}$ non e una clique perche i nodi 1 e 3... no, in questo caso sono collegati. Bisogna verificare caso per caso.

Il linguaggio e:

$$\text{CLIQUE} = \{\langle G, k \rangle \mid G \text{ e un grafo non diretto con una clique } C \text{ tale che } |C| \geq k\}$$

### 8. Il Lemma del Grafo Complemento: IS e Clique sono la stessa cosa "capovolta"

**Definizione (Grafo complemento)**: Dato un grafo $G = (V, E)$, il suo **complemento** $\bar{G} = (V, \bar{E})$ e il grafo sugli stessi nodi in cui:

$$\bar{E} = \{\{u, v\} \mid u, v \in V, u \neq v, \{u, v\} \notin E\}$$

In pratica, $\bar{G}$ ha un arco esattamente dove $G$ non ce l'ha, e viceversa.

**Lemma (Complemento IS-Clique)**: Sia $G = (V, E)$ un grafo e $S \subseteq V$. Allora:

$$S \text{ e un independent set di } G \iff S \text{ e una clique di } \bar{G}$$

#### 8.1 Dimostrazione

La dimostrazione e quasi immediata:

**($\Rightarrow$)** Se $S$ e un IS di $G$, allora per ogni $u, v \in S$ non esiste l'arco $\{u, v\}$ in $E$. Ma allora, per definizione di complemento, $\{u, v\} \in \bar{E}$. Ogni coppia di nodi in $S$ e collegata in $\bar{G}$: $S$ e una clique di $\bar{G}$.

**($\Leftarrow$)** Se $S$ e una clique di $\bar{G}$, allora per ogni $u, v \in S$ si ha $\{u, v\} \in \bar{E}$, cioe $\{u, v\} \notin E$. Nessuna coppia di nodi in $S$ e collegata in $G$: $S$ e un IS di $G$.

### 9. CLIQUE e NP-completo

#### 9.1 Membership in NP

Una NTM genera un sottoinsieme $C \subseteq V$ e verifica che $|C| \geq k$ e che ogni coppia di nodi in $C$ sia collegata. Tempo: $O(|C|^2 \cdot |E|)$, polinomiale.

#### 9.2 NP-hardness: riduzione IS $\leq_P$ CLIQUE

Anche qui, grazie al lemma, la riduzione e immediata. Data un'istanza $\langle G, k \rangle$ di IS, costruiamo:

$$H = \bar{G}, \quad \ell = k$$

**Correttezza**: 

$\langle G, k \rangle \in \text{IS}$ significa che $G$ ha un IS $S$ con $|S| \geq k$. Per il Lemma, $S$ e una clique di $\bar{G} = H$ con $|S| \geq k = \ell$. Dunque $\langle H, \ell \rangle \in \text{CLIQUE}$.

Viceversa, $\langle H, \ell \rangle \in \text{CLIQUE}$ significa che $\bar{G}$ ha una clique $C$ con $|C| \geq \ell = k$. Per il Lemma, $C$ e un IS di $G$ con $|C| \geq k$. Dunque $\langle G, k \rangle \in \text{IS}$.

La costruzione di $\bar{G}$ richiede tempo $O(|V|^2)$ (bisogna "invertire" la matrice di adiacenza), dunque e polinomiale.

> **Teorema**: CLIQUE e NP-completo.

---

## La visione d'insieme: la catena delle riduzioni

Dopo questa lezione, il nostro catalogo di problemi NP-completi si arricchisce notevolmente, e le riduzioni formano una rete elegante:

```
             SAT (Cook-Levin)
              |
            3SAT
           /    
         IS      (altri problemi...)
        /  \
      VC    CLIQUE
```

Un aspetto molto istruttivo e il ruolo dei lemmi strutturali. Le riduzioni da IS a VC e da IS a CLIQUE non richiedono costruzioni ingegnose: si basano su proprieta matematiche dei grafi (il complemento insiemistico e il grafo complemento) che trasformano un tipo di struttura in un altro in modo diretto. La riduzione "difficile" e quella da 3SAT a IS, dove bisogna codificare la struttura logica di una formula booleana nella struttura combinatoria di un grafo.

Questo illustra un principio generale della teoria della complessita: una volta che si ha un problema NP-completo, spesso e possibile dimostrare la NP-completezza di problemi "vicini" con riduzioni relativamente semplici, sfruttando relazioni strutturali tra i problemi.

### Riepilogo dei tre problemi

| Problema | Domanda | Riduzione da | Strumento chiave |
|---|---|---|---|
| **Independent Set** | Esiste un IS di taglia $\geq k$? | 3SAT | Triangoli per clausole + archi di consistenza |
| **Vertex Cover** | Esiste un VC di taglia $\leq k$? | IS | Lemma: $S$ e IS $\iff$ $V \setminus S$ e VC |
| **Clique** | Esiste una clique di taglia $\geq k$? | IS | Lemma: $S$ e IS in $G$ $\iff$ $S$ e clique in $\bar{G}$ |
