#!/usr/bin/env python3
"""Mazzo Anki: classi nested / inner / local / anonime nei 4 linguaggi.

Fonti: il documento 'robe_inner_nested_local_robe.txt' (Python, C, C++) e
la parte Java fornita a parte; piu' le verifiche fatte compilando ed
eseguendo (marcate [Verificato]).
"""

import html

OUT = ("/home/giovanni/Documents/università/AppuntiDelBasta/Anno3/"
       "ingegneria_del_software/nested-local-anonime-anki.txt")

HEADER = """#separator:tab
#html:true
#notetype:Basic
#deck:Ingegneria del Software::Nested, Inner, Local e Anonime (Java-C++-Python-C)
"""


def code(src: str) -> str:
    src = src.strip("\n")
    esc = html.escape(src, quote=False)
    out = []
    for line in esc.split("\n"):
        stripped = line.lstrip(" ")
        out.append("&nbsp;" * (len(line) - len(stripped)) + stripped)
    return ('<br><div style="text-align:left; display:inline-block; '
            'margin:6px 0;"><code>' + "<br>".join(out) + "</code></div>")


def c(x: str) -> str:
    return "<code>" + html.escape(x, quote=False) + "</code>"


CARDS = []


def card(tag, front, back):
    CARDS.append((tag + " " + front.strip(), back.strip()))


# =====================================================================
# JAVA — la tassonomia
# =====================================================================

card("[Java][Teoria]",
     "Disegna la <b>tassonomia</b> delle classi annidate in Java.",
     code("""
Nested classes
|-- Static nested class
`-- Inner class
    |-- Member inner class
    |-- Local class
    `-- Anonymous class
""") + "<br>&bull; <b>nested statica</b>: dichiarata con " + c("static") + "<br>"
     "&bull; <b>inner class</b>: NON statica<br>"
     "&bull; <b>local class</b>: inner dichiarata dentro un metodo/blocco<br>"
     "&bull; <b>anonymous class</b>: una classe locale <b>senza nome</b>"
     "<br><br><b>Attenzione al vocabolario:</b> tutte le inner sono nested, "
     "ma <b>non</b> tutte le nested sono inner --- quelle "
     + c("static") + " non lo sono.")

card("[Java][Trabocchetto]",
     "Vero o falso: <i>tutte le nested class sono inner class</i>.",
     "<b>FALSO.</b>" + code("""
static class A { }   // nested, ma NON inner
class B { }          // nested E inner
""") + "Le <b>static nested class</b> non sono inner class, perche' non sono "
     "legate a un'istanza della classe esterna.<br><br>"
     "E' l'errore di vocabolario piu' comune sull'argomento.")

card("[Java][Teoria]",
     "Quali sono i <b>vantaggi</b> di usare classi annidate?",
     "&bull; maggiore <b>organizzazione</b> del codice<br>"
     "&bull; migliore <b>incapsulamento</b><br>"
     "&bull; <b>accesso diretto</b> ai membri della classe esterna<br>"
     "&bull; riduzione del numero di classi <b>visibili all'esterno</b><br>"
     "&bull; possibilita' di modellare componenti strettamente collegati<br><br>"
     "Si usano quando una classe ha senso <b>solo in relazione</b> a "
     "un'altra (es. " + c("Motore") + " dentro " + c("Automobile") + ").")

# --- static nested ---------------------------------------------------

card("[Java][Teoria]",
     "Cos'e' una <b>static nested class</b>, e a cosa puo' accedere?",
     "Una classe dichiarata dentro un'altra con la keyword " + c("static") +
     ".<br><br><b>Caratteristica principale:</b> NON e' associata a una "
     "specifica <b>istanza</b> della classe esterna.<br><br>"
     "Percio' puo' accedere <b>direttamente solo ai membri statici</b> "
     "dell'esterna." + code("""
public class Esterna {
    private static int valoreStatico = 10;
    private int valoreIstanza = 20;

    static class Annidata {
        void mostra() {
            System.out.println(valoreStatico);      // OK
            // System.out.println(valoreIstanza);   // ERRORE
        }
    }
}
"""))

card("[Java][Cosa fa?]",
     code("""
public class Esterna {
    static class Annidata {
        void mostraMessaggio() {
            System.out.println("Sono una static nested class");
        }
    }
}
""") + "<br>Come si crea un oggetto di " + c("Annidata") + "?",
     code("""
Esterna.Annidata oggetto = new Esterna.Annidata();
oggetto.mostraMessaggio();
""") + "<br><b>NON serve</b> creare prima un oggetto di " + c("Esterna") +
     ".<br><br>Il nome e' <b>qualificato dalla CLASSE</b> "
     "(" + c("Esterna.Annidata") + "), non da un'istanza.")

card("[Java][Trabocchetto]",
     "Una static nested class puo' accedere ai membri <b>private</b> della "
     "classe esterna?",
     "<b>SI'</b> --- purche' disponga di un'<b>istanza</b>, quando il membro "
     "non e' statico." + code("""
public class Conto {
    private double saldo = 1000;          // PRIVATO

    static class Controllore {
        void controlla(Conto conto) {
            System.out.println(conto.saldo);   // OK!
        }
    }
}
""") + "<b>Il punto:</b> l'incapsulamento vale verso il <b>mondo esterno</b>, "
     "non fra classe esterna e classe annidata --- che sono considerate "
     "parte della stessa unita' di codice.")

card("[Java][Scrivi]",
     "<b>Scrivi</b> il pattern <b>Builder</b>, l'uso tipico di una static "
     "nested class.",
     code("""
public class Utente {
    private final String nome;
    private final int eta;

    private Utente(Builder builder) {       // costruttore PRIVATO
        this.nome = builder.nome;
        this.eta  = builder.eta;
    }

    public static class Builder {           // STATIC: non serve un Utente
        private String nome;
        private int eta;

        public Builder nome(String nome) {
            this.nome = nome;
            return this;                    // fluent interface
        }
        public Builder eta(int eta) {
            this.eta = eta;
            return this;
        }
        public Utente build() {
            return new Utente(this);
        }
    }
}
""") + "Uso:" + code("""
Utente utente = new Utente.Builder()
        .nome("Luca")
        .eta(30)
        .build();
""") + "<b>Perche' static:</b> il Builder costruisce un " + c("Utente") +
     ", quindi non puo' dipendere da un " + c("Utente") + " gia' esistente.")

# --- inner class -----------------------------------------------------

card("[Java][Teoria]",
     "Cos'e' una <b>inner class</b>, e in cosa differisce da una static "
     "nested?",
     "Una classe annidata <b>NON</b> dichiarata " + c("static") + ".<br><br>"
     "<b>Differenza fondamentale:</b> ogni oggetto della inner class e' "
     "collegato a uno <b>specifico oggetto</b> della classe esterna.<br><br>"
     "E' come se ogni oggetto interno contenesse implicitamente un "
     "<b>riferimento</b> all'oggetto esterno che lo ha creato:" + code("""
Documento
    `-- riferimento implicito a Persona
"""))

