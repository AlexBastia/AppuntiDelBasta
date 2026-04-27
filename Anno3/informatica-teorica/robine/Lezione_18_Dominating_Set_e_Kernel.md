# Lezione 18 -- Dominating Set e Kernel: due problemi NP-completi su grafi

---

## Premessa: il meccanismo delle riduzioni polinomiali

Prima di addentrarci nei due problemi protagonisti di questa lezione, richiamiamo brevemente lo schema generale che seguiamo ogni volta che vogliamo dimostrare che un linguaggio $\mathcal{L}$ e NP-completo. Servono due ingredienti:

1. **Membership in NP** -- mostrare che esiste un verificatore (o, equivalentemente, una macchina di Turing non deterministica) che decide $\mathcal{L}$ in tempo polinomiale.
2. **NP-hardness** -- esibire una riduzione polinomiale $\mathcal{L}' \leq_P \mathcal{L}$ da un problema $\mathcal{L}'$ gia noto essere NP-hard. In questo modo, per transitivita delle riduzioni, *ogni* linguaggio in NP si riduce a $\mathcal{L}$.

I problemi che useremo come "punto di partenza" per le riduzioni sono **Vertex Cover** (per Dominating Set) e **3SAT** (per Kernel).

---

## Parte I -- Dominating Set

### 1. Definizione informale

Consideriamo un grafo non diretto $G = (V, E)$. Immaginiamo di dover posizionare delle "sentinelle" sui nodi del grafo in modo tale che ogni nodo del grafo sia sorvegliato: un nodo e sorvegliato se ospita una sentinella oppure se almeno uno dei suoi vicini ne ospita una. Un insieme di nodi che soddisfa questa proprieta prende il nome di **dominating set** (insieme dominante).

### 2. Definizione formale

Dato un grafo non diretto $G = (V, E)$, un sottoinsieme $D \subseteq V$ e un **dominating set** se per ogni nodo $v \in V \setminus D$ esiste un nodo $u \in D$ tale che $\{u, v\} \in E$.

In altre parole: ogni nodo del grafo o appartiene a $D$, oppure e adiacente ad almeno un nodo di $D$.

Il problema decisionale che ci interessa e:

> **DOMINATING SET**: dato un grafo non diretto $G$ e un intero $k$, $G$ ammette un dominating set di taglia al piu $k$?

Come linguaggio:

$$\text{DS} = \{\langle G, k \rangle \mid G \text{ e un grafo non diretto con un dominating set } D \text{ tale che } |D| \leq k\}$$

### 3. Differenza con Vertex Cover

E importante non confondere il dominating set con il vertex cover, anche se i due concetti sono "cugini":

| | **Vertex Cover** | **Dominating Set** |
|---|---|---|
| **Cosa deve essere coperto** | Ogni *arco* del grafo | Ogni *nodo* del grafo |
| **Condizione** | Per ogni arco $\{u,v\} \in E$, almeno uno tra $u$ e $v$ e nel cover | Per ogni nodo $v \notin D$, esiste un vicino $u \in D$ |

Un vertex cover e sempre un dominating set (in grafi senza nodi isolati), perche se tocca tutti gli archi e non ci sono nodi isolati, allora ogni nodo e raggiunto. Il viceversa, pero, non vale: un dominating set puo "saltare" un arco intero, purche entrambi gli estremi siano dominati da qualche altro nodo.

**Esempio**: si consideri un grafo formato da un triangolo collegato ad un nodo esterno tramite un arco. I due nodi rossi (il nodo centrale del triangolo e il nodo esterno) formano un dominating set ma *non* un vertex cover, perche l'arco tra i due nodi restanti del triangolo non e coperto.

### 4. DS e in NP (Membership)

Per mostrare che DS $\in$ NP, costruiamo un verificatore non deterministico:

