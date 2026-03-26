# Lezione 2
### Bound 
- Il bottleneck che creiamo lanciando vagrant up: copio un immagine disco da un disco condiviso dentro la directory large -> il disco da cui leggo e il disco su cui devo scrivere è il collo di bottiglia 
    -  Il problema è quando ci sono molte persone che scrivono su un disco remoto sullo stesso server, usando la stessa rete (è un classico caso di troubleshooting, cioè ricerca dell'errore)
- CPU Bound: 
- I/O Bound: 
- Memory Bound: 

### Vagrant 
- Esercizio per vedere come partizionare un disco e come formattarlo 
- Usiamo Vagrant come sistema per automatizzare la configurazione di macchine virtuali
    - L'immagine della VM (box) facilmente reperibile da un cloud (VagrantCloud) che sia già preconfigurata e pronta all'uso (cioè basta accenderla), però queste macchine già preconfigurate non è detto abbiano tutto ciò che vogliamo
    - Con `vagrant up` tiriamo su macchine virtuali "a sforzo zero" preconfigurate, se poi vogliamo personalizzarle useremo dei plug in (moduli di adattamento) tramite strumenti come un virtualizzatore (virtualbox) e specifiche API, strumenti più complessi 
    - Vagrant non è usato nei server di produzione, perchè 
        * C'è un sistema per esempio di box di VM preconfigurate apposta di Amazon, è in un certo senso analogo al concetto di vagrant, ma 
```bash 
# Sono nella home/
$ bash setup_new.sh
$ cd large/ 
$ mkdir storage/
$ cd storage/ 
$ vagrant init debian/bookworm64    #Viene creato un file vagrant (Vagrantfile): è un file di configurazione in Ruby, è il file di configurazione che da' le caratteristiche alla macchina virtuale 
# Vagrant cercherà un'etichetta chiamata debian/bookworm64 (vedi interno file vagrant) e cercherà di avviare la box con quell'etichetta
$ vagrant up  # Fatto ciò sei dentro la macchina virtuale (l'hai accesa)
$ vagrant ssh 
# Ora siamo utente Vagrant su una macchina debian/bookworm (VM)
vagrant@bookworm:~$ df
# Diamo uno sguardo ai dischi: 
# /dev/sda1 è il disco virtuale montato sul device /dev/sda1 
# vagrant è un disco (share folder fittizio creato da vagrant) montato su /vagrant, dove all'interno della VM ritrovo la cartella su cui ho lanciato vagrant up (/large/storage),questo permette di finisce in /vagrant che è la cartella /large/storage, è una virtualizzazione di vagrant per usare /vagrant che coincide con /large/storages)
# Premendo Ctrl + Alt + F2 (/F3/F4/F5 fino a F6) si apre un terminale (utenti diversi) e se voglio tornare all'interfaccia grafica faccio Ctrl + Alt + F1 
vagrant@bookworm:~$ exit 
/large/storage:~$ vagrant ssh-config 
Host default 
    HostName 127.0.0.1
    User vagrant
    Port 2222
    UserKnownHostFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no

/large/storage:~$ ls -la  # Così vedo i file nascosti con il .<nome_file> per convenzione (TAB per gli autocompletamenti )
/large/storage:~$ ssh -p 2222 -i .vagrant/machines/default/virtualbox/private_key vagrant@127.0.0.1
# Se esce un messaggio The authenticity of host '[127.0.0.1]:2222 ([127.0.0.1]:2222)' can't be esthablished ... (ecc...)... Are you sure you want to continue connecting  (yes/no/[fingerprint])
# Mi viene inviata una fingerprint della chiave, così che se ci fosse un intruso posso contattare il sistemista e recuperare a voce (?RICHIEDI)
/large/storage:~$ vagrant ssh-config > storage.conf #salvo la configurazione ssh di vagrant su un file storage.conf (che vale per l'host default, se noi pensiamo in modo scalabile da sistemisti, così da dare un nome alla macchina e connettermi via ssh con quello )
/large/storage:~$ man ssh
/large/storage:~$ ssh -F storage.conf default 
/large/storage:~$ less storage.conf 
/large/storage:~$ vagrant halt #Vagrant è un'interfaccia per pilotare Virtualbox, così si può fermare la macchina, questo è meglio di usare power off su virtualbox, che è come staccare la spina, invece con vagrant alt la spengo in modo "gentile" ed evita problemi di incoerenza nel file system, perchè le VM come le macchine normali fanno caching aggressivo (meglio non staccare col cavo)
```
- A questo punto spenta la macchina con `vagrant halt` creo un nuovo hard disk virtuale (storage default da 1GB, senza preallocazione full size)
```bash
/large/storage:~$ virtualbox
# Su Virtualbox vai sulla macchina spenta, cliccaci sopra e vai su Settings, poi nel menù laterale vai su storage e vai su (Controller: SATA Controller) e clicca sull'icona di aggiungere dischi (add hard disk) e poi vai su create (controlla che sia le)
```
- Per lanciare comandi da root, ci metto `sudo` davanti 
```bash
/large/storage:~$ vagrant up 
/large/storage:~$ vagrant ssh
vagrant@bookworm:~$ sudo lsblk` # Mostra i dischi e le partizioni 
# Voglio partizionare /dev/sdb
vagrant@bookworm:~$ sudo fdisk -l # fa l'elenco dettagliato delle partizioni 
vagrant@bookworm:~$ sudo fdisk /dev/sdb # Scrivi bene il nome del dev/ perchè se no si modifica la tabella delle partizioni, rovinandola e va rimessa a posto (basta sapere com'era fatta o fare dei backup)
> n # Per aggiungere una nuova partizione 
# Se batto invia creo l'ultima partizione 
> p # Per controllare le partizioni appema create (è una buona pratica)
# Di default la partizione ha tipo Linux, è un'etichetta per indicare che ho pensato di mettere in quella partizione un hard disk linux 
# Invio per confermare
> w # Salvo quello che ho fatto
vagrant@bookworm:~$ ls -l /dev/sd*  #wildcard   (ricorda che con Ctrl + Shift + C/V copio/ incollo su terminale)
vagrant@bookworm:~$ sudo mkfs.ext4 /dev/sdb1    # Crea il file system allocando i metadati 
vagrant@bookworm:~$ sudo mkdir /nuovo  # Non ho specificato il punto di mount, comparirà su root (/)
vagrant@bookworm:~$ sudo mount /dev/sdb1 /nuovo # Sto dicendo di montare /dev/sdb1 su /nuovo, apparirà dentro /nuovo 
# Bisogna riavviare fstab perchè altrimenti il sistema non lo riavvia al punto giusto 
vagrant@bookworm:~$ df 
# Ora avrò /nuovo con montato /dev/sdb1
vagrant@bookworm:~$ vi /etc/fstab # Le righe entro questo file dicono come montare il disco di root, e come montare il disco dello shared folder all'avvio in modo automatico e possiamo aggiungere la riga (prima di #VAGRANT END)
# UUID è l'unique Identifier che si può usare per montare la partizione in modo da non doversi ricordare la sua posizione (per vederla c'è il comando tune2fs -l /dev/sdb1 | grep UUID | cut -c27-, cioè prendo i caratteri dal 27 esimo in poi)
/dev/sdb1 (dispositivo di storage) /nuovo (il punto dove si può raggiungere) ext4 (tipo di file system) defaults 0 0 (gli ultimi due parametri sono i controlli di manutenzione e di coerenza)
vagrant@bookworm:~$ sudo umount /nuovo # Smontiamo il file system montato prima 
vagrant@bookworm:~$ df # Controlliamo che il file system montato non sia più visibile 
vagrant@bookworm:~$ sudo mount -a oppure /dev/sdb1 /nuovo 
```
Note: 
- Vagrant simula un nuovo disco (virtuale) della macchina, va collegato a tale macchina 
- Poi voglio poter modificare la dimensione di tale partizione che ho creato, allargandole anche dinamicamente 
- serve configurazione dual boot / macchina virtuale 
- Se sono isolato dalla rete, uso la man page su un comando che mi ricordo e vedo la sezione SEE ALSO, così da avere altre man page correlate a certi argomenti 
(Es: tune2fs -l /dev/sdb1 | grep UUID) per trovare l' UUID di /dev/sdb1 
(Altro modo identico ma migliore: tune2fs -l /dev/sdb1 | grep UUID | cut -d' ' -f3) cut usa ' ' come delimitatore (anche se tra UUID e il valore ce ne sono '      ' un bel po' di ' ')
(Usiamo awk che è un vero e proprio linguaggio tune2fs -l /dev/sdb1 | grep UUID | awk '{print $3}' ) per awk un field è una qualunque combinazione di caratteri 

### Vagrant + SSH
- Vagrant mette a disposizione un meccanismo: utente vagrant che ha delle credenziali messe a disposizione (dopo vagrant up) e mi autentico con le credenziali di questo utente 
    * Utente Vagrant può diventare utente root usando sudo 
    * L'utilizzo di ssh è fondamentale
- SSH: è un sistema nato per sostituire telnet, un protocollo per remotizzare i terminali in modo efficiente e privo di misure di sicurezza (bastava che internet funzionasse ai tempi), oggi è nato un protocollo sicuro detto ssh, che fa forte uso di un'autenticazione basata su crittografia a chiave pubblica: 
    - si genera una coppia di chiavi: pubblica e privata ~ se noi vogliamo collegarci ad un server che ha la nostra chiave pubblica, ci manda un numero (NONCE) cifrato con la chiave pubblica nostra, se noi dimostriamo al server che la chiave privata è la nostra, allora possiamo autenticarci 
    - SSH sfida dal lato client, per dimostrare per il server è quello corretto e non ci sono punti intermedi malevoli magari, sfidiamo il server per vedere se è quello giusto: 
        * La chiave pubblica che lato client devo avere è quella del server e si manda un numero casuale cifrato con la chiave pubblica, mentre il server avrà la sua chiave privata e decifrerà il numero, così posso verificare che sia il server giusto
        * La prima volta che mi connetto il server devo scambiare le chiavi pubbliche del server in ambiente protetto, così ho le chiavi: A questo punto si crea un canale cifrato e devo dimostrare che l'utente vagrant sia io, ed è importante che io abbia depositato la mia chiave pubblica privata (questo è un modo, ma io avendo già un canale cifrato posso anche autenticarmi -> l'unico problema è che se un malintenzionato è in possesso del server all'arrivo la password potrà rivelarla con la chiave privata del server e me la ruba)
        * client (ha $K^+_server$) - $K^+_server(NONCE)$ -> server (ha $K^-_server$)
        * server (ha $K^-_client$) - $K^+_client(NONCE)$ -> server (ha $K^+_client$)
        * `ssh <nome_utente>@<remote_server>` per autenticarsi come utente <nome_utente> al server remoto 
- Vagrant crea una macchina con vagrant up: crea la chiave pubblica e la mette nella macchina virtuale dell'utente vagrant e inietta la chiave privata in un file di configurazione della mia macchina host (con ssh-config vagrant ci spiega dove ha messo le chiavi)
- VIrtualbox riproduce il traffico di rete comportandosi come un router (fa port forwarding)
    * Una macchina virtuale può essere vista dall'esterno, però perde i vantaggi di essere isolata dalla rete e va chiaramente protetta 
        ```
        default: Adapter 1: nat
        default: Forwarding ports...
        default: 22 (guest) => 2222 (host) (Adapter 1)
        ```
    * A livello di Networking è stato predisposto port forwarding e a livello di configurazione è stato creato un file con le rispettive chiavi 

### Altro esercizio pt2 partizionamento
- Devo cambiare il partizionamento fatto in precedenza 
```bash 
vagrant@bookworm:~$ sudo -i #divento root@bookworm 
root@bookworm:~$ fdisk /dev/sbd 
> d # Se c'è una partizione cancella quella, altrimenti mi chiede quale voglio cancellare
> p # Controllo 
> n
> p # Per dire che è una partizione primaria 
> First sector #invio per partire dal settore 2048
> Last sector, +/-sectors or +/-size{K,M,G,T,P}: +500M  #Se avessi scritto -500M significa che conta dalla fine, con il +500M parto dall'inizio 
# Se volessimo creare una partizione logica farei > e (creo una partizione estesa), gli do' un numero (3, si chiamerà sdb3) e First Sector lo faccio partire da 600M, devo iniziare a 1200000 ( a calcoli fatti), e premo invio per dire che la partizione estesa occupa tutto il resto del disco 
# La partizione estesa non è altro un contenitore di contenitori (non devo metterci nulla, contiene solo altre partizioni e basta, in genrale ho 3 partizioni primarie e 1 estended, che contiene partizioni logiche )
# Ti chiede se vuoi rimuovere la signature del file system 
> p # Controllo quello che ho fatto 
> w # Salvo quello che ho fatto ed esco (vedrò che il disco sdb ha 3 partizioni)
```

### Primi esercizi da riga di comando 
-
```bash
# Con ssh è possibile lanciare comandi remoti dalla proprima macchina host ad una remota
$ssh -F storage.conf default df
# Usare cat,ssh e pipeline per copiare un file (vagrantfile) dalla macchina host alla macchina guest (remota)
# ssh agisce come un tubo doppio, il secondo cat è in esecuzione sulla macchina remota, e il comando bash 
/large/storage:~$ cat Vagrantfile | ssh -F storage.conf default cat > Vagrantfile # Non va
# Devo trasformare con il quoting per passare un parametro su shell locale e che sia eeguito sulla shell remota come comando 
/large/storage:~$ cat Vagrantfile | ssh -F storage.conf default 'cat > Vagrantfile'
```

##### Filtri di base 
- Es: grep 
- less: per impaginare
- head: mostra le prime righe di un file (-c per ragionare con i caratteri), se il numero è negativo di righe, fa vedere tutte le righe tranne le ultime specificate con il segno meno
- tail: mostra le ultime righe di un file
- Su Linux, tutti i file di configurazione e tutti i diari dove il sistema tiene traccia di tutte le attività di esecuzione del sistema sono stringhe di testo

- Esercizio: prelevare le righe dalla 30.000 alla 30.020 del file /usr/share/dict/words 
```bash
$ less /usr/share/dict/words
$ wc /usr/share/dict/words  # Word count 
# Suggerimento: è una pipeline su head e tail 
# Rispetto all'inizio del file 
$ head -n 30020 /usr/share/dict/words | head -n 20
$ tail -n +30001 /usr/share/dict/words | head -20 
# Oppure rispetto alla fine del file 
$ tail -n 30020 /usr/share/dict/words | head 
```