card("[Java][Cosa fa?][Trabocchetto]",
     code("""
public class Esterna {
    class Interna { void saluta() { } }
}

// nel main:
Esterna.Interna a = new Esterna.Interna();        // (1)

Esterna esterna = new Esterna();
Esterna.Interna b = esterna.new Interna();        // (2)
""") + "<br>Quale delle due righe compila?",
     "Solo la <b>(2)</b>.<br><br>"
     "La riga (1) e' un <b>errore</b>. Messaggio reale:" +
     code("error: non-static variable this cannot be<br>"
          "       referenced from a static context") +
     "Una inner class <b>richiede un'istanza esterna</b> a cui "
     "agganciarsi.<br><br>"
     "La sintassi corretta e' particolare e va ricordata:" +
     code("esterna.new Interna()") +
     "cioe' <code>new</code> preceduto dall'<b>oggetto</b> esterno "
     "(non dalla classe).")

card("[Java][Teoria]",
     "A cosa puo' accedere una <b>inner class</b> della classe esterna?",
     "A <b>tutto</b>:<br>"
     "&bull; campi di <b>istanza</b><br>"
     "&bull; metodi di <b>istanza</b><br>"
     "&bull; membri <b>statici</b><br>"
     "&bull; membri <b>privati</b>" + code("""
public class Contatore {
    private int valore = 0;               // privato, di istanza

    public class Incrementatore {
        public void incrementa() { valore++; }     // accesso diretto!
        public void mostra() { System.out.println(valore); }
    }
}
""") + "Nessun bisogno di passare nulla: il riferimento all'esterno e' "
     "<b>implicito</b>.")

card("[Java][Cosa fa?]",
     code("""
Contatore c1 = new Contatore();
Contatore c2 = new Contatore();

Contatore.Incrementatore i1 = c1.new Incrementatore();
Contatore.Incrementatore i2 = c2.new Incrementatore();

i1.incrementa();
i1.incrementa();
i2.incrementa();
""") + "<br>Su quali stati lavorano <code>i1</code> e <code>i2</code>?",
     "<b>Su stati DIVERSI.</b><br><br>"
     "&bull; " + c("i1") + " modifica il valore di " + c("c1") + " &rarr; 2<br>"
     "&bull; " + c("i2") + " modifica il valore di " + c("c2") + " &rarr; 1<br><br>"
     "Ogni oggetto inner e' legato all'<b>istanza esterna che lo ha "
     "creato</b>: due oggetti esterni danno due \"mondi\" separati."
     "<br><br><i>(verificato eseguendo un caso analogo: la stessa strategia "
     "inner dava 20 e poi 1 dopo aver cambiato il campo dell'esterno)</i>")

card("[Java][Cosa fa?][Esame]",
     code("""
public class Esterna {
    private int valore = 10;

    class Interna {
        private int valore = 20;

        void mostra() {
            int valore = 30;
            System.out.println(valore);
            System.out.println(this.valore);
            System.out.println(Esterna.this.valore);
        }
    }
}
""") + "<br>Cosa stampa?",
     code("""
30
20
10
""") + "<br>&bull; " + c("valore") + " &rarr; la <b>variabile locale</b> (30)<br>"
     "&bull; " + c("this.valore") + " &rarr; il campo dell'oggetto "
     "<b>interno</b> (20)<br>"
     "&bull; " + c("Esterna.this.valore") + " &rarr; il campo dell'oggetto "
     "<b>esterno</b> associato (10)<br><br>"
     "<b>" + c("Esterna.this") + " e' la sintassi chiave delle inner class:</b> "
     "e' l'unico modo di nominare esplicitamente l'enclosing instance.<br><br>"
     "Il fenomeno si chiama <b>shadowing</b>: un nome piu' interno nasconde "
     "quello piu' esterno.")

card("[Java][Trabocchetto]",
     "Perche' una <b>inner class</b> puo' causare un <b>memory leak</b>?",
     "Perche' conserva un <b>riferimento implicito</b> all'oggetto esterno, "
     "che quindi non puo' essere liberato dal garbage collector." + code("""
public class Contenitore {
    private byte[] dati = new byte[10_000_000];   // 10 MB

    public class Elemento {
        void mostra() { System.out.println(dati.length); }
    }
}

Contenitore contenitore = new Contenitore();
Contenitore.Elemento elemento = contenitore.new Elemento();
contenitore = null;        // <- l'oggetto NON viene liberato!
""") + "L'oggetto esterno resta <b>raggiungibile attraverso</b> "
     + c("elemento") + ", quindi i 10 MB restano allocati.<br><br>"
     "<b>Regola pratica:</b> se la classe annidata non ha bisogno "
     "dell'istanza esterna, dichiarala <b>" + c("static") + "</b>.")

card("[Java][Teoria]",
     "Quali <b>modificatori di accesso</b> puo' avere una classe annidata? E "
     "una classe top-level?",
     "<b>Classe annidata (membro):</b> tutti e quattro" + code("""
public class Esempio {
    public class Pubblica { }
    protected class Protetta { }
    private class Privata { }
    class PackagePrivate { }
}
""") + "<b>Classe top-level:</b> solo " + c("public") + " oppure "
     "package-private (nessun modificatore).<br><br>"
     "<b>Non puo'</b> essere direttamente " + c("private") + " ne' "
     + c("protected") + ": non avrebbe senso, perche' non c'e' nessuna "
     "classe che la racchiuda rispetto a cui essere privata.")

# --- local class -----------------------------------------------------

card("[Java][Teoria]",
     "Cos'e' una <b>local class</b> e qual e' il suo ambito di visibilita'?",
     "Una classe dichiarata dentro un <b>metodo</b>, un <b>costruttore</b> o "
     "un <b>blocco</b>." + code("""
public void esegui() {
    class ClasseLocale {
        void saluta() { System.out.println("Sono locale"); }
    }
    ClasseLocale oggetto = new ClasseLocale();
    oggetto.saluta();
}
""") + "<b>Visibilita':</b> solo <b>dopo la sua dichiarazione</b> e "
     "<b>dentro il blocco</b> che la contiene." + code("""
public void esempio() {
    // Locale a = new Locale();   // ERRORE: non ancora dichiarata
    class Locale { }
    Locale b = new Locale();      // OK
}
""") + "In un altro metodo il nome <b>non esiste</b>.")

card("[Java][Teoria][Esame]",
     "Una local class puo' accedere alle <b>variabili locali</b> del metodo? "
     "A quale condizione?",
     "<b>SI'</b>, ma solo se sono <b>" + c("final") + "</b> oppure "
     "<b>effectively final</b>.<br><br>"
     "Una variabile e' <i>effectively final</i> quando viene assegnata "
     "<b>una sola volta</b> e non viene mai piu' modificata." + code("""
public void mostra() {
    String messaggio = "Ciao";        // effectively final: OK
    class Stampante {
        void stampa() { System.out.println(messaggio); }
    }
    new Stampante().stampa();
}
""") + "Questo invece <b>non compila</b>:" + code("""
public void mostra() {
    String messaggio = "Ciao";
    messaggio = "Buongiorno";         // RIASSEGNATA -> non piu' eff. final
    class Stampante {
        void stampa() { System.out.println(messaggio); }   // ERRORE
    }
}
""") + "Messaggio reale del compilatore:" +
     code("error: local variables referenced from an inner<br>"
          "       class must be final or effectively final"))

