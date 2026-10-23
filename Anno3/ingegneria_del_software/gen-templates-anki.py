#!/usr/bin/env python3
"""Genera il mazzo Anki sui TEMPLATE / genericita' (C++, Java, Python, C).
Fonti: slide TemplatesInCpp, Wikipedia (Template (C++), Generics in Java,
Generic programming, Duck typing), Thinking in C++ vol.2 cap.5.
Ogni output di codice riportato e' stato verificato compilando/eseguendo.
"""

import html

OUT = ("/home/giovanni/Documents/università/AppuntiDelBasta/Anno3/"
       "ingegneria_del_software/templates-avanzato-anki.txt")

HEADER = """#separator:tab
#html:true
#notetype:Basic
#deck:Ingegneria del Software::Template e Genericita' (teoria+codice)
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
# A. PERCHE' I TEMPLATE (slide)
# =====================================================================

card("[Teoria]",
     "Qual e' il <b>problema di partenza</b> che motiva i template, come lo "
     "pone il corso?",
     "Serve una <b>coda di clienti</b>; poi una <b>coda di messaggi</b>; poi "
     "una <b>coda di ordini</b>. La tentazione e' il "
     "copia-incolla-trova-sostituisci.<br><br>"
     "<b>Il problema non e' scrivere la prima coda</b>: e' che il codice viene "
     "<b>duplicato</b>. Ogni modifica futura (un bug, un controllo in piu') va "
     "replicata a mano in ogni copia, ed e' facile perderne una.<br><br>"
     "Ri-inventare codice identico e' l'opposto di cio' che l'OO promette: il "
     "<b>riuso</b>.<br><i>(slide 3-4)</i>")

card("[Teoria]",
     "Cos'e' la <b>type parameterization</b>?",
     "Implementare una struttura dati in modo che possa contenere un "
     "<b>tipo arbitrario</b>, parametrizzando il codice rispetto al tipo degli "
     "elementi.<br><br>Comunemente detta <b>generics</b>; in C++ si chiama "
     "<b>template</b>.<br><i>(slide 4)</i>")

card("[Teoria]",
     "Quali sono le <b>tre domande</b> da porsi sulle container class "
     "riusabili?",
     "1. E' possibile costruire container <b>indipendenti dal tipo</b> dei "
     "loro elementi?<br>"
     "2. Possono mantenere <b>un solo tipo</b> (omogenei) o <b>tipi "
     "diversi</b> (eterogenei)?<br>"
     "3. E' possibile dare accesso agli elementi <b>senza rimuoverli</b> e "
     "<b>senza esporre</b> i dettagli implementativi?<br><i>(slide 6)</i>")

card("[Teoria]",
     "Come si costruivano i container <b>eterogenei</b> nei linguaggi "
     "statici <b>pre-OO</b>, e con quali difetti?",
     "Con <b>variant record</b> o <b>union</b>.<br><br><b>Difetti:</b><br>"
     "&bull; si deve convivere con un <b>numero finito di alternative</b><br>"
     "&bull; servono <b>test e cast &quot;sporchi&quot;</b> per estrarre i valori<br>"
     "&bull; e' difficile nascondere l'implementazione: per iterare serve una "
     "variabile che, col suo tipo, <b>rivela la struttura interna</b> del "
     "container<br><br>"
     "Nei linguaggi a tipizzazione <b>dinamica</b>, invece, sia i container "
     "omogenei sia gli eterogenei si costruiscono con facilita'."
     "<br><i>(slide 7)</i>")

card("[Teoria]",
     "Nei linguaggi OO staticamente tipati, cosa serve per costruire "
     "container eterogenei? E per gli <b>omogenei</b>?",
     "<b>Eterogenei</b>, servono due cose:<br>"
     "&bull; la <b>substitutability</b>, con tutti i valori istanze di "
     "sottoclassi di una comune superclasse <code>general-element</code><br>"
     "&bull; oggetti che conoscono il proprio <b>tipo dinamico</b> (test e "
     "cast restano necessari, ma si possono nascondere con sotto-classing)<br><br>"
     "Si aggiungono <b>iteratori espliciti</b> per scorrere senza esporre la "
     "struttura interna.<br><br>"
     "<b>Per gli OMOGENEI, i template sono &quot;LA&quot; soluzione.</b>"
     "<br><i>(slide 8)</i>")

# =====================================================================
# B. COSA SONO — il meccanismo
# =====================================================================

card("[Teoria]",
     "Chi genera il codice di un template, e <b>quando</b>?",
     "Lo genera il <b>compilatore</b>, a ogni <b>istanziazione</b>.<br><br>"
     "<b>Il corpo effettivamente eseguito NON e' generico, ma molto "
     "specifico</b> per quel tipo.<br><br>"
     "Immagine mentale corretta (Wikipedia): e' come se, prima di compilare, "
     "si <b>copiasse e incollasse</b> il blocco templatizzato nel punto d'uso, "
     "sostituendo il parametro col tipo attuale.<br><i>(slide 10; Wikipedia)</i>")

card("[Teoria][Trabocchetto]",
     "Le slide dicono che <b>i template NON sono &quot;fully generic&quot;</b>. "
     "Perche'?",
     "L'obiettivo e' costruire <b>selettivamente</b> una classe assemblando "
     "solo le porzioni di codice necessarie, tenendo <b>solo il necessario</b>."
     "<br><br>Per essere efficiente, questo va fatto <b>a compile time</b>, "
     "proprio per poter <b>sopprimere la generazione di codice inutile</b>.<br><br>"
     "Conseguenza: <b>non c'e' type checking completo</b> alla definizione del "
     "template.<br><i>(slide 12)</i>")

card("[Teoria]",
     "Quando viene generato codice, incontrando la <b>definizione</b> di un "
     "template?",
     "<b>MAI.</b> Nessun codice viene generato alla definizione.<br><br>"
     "Il compilatore fa in quella fase <b>ogni controllo possibile</b>, ma "
     "<b>rimanda</b> il type checking completo e la compilazione alla fase di "
     "<b>istanziazione</b>.<br><br>"
     "<b>Conseguenza pratica:</b> dichiarazioni e definizioni dei metodi di "
     "una class template devono stare tutte nello <b>stesso header file</b>."
     "<br><i>(slide 13)</i>")

card("[Teoria]",
     "Cos'e' il <b>punto di istanziazione</b>? E cos'e' una <b>generated "
     "instance</b>?",
     "<b>Punto di istanziazione</b>: il punto del codice dove il template "
     "viene <b>usato</b>. Li' il compilatore conosce i tipi attuali e "
     "<b>genera il codice</b> per quei tipi.<br><br>"
     "Il codice generato e' una <b>generated instance</b>:<br>"
     "&bull; da una class template &rarr; <b>generated class</b><br>"
     "&bull; da una function template &rarr; <b>generated function</b><br>"
     "&bull; da un membro statico &rarr; <b>generated static data member</b><br><br>"
     "<b>Viene generata UNA SOLA VOLTA</b> e poi <b>riusata</b> a ogni "
     "successiva istanziazione con gli stessi parametri.<br><i>(slide 15)</i>")

card("[C++][Verificato]",
     code("""
