# Lezione 4

### Variabili della shell 
- Ci sono variabili comode da usare (e.g. RANDOM)
- Ci sono variabili che forniscono informazioni su proprietà del sistema (e.g $USER - per sapere chi siete su un sistema )
- $$ e $PPID e $BASHPID - permettono di ricostruire la gerarchia dei processi
    * $$ è l'id del processo shell che da' origine alla gerarchia 
    * 
```bash
$ ( echo $$ ; echo $BASHPID)   # hanno valori diversi perchè con ( ) ho creato una shell figlia che esegue il comando composto 
$ { echo $$ ; echo $BASHPID } # Qui non si creano shell figlie, non è un comando composto, è invece una sintassi che serve a raggruppare comandi, per esempio scrivere una piccola funzione 
```
- E' utile sapere se una variabile è predefinita da una shell, perchè così si evita di utilizzarle e di tentare di sovrascriverle (si genera un errore)

### Controllo sui parametri 
- se lo script lo scrivo io, i parametri glieli passo io e se funziona bene, in futuro potrei usarlo con parametri diversi 
    * E' sempre buona norma controllare i parametri
- si fa coi `comandi di test`:
    * `test`
    * oppure `[` 
    * oppure `[[` (è un comando che interpreta l'espressione valutandola e restituendo true/false come exit code UNIX)
```bash 
#!/bin/bash 
if [[ $1 = "" ]]; then 
    echo "serve un parametro"
    exit 1 
fi 
```
- Questo esempio dal punto di vista della leggibilità è molto chiaro, ma posso scriverlo in modo più compatto 
    * questo perchè il test è un comando, viene eseguito e restituisce un exit code 0/1 ,quindi posso usare l'OR per eseguire il comando successivo se il comando di test fallisce, mentre uso l'AND per NON eseguire i comandi successivi dopo il comando di test se questo fallisce 
```bash 
#!/bin/bash 
# [[ "$1" = "" ]] questo è un comando 
[[ "$1" = "" ]] && {
    echo "Serve un parametro"
    exit 1
}
```
- Se uso le graffe { ... } per fare comandi composti su una riga sola, serve il ; dopo l'ultimo comando cioè 
```bash
{ echo $$ ; echo $BASHPID ; }
[[ "$1" = "" ]] && { echo "Serve un parametro" ; exit 1 ; }
```
- Il man per `[[`, perchè è built-in in bash, quindi documentati nella man page di bash, e non esistono come man page a se'
    * posso usare `help` della shell, che è il tool fornito dall shell per i suoi comandi built-in 
- Le man page hanno i comandi di ricerca 
    * comando man: `/` posso scrivere questo e il pattern che voglio cercare (e.g / \[\[ per cercare '[[' e usare n per andare al successivo ) 
```bash
$ help [[
```
- A questo punto voglio controllare che il parametro passato ad uno script sia una directory 
```bash
#!/bin/bash 
[[ ! -d "$1" ]] && {
    echo "Il parametro passato non è una directory"
    exit 1 
}
# Oppure anche 
[[ -d "$1" ]] || { echo "$1 non è una directory" ; exit 2 ; }
```
- Potrei fare una funzione R che sia gentile con utente che si dimentica di fare quoting di parametri da stampare  
```bash 
$ set A B C D # setta i parametri posizionali $1,2,3,4 con i valori di A,B,C,D
$ shift 
$ echo $1 # è B
$ echo $2 # è C
$ echo $3 # è D
$ echo $4 # è scomparso
# Ho estratto A e shiftato gli altri valori, utile quando si ha un numero di parametri sicuri e un numero imprecisato di parametri successivi 

#!/bin/bash 
function err(){
    local code=$1   # il primo parametro è l'exit code che l'utente vuole produrre in errore
    shift 
    echo "$@"
    exit $code 
}

[[ -z "$1" ]] && err 1 serve un parametro # caso 1, non serve il quoting 
[[ -d "$1" ]] || err 2 "$1 non è una directory" # non so cosa c'è in $1, serve il quoting " " 
```

### Built-in . (detto anche source)
- Supponiamo di avere il seguente script function.sh, voglio avere questa funzione disponibile in tutti i miei script 
```bash 
function err(){
    local code=$1
    shift 
    echo "$@"
    exit $code 
}
```
- Apro un altro script che vuole usare function.sh
    * Il `.` è un comando che va a leggere il file passato come parametro 
    * source è utile per avere script che leggono dati (e.g. tutti gli utenti del sistema) e così che se cambio un utente, per tutti gli script sarà cambiato 
```bash
. ./funzioni.sh # comando source .
[[ -z "$1" ]] && err 1 serve un parametro 
[[ -d "$1" ]] || err 2 "$1 non è una directory"
```
### File di configurazione della shell 
- Si può dire alla shell che convenzioni locali usare per dialogare con l'utente, per esempio gli alfabeti rappresentano diversamente le stringhe
    - Il locale si cambia con `export LC_ALL=C` (convenzioni di C)
    - La shell ha file di configurazione, sono nascosti (con il . iniziale)  perchè il comando ls senza -a non li vede 
        * .bash_history: contiene la cronologia dei comandi eseguiti
        * .bash_logout: contiene i comandi da eseguire al logout
        * .bashrc: contiene la configurazione inziale della shell 
        * Nel man si vedono tutti i file di configurazione della shell 
- Ci sono inoltre due tipologie di shell: 
    - shell di login: quella dove si digita login e password
    - Le shell interattive sono quelle che permettono di lanciare comandi 
- Se apro il file .bashrc (con vi), per esempio
    * si possono per esempio definire alias (cioè soprannomi, che di fatto si scrivono come stringhe che verrano sostituite) nel file ./bash_aliases (si potrebbero anche scrivere direttamente in bashrc, ma è meglio tenere le cose pulite e ordinate)
```bash 
if [ -f ~/.bash_aliases ]; then # -f per controllare se il file esiste
    . ~/.bash_aliases   # il comando source include il file .bash_aliases, il ~ si espande come cartella home/ 
fi

export LC_ALL=C #export modifica la variabile, trasformandola in una variabile d'ambiente e quindi ereditabile dalle shell figlie (non più una variabile locale)
```

### esercizio 1
- Voglio vedere con il comando ls -l solo i file nascosti senza '.' e '..'
    (è un effetto collaterale, usa i caratteri speciali del file system)
```bash 
$ ls -l .*  # vengono fuori troppe cose, non va bene 
$ ls -ld .[a-z]*  # è quasi giusto 
# Siccome voglio che non ci sia carattere . e ..
$ ls -ld .[^.]*
```
- Se voglio sapere tra tutte le directory nascoste, quali sono le più grandi
```bash 
$ du -s .[^.]* 
# Purtroppo il metodo qui sotto non funziona perchè * non espande le directory col . iniziale (nascoste)
$ du -s /* 2>/dev/null  
# Un modo più efficace è: voglio le 10 directory a partire da / più ingombranti nel sistema 
$ du / 2>/dev/null | sort -nr | head 
```
- Se voglio creare un alias, non funzionerà subito perchè bash_aliases è incluso in bashrc, che è eseguito all'avvio della shell (devo riavviare la shell per includerlo)
    * un alias si crea così: `alias topdir='du / 2>/dev/null | sort -nr | head'`
    * se includo . .bash_aliases includo l'alias dentro bash_aliases e quindi si può usare (gli alias si vedono con il comando alias)

### case e cicli 
- E' lo switch, evita gli if annidati e valgono i metacaratteri della pathname expansion (cioè ?,*)
- comando `seq` genera sequenze di numeri
    * 2 parametri: inizio e fine 
    * 3 parametri: inizio, passo e fine 
    * trasformazione in stringhe usando command substitution
    `for i in $(seq 2 -0.5 1) ; do echo ecco $i ; done `
- keywork break e continue nei cicli 
```bash
$ while sleep 2 ; do echo faccio cose ; done
```

### esercizio 2 
- Versione fatta da me
```bash
#!/bin/bash
# Chiedere uno username 
# Se la stringa inserita è vuota, terminare 
# Se la stringa inserita non rispetta i vincoli, ripetere la richiesta 
# vincoli: 
#   - lunghezza minima 5 caratteri 
#   - lunghezza massima 8 caratteri 
#   - nessun carattere speciale (solo lettere e numeri)
#   - inizia con una lettera maiuscola 
while true ; do
    echo "Inserire una password: "
    read pwd 
    if [[ "$pwd" = "" ]]; then 
        echo "Stringa inserita vuota"
        exit 1
    elif [[ "$pwd" =~ [A-Z][a-zA-Z0-9]* && ${#pwd} -lt 9 && ${#pwd} -gt 5 ]]
        echo "Password inserita con successo" 
        break
    fi
    echo "Password non valida"
done 
```
- Soluzione del prof 
```bash
while true ; do 
    read -p "$Username? " U
    [[ -z "$U" ]] && break 
    # Approccio single regex
    [[ "$U" =~ ^[a-z][a-zA-Z0-9]{4,7}$ ]] || continue 
    # echo "$U" | grep -q '^[a-z][a-zA-Z0-9]{4,7}$' && continue (alternativa ulteriore alla riga sopra)
    echo ottima scelta && break
done
while true ; do
    read -p "$Username? " U 
    [[ -z "$U" ]] && break 
    # Approccio "eccezioni"
    [[ "${#U}" -lt 5 ]] && continue 
    [[ "${#U}" -gt 5 ]] && continue 
    [[ "$U" =~ [^a-zA-Z0-9] ]] && continue 
    [[ "$U" =~ ^[^a-z] ]] && continue
    echo ottima scelta && break
done 
```

### Segnali e processi in background 
- Ogni volta che lancio un processo in background, la variabile $! contiene il pid dell'ultimo processo in background lanciato, se voglio mantenerli devo salvarli uno ad uno 
- I processi in background sono scollegati dalla tastiera, devo mandare 
- I jobs sono i processi che eseguono in background 
```bash 
$ sleep 1000 & # processo sleep mandato in esecuzione in background, mostra il suo pid 
$ jobs # quali job stanno girando 
$ ps <job_id> # il job_id è l'id della shell che gira 
$ echo $!   # ultimo process id dell' ultimo processo lanciato in background 
$ ps $! # comando che indica lo stato del processo (es. sleeping )
$ kill -STOP $! # Fermo il processo in esecuzione, non viene assegnata la CPU dallo scheduler, viene ignorato
$ kill -CONT $! # Segnale cont riavvia il processo fermato, che ricomincia a contare i millisecondi di esecuzione 
$ kill $!   # Per uccidere un processo
$ sleep 1000 # il programma viene lanciato in foreground 
$ bg # Per mandare comandi in background
$ fg # manda il foreground l'ultimo processo mandato in esecuzione in background 
$ jobs # vedo i job e posso mandarli in foreground 
$ fg %2 # con jobs hanno un indice tra parentesi quadre (e.g. [2]+ In esecuzione sleep 1000 & )
```
- Voglio essere sicuro con uno script di eseguire tre comandi in parallelo e aspettare che rispondano tutti e tre 
```bash 
$ wait # è un tool di sincronizzazione, per aspettare che terminino tutti i processi in background
```

### esercizio 3 (processi in background)
- Si realizzi uno script che lancia i comandi sleep 10 e sleep 20 in parallelo, e che ogni 5 secondi scriva su STDOUT il loro stato (in esecuzione / terminato )
```bash 
#!/bin/bash 
sleep 10 & 
PRIMO=$!    # E' buona norma salvarsi il pid del processo lanciato in background 

sleep 20 &
SECONDO=$!

while sleep 5 ; do 
    STATO1=`ps hp $PRIMO | awk '{ print $3 }'`  # $3 è il terzo campo, i backtick `` sono il vecchio modo di $()
    STATO2=`ps hp $SECONDO | awk '{ print $3 }'`

    if test -z "$STATO1" ; then STATO1=terminato ; fi 
    if test -z "$STATO2" ; then STATO2=terminato ; fi 

    echo "Stato del processo $PRIMO: $STATO1, stato del processo $SECONDO: $STATO2" | tee -a log
	# if test "$STATO1" = "terminato" -a "$STATO2" = "terminato" ; then break ; fi
	if ! ps "$PRIMO" && ! ps "$SECONDO" ; then break ; fi
done
```