1. **Guess**: genera non deterministicamente un sottoinsieme $D \subseteq V$.
2. **Verifica**: controlla che $|D| \leq k$ e che per ogni nodo $v \in V \setminus D$ esista almeno un nodo $u \in D$ con $\{u,v\} \in E$.

La fase di verifica richiede, per ogni nodo $v \notin D$, di scorrere i nodi in $D$ e controllare l'adiacenza: il costo e $O(|V| \cdot |D| \cdot |E|) = O(|V|^2 \cdot |E|)$, che e polinomiale. Dunque DS $\in$ NP.

### 5. DS e NP-hard (riduzione da Vertex Cover)

Vogliamo mostrare che VC $\leq_P$ DS, cioe che il problema del Vertex Cover si riduce polinomialmente a Dominating Set. Poiche sappiamo gia che VC e NP-completo, questo implicara che anche DS e NP-hard.

#### 5.1 Idea della riduzione

Data un'istanza $\langle G, k \rangle$ di Vertex Cover, dobbiamo costruire in tempo polinomiale un'istanza $\langle H, \ell \rangle$ di Dominating Set tale che:

$$G \text{ ha un vertex cover di taglia} \leq k \iff H \text{ ha un dominating set di taglia} \leq \ell$$

Il trucco e il seguente:

1. **Rimuovere i nodi isolati** da $G$. Un nodo isolato non ha archi incidenti, quindi non influenza il vertex cover; possiamo ignorarlo.

