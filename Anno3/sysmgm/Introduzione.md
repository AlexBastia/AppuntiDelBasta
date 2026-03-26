# Introduzione AMMINISTRAZIONE DI SISTEMI
- Il corso va seguito bene 
- Se hai dual boot con distro linux, basta installare Vagrant e Ansible (e quello che usiamo)
- Tutte le attività che svolgiamo sono con i privilegi di amministrazione, usiamo la virtualizzazione (tecnica grazie alla quale
inseriamo uno strato tra hw e sistema operativo che illude l'ospite "guest" di avere un sistema operativo per se grazie a questo livello intermedio che è l'hypervisor (software) che ha accesso all'hw)
- Per virtualizzare uso VirtualBox e usiamo Vagrant (che impareremo ad usare)
- Per usare i lab, serve creare le credenziali 
- /home in lab ha una quota di GB liberi, invece /large sottodir di /home non ha una quota
- Sulle macchine di laboratorio usare 
- `pipe`: comandi che fanno bene una cosa specifica, i comandi si parlano attraverso stream, i file descriptor stdin e stdout si scambiano informazioni tra loro 
```bash
#!/bin/bash

STUDENT_ID="$(whoami)"

# grep cerca la directory large 
mount | grep -q large || { echo "La directory ~/large necessaria per le VM non è stata montata correttamente, è necessario riavviare il sistema" ; exit 1 ; }

mkdir -p ~/large/"VirtualBox VMs"
# Tool che imposta una proprietà della VM di Virtualbox 
vboxmanage setproperty machinefolder "/home/LABS/$STUDENT_ID/large/VirtualBox VMs"

echo "*****************************************************************"
echo "*     Sto per ripulire le precedenti istanze di VM vagrant      *"
echo "*                                                               *"
echo "* Per interrompere premere CTRL-C, per proseguire premere Invio *"
echo "*                                                               *"
echo "*****************************************************************"

read a

rm -rf ~/.vagrant.d ~/large/.vagrant.d

mkdir -p ~/large/.vagrant.d/boxes/

ln -s ~/large/.vagrant.d ~/.vagrant.d

mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/* ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/

echo '# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
     vb.linked_clone = true
  end
end
' > ~/large/.vagrant.d/Vagrantfile

```
### Cosa fare nel mondo reale quando installo una VM? 
- Oggi non capita spesso di installare VM 
- Ciò che c'è sul pen drive è la copia bit a bit di ciò che una volta era su un disco, si scarica questa immagine .iso si può trasferire o su un media ottico (DVD) o su un pen drive
- File .iso è un'immagine copiata bit a bit non è un file che va copiato sulla chiavetta, perchè se inserisco la chiavetta con i file dentro il sistema operativo non sa cosa fare di quel file .iso perchè non è bootabile, allora bisogna usare un modo per far sì che questi dati del file .iso vengano riconosciuti come bootabili (c'è uno strumento di creazione di media ottici, cioè crea un media con i dati del file .iso che quindi è bootabile)
- L'immagine ISO è un'immagine live, se usiamo il pen drive possiamo provarlo su chiavetta senza installarlo sul nostro sistema bootandolo da chiavetta 
1. Opzione di installazione classica 
    - Dobbiamo installare un SO, come facciamo? 
    - Tuttavia, nella maggior parte dei casi avremo nel mondo reale un'infrastruttura che funziona già, con un suo strato di virtualizzazione, e non partiremo da un sistema vuoto ma avvieremo un sistema che è già installato 
    - La configurazione non è un problema, si può rifare 
    -Creiamo una macchina virtuale esattamente come faremmo ad avviare un sistema con un pen drive 