template <typename T>
T usata(T a, T b) { return a > b ? a : b; }

template <typename T>
T mai_usata(T a, T b) { return a + b; }

template <class T>
class Z {
public:
    void f() { }
    void g() { }
};

int main() {
    usata(10, 15);       // T = int
    usata(10.5, 15.2);   // T = double
    Z<int> zi;   zi.f();
    Z<float> zf; zf.g();
    Z<char>* p = nullptr;   // solo un puntatore
}
""") + "<br>Quali simboli genera davvero il compilatore? "
     "(<code>nm -C file.o</code>)",
     "Simboli realmente prodotti (verificato):" + code("""
W double usata<double>(double, double)
W int    usata<int>(int, int)
W Z<float>::g()
W Z<int>::f()
""") + "<br><b>Cosa NON c'e', e perche':</b><br>"
     "&bull; <b>zero</b> simboli per " + c("mai_usata") + ": mai istanziata "
     "&rarr; il codice non esiste proprio<br>"
     "&bull; " + c("Z<int>::g()") + " e " + c("Z<float>::f()") + " assenti: i "
     "metodi di una class template sono generati <b>solo se chiamati</b><br>"
     "&bull; " + c("Z<char>") + " assente: dichiarare un <b>puntatore</b> non "
     "richiede l'istanziazione (come per una struct incompleta)<br><br>"
     "<b>E c'e' la prova della monomorfizzazione:</b> " + c("usata<int>") +
     " e " + c("usata<double>") + " sono <b>due funzioni distinte</b> nel "
     "binario.<br><i>(prove/T01)</i>")

card("[C++][Teoria]",
     "Perche' dichiarare solo un <b>puntatore</b> a una specializzazione "
     "(<code>Z&lt;int&gt;* p;</code>) NON richiede l'istanziazione?",
     "Perche' al compilatore basta sapere che <code>Z&lt;int&gt;</code> "
     "<b>e' un tipo</b>: non gli serve conoscerne il contenuto per "
     "dichiararne un puntatore.<br><br>"
     "E' <b>analogo a dichiarare un puntatore a una classe o struct non "
     "ancora definita</b> (tipo incompleto).<br><br>"
     "L'istanziazione scatta quando serve la <b>definizione completa</b>: "
     "creare un oggetto, accedere a un membro, fare <code>sizeof</code>."
     "<br><i>(slide 24, verificato in prove/T01)</i>")

card("[C++][Teoria]",
     "Qual e' la differenza tra istanziazione <b>implicita</b> ed "
     "<b>esplicita</b>?",
     code("""
Z<int> zi;                 // IMPLICITA: basta usarlo

template class Z<int>;     // ESPLICITA: forzata dal programmatore
""") + "<i>(slide 15, 32)</i><br><br>"
     "<b>Approfondimento (C++11):</b> esiste anche " + c("extern template") +
     ", che fa l'opposto &mdash; dice &quot;non istanziare qui, il codice "
     "esiste altrove&quot;. Serve a mitigare il <b>code bloat</b>: la "
     "specializzazione viene generata una sola volta invece che in ogni unita' "
     "di traduzione che la usa.")

# =====================================================================
# C. FUNCTION TEMPLATE
# =====================================================================

card("[C++][Teoria]",
     "Cos'e' una <b>function template</b>, e in che senso &quot;rilassa il "
     "type checking&quot;?",
     "Permette di definire una <b>generic function</b>, applicabile ad "
     "argomenti i cui tipi verranno specificati <b>piu' tardi, alla "
     "chiamata</b>.<br><br>"
     "Cosi' si informa il compilatore di <b>non fare il controllo completo</b> "
     "di consistenza dei tipi della definizione <b>finche' non incontra una "
     "chiamata</b>: e' in questo senso un modo di <b>rilassare il type "
     "checking</b>.<br><i>(slide 18)</i>")

card("[C++][Teoria]",
     "Perche' l'<b>overloading</b> non basta, e servono i template?",
     "Con l'overloading il comportamento della funzione deve essere "
     "<b>completamente specificato</b>, incluso il tipo degli argomenti: va "
     "<b>codificato in anticipo per ogni tipo</b> di parametro.<br><br>"
     "Se, nel momento in cui <b>scrivi</b> la funzione, il tipo degli "
     "argomenti attuali <b>non e' noto</b>, l'overloading semplicemente "
     "<b>non si puo' usare</b>.<br><i>(slide 19)</i>")

card("[C++][Cosa fa?]",
     code("""
template <typename T1, typename T2>
void f(T1 t, T2& r) {
    r = 2 * t;
}

class A {};      // classe vuota

int main() {
    int x = 1, y = 2;
    f(y, x);        // (1)
    A anA;
    f(anA, x);      // (2)
}
""") + "<br>Quale delle due chiamate e' errata, e <b>quando</b> il "
     "compilatore se ne accorge?",
     "<b>(1) OK</b> &mdash; deduce T1=<code>int</code>, T2=&quot;reference to "
     "int&quot;.<br><br>"
     "<b>(2) ERRORE</b>, ma nota <b>dove</b>: la deduzione riesce benissimo "
     "(T1=<code>A</code>, T2=&quot;reference to int&quot;). Il problema e' che "
     "il corpo tenterebbe di <b>moltiplicare per 2 una copia di anA</b>, e la "
     "classe A non sovraccarica " + c("operator*") + ".<br><br>"
     "<b>Il punto didattico:</b> alla DEFINIZIONE del template il compilatore "
     "<b>non poteva</b> saperlo &mdash; " + c("r = 2 * t") + " sarebbe legale "
     "per T1=int/float, illegale per un array o per A. Alcuni controlli "
     "<b>devono</b> essere rimandati all'<b>istanziazione</b>."
     "<br><i>(slide 22, 25)</i>")

card("[C++][Teoria]",
     "Come deduce il compilatore i parametri di una <b>function</b> template? "
     "E se non ci riesce?",
     "Li deduce <b>automaticamente</b> (con algoritmi di pattern matching), "
     "esaminando i <b>tipi degli argomenti effettivi</b> forniti nella "
     "chiamata.<br><br>"
     "<b>Se non ci riesce</b> (gli argomenti non portano abbastanza "
     "informazione), il compilatore segnala la chiamata come "
     "<b>ambigua</b> &mdash; anche se sarebbe eseguibile. Bisogna allora "
     "<b>disambiguare manualmente</b>:" +
     code("template_func_name<parameter_list>(arguments_list)") +
     "<i>(slide 23, 27)</i>")

card("[C++][Cosa fa?][Trabocchetto]",
     code("""
template <class T>
T scegli(T a, T b) { return a > b ? a : b; }

template <>                          // specializzazione SOLO per int
int scegli<int>(int a, int b) {
    cout << "[spec int] ";
    return a < b ? a : b;            // confronto INVERTITO
}

int main() {
    cout << scegli(10, 15)          << "\\n";   // (1)
    cout << scegli(10.5, 15.5)      << "\\n";   // (2)
    cout << scegli<double>(10, 15)  << "\\n";   // (3)
}
""") + "<br>Cosa stampa? Attenzione alla (3).",
     "Output verificato:" + code("""