card("[Java][Teoria][Esame]",
     "<b>Perche'</b> Java richiede che le variabili catturate siano "
     "<code>final</code> o effectively final?",
     "Perche' le variabili locali vivono nello <b>stack</b> del metodo e "
     "<b>smettono di esistere</b> quando il metodo termina --- ma l'oggetto "
     "della classe locale <b>puo' sopravvivergli</b>." + code("""
public Runnable creaOperazione() {
    int valore = 10;
    class Operazione implements Runnable {
        public void run() { System.out.println(valore); }
    }
    return new Operazione();      // il metodo finisce, l'oggetto resta
}
""") + "Quindi Java <b>non usa la variabile</b>: ne memorizza una "
     "<b>COPIA</b> dentro l'oggetto.<br><br>"
     "Se la variabile potesse cambiare, si creerebbe ambiguita' fra il "
     "<b>valore originale</b> e il <b>valore copiato</b>: la regola "
     "elimina l'incoerenza alla radice.")

card("[Java][Scrivi]",
     "<b>Scrivi</b> una local class dichiarata dentro un <b>costruttore</b>, "
     "usata per validare un parametro.",
     code("""
public class Prodotto {

    public Prodotto(String nome) {

        class Validatore {                     // esiste solo qui
            boolean valido() {
                return nome != null && !nome.isBlank();
            }
        }

        Validatore validatore = new Validatore();

        if (!validatore.valido()) {
            throw new IllegalArgumentException("Nome non valido");
        }
    }
}
""") + "<b>Perche' local:</b> il validatore serve <b>solo durante la "
     "costruzione</b>; non ha senso esporlo come tipo nel resto della "
     "classe. Nota che cattura il parametro " + c("nome") + " (effectively "
     "final).<br><br>Una local class si puo' dichiarare anche in un blocco "
     + c("if") + ", " + c("for") + ", " + c("while") + ", " + c("try") + ".")

# --- anonymous -------------------------------------------------------

card("[Java][Teoria]",
     "Cos'e' una <b>anonymous class</b>?",
     "Una classe <b>senza nome</b>, dichiarata e <b>istanziata nello stesso "
     "momento</b>. E' considerata una forma particolare di local class." +
     code("""
Saluto saluto = new Saluto() {
    @Override
    public void saluta() { System.out.println("Ciao!"); }
};
""") + "<b>Attenzione alla semantica:</b> la sintassi " + c("new Saluto() {...}") +
     " <b>non</b> crea un oggetto dell'interfaccia " + c("Saluto") +
     ": crea un oggetto di una <b>classe anonima che la implementa</b>.<br><br>"
     "Puo' anche <b>estendere una classe</b>, non solo implementare "
     "un'interfaccia.")

card("[Java][Trabocchetto]",
     "Una classe anonima puo' avere un <b>costruttore</b>?",
     "<b>NO</b> --- perche' non possiede un nome, e il costruttore deve "
     "avere lo stesso nome della classe.<br><br>"
     "Puo' pero' usare un <b>blocco di inizializzazione</b>:" + code("""
Animale animale = new Animale() {
    {
        System.out.println("Inizializzazione della classe anonima");
    }
    @Override
    public void verso() { System.out.println("Miao"); }
};
"""))

card("[Java][Trabocchetto]",
     code("""
Animale animale = new Animale() {
    private int energia = 100;

    void dormi() { energia += 10; }        // metodo NUOVO

    @Override
    public void verso() { System.out.println("Energia: " + energia); }
};

animale.dormi();     // ???
""") + "<br>L'ultima riga compila?",
     "<b>NO.</b><br><br>Il metodo " + c("dormi()") + " appartiene davvero "
     "alla classe anonima, ma il <b>tipo statico</b> della variabile e' "
     + c("Animale") + ", che non lo dichiara.<br><br>"
     "Una classe anonima <b>puo'</b> dichiarare nuovi campi e metodi, ma "
     "sono <b>irraggiungibili dall'esterno</b>: non esiste un nome di tipo "
     "con cui riferirsi ad essa.<br><br>"
     "E' un limite intrinseco dell'anonimato --- ed e' il motivo per cui, se "
     "servono membri aggiuntivi accessibili, si usa una local class con nome.")

card("[Java][Teoria][Esame]",
     "Qual e' la <b>differenza nell'uso di <code>this</code></b> fra una "
     "classe anonima e una lambda?",
     "<b>Classe anonima:</b> " + c("this") + " indica l'<b>oggetto anonimo</b>."
     + code("""
Runnable r = new Runnable() {
    public void run() { System.out.println(this); }   // l'oggetto anonimo
};
""") + "<b>Lambda:</b> " + c("this") + " indica l'oggetto della <b>classe che "
     "contiene</b> la lambda." + code("""
Runnable r = () -> System.out.println(this);   // l'oggetto di Esempio
""") + "<b>Le lambda NON introducono un nuovo contesto per <code>this</code>.</b>"
     "<br><br>E' la ragione principale per cui una lambda <b>non</b> e' "
     "sempre sostituibile a una classe anonima, anche quando l'interfaccia "
     "e' funzionale.")

card("[Java][Teoria]",
     "Quando si puo' sostituire una anonymous class con una <b>lambda</b>?",
     "Quando l'interfaccia ha <b>un solo metodo astratto</b> (interfaccia "
     "funzionale)." + code("""
@FunctionalInterface
public interface Operazione { int esegui(int a, int b); }

// anonymous class
Operazione somma = new Operazione() {
    @Override
    public int esegui(int a, int b) { return a + b; }
};

// lambda: equivalente e piu' breve
Operazione somma = (a, b) -> a + b;
""") + "<b>Usa la lambda quando:</b> il tipo e' un'interfaccia funzionale, "
     "non serve uno stato complesso, e <b>non serve un nuovo significato di "
     + c("this") + "</b>.")

card("[Java][Teoria][Esame]",
     "Completa la <b>tabella di confronto</b> dei quattro tipi.",
     "<table border=1 cellpadding=4 style='border-collapse:collapse'>"
     "<tr><th>Tipo</th><th>static</th><th>Richiede oggetto esterno</th>"
     "<th>Accesso ai campi esterni</th><th>Ambito</th></tr>"
     "<tr><td>Static nested</td><td>Si'</td><td>No</td>"
     "<td>solo statici</td><td>corpo della classe</td></tr>"
     "<tr><td>Member inner</td><td>No</td><td><b>Si'</b></td>"
     "<td>Si'</td><td>corpo della classe</td></tr>"
     "<tr><td>Local</td><td>No</td><td>Si', se in contesto di istanza</td>"
     "<td>Si'</td><td>metodo o blocco</td></tr>"
     "<tr><td>Anonymous</td><td>No</td><td>dipende dal contesto</td>"
     "<td>Si'</td><td>l'espressione in cui nasce</td></tr>"
     "</table>")

card("[Java][Verificato]",
     "Che <b>nomi</b> genera il compilatore per le varie forme? "
     "(<code>getClass().getName()</code>)",
     "Output reale (verificato con JDK 21):" + code("""
static nested -> Esempio$Somma
inner         -> Esempio$MoltiplicaPerCampo
local         -> Esempio$1SottrazioneLimitata
anonima       -> Esempio$1
lambda        -> Esempio$$Lambda/0x000000003f041000
""") + "<br>&bull; nested e inner: il <b>proprio nome</b><br>"
     "&bull; <b>local</b>: un <b>numero DAVANTI</b> al nome (serve perche' due "
     "metodi diversi possono avere local class omonime)<br>"
     "&bull; <b>anonima</b>: <b>solo</b> un numero<br>"
     "&bull; <b>lambda</b>: contiene un <b>indirizzo</b>, e <b>non produce "
     "alcun file <code>.class</code></b> --- e' generata a runtime dalla JVM "
     "(<code>invokedynamic</code> + <code>LambdaMetafactory</code>).<br><br>"
     "<b>Conclusione:</b> una lambda NON e' zucchero sintattico per una "
     "classe anonima: sono meccanismi diversi.")