2. **Trasformare ogni arco in un triangolo**: per ogni arco $e = \{u, v\} \in E$, creiamo un nuovo nodo speciale $v_e$ e lo colleghiamo sia a $u$ che a $v$ (ma a nient'altro). Si ottiene cosi un grafo $H$.

3. **Porre $\ell = k$**: la soglia resta invariata.

#### 5.2 Perche funziona (direzione $\Rightarrow$)

Supponiamo che $G$ abbia un vertex cover $C$ con $|C| \leq k$. Mostriamo che $C$ e anche un dominating set di $H$.

- Ogni nodo originale $v \in V$: se $v \in C$ e gia dominato; se $v \notin C$, dato che $G$ non ha nodi isolati, $v$ ha almeno un vicino, e quell'arco deve essere coperto dal cover, quindi almeno un vicino di $v$ sta in $C$, e percio $v$ e dominato.
- Ogni nodo speciale $v_e$ (aggiunto per l'arco $e = \{u,v\}$): per definizione di vertex cover, almeno uno tra $u$ e $v$ sta in $C$. Quel nodo e adiacente a $v_e$ in $H$, quindi $v_e$ e dominato.

Dunque $C$ e un dominating set di $H$ con $|C| \leq k = \ell$.

#### 5.3 Perche funziona (direzione $\Leftarrow$)

Supponiamo che $H$ abbia un dominating set $D$ con $|D| \leq \ell = k$. Osserviamo che se $D$ contiene un nodo speciale $v_e$ (creato per l'arco $e = \{u,v\}$), possiamo sostituirlo con uno degli estremi $u$ o $v$: il nodo speciale $v_e$ e collegato solo a $u$ e $v$, quindi dominava al piu loro, ma $u$ (o $v$) domina $v_e$ stesso e tutti i propri vicini originali. La taglia non aumenta.

Dopo questa sostituzione, $D$ contiene solo nodi originali di $G$. Ora, $D$ deve dominare *tutti* i nodi speciali $v_e$. L'unico modo per dominare $v_e$ e avere in $D$ almeno uno tra $u$ e $v$, cioe almeno un estremo di ogni arco. Ma questa e esattamente la definizione di vertex cover.

Dunque $D$ e un vertex cover di $G$ con $|D| \leq k$.

#### 5.4 Complessita della riduzione

La costruzione di $H$ richiede tempo proporzionale a $|V| + |E|$: per ogni arco si aggiungono un nodo e due archi. E quindi polinomiale. La riduzione e corretta e la conclusione e:

> **Teorema**: DOMINATING SET e NP-completo.

---

## Parte II -- Kernel nei grafi diretti

### 6. Definizione di Kernel

Passiamo ora a un problema definito su **grafi diretti** (digrafi). Dato un grafo diretto $G = (V, E)$, un sottoinsieme $K \subseteq V$ e un **kernel** se soddisfa *contemporaneamente* due proprieta:

1. **$K$ e un independent set di $G$**: non esistono due nodi $u, v \in K$ tali che $(u, v) \in E$. In altre parole, nessun arco del grafo collega due nodi del kernel.

2. **$K$ e un dominating set di $G$**: per ogni nodo $v \in V \setminus K$, esiste un nodo $u \in K$ tale che $(v, u) \in E$. Attenzione alla direzione: e il nodo *esterno* $v$ che deve avere un arco *verso* un nodo del kernel, non viceversa.

In sintesi: un kernel e un insieme di nodi indipendenti tale che ogni nodo esterno puo "raggiungere" almeno un nodo del kernel con un singolo passo.

Il problema decisionale e:

$$\text{KERNEL} = \{G \mid G \text{ e un grafo diretto che possiede un kernel}\}$$

Si noti che, a differenza dei problemi precedenti, qui non c'e un parametro $k$: chiediamo semplicemente l'*esistenza* di un kernel, di qualsiasi taglia.

### 7. Intuizione sul kernel

Per capire intuitivamente il concetto, si puo pensare al kernel come a un insieme di "posizioni vincenti" in un gioco combinatorio a due giocatori: se ti trovi su un nodo del kernel, il tuo avversario (che deve muoversi lungo un arco uscente) finira su un nodo fuori dal kernel, e da li sara costretto a poter raggiungere un nodo del kernel (che e la tua prossima mossa vincente). L'indipendenza garantisce che dal kernel non si va nel kernel; la dominanza garantisce che da fuori del kernel si puo sempre andare nel kernel.

### 8. KERNEL e in NP (Membership)

Mostrare che KERNEL $\in$ NP e semplice:

1. **Guess**: genera non deterministicamente un sottoinsieme $K \subseteq V$.
2. **Verifica**:
   - Controlla che $K$ sia un independent set: per ogni coppia $u, v \in K$, verifica che $(u,v) \notin E$. Costo: $O(|K|^2 \cdot |E|)$.
   - Controlla che $K$ sia dominating: per ogni $v \in V \setminus K$, verifica che esista $u \in K$ con $(v, u) \in E$. Costo: $O(|V| \cdot |K| \cdot |E|)$.

Il tutto e polinomiale, dunque KERNEL $\in$ NP.

### 9. KERNEL e NP-hard (riduzione da 3SAT)

Dimostriamo che 3SAT $\leq_P$ KERNEL, cioe riduciamo il classico problema 3SAT al problema del kernel. Poiche 3SAT e NP-completo, questo implicara la NP-hardness di KERNEL.

#### 9.1 Istanza di partenza

Prendiamo una formula booleana $\varphi$ in 3-CNF:

$$\varphi = C_1 \wedge C_2 \wedge \ldots \wedge C_m$$

dove ogni clausola $C_j$ contiene esattamente 3 letterali, su variabili $x_1, x_2, \ldots, x_n$.

Ad esempio:

$$\varphi = (x_1 \vee x_2 \vee x_3) \wedge (\neg x_2 \vee \neg x_1 \vee x_3) \wedge (x_4 \vee \neg x_2 \vee x_5)$$

#### 9.2 Costruzione del grafo diretto $G$

La funzione di riduzione $f$ trasforma $\varphi$ in un grafo diretto $G$ nel modo seguente:

**Passo 1 -- Nodi per i letterali**: per ogni variabile $x_i$, creiamo due nodi: uno etichettato $x_i$ e uno etichettato $\neg x_i$. Colleghiamo questi due nodi con archi in entrambe le direzioni:

$$x_i \longleftrightarrow \neg x_i$$

Questo crea un "gadget variabile": in qualsiasi kernel, esattamente uno tra $x_i$ e $\neg x_i$ deve appartenere al kernel (perche sono collegati bidirezionalmente e il kernel deve essere indipendente, quindi al piu uno dei due puo stare nel kernel; ma la dominanza richiede che almeno uno ci sia, dato che ciascuno dei due raggiunge l'altro). Intuitivamente, scegliere $x_i$ nel kernel corrisponde ad assegnare $x_i = \text{true}$; scegliere $\neg x_i$ corrisponde a $x_i = \text{false}$.

**Passo 2 -- Nodi per le clausole**: per ogni clausola $C_j$, creiamo un nodo etichettato $C_j$.

**Passo 3 -- Archi clausola-letterale**: per ogni clausola $C_j$ e per ogni letterale $\ell$ che compare in $C_j$, aggiungiamo un arco *dal nodo clausola $C_j$ al nodo letterale $\ell$*:

$$C_j \longrightarrow \ell$$

Questo significa che il nodo clausola puo "raggiungere" i letterali che la compongono. Se almeno uno di quei letterali e nel kernel, allora $C_j$ e dominato.

**Passo 4 -- Archi letterale-clausola**: per ogni letterale $\ell$ che compare nella clausola $C_j$, aggiungiamo anche un arco nella direzione opposta (cioe *dal nodo letterale negato alla clausola*). Piu precisamente: se il letterale $\ell$ compare nella clausola $C_j$, allora $\bar{\ell}$ (il complementare di $\ell$) ha un arco verso $C_j$:

$$\bar{\ell} \longrightarrow C_j$$

Questo arco serve a garantire che se il letterale $\ell$ e falso (cioe $\bar{\ell}$ e nel kernel), allora $\bar{\ell}$ "vede" il nodo clausola, contribuendo a forzare la struttura corretta.

#### 9.3 Esempio della costruzione

Per $\varphi = (x_1 \vee x_2 \vee x_3) \wedge (\neg x_2 \vee \neg x_1 \vee x_3) \wedge (x_4 \vee \neg x_2 \vee x_5)$:

- **Nodi letterali**: $x_1, \neg x_1, x_2, \neg x_2, x_3, \neg x_3, x_4, \neg x_4, x_5, \neg x_5$ (10 nodi, con archi bidirezionali tra ogni coppia complementare).
- **Nodi clausola**: $C_1, C_2, C_3$ (3 nodi).
- **Archi da clausole a letterali**:
  - $C_1 \to x_1$, $C_1 \to x_2$, $C_1 \to x_3$
  - $C_2 \to \neg x_2$, $C_2 \to \neg x_1$, $C_2 \to x_3$
  - $C_3 \to x_4$, $C_3 \to \neg x_2$, $C_3 \to x_5$
- **Archi da letterali negati a clausole**: per ogni letterale nella clausola, il suo complementare punta alla clausola.

#### 9.4 Correttezza della riduzione (direzione $\Rightarrow$)

Supponiamo che $\varphi$ sia soddisfacibile, con assegnamento $\alpha \models \varphi$. Costruiamo il kernel $K$ cosi:

- Per ogni variabile $x_i$: se $\alpha(x_i) = \text{true}$, mettiamo il nodo $x_i$ in $K$; se $\alpha(x_i) = \text{false}$, mettiamo $\neg x_i$ in $K$.

**$K$ e un independent set?** Si. I nodi letterali nel kernel corrispondono a letterali veri. Per costruzione, i due nodi di ogni coppia complementare $(x_i, \neg x_i)$ non possono essere entrambi in $K$ (ne scegliamo esattamente uno). Inoltre, tra i nodi letterali scelti non ci sono archi diretti (gli archi tra letterali connettono solo coppie complementari). I nodi clausola non sono in $K$.

**$K$ domina tutti i nodi?** Verifichiamo:
- Ogni nodo letterale non in $K$: e della forma $\neg x_i$ (se $x_i \in K$) o $x_i$ (se $\neg x_i \in K$). In ogni caso, ha un arco verso il suo complementare che e in $K$. Dunque e dominato.
- Ogni nodo clausola $C_j$: poiche $\alpha$ soddisfa $\varphi$, almeno un letterale di $C_j$ e vero, cioe il corrispondente nodo e in $K$. L'arco $C_j \to \ell$ raggiunge quel nodo. Dunque $C_j$ e dominato.

#### 9.5 Correttezza della riduzione (direzione $\Leftarrow$)

Supponiamo che $G$ abbia un kernel $K$. Definiamo un assegnamento $\alpha_K$:

- Se $x_i \in K$, poniamo $\alpha_K(x_i) = \text{true}$.
- Se $\neg x_i \in K$, poniamo $\alpha_K(x_i) = \text{false}$.

Perche questo e ben definito? Poiche $K$ e un independent set e i nodi $x_i$ e $\neg x_i$ sono collegati bidirezionalmente, al piu uno dei due sta in $K$. Per la proprieta di dominanza, almeno uno dei due deve stare in $K$ (ciascuno deve poter raggiungere qualcuno nel kernel; l'unico candidato per $x_i$ -- a parte i nodi clausola -- e $\neg x_i$, e viceversa). Dunque esattamente uno dei due sta in $K$.

**$\alpha_K$ soddisfa $\varphi$?** Consideriamo una clausola generica $C_j$. Il nodo $C_j$ non puo appartenere al kernel (perche ha archi verso i letterali, e se $C_j \in K$ dovrebbe essere indipendente da tutti, ma i nodi clausola sono collegati a nodi letterali che a loro volta sono collegati tra loro -- la struttura lo impedisce). Dunque $C_j \notin K$, e per la dominanza deve esistere un arco $C_j \to \ell$ con $\ell \in K$. Ma i letterali in $K$ sono quelli veri nell'assegnamento $\alpha_K$. Dunque la clausola $C_j$ contiene almeno un letterale vero, ed e soddisfatta.

#### 9.6 Conclusione

La costruzione del grafo $G$ a partire da $\varphi$ richiede tempo polinomiale (lineare nel numero di variabili e clausole). La riduzione e corretta in entrambe le direzioni. Dunque:

> **Teorema**: KERNEL e NP-completo.

---

## Riepilogo e connessioni

In questa lezione abbiamo visto due nuovi problemi NP-completi, entrambi definiti su grafi, ma con strategie di riduzione molto diverse:

| Problema | Tipo di grafo | Riduzione da | Idea chiave della riduzione |
|---|---|---|---|
| **Dominating Set** | Non diretto | Vertex Cover | Trasformare ogni arco in un triangolo, forzando il DS a coprire almeno un estremo per arco |
| **Kernel** | Diretto | 3SAT | Gadget variabile (coppia di nodi bidirezionali) + nodi clausola collegati ai letterali |

Questi risultati si inseriscono nella lunga catena di riduzioni che parte dal teorema di Cook-Levin (SAT e NP-completo) e si ramifica attraverso 3SAT, Independent Set, Vertex Cover, Clique, e molti altri problemi. Ogni nuova riduzione arricchisce il nostro "catalogo" di problemi NP-completi e ci offre nuovi punti di partenza per dimostrazioni future.

La lezione mette anche in evidenza un principio metodologico fondamentale: per dimostrare che un problema e NP-completo, la scelta del problema da cui ridurre e cruciale. Per Dominating Set, la somiglianza strutturale con Vertex Cover rende la riduzione piuttosto naturale. Per Kernel, invece, il legame con la soddisfacibilita booleana e meno ovvio, e la riduzione da 3SAT richiede una costruzione piu ingegnosa basata su gadget.