[spec int] 10
15.5
15
""") + "<br>(1) T dedotto <code>int</code> &rarr; usa la <b>specializzazione</b> "
     "&rarr; confronto invertito &rarr; <b>10</b><br>"
     "(2) T dedotto <code>double</code> &rarr; <b>generico</b> &rarr; 15.5<br>"
     "(3) <b>TRABOCCHETTO</b>: specificando " + c("<double>") + " a mano si "
     "<b>bypassa la deduzione</b>; gli int vengono convertiti a double e si usa "
     "il <b>generico</b> (non la specializzazione per int) &rarr; <b>15</b>.<br><br>"
     "<i>Nel binario: 3 istanziazioni (char/double weak, int strong perche' e' "
     "una definizione esplicita).</i><br><i>(prove/es_T01)</i>")

# =====================================================================
# D. CLASS TEMPLATE
# =====================================================================

card("[C++][Teoria]",
     "Qual e' la <b>differenza principale</b> tra istanziazione di una "
     "function template e di una class template?",
     "Per le <b>class</b> template il compilatore <b>NON tenta di dedurre</b> "
     "i parametri: vanno <b>sempre specificati esplicitamente</b> "
     "(<code>A&lt;int&gt;</code>, <code>A&lt;double&gt;</code>).<br><br>"
     "<b>Perche':</b> la deduzione sarebbe comunque <b>impossibile</b> &mdash; "
     "non c'e' nessuna informazione su cui basarsi. Nelle function template "
     "c'e' la <b>lista degli argomenti attuali</b> della chiamata; per una "
     "classe non esiste niente di analogo.<br><i>(slide 30)</i>")

card("[C++][Verificato]",
     code("""
template <typename T>
class A {
    T x, y;
public:
    T getSum() { return x + y; }
};

A<int>    iA;
A<double> dA;
iA = dA;      // ???
""") + "<br>L'ultima riga compila? Cosa sono <code>A&lt;int&gt;</code> e "
     "<code>A&lt;double&gt;</code> l'uno per l'altro?",
     "<b>NON compila:</b>" + code(
         "error: no match for 'operator=' (operand types are<br>"
         "'A&lt;int&gt;' and 'A&lt;double&gt;')") +
     "<b>Sono classi regolari COMPLETAMENTE SCORRELATE</b>, anche se generate "
     "dallo stesso template. Nessuna parentela, nessuna conversione implicita: "
     "servirebbe un <b>operatore di conversione esplicito</b>.<br><br>"
     "Verifiche a supporto:" + code("""
sizeof(A<int>)    = 8      typeid: 1AIiE
sizeof(A<double>) = 16     typeid: 1AIdE
stesso tipo? NO
""") + "<b>Contrasto con Java:</b> li' " + c("List<String>") + " e "
     + c("List<Integer>") + " condividono lo <b>stesso bytecode</b> (una sola "
     "classe a runtime, erasure).<br><i>(slide 31; prove/T02)</i>")

# =====================================================================
# E. SPECIALIZATION
# =====================================================================

card("[C++][Cosa fa?][Esame]",
     code("""
template <class T>
T massimo(T a, T b) { return a > b ? a : b; }

int main() {
    cout << massimo(10, 15) << "\\n";
    cout << massimo('k', 's') << "\\n";
    cout << massimo(10.1, 15.2) << "\\n";
    cout << massimo("Aladdin", "Jasmine") << "\\n";
}
""") + "<br>Le prime tre righe vanno bene. La quarta?",
     "Le prime tre: <b>15</b>, <b>s</b>, <b>15.2</b> &mdash; corrette.<br><br>"
     "La quarta stampa <b>&quot;Aladdin&quot;</b>, che e' <b>SBAGLIATO</b> "
     "(alfabeticamente viene prima).<br><br>"
     "<b>Perche':</b> la chiamata istanzia " + c("massimo(char*, char*)") +
     ", e " + c("operator>") + " fra due " + c("char*") + " confronta gli "
     "<b>INDIRIZZI DI MEMORIA</b> delle stringhe, non il loro <b>contenuto</b>."
     "<br><br><i>Verificato: &quot;Aladdin&quot; e' a 0x4040d9, "
     "&quot;Jasmine&quot; a 0x4040d1 &mdash; il primo indirizzo e' maggiore, "
     "quindi vince &quot;Aladdin&quot;. Il risultato dipende dal LAYOUT DI "
     "MEMORIA deciso dal compilatore!</i><br><i>(slide 36; prove/T03)</i>")

card("[C++][Scrivi]",
     "<b>Scrivi</b> la correzione del problema di " + c("massimo") + " su "
     + c("char*") + " tramite <b>template specialization</b>, e spiega perche' "
     "in C++ moderno il problema non si porrebbe.",
     code("""
#include <cstring>

// il template generico resta invariato
template <class T>
T massimo(T a, T b) {
    return a > b ? a : b;
}

// FULL (explicit) specialization per const char*
// 'template <>' vuoto = tutti i parametri sono specializzati
template <>
const char* massimo<const char*>(const char* a, const char* b) {
    return strcmp(a, b) > 0 ? a : b;    // confronta il CONTENUTO
}

int main() {
    massimo<const char*>("Aladdin", "Jasmine");   // -> "Jasmine" (corretto)
}
""") + "<b>In C++ moderno</b> il problema non si presenta usando "
     + c("std::string") + " al posto di " + c("char*") + ": "
     + c("std::string") + " <b>sovraccarica correttamente</b> " + c("operator>") +
     " confrontando il contenuto.<br><br>"
     "<b>Morale (il punto del prof):</b> <i>il template genera codice "
     "specifico che magari non fa cio' che credi</i> &mdash; e' "
     "sintatticamente valido ma semanticamente sbagliato per quel tipo."
     "<br><i>(slide 37; prove/T03)</i>")

card("[C++][Teoria]",
     "Che differenza c'e' tra <b>full specialization</b> e <b>partial "
     "specialization</b>? Quale delle due vale per le funzioni?",
     "<b>Full (explicit) specialization</b>: <b>tutti</b> i parametri sono "
     "specializzati. Sintassi: " + c("template <> class Vector<bool> {...};") +
     "<br><br>"
     "<b>Partial specialization</b>: solo un <b>sottoinsieme</b> dei parametri "
     "e' specializzato (es. &quot;per tutti i tipi puntatore&quot;), "
     "permettendo ottimizzazioni come ridurre il code bloat con "
     "un'implementazione condivisa per i puntatori." + code("""
template <typename T> struct is_pointer      { static const bool v = false; };
template <typename T> struct is_pointer<T*>  { static const bool v = true;  };
""") + "<b>La partial specialization e' disponibile SOLO per le CLASS "
     "template</b>: le function template <b>non</b> possono essere "
     "specializzate parzialmente (si usa l'<b>overloading</b> al loro posto)."
     "<br><i>(Wikipedia; libro cap.5)</i>")

# =====================================================================
# F. DAL LIBRO (Thinking in C++ cap.5)
# =====================================================================

card("[C++][Libro][Teoria]",
     "Cos'e' un <b>non-type template parameter</b>? Puo' essere una variabile "
     "a runtime?",
     "Un template puo' essere parametrizzato non solo su un <b>tipo</b> ma "
     "anche su un <b>valore</b>:" + code("""