# =====================================================================
# C++
# =====================================================================

card("[C++][Teoria][Esame]",
     "In C++, una <b>nested class</b> richiede un oggetto della classe "
     "esterna? Conserva <code>this</code> dell'esterna?",
     "<b>No</b> a entrambe." + code("""
Esterna::Annidata oggetto;      // basta questo
""") + "In C++ una classe annidata e' <b>sempre</b> l'equivalente di una "
     + c("static") + " nested class di Java: e' solo una questione di "
     "<b>scope e naming</b>.<br><br>"
     "Per avere un legame con l'oggetto esterno bisogna <b>scriverlo a "
     "mano</b>, memorizzando un " + c("Esterna&amp;") + " o un "
     + c("Esterna*") + ".<br><br>"
     "<b>In C++ NON esiste l'inner class di Java.</b>")

card("[C++][Cosa fa?]",
     code("""
struct E {
    int v = 1;
    struct N {
        int f() { return v; }
    };
};
""") + "<br>Compila?",
     "<b>NO.</b> Errore reale:" +
     code("error: invalid use of non-static data member 'E::v'") +
     "La nested " + c("N") + " non ha alcuna <b>enclosing instance</b>: "
     + c("v") + " appartiene a un oggetto " + c("E") + " specifico, e li' "
     "non ce n'e' nessuno.<br><br><b>Fix:</b> passarlo esplicitamente." + code("""
struct N {
    int f(const E& e) { return e.v; }
};
"""))

card("[C++][Trabocchetto]",
     "Una nested class C++ puo' accedere ai membri <b>privati</b> della "
     "classe esterna? E viceversa?",
     "<b>Nested &rarr; esterna: SI'</b> (dal C++11 ha gli stessi diritti di "
     "un membro).<br><br>"
     "<b>Esterna &rarr; nested: NO</b>, non automaticamente!<br><br>"
     "<b>L'accesso non e' reciproco.</b> Per permettere alla classe esterna "
     "di vedere i privati della nested serve una dichiarazione "
     + c("friend") + ".<br><br>"
     "<i>Verificato: una nested puo' incrementare un "
     "<code>contatoreStatico_</code> privato dell'enclosing.</i>")

card("[C++][Scrivi]",
     "<b>Scrivi</b> come si <b>simula una inner class Java</b> in C++.",
     code("""
class Esterna {
    int valore = 42;                    // privato
public:
    class Simulata {
        Esterna* esterno_;              // il legame, ESPLICITO
    public:
        explicit Simulata(Esterna* e) : esterno_(e) {}
        int leggi() const {
            return esterno_->valore;    // accede al privato: OK
        }
    };

    // factory che imita la sintassi Java 'esterno.new Inner()'
    Simulata creaSimulata() { return Simulata(this); }
};
""") + "Si puo' usare un <b>riferimento</b> (" + c("Esterna&amp;") + ") invece "
     "di un puntatore: piu' sicuro (non puo' essere nullo) ma rende la "
     "classe <b>non assegnabile</b>.<br><br>"
     "<b>Attenzione alla durata:</b> se l'oggetto esterno muore prima, il "
     "puntatore diventa <b>pendente</b> (dangling) --- problema che in Java "
     "il garbage collector elimina.")

card("[C++][Teoria][Esame]",
     "Una <b>local class</b> C++ puo' usare le variabili locali della "
     "funzione che la contiene?",
     "<b>NO.</b> Errore reale del compilatore:" +
     code("error: use of local variable with automatic storage<br>"
          "       from containing function") +
     "Puo' usare <b>solo</b>: variabili <code>static</code>, globali, "
     "<code>enum</code> e tipi.<br><br>"
     "<b>Il motivo:</b> una local class e' un <i>tipo</i>, e i suoi metodi "
     "sono funzioni ordinarie; non esiste alcun meccanismo che copi le "
     "variabili locali dentro l'oggetto.<br><br>"
     "In Java quel meccanismo esiste (cattura per valore delle "
     "<i>effectively final</i>). In C++ e' arrivato nel 2011 e si chiama "
     "<b>lambda</b>.<br><br>"
     "<b>Soluzione:</b> passare i dati <b>esplicitamente</b>, es. nel "
     "costruttore.")

card("[C++][Trabocchetto]",
     "Una local class C++ puo' avere <b>membri dati static</b>?",
     "<b>NO.</b> Errore reale:" +
     code("error: local class 'class g()::L' shall not have<br>"
          "       static data member 'int g()::L::m'") +
     "Un membro dati static richiederebbe una definizione a livello di "
     "<b>namespace</b>, che per una classe locale non e' esprimibile.<br><br>"
     "<b>Puo' invece</b> avere: metodi static, tipi annidati e costanti "
     "<code>static const</code> integrali inizializzate in linea.")

card("[C++][Teoria]",
     "Cos'e' davvero una <b>lambda</b> in C++?",
     "Il compilatore genera un <b>tipo senza nome</b> (<i>closure type</i>), "
     "<b>locale</b> allo scope in cui la lambda appare, con:<br>"
     "&bull; un " + c("operator()") + "<br>"
     "&bull; un membro per ogni variabile catturata<br><br>"
     "E' quindi letteralmente una <b>classe locale anonima con cattura</b>: "
     "risolve il limite della local class e fornisce l'equivalente della "
     "classe anonima di Java.<br><br>"
     "<b>Verificato (sizeof):</b>" + code("""
lambda che cattura un int  =  4 byte   (solo la cattura, NESSUN vptr)
lambda senza cattura       =  1 byte   (oggetto vuoto)
classe con metodo virtuale =  8 byte   (il vptr)
std::function<int(int,int)> = 32 byte  (type erasure)
"""))

card("[C++][Teoria][Esame]",
     "Cosa significano le quattro forme di <b>cattura</b> "
     "<code>[x]</code>, <code>[&amp;x]</code>, <code>[=]</code>, "
     "<code>[&amp;]</code>?",
     "&bull; " + c("[x]") + " &rarr; cattura <b>x per valore</b> (una copia)<br>"
     "&bull; " + c("[&x]") + " &rarr; cattura <b>x per riferimento</b><br>"
     "&bull; " + c("[=]") + " &rarr; cattura <b>tutto</b> per valore "
     "(automaticamente, solo le variabili usate)<br>"
     "&bull; " + c("[&]") + " &rarr; cattura <b>tutto</b> per riferimento<br><br>"
     "Si possono <b>mischiare</b>:" + code("""
int a = 10, b = 20;
auto operazione = [a, &b]() { b += a; };   // a copiato, b per riferimento
""") + "<b>Consiglio:</b> " + c("[=]") + " e " + c("[&]") + " sono comode ma "
     "rendono meno chiaro quali variabili si usino davvero. Meglio la "
     "cattura <b>esplicita</b>.")

card("[C++][Cosa fa?]",
     code("""
int numero = 10;

auto mostra = [numero]() { std::cout << numero << '\\n'; };

numero = 20;
mostra();
""") + "<br>Cosa stampa?",
     "Stampa <b>10</b>.<br><br>"
     "La lambda ha catturato il <b>valore al momento della sua "
     "creazione</b>: conserva una <b>copia</b>, non un collegamento.<br><br>"
     "Con la cattura per riferimento invece:" + code("""
int numero = 10;
auto incrementa = [&numero]() { ++numero; };
incrementa();
std::cout << numero;      // stampa 11
""") + "qui la lambda lavora sulla <b>variabile originale</b>.")

