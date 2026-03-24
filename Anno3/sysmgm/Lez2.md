# Lezione 3 
- Nota: se si lavora in /large/storage/ 

### Quoting  
```bash 
$ mkdir test    # directory con i file a 'a*' a2 b1 b11 
$ cd test/      # Lavoriamo nella directory 
$ touch a a* a2 b1 b11
$ touch a 'a*' a2 b1 b11
$ echo *    # - la shell trasforma l'asterisco nei nomi di file che fanno match con *, cioè tutti (sarebbe come fare echo a a* a2 b1 b11 , che sono i file)
$ A = a*    # 
$ echo $A ; echo "$A" ; echo '$A'   #(separo dei comandi in sequenza con ';') Se io faccio $A, la prima espansione che avviene è che $A viene sostituito con a*, e come seconda espansione a* viene sostituito in tutti i nomi dei file che iniziano con a- 
# I doppi apici "" lascia che l'espansione di $A crei il suo valore, ma impedisce l'espansione dei metacaratteri (e quindi echo "$A" restituisce a* senza che il '*' venga espanso)
$ echo $A # L'espansione di nomi di file 
$ echo a$A # Stampa a2, è il file che fa match con a e l'espansione di $A
$ ls 
> a 'a*' a2 b1 b11 
$ echo a"$A"  # Stampa a[12] perchè ho inibito l'espansione con le double quotes 
$ A={a1,a2}   
$ echo $A   # Stampa {a1,a2}
$ echo {a1,a2}  #Stampa a1 a2 perchè al shell fa braces expansion 
$ eval echo $A  #Stampa a1 a2 
$ eval echo {a1,a2} #Stampa 
$ mkdir f
$ cp * f # Mi aspetto che copi i file della dir corrente e li copi nella directory f (errore: perchè se io faccio echo * noto che * si riferisce anche a f, sto provando a copiare f, devo aggiungere -r per copiare f ma la shell lo vieta, creerebbe infinite ricorsioni all'interno di una directory)
$ ls -l # E' diverso da ls -l *, dove se c'è una directory, mi mostra il suo contenuto e non il nome perchè al posto di asterisco viene messo il nome della directory, come se si facesse ls -l <nome_directory>
$ touch 'a1 a2'      # Ecco come fare un file a1 a2 (con lo spazio) uso le '' per separare un token da un altro -> inibisco il word splitting che è l'ultimo passo prima dell'esecuzione 
$ A=a1 a2  # Qui la shell assegna a1 ad A e cerca di eseguire un comando chiamato a2, da' errore
$ A='a1 a2'
$ ls -l $A # Dove se non proteggo $A da' errore, devo scrivere ls -l "$A" in modo che "$A" venga espanso in 'a1 a2' e non a1 a2 (con lo spazio)
```

### Command substitution 
```bash
$ A=$(ls -l)    #Il risultato del comando viene scritto al posto di $(...) e in questo caso viene assegnato alla variabile A (a cui ho assegnato la command substitution di ls -l)
$ echo $A   # diverso da echo "$A", c'è il word splitting (se c'è un qualsiasi token di spaziatura lo considera come spazio tra un token e un altro) -> la shell tokenizza ogni elemento di A e rimuove ogni token di spaziatura e anche gli andare a capo
# Prima viene espansa la variabile, poi viene fatto il word splitting 
$ echo "$A" # Uso le parentesi " " per inibire il word splitting, così che ogni spazio e a capo non viene usato come separatore di nessun token, viene letto tutto come un unico token, che mantiene gli spazi e gli a capo originali 
```


## Scripting 
- consiglio: quando fai uno script, testa i pezzi uno alla volta prima di testarli assieme 
- Si indica l'interprete che andrà ad eseguire lo script 
```bash 
#!/bin/bash     
```
- Altra caratteristica degli script sono gli argomenti passati via riga di comando 
    * Vi si accede con le variabili posizionali $1,$2,...   
    * C'è una variabile $@ che contiene i parametri che passo ($0 è il nome dello script)
    * echo $PATH  -> path è una variabile speciale che indica il path di esecuzione di comand
- file test.sh: 
```bash
#!/bin/bash
echo "$1" "$2" 
echo "$@" 
```
- Se ho i permessi giusti impostati, posso eseguirlo 
- Per eseguirlo indico il path dello script
```bash
$ test.sh   # non fa nulla 
$ ./tesh.sh # esecuzione senza parametri 
$ ./test.sh 1 2 # esecuzione con parametri
```