template <class T, int sz>
class Array {
    T data[sz];                    // la dimensione fa parte del TIPO
public:
    int size() const { return sz; }
};

Array<int, 5>   a5;     // sizeof = 20  (verificato)
Array<int, 100> a100;   // sizeof = 400 -> TIPI DIVERSI
""") + "<b>NO, non puo' essere una variabile a runtime:</b> deve essere una "
     "<b>costante nota a compile time</b>." + code("""
int n; cin >> n;
Array<int, n> bad;      // IMPOSSIBILE
""") + "E' esattamente il meccanismo di " + c("std::array<T, N>") + ": a "
     "differenza di un array C, la dimensione fa parte del <b>tipo</b>."
     "<br><i>(libro cap.5; prove/T04)</i>")

card("[C++][Libro][Trabocchetto]",
     "La keyword " + c("typename") + " serve solo come sinonimo di "
     + c("class") + " nella lista dei parametri?",
     "<b>No</b>: quello e' solo il primo uso (dove sono intercambiabili, ma "
     + c("class") + " e' <b>deprecato</b>).<br><br>"
     "Il <b>secondo uso non e' opzionale</b>: disambiguare i <b>nomi "
     "dipendenti</b> dentro il corpo di un template." + code("""
template <typename Container>
void stampaPrimo(const Container& c) {
    typename Container::const_iterator it = c.begin();
    // ^^^^^^^^ obbligatorio!
}
""") + "<b>Senza <code>typename</code></b>, il compilatore assume di default "
     "che " + c("Container::const_iterator") + " <b>non sia un tipo</b> "
     "(potrebbe essere un dato statico), e interpreta la riga come "
     "un'<b>espressione</b> (una moltiplicazione!) &mdash; da cui un errore "
     "notoriamente incomprensibile.<br><i>(libro cap.5; prove/T04)</i>")

card("[C++][Libro][Cosa fa?]",
     code("""
template <typename Derived>
struct Base {
    void interface() {
        static_cast<Derived*>(this)->implementation();
    }
};

struct Der1 : Base<Der1> {
    void implementation() { cout << "Der1\\n"; }
};

int main() {
    Der1 d;
    d.interface();
    cout << sizeof(Der1) << "\\n";
}
""") + "<br>Come si chiama questo pattern? Quanto vale sizeof(Der1)?",
     "E' il <b>CRTP</b> (<i>Curiously Recurring Template Pattern</i>): una "
     "classe <b>eredita da un template parametrizzato su se stessa</b>.<br><br>"
     "Output verificato: stampa <code>Der1</code>, e "
     "<b>sizeof(Der1) = 1</b>.<br><br>"
     "<b>Il punto:</b> <b>nessun vptr!</b> (con una funzione virtuale sarebbero "
     "8 byte). Il dispatch e' <b>completamente statico</b>: "
     + c("static_cast<Derived*>(this)") + " e' risolto a compile time, quindi "
     "la chiamata e' diretta e <b>inlineabile</b>.<br><br>"
     "Il libro lo definisce: <i>&quot;polimorfismo statico senza funzioni "
     "virtuali &mdash; si scambia il dispatch dinamico per un'astrazione a "
     "costo zero&quot;</i>.<br><i>(libro cap.5; prove/T05)</i>")

card("[C++][Libro][Trabocchetto]",
     "Qual e' il <b>bug classico</b> del CRTP, e qual e' il suo equivalente "
     "in Java?",
     "<b>Il bug:</b> passare come parametro un tipo <b>diverso da se stessi</b>:"
     + code("""
struct Der1 : Base<Der1> { ... };     // corretto
struct Evil : Base<Der1> { ... };     // BUG: passa Der1, non Evil!
""") + "Dentro " + c("Base<Der1>::interface()") + ", "
     + c("static_cast<Der1*>(this)") + " reinterpreta un puntatore a "
     + c("Evil") + " come se puntasse a un " + c("Der1") + " che <b>non "
     "esiste</b> &rarr; <b>undefined behavior</b>. Il compilatore non se ne "
     "accorge.<br><br>"
     "<b>Equivalente Java:</b> " + c("class Enum<E extends Enum<E>>") +
     " &mdash; l'<b>F-bounded polymorphism</b>. Stessa idea (una base generica "
     "che &quot;sa&quot; il tipo concreto che la deriva), ma il bound Java "
     "<b>e' verificato dal compilatore</b>.<br><br>"
     "<b>Differenza chiave:</b> il CRTP non lascia <b>nessun</b> residuo a "
     "runtime (monomorfizzazione); il bound Java viene <b>eraso</b>.")

card("[C++][Libro][Teoria]",
     "Cosa sono i <b>traits</b> e le <b>policies</b> (idiomi del cap.5)?",
     "<b>TRAITS</b>: informazioni sul <i>tipo</i> codificate dentro classi "
     "template, che permettono <b>decisioni a compile time</b> (proprieta' "
     "numeriche, categorie di iteratori, codifiche). Consentono a un algoritmo "
     "di <b>adattarsi</b> al proprio parametro." + code("""
template <typename T> struct TipoInfo {
    static const char* nome() { return "sconosciuto"; }
};
template <> struct TipoInfo<int> {
    static const char* nome() { return "int"; }
};
""") + "<b>POLICIES</b>: parametri di template che <b>controllano il "
     "comportamento</b> di un algoritmo, per un design flessibile <b>senza "
     "overhead a runtime</b>." + code("""
template <typename Policy>
class Messaggio {
public:
    void stampa(const string& s) { cout << Policy::formatta(s); }
};

Messaggio<PolicyUrlato>().stampa("ciao");      // "CIAO!!!"
Messaggio<PolicySussurrato>().stampa("ciao");  // "(ciao)"
""") + "L'esempio classico di policy nella STL sono gli <b>allocator</b> dei "
     "container.<br><i>(libro cap.5; prove/T05)</i>")

card("[C++][Libro][Scrivi]",
     "<b>Scrivi</b> il calcolo del <b>fattoriale a compile time</b>, sia nello "
     "stile classico (template metaprogramming) sia in quello moderno.",
     "<b>Stile classico</b> &mdash; ricorsione via istanziazione + caso base "
     "via <b>full specialization</b>:" + code("""
template <unsigned int N>
struct Fattoriale {
    static const unsigned int value = N * Fattoriale<N - 1>::value;
};

template <>                        // caso base
struct Fattoriale<0> {
    static const unsigned int value = 1;
};

// uso: Fattoriale<6>::value  ->  720, calcolato dal COMPILATORE
""") + "<b>Stile moderno</b> (C++17) &mdash; " + c("constexpr") + " + "
     + c("if constexpr") + ":" + code("""