card("[C++][Trabocchetto][Esame]",
     "A cosa serve <code>mutable</code> in una lambda?",
     "Per impostazione predefinita l'" + c("operator()") + " generato e' "
     "<b>const</b>: una variabile catturata <b>per valore</b> non puo' essere "
     "modificata." + code("""
auto operazione = [numero]() {
    // ++numero;      // ERRORE: operator() e' const
};
""") + "Con " + c("mutable") + " si puo':" + code("""
int numero = 10;
auto operazione = [numero]() mutable {
    ++numero;
    std::cout << numero << '\\n';      // stampa 11
};
operazione();
std::cout << numero << '\\n';          // stampa 10 !
""") + "<b>Punto chiave:</b> viene modificata <b>solo la copia interna</b> "
     "alla lambda. La variabile originale resta <b>invariata</b>.")

card("[C++][Teoria]",
     "Cos'e' una <b>init capture</b> (C++14)?",
     "Una cattura che <b>inizializza direttamente</b> una variabile membro "
     "della closure:" + code("""
auto operazione = [valore = 42]() {
    std::cout << valore << '\\n';
};
""") + "Serve soprattutto per <b>spostare</b> un oggetto dentro la lambda "
     "(cosa impossibile con le catture classiche):" + code("""
auto puntatore = std::make_unique<int>(42);

auto operazione = [p = std::move(puntatore)]() {
    std::cout << *p << '\\n';
};
"""))

card("[C++][Teoria]",
     "Cosa cattura <code>[this]</code> in una lambda dentro un metodo? E "
     "<code>[*this]</code>?",
     c("[this]") + " cattura il <b>puntatore</b> all'oggetto: la lambda "
     "accede ai membri dell'oggetto <b>originale</b>." + code("""
class Contatore {
    int valore = 10;
public:
    void mostra() {
        auto operazione = [this]() { std::cout << valore << '\\n'; };
        operazione();
    }
};
""") + c("[*this]") + " (da C++17) cattura una <b>copia dell'intero "
     "oggetto</b>.<br><br>"
     "<b>Differenza cruciale:</b> con " + c("[this]") + ", se l'oggetto muore "
     "prima della lambda, si ha un puntatore <b>pendente</b>. Con "
     + c("[*this]") + " la lambda e' autonoma.")

card("[C++][Trabocchetto]",
     "Qual e' il <b>rischio principale</b> della cattura per riferimento?",
     "La lambda puo' <b>sopravvivere</b> alle variabili catturate, "
     "producendo <b>riferimenti pendenti</b> (dangling) e <b>undefined "
     "behavior</b>." + code("""
std::function<void()> crea() {
    int locale = 42;
    return [&locale]() {          // PERICOLO
        std::cout << locale;      // 'locale' non esiste piu'!
    };
}
""") + "Quando la funzione ritorna, " + c("locale") + " e' distrutta: la "
     "lambda punta a memoria non piu' valida.<br><br>"
     "<b>Regola:</b> se la lambda puo' vivere piu' a lungo dello scope "
     "corrente (la si restituisce, la si memorizza, la si passa a un "
     "thread), cattura <b>per valore</b>.")

card("[C++][Trabocchetto]",
     "Elenca gli <b>errori comuni</b> con nested/local/lambda in C++.",
     "1. credere che esista un <b>riferimento implicito</b> all'oggetto "
     "esterno (non esiste: va scritto a mano)<br>"
     "2. usare " + c(".") + " invece di " + c("::") + " per il <b>tipo</b>: "
     "si scrive " + c("Esterna::Annidata") + ", non "
     + c("Esterna.Annidata") + "<br>"
     "3. restituire una lambda che cattura <b>per riferimento</b> variabili "
     "locali (dangling)<br>"
     "4. conservare un riferimento a un oggetto esterno <b>gia' "
     "distrutto</b><br>"
     "5. credere che una <b>classe locale catturi</b> le variabili (non lo "
     "fa: solo le lambda)<br>"
     "6. usare cattura per riferimento senza controllare la <b>durata</b><br>"
     "7. usare " + c("std::function") + " <b>sempre</b>: introduce type "
     "erasure e un costo (32 byte + possibile allocazione) spesso inutile --- "
     "se il tipo e' noto, " + c("auto") + " basta")

# =====================================================================
# PYTHON
# =====================================================================

card("[Python][Teoria]",
     "Cos'e', tecnicamente, una <b>classe annidata</b> in Python?",
     "Semplicemente un <b>attributo</b> della classe esterna." + code("""
class Esterna:
    class Annidata:
        def saluta(self):
            print("Sono una classe annidata")

oggetto = Esterna.Annidata()
""") + "E' concettualmente identico a scrivere:" + code("""
class Annidata:
    pass

class Esterna:
    pass

Esterna.Annidata = Annidata
""") + "Il nome completo e' " + c("Esterna.Annidata") + " --- e' quindi puro "
     "<b>namespacing</b>, come le nested del C++.")

card("[Python][Cosa fa?][Esame]",
     code("""
class Esterna:
    def __init__(self):
        self.valore = 10

    class Annidata:
        def mostra(self):
            print(self.valore)

Esterna.Annidata().mostra()
""") + "<br>Stampa 10?",
     "<b>NO</b> --- solleva " + c("AttributeError") + ".<br><br>"
     "Dentro " + c("Annidata") + ", " + c("self") + " rappresenta un oggetto "
     "<b>Annidata</b>, non un oggetto <b>Esterna</b>.<br><br>"
     "<b>In Python NON esistono le inner class automatiche di Java:</b> una "
     "classe annidata <b>non</b> conserva alcun riferimento all'oggetto "
     "esterno.<br><br>"
     "<i>Verificato anche con un nome di classe: usando un attributo di "
     "classe non qualificato si ottiene</i> "
     + c("NameError: name '...' is not defined") + "<i>, perche' il corpo di "
     "una classe non crea uno scope annidato per la ricerca dei nomi.</i>")

card("[Python][Scrivi]",
     "<b>Scrivi</b> le due tecniche per far accedere una classe annidata "
     "all'oggetto esterno in Python.",
     "<b>1. Passare esplicitamente l'oggetto</b>" + code("""
class Esterna:
    def __init__(self):
        self.valore = 10

    class Annidata:
        def __init__(self, esterna):
            self.esterna = esterna          # il legame, ESPLICITO
        def mostra(self):
            print(self.esterna.valore)

e = Esterna()
Esterna.Annidata(e).mostra()        # 10
""") + "<b>2. Metodo factory nella classe esterna</b> (imita "
     + c("esterna.new Inner()") + " di Java)" + code("""
class Esterna:
    def __init__(self):
        self.valore = 10

    class Annidata:
        def __init__(self, esterna):
            self.esterna = esterna
        def mostra(self):
            print(self.esterna.valore)

    def crea_annidata(self):            # <- la factory
        return Esterna.Annidata(self)

Esterna().crea_annidata().mostra()      # 10
"""))