### Cicli su shell
- for: c'è una variabile che uso come iteratore, dopo la keyword in potrebbe esserci qualcosa che la shell espande 
```bash 
for I in {1..5}
# Oppure con le variabili posizionali
# Varianti: 
for I in $@ ; do   # parametri espansi, spazi rimossi da word splitting e quindi stampate quattro parole 
    echo "$I"
done
echo ....   # Separatore che ci aiuta a vedere meglio l'output 
for I in "$@" ; do # 2 iterazioni
    echo "$I"
done 
echo ....
for I in $* ; do # Equivale a $@ 
    echo "$I"
done
echo ....
for I in "$*" ; do # Ha preso i parametri come se fossero un' unica stringa 
    echo "$I"
done 
```
- Lo eseguo così: 
```bash 
$ ./test.sh "Ciao mamma" "primo script" # Script lanciato con due parametri
```
- Si può usare il comando set per simulare i parametri posizionali: 
```bash 
$ set primo secondo
$ echo "$2"
> secondo 
$ echo "$1" 
> primo 
```

### Array su shell
- Oltre agli array tradizionali, la shell supporta gli array associativi (array con coppie chiave-valore dove la chiave può essere diversa da un numero)
```bash
$declare -a ARRAY    #Ho dichiarato un array tradizionale (con indici numerici)
$ARRAY[0]="zero"
$ARRAY[5]="cinque"  # Essendo la shell un linguaggio interpretato, posso anche memorizzare su celle non contigue di array, lasciandone alcune vuota
$echo ${ARRAY[@]}   # Restituisce tutti i valori memorizzati nell'array 
$echo ${!ARRAY[@]}  # Con il ! prima del nome dell'array sto chiedendo di parlarmi degli indici anzichè dei valori
$ for i in ${ARRAY[@]} # Iterando direttamente sui valori degli array, se non metto le "" il word splitting considererà gli spazi come separatori di token (e non uno spazio dentro un token unico)
$ for i in "${ARRAY[@]}"    # C'è protezione da word splitting, mantiene gli spazi dentro uno stesso token senza tokenizzarlo 
$ declare -A AA # Per dichiarare con la flag -A un array associativo (indici non numerici)
```

- Gli array tradizionali (non associativi) possono essere inizializzati in questo modo: 
    * utile per assegnare risultati di comandi alle celle dell'array 
```bash
$ ARRAY=(un due tre)
$ echo ${!ARRAY[@]} 
> 0 1 2
$ echo ${ARRAY[@]}
> un due tre
# Torna molto utile nei casi in qui voglio assegnare l'output di un comando ad un array (tradizionale)
$ ARRAY=$(ls -l)    #Ogni token (parola) del comando ls -l è stato messo in ogni cella dell'array 
$ echo ARRAY[56]
> Mar               # Una qualche parola nell'output di ls -l memorizzata all'indice 56 dell'array 
```


### Apertura di device e file descriptor 

```bash 
$ tty 
> /dev/pts/0    # La shell risponde al comando tty con il terminale che sta utilizzando (quello in cui mi trovo e da cui ho lanciato il comando)
# Se apro un altro terminale sulla stessa macchina (anche virtuali, con vagrant shh su due terminali diversi)
$ tty 
> /dev/pts/1    
# Su questo terminale (1) lancio il comando 
$ echo ciao > /dev/pts/0    # Questa ridirezione ( > ) non riversa l'output sul file come farebbe su un file normale, ma significa mandare l'output di echo ciao sul terminale (0), perchè /dev/pts/0 è un file speciale 
$ cat /dev/pts/0    # cat si mette in lettura di ciò che arriva dalla tastiera su /dev/pts/0 e lo mostra su /dev/pts/1 dove è stato lanciato  
> cao # se io scrivo sulla tastiera e sono nel terminale 0, cat si mangia alcuni caratteri perchè c'è lui e il processo di scrittura su shell che si mangiano i caratteri perchè eseguono in concorrenza dallo stesso flusso di input (la tastiera)
```