template <unsigned int N>
constexpr unsigned int fattoriale() {
    if constexpr (N <= 1) return 1;
    else                  return N * fattoriale<N - 1>();
}
""") + "<b>La prova che e' compile time</b> (verificata): il risultato si puo' "
     "usare dove serve una costante di compilazione, es. come dimensione di un "
     "array &mdash; " + c("int arr[Fattoriale<5>::value];") + " crea un array "
     "di <b>120</b> elementi.<br><br>"
     "Oggi il metaprogramming &quot;puro&quot; si usa soprattutto per "
     "operazioni <b>sui tipi</b>, dove " + c("constexpr") + " non basta."
     "<br><i>(libro cap.5; Wikipedia; prove/T05)</i>")

card("[C++][Libro][Teoria]",
     "Cosa sono le <b>expression templates</b>?",
     "Una tecnica avanzata che <b>cattura le operazioni</b> dentro strutture "
     "template <b>prima di valutarle</b>, permettendo ottimizzazioni.<br><br>"
     "<b>Esempio tipico:</b> nell'aritmetica su vettori, "
     + c("a = b + c + d") + " con operatori ingenui creerebbe <b>due vettori "
     "temporanei</b>. Con le expression templates l'espressione viene "
     "rappresentata come un <i>tipo</i>, e valutata in <b>un solo ciclo</b> "
     "senza temporanei.<br><br>"
     "E' la base di librerie di calcolo numerico ad alte prestazioni come "
     "<b>Eigen</b> e <b>Blitz++</b>.<br><i>(libro cap.5)</i>")

card("[C++][Libro][Teoria]",
     "Quali sono i due <b>compilation model</b> dei template, e quale ha "
     "vinto?",
     "<b>1. Inclusion model</b> (quello che si usa davvero): le definizioni "
     "stanno negli <b>header</b>. Costringe a ricompilare tutto quando un "
     "template cambia, ma rende immediata la compilazione separata. E' il "
     "motivo della regola &quot;tutto nello stesso header&quot; (slide 13).<br><br>"
     "<b>2. Separation model</b> (" + c("export") + "): avrebbe permesso di "
     "mettere le implementazioni in file sorgente separati. Il libro lo "
     "descrive come <b>&quot;raramente implementato&quot;</b> &mdash; solo "
     "Comeau C++ lo supportava davvero.<br><br>"
     "<b>Esito:</b> " + c("export") + " e' stato <b>rimosso in C++11</b> "
     "(costoso da implementare, poco beneficio, limitava l'evoluzione del "
     "linguaggio). In C++20 la keyword e' tornata, ma con significato diverso "
     "(<b>moduli</b>), che offrono quel beneficio in altro modo."
     "<br><i>(libro cap.5; Wikipedia)</i>")

# =====================================================================
# G. JAVA
# =====================================================================

card("[Java][Teoria]",
     "Cos'e' la <b>type erasure</b>? Perche' Java l'ha scelta?",
     "L'informazione di tipo generico viene <b>rimossa durante la "
     "compilazione</b>: " + c("List<Integer>") + " diventa il semplice "
     + c("List") + " nel bytecode. La correttezza e' garantita dai controlli "
     "fatti a compile time, non da verifiche residue a runtime.<br><br>"
     "<b>Perche':</b> per mantenere la <b>retrocompatibilita'</b> col codice "
     "pre-generics (pre Java 5, 2004), <b>senza modificare la JVM</b>.<br><br>"
     "<b>La prova:</b>" + code("""
List<Integer> li = new ArrayList<>();
List<Float>   lf = new ArrayList<>();
li.getClass() == lf.getClass()    // TRUE!
""") + "<i>(Wikipedia, &quot;Generics in Java&quot;)</i>")

card("[Java][Teoria]",
     "Elenca le <b>conseguenze</b> pratiche della type erasure.",
     "&bull; <b>Niente <code>new T()</code> ne' <code>new T[n]</code></b>: a "
     "runtime T non esiste piu'<br>"
     "&bull; <b>Niente classi eccezione generiche</b> (non si puo' estendere "
     "<code>Throwable</code>): due <code>catch</code> su "
     "<code>GenericException&lt;Integer&gt;</code> e "
     "<code>&lt;String&gt;</code> sarebbero indistinguibili<br>"
     "&bull; <b>Restrizioni sui membri static</b>: esiste una sola copia della "
     "classe a runtime, quindi un parametro di tipo non puo' comparire in una "
     "dichiarazione static<br>"
     "&bull; <b><code>instanceof List&lt;String&gt;</code> e' illegale</b> "
     "(non e' un tipo <i>reificabile</i>); <code>instanceof List&lt;?&gt;</code> "
     "invece si'<br>"
     "&bull; <b>Niente primitivi</b>: <code>List&lt;int&gt;</code> e' illegale, "
     "serve <code>List&lt;Integer&gt;</code> con boxing")

card("[Java][Teoria]",
     "Cos'e' un tipo <b>reificabile</b>? Perche' gli array lo sono e i "
     "generics no?",
     "<b>Reificabile</b> = tipo la cui informazione completa e' <b>disponibile "
     "a runtime</b>.<br><br>"
     "&bull; Gli <b>array sono reificati</b>: portano il proprio tipo di "
     "componente a runtime (per ogni T esiste un T[] distinto). E' per questo "
     "che " + c("Object[] o = new String[3]; o[0] = 42;") + " lancia "
     + c("ArrayStoreException") + ".<br><br>"
     "&bull; I <b>generics NON sono reificati</b>: dopo l'erasure "
     + c("List<String>") + " e' solo " + c("List") + ".<br><br>"
     "Questa distinzione spiega <b>entrambi</b> i divieti: non si possono "
     "creare array generici, e " + c("instanceof") + " su un tipo "
     "parametrizzato concreto e' vietato.")

card("[Java][Teoria]",
     "Enuncia <b>PECS</b> e giustificalo.",
     "<b>PECS = Producer Extends, Consumer Super</b> (Joshua Bloch, "
     "<i>Effective Java</i>).<br><br>"
     "&bull; <code>? extends T</code> quando il parametrizzato <b>PRODUCE</b> "
     "valori (li <b>leggi</b>)<br>"
     "&bull; <code>? super T</code> quando li <b>CONSUMA</b> (li <b>scrivi</b>)"
     + code("""
List<? extends Number> src;   // producer
Number n = src.get(0);        // OK: leggere e' sicuro
src.add(42);                  // ERRORE: potrebbe essere una List<Float>!

List<? super Number> dst;     // consumer
dst.add(42);                  // OK: qualunque Number ci sta
Object o = dst.get(0);        // si legge solo Object (potrebbe essere List<Object>)
""") + "<b>Giustificazione:</b> <code>extends</code> fissa un limite "
     "<b>superiore</b> sconosciuto (lettura sicura, scrittura no); "
     "<code>super</code> un limite <b>inferiore</b> sconosciuto (scrittura "
     "sicura, lettura solo a Object).<br><br>Corrisponde esattamente a "
     "covarianza e controvarianza.")

card("[Java][Trabocchetto]",
     "Perche' questi due metodi non possono coesistere?" + code("""