card("[Python][Trabocchetto][Esame]",
     code("""
class Conto:
    def __init__(self):
        self.__saldo = 1000

    class Controllore:
        def mostra(self, conto):
            print(conto.__saldo)        # ???
""") + "<br>Funziona?",
     "<b>NO.</b> E' il <b>name mangling</b>.<br><br>"
     "Un attributo che inizia con <b>due underscore</b> viene riscritto "
     "internamente aggiungendo il nome della classe <b>in cui il codice e' "
     "scritto</b>:<br>"
     "&bull; in " + c("Conto") + ": " + c("self.__saldo") + " &rarr; "
     + c("self._Conto__saldo") + "<br>"
     "&bull; in " + c("Controllore") + ": " + c("conto.__saldo") + " &rarr; "
     + c("conto._Controllore__saldo") + " &larr; <b>non esiste!</b><br><br>"
     "<b>Errore reale</b> (verificato):" +
     code("AttributeError: 'Conto' object has no attribute\n"
          "                '_Controllore__saldo'") +
     "<i>Il messaggio mostra letteralmente il nome mangled sbagliato.</i><br><br>"
     "Tecnicamente funzionerebbe " + c("conto._Conto__saldo") + ", ma e' "
     "<b>sconsigliato</b>.<br><br><b>Soluzione corretta:</b> esporre un "
     "metodo o una <code>property</code>." + code("""
class Conto:
    def __init__(self):
        self.__saldo = 1000

    @property
    def saldo(self):
        return self.__saldo

    class Controllore:
        def mostra(self, conto):
            print(conto.saldo)          # OK
"""))

card("[Python][Cosa fa?][Esame]",
     code("""
def crea_contatore(inizio):
    valore = inizio

    class Contatore:
        def mostra(self):
            print(valore)

    return Contatore()

crea_contatore(10).mostra()
""") + "<br>Cosa stampa? (e cosa succederebbe in C++?)",
     "Stampa <b>10</b>.<br><br>"
     "In Python una <b>classe locale</b> (dentro una funzione) e' una "
     "<b>closure</b>: i suoi metodi <b>catturano</b> le variabili locali "
     "della funzione che la contiene.<br><br>"
     "<b>In C++ la stessa cosa e' un ERRORE:</b>" +
     code("error: use of local variable with automatic storage<br>"
          "       from containing function") +
     "E' una delle differenze piu' nette fra i due linguaggi: Python "
     "<b>non</b> ha l'inner class di Java, ma <b>ha</b> la local class con "
     "cattura, che in C++ richiede una lambda.")

card("[Python][Trabocchetto]",
     "In una classe locale Python, come si <b>modifica</b> una variabile "
     "della funzione esterna?",
     "Serve " + c("nonlocal") + "." + code("""
def crea_contatore(inizio):
    valore = inizio

    class Contatore:
        def incrementa(self):
            nonlocal valore          # <- indispensabile
            valore += 1
        def mostra(self):
            print(valore)

    return Contatore()

c = crea_contatore(10)
c.incrementa(); c.incrementa(); c.mostra()     # 12
""") + "<b>Senza</b> " + c("nonlocal") + ", l'istruzione " + c("valore += 1") +
     " verrebbe interpretata come <b>creazione di una variabile locale al "
     "metodo</b> &rarr; " + c("UnboundLocalError") + ".<br><br>"
     "<b>Leggere</b> non richiede <code>nonlocal</code>; <b>assegnare</b> si'.")

card("[Python][Verificato]",
     code("""
def fabbrica(moltiplicatore):
    class Locale:
        def calcola(self, x):
            return x * moltiplicatore
    return Locale

L3, L5 = fabbrica(3), fabbrica(5)
""") + "<br>" + c("L3 is L5") + "? E " + c("isinstance(L3(), L5)") + "?",
     "Entrambi <b>False</b> (verificato)." + code("""
L3 is L5                  -> False
isinstance(L3(), L5)      -> False
stesso __qualname__       -> True   (fabbrica.<locals>.Locale)
""") + "<b>Ogni chiamata della funzione crea una CLASSE NUOVA</b>, distinta, "
     "pur avendo lo stesso nome sorgente.<br><br>"
     "<b>Conseguenza pratica pesante:</b> " + c("isinstance") + " non e' "
     "affidabile fra oggetti prodotti da chiamate diverse della stessa "
     "factory.<br><br>"
     "In <b>Java</b> la local class e' compilata <b>una sola volta</b> "
     "(<code>$1Nome</code>) e le istanze condividono il tipo.")

card("[Python][Teoria]",
     "Qual e' l'equivalente Python di una <b>classe anonima</b>?",
     "Non esiste un costrutto dedicato. Ci sono due strade:<br><br>"
     "<b>1. Una lambda</b> (per un solo comportamento):" +
     code("operazione = lambda a, b: a + b") +
     "<b>2. La funzione " + c("type()") + "</b>, che crea una classe "
     "dinamicamente ed e' l'unica cosa davvero \"anonima\":" + code("""
Anonima = type(
    "",                      # nome VUOTO
    (BaseClass,),            # tuple delle basi
    {                        # dizionario dei membri
        "applica": lambda self, a, b: a + b,
        "simbolo": lambda self: "+",
    },
)
oggetto = Anonima()
""") + "<b>Verificato:</b> " + c("type(oggetto).__name__") + " e' la stringa "
     "<b>vuota</b>, e " + c("isinstance(oggetto, BaseClass)") + " e' "
     + c("True") + " --- e' una sottoclasse a tutti gli effetti, senza nome."
     "<br><br><i>Nota: abusare di <code>type()</code> rende il codice "
     "illeggibile. Va usata solo quando serve davvero generare classi a "
     "runtime.</i>")

card("[Python][Cosa fa?][Trabocchetto]",
     code("""
funzioni = []
for i in range(3):
    funzioni.append(lambda: i)

print([f() for f in funzioni])
""") + "<br>Cosa stampa?",
     "Stampa <b>[2, 2, 2]</b>, non <code>[0, 1, 2]</code>.<br><br>"
     "E' il problema del <b>late binding</b>: la lambda non cattura il "
     "<b>valore</b> di " + c("i") + ", ma la <b>variabile</b>. Quando le "
     "lambda vengono chiamate, il ciclo e' finito e " + c("i") + " vale 2."
     "<br><br><b>Soluzione:</b> forzare la cattura del valore con un "
     "argomento di default (valutato alla <b>definizione</b>):" + code("""
for i in range(3):
    funzioni.append(lambda i=i: i)      # -> [0, 1, 2]
""") + "<b>Confronto:</b> in C++ e' la differenza fra " + c("[&i]") +
     " (late binding, come Python) e " + c("[i]") + " (cattura per valore). "
     "In Java il problema <b>non esiste</b>, perche' la variabile catturata "
     "deve essere <i>effectively final</i>.")

card("[Python][Trabocchetto]",
     "Elenca gli <b>errori comuni</b> con le classi annidate in Python.",
     "1. pensare che la classe annidata <b>conosca l'oggetto esterno</b> "
     "(non lo conosce: va passato)<br>"
     "2. confondere " + c("self") + ": dentro la annidata e' un oggetto "
     "<b>della annidata</b><br>"
     "3. usare una classe annidata <b>solo come namespace</b>: spesso un "
     "modulo separato e' piu' chiaro<br>"
     "4. <b>abusare di " + c("type()") + "</b> per creare classi dinamiche "
     "&rarr; codice illeggibile<br>"
     "5. il <b>late binding</b> nelle lambda dentro un ciclo<br><br>"
     "<b>Bonus (verificato):</b> dentro una classe annidata, un attributo di "
     "classe dell'esterna va <b>qualificato</b> "
     "(" + c("Esterna.attributo") + "): il nome nudo da' "
     + c("NameError") + " a <b>runtime</b> --- Python non puo' accorgersene "
     "prima.")