- Com'è configurato il laboratorio? 
    - usiamo la shell (apri con Ctrl Alt T)
    - `df`: disk free permette di vedere le partizioni montate sul pc 
        (nel computer del lab ci interessano, /home/<username>, le /home stanno su un server di rete (192.168.123.234:/linuxHome/<username>), poi c'è /<indirizzo>/large <indirizzo>/OVA_01 contiene file di sola lettura come punto di partenza per creare cose )
    - Tutto quello che faccio sulla macchina di laboratorio, incide su un file system in rete 
        * Se installo un file .iso su OVA_1 tutti assieme, leggiamo il file in sola lettura e scriviamo i dati su /large, succede che il bottleneck di rete che si crea farà sì che non funzioni nulla 

### Esempio: installo Ubuntu 
- Ho bisogno di un computer virtuale da installare (su virtualbox)
- Creo una nuova macchina virtuale (gli do' un nome, fa machine new, controlla sul pc di lab che ci sia large nel path)
- Voglio xubuntu (vedi directory OVA_1) selezionandolo Linux si accorge di ciò 
- Vogliamo fare una installazione supervisionata (clicchiamo su Skip Unattended Installation)
- Il virtualizzatore ci fa scegliere quanta RAM dare e quanti processori mettere (occhio al proprio sistema operativo)
- Per quanto riguarda i dischi, si può usare uno che hai già, o crearne uno 
    - La virtualizzazione ha un bel vantaggio, perchè il contenuto del disco virtuale è un file del virtualizzatore che memorizza tutte queste informazioni (e non un disco fisico) 
    - Posso scegliere se fare "Preallocate full size": virtualbox genere un file di 25GB (o altri GB) e lo riempe di zeri, riservando quello spazio sulla macchina ospite e non si potrà fare più nulla 
    - Se invece non lo scelgo, avrò un file vuoto che può crescere di dimensione 
        + difetti di questo approccio: è più lento  perchè ogni volta che devo fare una scrittura non ho lo spazio che mi serve e l'hypervisor deve cercarlo, l'altro è rischiare di fare overbooking, se faccio molte macchine virtuali lo spazio libero su disco prima o poi si esaurirà (nonostante ciò è un vantaggio dei sistemi di virtualizzazione quello di avere più macchine)
- Creo la macchina, facendo un ultima verifica che il disco sia su /large 
- La macchina virtuale creata come impostazione di rete vede quelle che gli da' virtualbox 
    + Adapter 1 è collegato al NAT, la macchina virtuale crede di avere una scheda di rete ethernet 
- Per installarlo, Xubuntu Minimale così abbiamo i pacchetti essenziali 
- La parte di installazione del disco è critica, perchè quando noi facciamo "Erase disk and install Xubuntu" è sicura perchè abbiamo un disco virtuale (se facciamo il dual boot, lo facciamo in manuale)
- Si sceglie il nome per il proprio utente (e altre info di cui non servono appunti, come il fuso orario)
- Se si vuole vedere gli effetti dell'installazione vai sul path di virtualbox, nella directory con il nome della macchina virtuale e si fa `ls -lh` e si vede l'immagine del disco che cresce 
- Alternativa a VirtualBox: WSL  

### Accesso all'hardware 
- Linux usa le periferiche di storage: ci sono una serie di pratiche che permettono all'utente di visualizzare le periferiche di storage (dischi), questa vanno a interagire con l'hardware 
    - cos'è il device driver: è un interprete/traduttore, parla il linguaggio delle system call che sono universale (open/close read/write sync) dove in linux tutto è un file
    da una lato c'è il linguaggio dell'hardware, con una sync si sposta la testina del disco.
    Una volta che abbiamo individuato una famiglia di dischi, le operazioni sono le stesse ma i comandi sono diversi (es. famiglia degli hard disk, famiglia delle schede di rete) 
    - In linux i device driver sono dei moduli caricabili dinamicamente (es. /lib/modules) 
    (es. acpi è il power management, sono directory che contengono altri file, estensione .ko (kernel-object))
    - file .ko : kernel-object, sono file che vengono caricati nel kernel e gli "insegnano" a parlare una lingua
        (es. se io carico un file potrei insegnare al kernel a parlare con un certo modello di scheda di rete)
        * Il kernel riconosce quasi sempre automaticamente i moduli da caricare 
        (dai un occhio alle man pages)
    - dispositivi a blocchi: 
        - E' un elenco di blocchi numerati
            * quando lavoriamo con i dati non vogliamo dire che una certa informazione sia memorizzata tra blocco n1 e blocco n2, abbiamo invece un ulteriore strato di astrazione, cioè il file system che mi consente di usare comandi a più alto livello per effettuare operazioni sul disco 
        - hard disk, dischi ottici, pen drive 
        - dischi logici: RAID 
    - dispositivi a caratteri: 
        * tastiera (device a caratteri di input): se digito un certo numero di caratteri, vengono memorizzati in un certo buffer e viene "consumato" un valore alla volta ogni valore nel buffer, spariscono 

    - I moduli registrano degli handler per la sistem call
        * Quando un modulo viene caricato, indica la propria interpretazione della system call (implementazione)
        * es. read diversa tra mouse o tastiera per esempio, per sapere quale fare ci sono dei file speciali es. dev/ 
            - es. dev/block/ ci sono link simbolici, c'è il major/minor number: è un numero che rappresenta la tipologia di dispositivo e un numero che rappresenta l'istanza del dispositivo 
            (es. major num: 259 e varie istanza che posso riconoscere 0,1,2, per esempio)
            `ls -l /dev/block
            `brw-rw---- 1 root disk 259, 0 Feb 17 12:06 /dev/nvme0n1
            - La open alla riga 259 ci sarà il codice (implementazione) della system call per quel 
            - /dev/null il kernel butta via quello che gli sto mandando
            
### Partizionamento
- suddivisione di un hard disk in tanti contenitori stagni molto semplici divisi gli uni dagli altri 
- Scrive informazioni sul disco, una certa partizione dove inizia e dove finisce 
- ci possono essere dei tag, che mettono un appunto su come pensiamo di usare tale partizione (ci sono due sistemi di partizionamento)
    * Master boot record, all'inizio del disco c'è un piccolo settore che contiene il codice per avviare il sistema, tale settore è riconoscibile dal BIOS, che individua una periferica da cui fare il boot, all'interno del MBR c'è una tabella delle partizioni in cui è stato suddiviso un hard disk (in passato ce ne potevano essere 4, dove una di queste può essere una partizione estesa)
    * GPT, sistema di partizionamento "GUID Partition Table Scheme" 

### Device file per dischi e partizioni
- Se ci sono dischi tradizionali, attaccati col cavo, questi compaiono con il prefisso sd-* nella directory /dev/ 
- Quando creiamo partizioni del disco, questi compaiono con un numero aggiuntivo 
- dischi nVME/M.2 ad alta prestazione, compaiono con vari numeri che indicano per esempio i due livelli di partizionamento: quello fisico e quello logico fatto dal sistema operativo 

### Criteri di partizionamento
- criterio minimale: faccio una partizione e basta 
- Se abbiamo bisogno di memoria virtuale, possiamo allocare un file per la memoria virtuale, se fatta con una partizione è più efficiente 
- La memoria virtuale serve ancora? All'inizio di Linux sì per fare multitasking, ma con l'aumento della velocità del computer è diventata non fondamentale 
    - inoltre se hai la swap per la memoria virtuale utile se il kernel si blocca se ha finito la RAM 
    - Linux usa la swap per memorizzare ciò che facciamo quando il pc va in ibernazione 
    - Si può usare anche la swap perchè i file su disco sono troppi
- Formattare un disco: vuol dire creare i metadati di un file system 

### Filesystem ext3 
- Filesystem di linux che ha il jounaling, cioè tutte le volte che si modifica un file i metadati del file system si aggiornano in modo transazionale -> rimane traccia delle operazioni intermedie che non sono state portate a termine correttamente e si può fare rollback 
(in precedenza i metadati, cioè blocchi liberi, i-node, ecc... richiedeva molto tempo perchè bisogna scandire tutto il disco)
- Il journaling permette di fare rollback e ripstinare una situazione coerente, avendo un file system coerente, non garantisce di NON perdere dati ma di avere una situazione coerente (se un blocco libero è davvero tale, non è riempito quindi)

### Mount 
- Per utilizzare un file system c'è il mount: 
    * in Windows se formatti una partizione, sappiamo dove trovare lo spazio perchè nasce una nuova unità di volume 
    * In Linux dobbiamo specificare dove vogliamo rendere disponibile lo spazio di una certa partizione: (creo un mount point)
        - esempio: monto /dev/sda1 su / 