void process(List<String> list)  { }
void process(List<Integer> list) { }
"""),
     "Per <b>erasure</b>, entrambi diventano " + c("process(List)") + " nel "
     "bytecode: avrebbero la <b>stessa erased signature</b>, cioe' sarebbero "
     "letteralmente lo <b>stesso metodo</b> per la JVM.<br><br>"
     "Errore del compilatore:" + code(
         "name clash: process(List&lt;String&gt;) and<br>"
         "process(List&lt;Integer&gt;) have the same erasure") +
     "<b>Confronto col C++:</b> li' " + c("f(vector<int>)") + " e "
     + c("f(vector<string>)") + " sono <b>due overload perfettamente "
     "legali</b>, perche' le due specializzazioni sono tipi diversi e distinti "
     "anche dopo la compilazione (monomorfizzazione).")

card("[Java][Teoria]",
     "Cos'e' un <b>bridge method</b>, e quando viene generato?",
     "Un metodo <b>sintetico</b> (" + c("ACC_BRIDGE | ACC_SYNTHETIC") + ") "
     "generato dal compilatore per riconciliare l'erasure con la firma che la "
     "JVM richiede per il dispatch." + code("""
class Node<T>  { void set(T t) { } }            // erasa a set(Object)
class MyNode extends Node<Integer> {
    void set(Integer i) { }                     // firma DIVERSA da set(Object)
}
// il compilatore genera in MyNode:
//   void set(Object o) { this.set((Integer) o); }   <- bridge
""") + "<b>Il bug che ne deriva</b> (heap pollution):" + code("""
Node n = new MyNode();     // tipo RAW: niente checkcast al call site
n.set("stringa");          // ClassCastException DENTRO il bridge!
""") + "Vengono generati anche per i <b>return type covarianti</b> (base "
     "ritorna Object, derivata String &rarr; servono due metodi).")

# =====================================================================
# H. PYTHON
# =====================================================================

card("[Python][Teoria]",
     "Perche' Python non ha bisogno di template/generics?",
     "Perche' nei linguaggi a <b>tipizzazione dinamica</b> il passaggio di "
     "valori alle funzioni e l'assegnazione sono <b>type-indifferent</b>: la "
     "genericita' esiste <b>gia' per costruzione</b>.<br><br>"
     "Wikipedia osserva che questo di solito <b>non viene nemmeno chiamato "
     "&quot;genericita'&quot;</b>, perche' e' una conseguenza diretta del "
     "sistema di tipi, non un meccanismo dedicato.<br><br>"
     "<b>Collegamento con le slide:</b> e' esattamente il punto di "
     "&quot;Pre-OO solutions&quot; (slide 7), dove si dice che nei linguaggi "
     "dinamici i container omogenei <i>ed eterogenei</i> si costruiscono con "
     "facilita'.<br><i>(Wikipedia, &quot;Generic programming&quot;)</i>")

card("[Python][Cosa fa?][Trabocchetto]",
     code("""
from typing import TypeVar, Generic
T = TypeVar("T")

class Box(Generic[T]):
    def __init__(self, item: T) -> None:
        self.item = item

b = Box[int]("questa NON e' un int!")
print(type(b))
print(Box[int] is Box[str])
""") + "<br>Solleva errore? Cosa stampa?",
     "<b>Nessun errore.</b> Output verificato:" + code("""
<class '__main__.Box'>
False
""") + "<br><b>Perche':</b> " + c("Box[int]") + " invoca "
     + c("__class_getitem__") + ", che <b>non crea una classe nuova</b>: "
     "restituisce un oggetto " + c("_GenericAlias") + ", cioe' una semplice "
     "<b>etichetta</b> per i type checker. Chiamandolo, delega a "
     + c("Box(...)") + ".<br><br>"
     "A runtime esiste <b>solo <code>Box</code></b>: nessun controllo, nessuna "
     "specializzazione.<br><br>"
     "<b>Il contrasto:</b> C++ genera codice diverso per ogni tipo; Java "
     "controlla a compile time e poi cancella; <b>Python non fa ne' l'uno ne' "
     "l'altro</b> &mdash; solo mypy, <b>offline</b>, segnalerebbe l'errore."
     "<br><i>(prove/T07)</i>")

card("[Python][Cosa fa?]",
     code("""
def somma(a: int, b: int) -> int:
    return a + b

print(somma("foo", "bar"))
print(somma.__annotations__)
""") + "<br>Cosa succede?",
     "Stampa (verificato):" + code("""
foobar
{'a': <class 'int'>, 'b': <class 'int'>, 'return': <class 'int'>}
""") + "<br><b>Nessuna eccezione:</b> " + c('"foo" + "bar"') + " e' una "
     "concatenazione perfettamente valida.<br><br>"
     "I type hint, <b>di default</b>, non vengono controllati affatto a "
     "runtime: finiscono solo nel dizionario " + c("__annotations__") + ", "
     "pura <b>metadata</b> ispezionabile ma non applicata.<br><br>"
     "L'unico modo di intercettare il bug e' uno strumento di analisi statica "
     "<b>offline</b> (mypy), eseguito <i>prima</i> di lanciare il programma "
     "(oppure una libreria che li applica attivamente, come pydantic &mdash; "
     "ma non e' comportamento del linguaggio).")

card("[Python][Teoria]",
     "Cos'e' un " + c("Protocol") + ", e in che senso e' &quot;duck typing "
     "formalizzato&quot;?",
     "E' <b>structural typing</b>: un tipo soddisfa un Protocol se ha i "
     "<b>metodi giusti</b>, indipendentemente da qualunque dichiarazione di "
     "ereditarieta'." + code("""
from typing import Protocol

class Sized(Protocol):
    def __len__(self) -> int: ...

def descrivi(x: Sized) -> str:
    return f"dimensione {len(x)}"

class MioSacchetto:          # NON eredita da Sized!
    def __len__(self): return 42