# =====================================================================
# C
# =====================================================================

card("[C][Teoria]",
     "In C non esistono le classi. Con quali strumenti si costruiscono i "
     "concetti equivalenti?",
     "&bull; " + c("struct") + " &rarr; il contenitore di dati<br>"
     "&bull; <b>funzioni</b> che ricevono un puntatore alla struct &rarr; i "
     "\"metodi\" (il " + c("this") + " diventa un parametro esplicito)<br>"
     "&bull; <b>puntatori a funzione</b> dentro la struct &rarr; i metodi "
     "\"virtuali\" (vtable)<br>"
     "&bull; <b>callback</b> + " + c("void*") + " &rarr; le closure<br>"
     "&bull; " + c("static") + " e la divisione " + c(".h") + "/" + c(".c") +
     " &rarr; l'incapsulamento<br>"
     "&bull; <b>prefissi</b> nei nomi &rarr; i namespace")

card("[C][Verificato][Esame]",
     code("""
struct Contenitore {
    int campo;
    struct Annidata {
        int x;
    } ann;
};

struct Annidata usata_fuori = { 42 };    /* ??? */
""") + "<br>L'ultima riga compila in C? E in C++?",
     "<b>In C: SI'</b> (verificato, stampa 42).<br>"
     "<b>In C++: NO</b> &rarr; " +
     c("error: variable 'Annidata usata_fuori' has initializer but "
       "incomplete type") + "<br><br>"
     "<b>In C annidare una struct NON crea alcuno scope:</b> il tag "
     + c("Annidata") + " finisce nello <b>stesso spazio dei nomi globale</b> "
     "del tag esterno. Non c'e' alcun incapsulamento.<br><br>"
     "In C++ il nome corretto sarebbe " + c("Contenitore::Annidata") + ".<br><br>"
     "<b>E' un caso in cui il C++ NON e' un soprainsieme del C.</b>")

card("[C][Trabocchetto][Esame]",
     "In C si possono definire <b>funzioni dentro una funzione</b>?",
     "<b>NO</b>, non in C standard. Verificato con "
     + c("gcc -std=c11 -pedantic") + ":" +
     code("warning: ISO C forbids nested functions [-Wpedantic]") +
     "Funziona <b>solo come estensione GNU</b> (" + c("-std=gnu11") + ")."
     "<br><br><b>Conseguenza per le classi \"locali\":</b> si puo' definire "
     "una " + c("struct") + " dentro una funzione (e quella e' davvero "
     "locale), ma <b>non le si puo' dare un metodo</b>: le funzioni che "
     "implementano il comportamento devono stare a <b>livello globale</b>."
     "<br><br>Percio' la vtable e le funzioni-strategia sono sempre globali; "
     "la \"localita'\" puo' riguardare <b>solo i dati</b>.")

card("[C][Scrivi]",
     "<b>Scrivi</b> in C l'equivalente di una <b>inner class</b> (una struct "
     "che accede allo stato dell'oggetto \"esterno\").",
     code("""
#include <stdio.h>

typedef struct {
    int valore;
} Esterna;

typedef struct {
    const Esterna *esterna;      /* l'"enclosing instance", A MANO */
} Interna;

/* il "costruttore" che imita esterna.new Interna() di Java */
static Interna interna_crea(const Esterna *e) {
    Interna i;
    i.esterna = e;
    return i;
}

static void interna_mostra(const Interna *i) {
    printf("%d\\n", i->esterna->valore);
}

int main(void) {
    Esterna e = { 42 };
    Interna i = interna_crea(&e);
    interna_mostra(&i);          /* 42 */
    return 0;
}
""") + "<b>Pericolo da ricordare:</b> se " + c("e") + " viene distrutta prima "
     "di " + c("i") + ", il puntatore diventa <b>pendente</b>. In C non c'e' "
     "nessun garbage collector a proteggerti: la <b>durata degli oggetti</b> "
     "e' interamente a tuo carico.")

card("[C][Scrivi]",
     "<b>Scrivi</b> in C una \"classe\" con <b>metodi virtuali</b> "
     "(struct con puntatori a funzione).",
     code("""
#include <stdio.h>

typedef struct Animale Animale;

typedef struct {                 /* la VTABLE: una per "classe" */
    void (*verso)(const Animale *self);
    const char *nome_tipo;
} AnimaleVT;

struct Animale {                 /* la "classe base" */
    const AnimaleVT *vptr;
};

typedef struct {                 /* la "derivata" */
    Animale base;                /* PRIMO membro: cast sicuro */
    const char *nome;
} Cane;

static void cane_verso(const Animale *self) {
    printf("%s: Bau\\n", ((const Cane *)self)->nome);
}
static const AnimaleVT CANE_VT = { cane_verso, "Cane" };

static Cane cane_crea(const char *nome) {
    Cane c;
    c.base.vptr = &CANE_VT;      /* il "costruttore" installa il vptr */
    c.nome = nome;
    return c;
}

int main(void) {
    Cane c = cane_crea("Fido");
    Animale *a = (Animale *)&c;
    a->vptr->verso(a);           /* dispatch "virtuale": Fido: Bau */
    return 0;
}
""") + "<b>Il primo membro DEVE essere la base:</b> lo standard C garantisce "
     "l'assenza di padding all'inizio di una struct, quindi il cast "
     "derivata&rarr;base e' un <b>no-op</b>.<br><br>"
     "<b>Se dimentichi</b> " + c("c.base.vptr = &CANE_VT;") + ": "
     "<b>segmentation fault</b> (verificato). In C++ quella riga la scrive "
     "il compilatore in ogni costruttore.")

card("[C][Scrivi][Esame]",
     "<b>Scrivi</b> come si simula una <b>closure</b> in C.",
     "Con la coppia <b>(puntatore a funzione, " + c("void*") + " di "
     "contesto)</b>:" + code("""
#include <stdio.h>

typedef void (*Callback)(void *ctx, int valore);

typedef struct {                 /* il "contesto catturato" */
    int totale;
} Accumulatore;

static void accumula(void *ctx, int valore) {
    Accumulatore *a = (Accumulatore *)ctx;
    a->totale += valore;                    /* modifica lo stato */
}

static void per_ogni(const int *v, int n, Callback f, void *ctx) {
    for (int i = 0; i < n; ++i)
        f(ctx, v[i]);                       /* la delega */
}

int main(void) {
    int dati[] = { 1, 2, 3, 4 };
    Accumulatore acc = { 0 };
    per_ogni(dati, 4, accumula, &acc);
    printf("%d\\n", acc.totale);             /* 10 */
    return 0;
}
""") + "E' il pattern di " + c("qsort_r") + ", dei callback POSIX e di GTK."
     "<br><br><b>La differenza con le vere closure:</b> in C++/Java/Python il "
     "contesto e' <b>catturato automaticamente</b>; in C va <b>passato a "
     "mano</b> a ogni chiamata, e il cast da " + c("void*") + " non e' "
     "controllato dal compilatore.")