```bash 
$ cat /etc/passwd # produce l'elenco degli utenti nel sistema con tutti i loro dettagli 
$ cat /etc/passwd | while read R 
> echo "$R" 
> done 
$ cat /etc/passwd | while read R ; do echo $R ; done 
$ read -p "domanda" A
> domanda risposta # risposta è messo nello stdin e viene messo in A dal comando read 
$ cat /etc/passwd | while read R ; do read -p "ti interessa questa riga? " A ; echo $R done # In questo comando, lo stdin del read è la pipeline, perchè la pipe fa una fork e quindi lo stdin non è più la tastiera ma è quello della pipeline
```
- I vari comandi di prima possiamo usarli per il seguente script 
```bash 
#!/bin/bash 
exec 3<>$(tty)  # creo il file descrptor 3 collegato al terminale
cat /etc/passwd | while read R 
do 
    read -u 3 -p "ti interessa questa riga? " A 
    if [[ "$A" = "yes" ]]
    then 
        echo $R
    fi 
done 
```
- Per eseguirlo, apro un terminale nuovo (diverso da quello precedente)
```bash
$ ./read.sh     #nome che abbiamo dato allo script 
```
- comando read per leggere diverse stringhe separate dai caratteri di IFS 
    * posso modificare IFS, assegnandogli temporaneamente un valore diverso 
```bash 
$read A B C 
> 1 2 3     # mette i valori nelle rispettiva variabili (A=1 B=2 C=3) leggendoli da tastiera 
# posso modificare IFS, assegnandogli temporaneamente un valore diverso 
$IFS=: read A B C
> 1:2:3 
$ echo 1 2 3 | read A B C # Una scorciatoia del genere può funzionare? SI, la pipeline replica esattamente quanto scritto sopra ma in un unico comando 
# echo 1 2 3 produce la stringa 1 2 3 (con spazi che separano)
$ echo $A # Non stampa niente, non è un problema di spazi ma il processo read è una sottoshell che termina  e quindi il processo padre (la shell da cui lancio il comando) non ha la variabile A del figlio che è terminato e quindi la sua memoria è deallocata 
$ echo 1 2 3 | ( read A B C; echo $A )  # In questo modo sto dicendo che il comando echo $A venga eseguito dalla shell figlia
```     

### Funzioni su shell
- Le funzioni hanno i propri parametri posizionali (non usano quelle della shell ma hanno la stessa sintassi - scope diverso)
```bash 
function sum() { 
    echo debug: initial A=$A
    echo debug: increment of $1
    (( A+=$1 ))
    echo debug: final A=$A
}
A=0
sum 5
```

##### Esercizio 1
Modificare il seguente script nel modo indicato nelle righe commentate 
```bash 
#!/bin/bash 
exec 3<>$(tty)  
cat /etc/passwd | while read R 
do 
####### parsing della riga per individuare il nome utente 
####### e includerlo nella domanda 
    read -u 3 -p "ti interessa questa riga? " A 
    if [[ "$A" = "yes" ]]
    then 
####### contare quante righe sono state effettivamente mostrate
####### e alla fine stampare il valore
        echo $R
    fi 
done 
```
- Script modificato: 
```bash 
#!/bin/bash
COUNTER=0
exec 3<>$(tty)  
cat /etc/passwd | while read R 
do 
    U=$(echo "$R" | cut -f1 -d:)        # meno costoso (crea un processo anzichè due) cut -f1 -d: <<< "$R"
    read -u 3 -p "ti interessa $U? " A 
    if [[ "$A" = "yes" ]]
    then 
        echo $R
        (( COUNTER++ ))
    fi 
done 
echo "utenti visualizzati: $COUNTER" 
```

### Esercizio 2 
- `echo $RANDOM` per generare numeri random 
- `cat /dev/urandom` e `cat /dev/random` (il primo è infinito ma genera numeri con meno causalità, mentre il file random genera numeri davvero nel modo più casuale possibile ma prima o poi finiscono)
    * urandom ha il problema che stampa numeri binari fuori dal range di rappresentazione, c'è un trucchetto con tr: `cat /dev/urandom | tr -d -c '0-9a-zA-Z' | dd count=10 bs=1 2>/dev/null 
    * dd è il data dump, prende un file di input (defaut stdin) facendo modifiche in mezzo (qui gli ho detto di prendere 10 elementi con block size 1 ) - vedi man size 
    * 2>/dev/null per non stampare lo stderr 
Realizzare uno script che contenga

1) una funzione INIT che esegue  un ciclo con queste caratteristiche:

chiede a terminale di inserire una stringa UTENTE,
termina se la stringa è vuota
stampa un messaggio d'errore e riparte dalla richiesta se la stringa non rispetta questi vincoli: lunghezza compresa tra 4 e 8 caratteri, inizia con lettera minuscola, non contiene caratteri diversi da lettere e numeri
genera una PASSWORD casuale di 10 caratteri 
memorizza la coppia in un array associativo, in cui la chiave è UTENTE e il valore è PASSWORD
ritorna "true" se ha inserito almeno una coppia nell'array
2) una funzione QUERY che chiede un nome utente e stampa la password

3) un main che invoca la prima funzione e in caso di successo la seconda