descrivi(MioSacchetto())     # OK per mypy
""") + "<b>Contrasto con <code>abc.ABC</code></b>, che e' <b>nominale</b>: "
     "li' serve un esplicito <code>class X(Base)</code> o una "
     "<code>register()</code>.<br><br>"
     "<b>Nota:</b> " + c("isinstance()") + " su un Protocol semplice <b>non "
     "funziona</b>: serve decorarlo con " + c("@runtime_checkable") + ", e "
     "anche allora verifica solo la <i>presenza</i> dei metodi, non le firme."
     "<br><i>(Wikipedia, &quot;Duck typing&quot;; prove/T07)</i>")

card("[Trasv][Teoria][Esame]",
     "Wikipedia dice che i <b>template applicano lo stesso &quot;duck "
     "test&quot; del duck typing</b>. Spiega, e di' quale dei due e' piu' "
     "flessibile.",
     "Le funzioni template applicano il duck test in un contesto di "
     "tipizzazione <b>statica</b>, mantenendo vantaggi e svantaggi di entrambi "
     "gli approcci.<br><br>"
     "<b>Il duck typing e' PIU' FLESSIBILE</b>, perche' richiede solo "
     "l'implementazione dei metodi <b>effettivamente invocati a runtime</b>; i "
     "template richiedono invece che siano valide <b>tutte</b> le "
     "implementazioni non provabilmente irraggiungibili a compile time.<br><br>"
     "<b>Collegamento:</b> e' la stessa idea del &quot;non c'e' type checking "
     "completo alla definizione&quot; (slide 12) &mdash; l'istanziazione e' "
     "l'equivalente, a compile time, del momento in cui in Python emergerebbe "
     "un <code>AttributeError</code>.<br><i>(Wikipedia, &quot;Duck typing&quot;)</i>")

# =====================================================================
# I. C
# =====================================================================

card("[C][Cosa fa?][Trabocchetto]",
     code("""
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int i = 5;
int m = MAX(i++, 0);
printf("%d %d\\n", m, i);
""") + "<br>Cosa stampa? (non e' &quot;5 6&quot;)",
     "Stampa <b>6 7</b> (verificato).<br><br>"
     "<b>Espansione testuale:</b> " + c("((i++) > (0) ? (i++) : (0))") +
     "<br>1. si valuta la condizione " + c("(i++) > (0)") + ": restituisce 5 "
     "(vecchio valore) e porta <code>i</code> a <b>6</b>; 5&gt;0 e' vero<br>"
     "2. si valuta il ramo " + c("(i++)") + ": restituisce <b>6</b> e porta "
     "<code>i</code> a <b>7</b><br><br>"
     "<b>Il bug:</b> la macro, essendo pura sostituzione testuale, ha scritto "
     + c("i++") + " <b>due volte</b>, ed entrambe vengono valutate.<br><br>"
     "<b>Un template C++ non ha questo problema:</b> gli argomenti sono veri "
     "parametri di funzione, valutati una volta sola.<br><i>(prove/T08)</i>")

card("[C][Scrivi]",
     "<b>Scrivi</b> la versione &quot;sicura&quot; di " + c("MAX") + " in C "
     "che evita la doppia valutazione, e di' che limite ha.",
     "Con le estensioni GNU " + c("typeof") + " + <i>statement expression</i> "
     "(citata da Wikipedia):" + code("""
#define MAX_SICURA(a, b)          \\
    ({ typeof (a) _a = (a);       \\
       typeof (b) _b = (b);       \\
       _a > _b ? _a : _b; })
""") + "Gli argomenti finiscono in <b>variabili temporanee</b>, valutati "
     "<b>una volta sola</b>. Verificato: con <code>i=5</code>, "
     + c("MAX_SICURA(i++, 0)") + " da' <code>m=5, i=6</code> (corretto), "
     "contro <code>m=6, i=7</code> della versione ingenua.<br><br>"
     "<b>I limiti:</b><br>"
     "&bull; " + c("typeof") + " e le statement expression sono "
     "<b>estensioni GNU</b>, non C standard (serve <code>-std=gnu11</code>)<br>"
     "&bull; resta <b>pura espansione testuale</b>: nessun controllo di tipo "
     "reale, nessun messaggio d'errore sensato<br>"
     "&bull; i nomi <code>_a</code>/<code>_b</code> possono ancora fare "
     "<i>shadowing</i> di variabili del chiamante")

card("[C][Teoria][Trabocchetto]",
     c("_Generic") + " (C11) e' l'equivalente C dei template?",
     "<b>No.</b> Wikipedia e' netta: il C offre le <i>type-generic "
     "expression</i> con " + c("_Generic") + ", che forniscono "
     "<b>overloading di funzione</b>, ma <b>NON vera programmazione "
     "generica</b>." + code("""
#define valore_assoluto(x) _Generic((x), \\
        int:    abs,                     \\
        float:  fabsf,                   \\
        double: fabs)(x)
""") + "<b>La differenza fondamentale:</b> " + c("_Generic") + " sceglie a "
     "compile time fra un insieme <b>FISSO e scritto a mano</b> di funzioni "
     "gia' esistenti. <b>Non genera nulla.</b><br><br>"
     "Per supportare un nuovo tipo (es. <code>struct Vector3</code>) devi "
     "(a) <b>scrivere tu</b> <code>vector3_abs</code>, e (b) <b>modificare la "
     "macro</b>.<br><br>"
     "Un template C++ si istanzia da solo su <b>qualunque</b> tipo che "
     "supporti le operazioni usate &mdash; <b>anche tipi che non esistevano "
     "quando il template e' stato scritto</b>.<br><i>(prove/T08)</i>")

card("[C][Cosa fa?]",
     code("""
typedef struct { void **items; size_t n; } ListaGenerica;

int x = 42;
double y = 3.14;
ListaGenerica l = {0};
lista_push(&l, &x);
lista_push(&l, &y);