card("[C][Teoria]",
     "Quali sono i <b>tre significati</b> di <code>static</code> in C?",
     "1. <b>Variabile locale statica</b> (dentro una funzione): conserva il "
     "valore fra le chiamate, ma resta visibile solo li'." + code("""
void contatore(void) {
    static int n = 0;      /* inizializzata UNA volta sola */
    n++;
}
""") + "2. <b>Funzione statica</b> (a livello di file): visibile <b>solo in "
     "quel file</b> &rarr; e' l'equivalente di un metodo " + c("private") +
     ".<br><br>"
     "3. <b>Variabile globale statica</b>: come sopra, visibile solo nel "
     "file.<br><br>"
     "<b>I punti 2 e 3 sono il meccanismo di incapsulamento del C:</b> "
     "insieme alla divisione " + c(".h") + " (interfaccia pubblica) / "
     + c(".c") + " (implementazione), realizzano l'equivalente di una classe "
     "con membri privati.")

card("[C][Teoria]",
     "Cos'e' una <b>anonymous struct</b> / <b>anonymous union</b> in C?",
     "Una struct o union <b>senza nome</b> dichiarata come membro: i suoi "
     "campi diventano accessibili <b>direttamente</b> dal contenitore." +
     code("""
struct Punto {
    struct {                 /* struct anonima come membro */
        int x;
        int y;
    };
    int z;
};

struct Punto p;
p.x = 1;                     /* NON p.anonima.x */
""") + "Con le <b>union anonime</b> si ottiene la sovrapposizione in memoria:"
     + code("""
struct Valore {
    int tipo;
    union {                  /* union anonima */
        int intero;
        float reale;
    };
};
""") + "<b>Attenzione:</b> non ha <b>nulla a che vedere</b> con le anonymous "
     "class di Java: qui non c'e' comportamento, solo un aggregato di dati "
     "senza nome di tipo.")

card("[C][Trabocchetto]",
     "Elenca gli <b>errori comuni</b> in C su questo argomento.",
     "1. pensare che una " + c("struct") + " sia una classe (non ha metodi "
     "ne' incapsulamento)<br>"
     "2. <b>restituire puntatori a variabili locali</b> (la memoria non "
     "esiste piu' al ritorno)<br>"
     "3. usare un oggetto esterno <b>gia' distrutto</b> tramite il puntatore "
     "salvato nella \"inner\"<br>"
     "4. dimenticare " + c("free") + " &rarr; memory leak<br>"
     "5. chiamare una callback <b>" + c("NULL") + "</b> senza controllare "
     "&rarr; crash<br>"
     "6. <b>cast errato</b> di " + c("void*") + " &rarr; type confusion "
     "silenziosa (il compilatore non protesta)<br>"
     "7. confondere " + c(".") + " e " + c("->") + ": il primo su un oggetto, "
     "il secondo su un <b>puntatore</b> a oggetto")

# =====================================================================
# TRASVERSALI
# =====================================================================

card("[Trasv][Teoria][Esame]",
     "<b>Tabella a quattro vie:</b> chi ha il <b>riferimento implicito</b> "
     "all'oggetto esterno?",
     "<table border=1 cellpadding=4 style='border-collapse:collapse'>"
     "<tr><th></th><th>Riferimento implicito</th><th>Come si ottiene</th></tr>"
     "<tr><td><b>Java</b></td><td><b>SI'</b> (inner class non-static)</td>"
     "<td>automatico; <code>Esterna.this</code></td></tr>"
     "<tr><td><b>C++</b></td><td>NO</td>"
     "<td><code>Esterna&amp;</code> o <code>Esterna*</code> a mano</td></tr>"
     "<tr><td><b>Python</b></td><td>NO</td>"
     "<td>passare l'oggetto al costruttore</td></tr>"
     "<tr><td><b>C</b></td><td>NO</td>"
     "<td>campo puntatore nella struct</td></tr>"
     "</table><br>"
     "<b>Java e' l'unico</b> ad avere l'inner class vera. Negli altri tre il "
     "legame esiste solo se lo scrivi tu --- e in Java quel campo puntatore "
     "esiste comunque, solo che non si vede (ed e' la causa dei memory leak).")

card("[Trasv][Teoria][Esame]",
     "<b>Tabella a quattro vie:</b> la <b>classe locale</b> cattura le "
     "variabili della funzione?",
     "<table border=1 cellpadding=4 style='border-collapse:collapse'>"
     "<tr><th></th><th>Cattura?</th><th>Dettaglio</th></tr>"
     "<tr><td><b>Java</b></td><td><b>SI'</b></td>"
     "<td>solo <code>final</code> / effectively final, <b>per valore</b></td></tr>"
     "<tr><td><b>C++</b></td><td><b>NO</b></td>"
     "<td>vietato per le automatiche; serve una <b>lambda</b></td></tr>"
     "<tr><td><b>Python</b></td><td><b>SI'</b></td>"
     "<td>vera closure; <code>nonlocal</code> per modificare</td></tr>"
     "<tr><td><b>C</b></td><td><b>NO</b></td>"
     "<td>niente funzioni locali; contesto passato come <code>void*</code></td></tr>"
     "</table><br>"
     "<b>La casella piu' sorprendente e' il C++:</b> e' l'unico dei tre "
     "linguaggi con le classi a vietarlo, ed e' il motivo per cui le lambda "
     "(2011) sono cosi' importanti.")

card("[Trasv][Teoria]",
     "Qual e' l'<b>equivalente della anonymous class Java</b> in ciascun "
     "linguaggio?",
     "&bull; <b>Java</b>: la classe anonima stessa "
     "(" + c("new Interfaccia() { ... }") + "), oppure una <b>lambda</b> se "
     "l'interfaccia e' funzionale<br><br>"
     "&bull; <b>C++</b>: la <b>lambda</b> --- il compilatore genera un "
     "closure type locale senza nome<br><br>"
     "&bull; <b>Python</b>: una <b>lambda</b> (per un solo comportamento) "
     "oppure " + c('type("", (Base,), {...})') + " per una vera classe senza "
     "nome<br><br>"
     "&bull; <b>C</b>: <b>non esiste</b>. Il piu' vicino e' un puntatore a "
     "funzione con contesto " + c("void*") + ", ma la funzione deve comunque "
     "avere un nome e stare a livello globale.")

card("[Trasv][Teoria][Esame]",
     "Riassumi in 4 righe la <b>regola di scelta</b> valida in tutti i "
     "linguaggi.",
     "&bull; la classe <b>non serve</b> lo stato dell'esterno &rarr; "
     "<b>nested/static</b> (default: non trattiene l'oggetto esterno, evita "
     "memory leak)<br><br>"
     "&bull; serve lo stato <b>vivo</b> dell'esterno &rarr; <b>inner</b> "
     "(Java) o riferimento esplicito (altrove)<br><br>"
     "&bull; serve solo dentro un metodo e cattura un parametro &rarr; "
     "<b>local class</b> (Java, Python) o <b>lambda</b> (C++)<br><br>"
     "&bull; serve una volta sola, in un'espressione &rarr; <b>anonima</b> "
     "(Java) o <b>lambda</b> (C++, Python)<br><br>"
     "<b>La regola d'oro (Java):</b> <i>se la classe annidata non ha bisogno "
     "dell'istanza esterna, dichiarala </i>" + c("static") + ".")

# =====================================================================

def main():
    lines = [HEADER]
    for front, back in CARDS:
        assert "\t" not in front and "\t" not in back, "tab nel testo!"
        assert "\n" not in front and "\n" not in back, "newline nel testo!"
        lines.append(front + "\t" + back)
    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    print(f"Scritte {len(CARDS)} card in {OUT}")


if __name__ == "__main__":
    main()