double *p = (double *)l.items[0];   /* era un int! */
printf("%f\\n", *p);
""") + "<br>Compila? Cosa stampa?",
     "<b>Compila senza un warning</b>, e stampa <b>spazzatura</b> (verificato: "
     "un numero dell'ordine di 1e63).<br><br>"
     "<b>Perche':</b> " + c("void*") + " accetta qualunque puntatore senza "
     "controlli. A runtime i byte di un <code>int</code> vengono "
     "reinterpretati come la rappresentazione IEEE-754 di un "
     "<code>double</code> &mdash; <i>type confusion</i>, e tecnicamente anche "
     "una violazione di <b>strict aliasing</b> (UB).<br><br>"
     "<b>Dove sarebbe stato impedito:</b><br>"
     "&bull; <b>C++</b>: un " + c("vector<int*>") + " fortemente tipato "
     "avrebbe rifiutato tutto a compile time<br>"
     "&bull; <b>Java</b>: non esistono puntatori grezzi, e i generics "
     "impediscono l'inserimento eterogeneo<br><i>(prove/T08)</i>")

# =====================================================================
# J. TRASVERSALI
# =====================================================================

card("[Trasv][Teoria][Esame]",
     "<b>Monomorfizzazione vs. type erasure:</b> spiega le due strategie e "
     "<b>perche'</b> ciascun linguaggio ha scelto la sua.",
     "<b>MONOMORFIZZAZIONE (C++, Rust):</b> il compilatore genera una "
     "<b>copia separata</b> del codice per ogni combinazione di parametri "
     "usata. Massime prestazioni (nessun boxing, tutto inlineabile), ma "
     "possibile <b>code bloat</b>.<br><br>"
     "<b>TYPE ERASURE (Java):</b> i parametri servono solo al type checker e "
     "vengono <b>cancellati</b>. Un solo bytecode, dimensione costante, ma "
     "informazioni di tipo <b>non disponibili a runtime</b>.<br><br>"
     "<b>PERCHE' (la domanda vera d'esame):</b><br>"
     "&bull; <b>Java</b>: <b>retrocompatibilita' stretta</b>. Nel 2004 "
     "esisteva gia' un enorme corpus di bytecode compilato senza generics; "
     "l'erasure permette di non toccare la JVM ne' il formato dei class file.<br>"
     "&bull; <b>C++</b>: i template nascono per la <b>massima prestazione a "
     "costo zero</b> (zero-overhead principle), e non c'era nessun vincolo "
     "storico di compatibilita' binaria da preservare.")

card("[Trasv][Teoria]",
     "Cosa manca ai <b>generics</b> (Java/.NET) rispetto ai <b>template</b> "
     "C++? (le cinque feature)",
     "1. <b>explicit specialization</b><br>"
     "2. <b>partial specialization</b><br>"
     "3. <b>default template argument</b><br>"
     "4. <b>non-type template argument</b> (es. <code>Array&lt;char, 6&gt;</code>)<br>"
     "5. <b>template template argument</b><br><br>"
     "Wikipedia: <i>&quot;i generics imitano solo il comportamento di base dei "
     "template C++&quot;</i>.<br><br>"
     "Sono proprio queste feature a rendere possibili le librerie di "
     "metaprogramming sofisticate come <b>Boost</b>, <b>STLSoft</b> e la "
     "<b>STL</b> stessa.<br><br>"
     "<i>(Nota storica: i generics di Ada PRECEDONO i template C++; Java e "
     "C# 1.0 inizialmente non avevano nulla.)</i>")

card("[Trasv][Teoria][Esame]",
     "<b>Tabella a quattro vie:</b> come si ottiene la genericita' in C, C++, "
     "Java e Python, e quando avviene il controllo?",
     "<b>C</b> &mdash; nessun meccanismo strutturato: macro (zero type check), "
     + c("void*") + " (zero type safety), " + c("_Generic") + " (insieme "
     "chiuso). Controllo: <b>mai</b>.<br><br>"
     "<b>C++</b> &mdash; template: <b>generazione di codice</b> a compile time "
     "(monomorfizzazione). Controllo: a compile time, ma <b>solo "
     "all'istanziazione</b>. Una copia per tipo.<br><br>"
     "<b>Java</b> &mdash; generics con <b>erasure</b>. Controllo: completo a "
     "compile time (grazie ai <i>bound</i>), poi cancellato. Una sola copia "
     "condivisa.<br><br>"
     "<b>Python</b> &mdash; nessuno: <b>duck typing</b>. Controllo: a "
     "<b>runtime</b>, e solo sui metodi davvero invocati (oppure offline con "
     "mypy, opzionale).")

card("[Trasv][Teoria][Esame]",
     "In una frase: qual e' il <b>filo che lega</b> template, generics e duck "
     "typing?",
     "Sono <b>tre risposte allo stesso problema</b> &mdash; evitare di "
     "duplicare codice per tipi diversi &mdash; che differiscono per "
     "<b>QUANDO</b> verificano che il tipo &quot;vada bene&quot;, non per "
     "<b>COSA</b> verificano (che il tipo supporti le operazioni richieste: il "
     "&quot;duck test&quot;).<br><br>"
     "&bull; <b>C++</b>: compile time, generando codice specifico<br>"
     "&bull; <b>Java</b>: compile time, poi cancellando tutto<br>"
     "&bull; <b>Python</b>: a runtime, senza generare nulla<br><br>"
     "Il <b>C</b> e' li' a ricordare cosa succede quando quel controllo, a "
     "qualunque livello, <b>semplicemente non c'e'</b>.")

card("[Trasv][Scrivi]",
     "<b>Scrivi</b> la stessa funzione &quot;massimo di due valori&quot; nei "
     "quattro linguaggi, evidenziando cosa garantisce ciascuno.",
     "<b>C++</b> &mdash; template, monomorfizzato:" + code("""
template <class T>
T massimo(T a, T b) { return a > b ? a : b; }
// ATTENZIONE: su char* confronta gli INDIRIZZI (serve specializzazione)
""") + "<b>Java</b> &mdash; generic con <b>bound</b>:" + code("""
static <T extends Comparable<T>> T massimo(T a, T b) {
    return a.compareTo(b) >= 0 ? a : b;
}
// il bound GARANTISCE a compile time che T sappia confrontarsi
""") + "<b>Python</b> &mdash; duck typing:" + code("""
def massimo(a, b):
    return a if a > b else b
# corretto su str: confronta il CONTENUTO
""") + "<b>C</b> &mdash; macro (con i suoi difetti):" + code("""
#define MAX(a, b) ((a) > (b) ? (a) : (b))
/* doppia valutazione, zero type checking */
""") + "<br><b>Il confronto che conta:</b> il <b>bound</b> Java e' proprio cio' "
     "che i template &quot;classici&quot; non hanno &mdash; per questo il C++ "
     "accetta " + c("char*") + " e produce un risultato semanticamente "
     "sbagliato, mentre Java rifiuterebbe a compile time un tipo non "
     "<code>Comparable</code>. (In C++20 i <b>concepts</b> colmano il divario.)")

card("[C++][Teoria]",
     "Cosa sono i <b>concepts</b> (C++20) e che problema risolvono?",
     "Un <b>predicato booleano valutato a compile time</b>, usato per "
     "<b>vincolare</b> i parametri di template &mdash; l'equivalente C++ dei "
     "<i>bound</i> di Java o delle clausole <code>where</code> di Rust." +
     code("""
template <std::totally_ordered T>
constexpr T massimo(T x, T y) { return x < y ? y : x; }

template <std::derived_from<Player> T>
void processa(const std::vector<T>& players) { }
""") + "<b>Il problema che risolvono:</b> senza concepts, un vincolo violato "
     "emerge come un <b>errore di sostituzione oscuro</b>, prodotto in "
     "profondita' dentro l'istanziazione del template (i famigerati muri di "
     "errori della STL).<br><br>"
     "Con i concepts il vincolo e' <b>dichiarato nella firma</b>, e il "
     "compilatore rifiuta subito il tipo sbagliato con un messaggio "
     "comprensibile &mdash; colmando proprio il divario con i generics Java.")

card("[C++][Teoria]",
     "Cosa sono i <b>variadic template</b> (C++11) e perche' sono "
     "importanti?",
     "Template che accettano un <b>numero variabile</b> di parametri." + code("""
template <typename... Args>
void log(const std::format_string<Args...>& fmt, Args&&... args) {
    std::println(logFile, fmt, args...);
}
""") + "<b>Perche' contano</b> (Wikipedia): in C++ sono supportati solo i "
     "parametri variadici <b>in stile C</b> (<code>...</code>, quelli di "
     "<code>printf</code>), che sono <b>type-unsafe</b>.<br><br>"
     "<b>L'unico modo di ottenere funzioni variadiche TYPE-SAFE</b> (come "
     "quelle di Java) e' proprio tramite i variadic template.<br><br>"
     "E' cio' che rende possibili " + c("std::format") + "/"
     + c("std::println") + " e " + c("make_unique") + ".")

card("[C++][Teoria]",
     "Cos'e' un <b>template alias</b> (C++11)?",
     "Un <b>typedef parametrizzato</b>: dà un nome comodo a un'istanziazione "
     "parziale di un template piu' complesso." + code("""
template <typename K, typename V>
using TreeMap = std::map<K, V>;

// si possono anche FISSARE alcuni parametri:
template <typename K>
using StringHashMap = HashMap<K, std::string>;

StringHashMap<int> myMap;   // == std::unordered_map<int, std::string>
""") + "Un semplice " + c("typedef") + " non puo' farlo: non accetta "
     "parametri.")

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
