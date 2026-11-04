#!/usr/bin/env python3
"""Genera il mazzo Anki su Virtual Functions / Ereditarieta'.
Ogni blocco di codice viene reso come <div left-aligned><code>...</code></div>
con indentazione preservata (&nbsp;) e a-capo (<br>), cosi' resta leggibile
anche se il notetype Anki centra il testo."""

import html

OUT = "/home/giovanni/Documents/università/AppuntiDelBasta/Anno3/ingegneria_del_software/virtual-functions-avanzato-anki.txt"

HEADER = """#separator:tab
#html:true
#notetype:Basic
#deck:Ingegneria del Software::Virtual Functions ed Ereditarieta' (teoria+codice)
"""


def code(src: str) -> str:
    """Blocco di codice: escaped, indentazione preservata, allineato a sinistra."""
    src = src.strip("\n")
    esc = html.escape(src, quote=False)
    out_lines = []
    for line in esc.split("\n"):
        stripped = line.lstrip(" ")
        n = len(line) - len(stripped)
        out_lines.append("&nbsp;" * n + stripped)
    body = "<br>".join(out_lines)
    # il <br> iniziale stacca sempre il blocco dal testo che lo precede
    return ('<br><div style="text-align:left; display:inline-block; '
            'margin:6px 0;"><code>' + body + "</code></div>")


def c(x: str) -> str:
    """codice inline"""
    return "<code>" + html.escape(x, quote=False) + "</code>"


CARDS = []


def card(tag, front, back):
    CARDS.append((tag + " " + front.strip(), back.strip()))


# =====================================================================
# A. TEORIA DI BASE (slide del corso)
# =====================================================================

card("[C++][Teoria]",
     "Cos'e' una <b>funzione virtuale</b>, e come si chiama la sua ridefinizione?",
     "Un metodo <b>non statico</b> di una classe base che puo' essere "
     "&quot;ridefinito&quot; nelle classi derivate. La ridefinizione si chiama "
     "<b>overriding</b>.<br><br><i>(slide 5)</i>")

card("[Teoria]",
     "Quali sono le <b>due condizioni</b> perche' avvenga overriding?",
     "1. Il metodo sovrascritto (nella base) deve essere <b>virtual</b>.<br>"
     "2. Il metodo che sovrascrive (nella derivata) deve avere la <b>stessa "
     "signature</b> e lo <b>stesso return type</b>.<br><br>"
     "In certi linguaggi l'overriding puo' essere impedito (es. "
     + c("final") + " in Java).<br><i>(slide 6)</i>")

card("[Teoria]",
     "Cosa include la <b>signature</b> di una funzione? E il <b>prototype</b>?",
     "<b>Signature</b> = nome + numero dei parametri formali + tipi dei "
     "parametri formali.<br>Il <b>return type NON e' incluso</b> nella "
     "signature.<br><br><b>Prototype</b> = signature + return type."
     "<br><i>(slide 7)</i>")

card("[Teoria]",
     "Quali sono le <b>tre possibilita'</b> quando una f() virtuale e' "
     "invocata su un oggetto <code>o</code> di classe D derivata da B?",
     "1. <code>f</code> definita <b>solo in D</b> &rarr; si chiama D.f<br>"
     "2. <code>f</code> definita <b>solo in B</b> &rarr; si chiama B.f (ereditata)<br>"
     "3. <code>f</code> <b>overridden in D</b> &rarr; si chiama D.f (la versione overridden)"
     "<br><br>In tutti i casi si usa la <b>classe reale dell'oggetto</b>, "
     "NON la classe del riferimento/puntatore.<br><i>(slide 11)</i>")

card("[Teoria]",
     "Quando emerge davvero il <b>vantaggio</b> delle funzioni virtuali?",
     "Quando si manipolano oggetti tramite <b>riferimenti o puntatori alla "
     "classe base</b>: solo in quel caso il comportamento &quot;virtuale&quot; "
     "diventa visibile.<br><br>Chiamando il metodo su un oggetto il cui tipo "
     "e' gia' noto a compile-time, si comporta come un metodo non virtuale."
     "<br><i>(slide 10, 12)</i>")

card("[Teoria]",
     "Cos'e' l'<b>early binding</b> (compile-time binding)?",
     "Il compilatore, incontrando una chiamata a funzione, scrive codice "
     "macchina che chiama un <b>indirizzo ben definito</b> (dove inizia il "
     "codice della funzione): &quot;lega&quot; il punto di chiamata al codice "
     "gia' a <b>compile time</b>.<br><br>E' il comportamento standard per "
     "funzioni e metodi C++ <b>non virtual</b>, e l'unico esistente nei "
     "linguaggi imperativi non-OO (C, Pascal).<br><i>(slide 29-30)</i>")

card("[Teoria]",
     "Cos'e' il <b>late binding</b> (run-time binding)?",
     "In presenza di funzioni virtuali il binding non puo' essere fatto a "
     "compile time: il compilatore <b>sa quale funzione e' virtual</b>, ma non "
     "puo' dedurre quale codice eseguire guardando solo la chiamata.<br><br>"
     "Scrive quindi codice macchina che <b>deduce l'indirizzo corretto a "
     "runtime</b>.<br><i>(slide 31)</i>")

card("[Teoria]",
     "Cosa sono <b>VFT</b> e <b>VFTP</b>?",
     "<b>VFT</b> (Virtual Function Table): tabella associata a <b>ogni classe</b> "
     "con funzioni virtuali, contiene i puntatori al codice di ciascuna "
     "funzione virtuale.<br><br>"
     "<b>VFTP</b> (Virtual Function Table Pointer): puntatore <b>nascosto "
     "all'utente</b> che <b>ogni oggetto</b> di tale classe porta con se', e "
     "che punta alla VFT della propria classe.<br><br>"
     "Nota: &quot;pointer&quot; qui = puntatore C++ <i>oppure</i> riferimento "
     "Java.<br><i>(slide 33)</i>")

card("[Teoria]",
     "Elenca i <b>5 passi</b> eseguiti a runtime per completare una chiamata "
     "late-bound.",
     "1. dal puntatore/riferimento si raggiunge l'<b>oggetto</b><br>"
     "2. si cerca il <b>VFTP</b> nell'oggetto<br>"
     "3. tramite il VFTP si trova la <b>VFT della classe reale</b><br>"
     "4. si cerca nella VFT l'<b>entry giusta</b> (es. VFP2 per la funzione VF2)<br>"
     "5. tramite quel puntatore si raggiunge ed <b>esegue il codice corretto</b>"
     "<br><i>(slide 35)</i>")

card("[Teoria]",
     "Se il late binding e' cosi' comodo, perche' il C++ non rende tutto "
     "virtual (come fa Java)?",
     "Per <b>efficienza</b>: il late binding e' relativamente costoso in tempo "
     "di esecuzione. Se un metodo e' chiamato molto di frequente ed e' "
     "semplice, l'overhead puo' diventare un collo di bottiglia.<br><br>"
     "In pratica pero' pochissimi punti di un programma medio sono cosi' "
     "critici: conta in <b>sistemi real-time</b>, <b>routine matematiche "
     "core</b>, <b>programmazione di sistema di basso livello</b>."
     "<br><i>(slide 36-38)</i>")

# =====================================================================
# B. COSA FA QUESTO CODICE — C++ base
# =====================================================================

card("[C++][Cosa fa?]",
     code("""
struct B {
    virtual void f() { cout << "B::f\\n"; }
             void g() { cout << "B::g\\n"; }
};
struct D : B {
    void f() override { cout << "D::f\\n"; }
    void g()          { cout << "D::g\\n"; }
};

int main() {
    D d;
    B* p = &d;
    p->f();
    p->g();
    d.f();
    d.g();
}
""") + "<br>Cosa stampa, riga per riga?",
     "Output (verificato):" + code("""
D::f
B::g
D::f
D::g
""") + "<br><b>Perche':</b> " + c("f()") + " e' virtual &rarr; late binding, "
     "si guarda la classe <b>reale</b> (D) anche tramite " + c("B*") + ".<br>"
     + c("g()") + " NON e' virtual &rarr; early binding, si guarda il "
     "<b>tipo del puntatore</b> (B). Con " + c("d.g()") + " il tipo statico e' "
     "gia' D, quindi sembra un override ma non lo e': e' <b>hiding</b>.<br><br>"
     "<i>La prova che g() e' hiding: p-&gt;g() e d.g() stampano cose DIVERSE.</i>"
     "<br><i>(prove/02)</i>")

card("[C++][Cosa fa?]",
     code("""
struct B {
    virtual void f(int i)    { cout << "B::f(int) " << i << "\\n"; }
             void f(double d){ cout << "B::f(double) " << d << "\\n"; }
};
struct D : B {
    void f(int i) override { cout << "D::f(int) " << i << "\\n"; }
};

int main() {
    D d;
    d.f(3.14);
}
""") + "<br>Cosa stampa? (attenzione, non e' quello che sembra)",
     "Stampa:" + code("D::f(int) 3") +
     "<br><b>Perche':</b> " + c("D::f(int)") + " <b>nasconde TUTTI</b> gli "
     "overload di " + c("f") + " ereditati (<b>name hiding</b>). Il name "
     "lookup si ferma al primo scope che contiene il nome " + c("f") + " "
     "(cioe' D), <b>prima</b> ancora di guardare quanti overload ci sono in B."
     "<br>L'unico candidato e' " + c("D::f(int)") + ", quindi 3.14 viene "
     "troncato a 3.<br><br><b>Tre fix:</b><br>"
     "1. " + c("using B::f;") + " dentro D<br>"
     "2. chiamata qualificata " + c("d.B::f(3.14)") + "<br>"
     "3. ridichiarare l'overload in D<br>"
     "(il flag " + c("-Woverloaded-virtual") + " lo intercetta)<br>"
     "<i>(prove/03)</i>")

card("[C++][Cosa fa?]",
     code("""
struct A {
    A()          { cout << "A() "; f(); }
    virtual ~A() { cout << "~A() "; g(); }
    virtual void f() { cout << "A::f\\n"; }
    virtual void g() { cout << "A::g\\n"; }
};
struct B : A {
    int x = 42;
    void f() override { cout << "B::f (x=" << x << ")\\n"; }
    void g() override { cout << "B::g (x=" << x << ")\\n"; }
};

int main() { B b; }
""") + "<br>Cosa stampa? Perche' NON si vede mai B::f ne' B::g?",
     "Output (verificato):" + code("""
A() A::f
~A() A::g
""") + "<br><b>Perche':</b> il tipo dinamico di un oggetto C++ <b>cresce</b> "
     "durante la costruzione e <b>decresce</b> durante la distruzione.<br><br>"
     "&bull; Nel corpo del ctor di A, l'oggetto E' ancora un A (il vptr punta "
     "alla vtable di A) &rarr; " + c("A::f") + ".<br>"
     "&bull; " + c("~A()") + " gira <b>dopo</b> " + c("~B()") + ": il vptr e' "
     "gia' tornato ad A &rarr; " + c("A::g") + ".<br><br>"
     "<b>E' una protezione:</b> se si chiamasse B::f dal ctor di A, leggerebbe "
     "<code>x</code> non ancora inizializzato.<br><i>(prove/04)</i>")

card("[C++][Cosa fa?]",
     code("""
struct A { virtual void f() { cout << "A::f\\n"; } };
struct B : virtual A { void f() override { cout << "B::f\\n"; } };
struct C : virtual A { };
struct D : B, C { };

int main() {
    D d;
    d.f();
}
""") + "<br>Compila? Cosa stampa? Come si chiama la regola in gioco?",
     "Compila e stampa:" + code("B::f") +
     "<br><b>Regola: DOMINANZA.</b><br>Con le basi <b>virtual</b> esiste un "
     "<b>solo</b> sotto-oggetto A condiviso; " + c("B::f") + " e' un override "
     "di quell'unico " + c("A::f") + ", quindi <b>domina</b> su di esso.<br>"
     "Il <i>final overrider</i> e' unico &rarr; nessuna ambiguita'.<br><br>"
     "<b>Verifica dell'unicita':</b> castando <code>&amp;d</code> ad A* via B e "
     "via C si ottiene lo <b>stesso indirizzo</b>.<br><i>(prove/06)</i>")

card("[C++][Cosa fa?]",
     code("""
struct A { virtual void f() { cout << "A::f\\n"; } };
struct B : A { void f() override { cout << "B::f\\n"; } };
struct C : A { };
struct D : B, C { };

int main() {
    D d;
    d.f();
}
""") + "<br>Uguale al precedente ma <b>senza</b> <code>virtual</code> nelle "
     "basi. Cosa cambia?",
     "<b>NON compila.</b> Errore reale di GCC:" + code("""
error: request for member 'f' is ambiguous
note: candidates are: 'virtual void A::f()'
note:                 'virtual void B::f()'
""") + "<br><b>Perche':</b> senza <code>virtual</code> ci sono <b>DUE</b> "
     "sotto-oggetti A distinti in D (uno via B, uno via C), quindi due "
     "<code>f()</code> candidate: quella overridden in B, e quella originale "
     "di A raggiunta via C. Nessuna delle due domina l'altra.<br><br>"
     "<b>Fix:</b> chiamata qualificata " + c("d.B::f();") +
     " (si sceglie <b>attraverso quale sotto-oggetto A</b> passare)."
     "<br><i>(prove/07)</i>")

card("[C++][Cosa fa?]",
     code("""
struct A { A(const char* who) { cout << "A(" << who << ") "; } };
struct B : virtual A { B() : A("da B") { cout << "B() "; } };
struct C : virtual A { C() : A("da C") { cout << "C() "; } };
struct D : B, C  { D() : A("da D"), B(), C() { cout << "D() "; } };
struct E : D     { E() : A("da E"), D()      { cout << "E() "; } };

int main() { E e; }
""") + "<br>Quale fra &quot;da B/C/D/E&quot; viene stampato? Uno solo o tutti?",
     "Output (verificato):" + code("A(da E) B() C() D() E()") +
     "<br><b>Un solo A(...), quello di E.</b><br><br>"
     "<b>Regola:</b> la base virtuale e' inizializzata <b>sempre dalla classe "
     "MOST DERIVED</b> (qui E). I mem-initializer per A scritti in B, C e D "
     "vengono <b>ignorati</b> in questa costruzione.<br><br>"
     "Costruendo un <code>D d;</code> da solo, invece, vincerebbe "
     "&quot;da D&quot;. Lo stesso mem-initializer viene usato o ignorato a "
     "seconda del ruolo della classe in quella costruzione.<br>"
     "<i>(prove/08)</i>")

card("[C++][Cosa fa?]",
     code("""
struct I {
    virtual void f() = 0;
    virtual ~I() = default;
};
struct L : virtual I { void f() override { cout << "L::f\\n"; } };
struct R : virtual I { };
struct D : L, R { };

int main() {
    D d;
    d.f();
}
""") + "<br>D e' istanziabile, dato che R non implementa f()?",
     "<b>Si', compila e stampa</b> " + c("L::f") + ".<br><br>"
     "Con ereditarieta' <b>virtuale</b> esiste un <b>solo</b> sotto-oggetto I: "
     "per dominanza il final overrider unico e' " + c("L::f") + ". Il ramo R "
     "&quot;eredita gratis&quot; l'implementazione dall'altra parte del "
     "diamante.<br><br>"
     "<b>Regola:</b> in un diamante virtuale un metodo puro va implementato "
     "<b>una volta sola</b>.<br><br>"
     "<b>Togliendo <code>virtual</code></b> dalle basi: due I distinti, quello "
     "via R ha ancora f() pura &rarr; D resta <b>astratta</b>, non "
     "istanziabile.<br><i>(prove/09)</i>")

card("[C++][Verificato]",
     code("""
struct Base {
    virtual void f() = 0;
    Base() { f(); }
};
struct Derivata : Base {
    void f() override { cout << "Derivata::f\\n"; }
};

int main() { Derivata d; }
""") + "<br>Chiamata a una virtuale <b>pura</b> dal costruttore: crash a "
     "runtime? Cosa succede DAVVERO?",
     "<b>NON e' un crash a runtime: e' un ERRORE DI LINK</b> (verificato, "
     "g++ 15.2.1):" + code("undefined reference to `Base::f()'") +
     "<br><b>Perche':</b> dentro il ctor di Base il compilatore <b>sa</b> che "
     "il tipo dinamico e' esattamente Base (non ancora Derivata), quindi "
     "<b>devirtualizza</b> la chiamata in una chiamata diretta a "
     + c("Base::f()") + ". Ma quel simbolo non esiste (pura, senza corpo) "
     "&rarr; se ne accorge il <b>linker</b>.<br><br>"
     "<i>La teoria dice &quot;UB&quot;; nella pratica di questa toolchain "
     "l'errore arriva prima, a link time.</i><br><i>(prove/05)</i>")

card("[C++][Trabocchetto]",
     "Una funzione virtuale <b>pura</b> (<code>= 0</code>) puo' avere un "
     "<b>corpo</b>? Se si', come lo si chiama?",
     "<b>SI'</b> — e' un &quot;corner case&quot; citato dai riferimenti di "
     "Wikipedia (Raymond Chen, <i>&quot;C++ corner case: you can implement pure "
     "virtual functions in the base class&quot;</i>).<br><br>"
     + code("""
struct Base {
    virtual void f() = 0;      // dichiarata pura...
    Base() { f(); }
};
void Base::f() {               // ...ma con un corpo!
    cout << "Base::f (default)\\n";
}
struct Derivata : Base {
    void f() override { cout << "Derivata::f\\n"; }
};
""") + "<br>" + c("= 0") + " impone solo che le derivate <b>concrete</b> "
     "facciano l'override: <b>non vieta</b> un'implementazione di default.<br>"
     "Il corpo e' invocabile solo per <b>chiamata qualificata</b> "
     "(" + c("Base::f()") + ") o, come qui, dal ctor della classe stessa: "
     "non finisce mai in vtable come &quot;la&quot; implementazione."
     "<br><b>Con il corpo, il programma sopra compila e stampa "
     "&quot;Base::f (default)&quot;.</b><br><i>(prove/05, variante B)</i>")

card("[C++][Verificato][Trabocchetto]",
     "La slide 18 dice: &quot;In C++ non esiste una keyword come <code>final</code> "
     "di Java, non e' possibile impedire l'hiding&quot;. E' ancora vero?",
     "<b>La slide e' datata.</b> Da <b>C++11</b> la keyword " + c("final") +
     " esiste e funziona (verificato con g++):" + code("""
struct B { virtual void f() { } };
struct D : B { void f() final { } };   // nessuno potra' piu' overridare f
struct E : D { void f() { } };         // ERRORE di compilazione
""") + "Errore reale prodotto:" + code(
         "error: virtual function 'virtual void E::f()'<br>overriding final function") +
     "<br>Si puo' marcare " + c("final") + " anche un'<b>intera classe</b> "
     "(" + c("struct D final : B { };") + ") per impedirne la derivazione, "
     "come in Java.<br><br>"
     "<b>Resta vero</b> il punto sostanziale della slide: " + c("final") +
     " impedisce l'<b>override</b>, ma non impedisce l'<b>hiding</b> di un "
     "nome non virtuale in una derivata.")

# =====================================================================
# C. SCRIVI IL CODICE — C++
# =====================================================================

card("[C++][Scrivi]",
     "<b>Scrivi</b> una gerarchia con una classe base astratta "
     + c("Shape") + " (metodo virtuale <b>puro</b> " + c("area()") + " e "
     "distruttore virtuale), due derivate " + c("Circle") + " e "
     + c("Rectangle") + ", e una funzione " + c("totalArea") + " che somma "
     "le aree di un " + c("vector&lt;Shape*&gt;") + " <b>senza usare "
     "if/switch/dynamic_cast</b>.",
     code("""
#include <iostream>
#include <vector>

struct Shape {
    virtual double area() const = 0;   // puro: Shape e' astratta
    virtual ~Shape() = default;        // OBBLIGATORIO: si distrugge via Shape*
};

struct Circle : Shape {
    double r;
    Circle(double r_) : r(r_) {}
    double area() const override { return 3.14159265 * r * r; }
};

struct Rectangle : Shape {
    double base, height;
    Rectangle(double b, double h) : base(b), height(h) {}
    double area() const override { return base * height; }
};

double totalArea(const std::vector<Shape*>& shapes) {
    double total = 0;
    for (Shape* s : shapes)
        total += s->area();            // late binding: nessun if!
    return total;
}

int main() {
    std::vector<Shape*> shapes;
    shapes.push_back(new Circle(2.0));
    shapes.push_back(new Rectangle(3.0, 4.0));

    std::cout << "Area totale: " << totalArea(shapes) << "\\n";

    for (Shape* s : shapes) delete s;
}
""") + "<br>Output verificato: " + c("Area totale: 24.5664") +
     " (4&pi; &asymp; 12.566 + 12).<br><br>"
     "<b>Il punto:</b> " + c("totalArea") + " non conosce ne' Circle ne' "
     "Rectangle, solo Shape. E' esattamente il late binding contrapposto agli "
     "<code>switch</code>/<code>if</code> manuali della slide 3.")

card("[C++][Scrivi]",
     "<b>Scrivi</b> il pattern <b>NVI</b> (Non-Virtual Interface): una classe "
     + c("Task") + " con interfaccia pubblica <b>non virtuale</b> "
     + c("run()") + " che stampa un prologo, chiama il punto di variazione, e "
     "stampa un epilogo. Il punto di variazione deve essere <b>virtuale "
     "privato</b>. Poi due derivate concrete.",
     code("""
#include <iostream>
#include <vector>
#include <string>

class Task {
public:
    void run() {                      // pubblico, NON virtuale
        std::cout << "Task: inizio\\n";
        execute();                    // punto di variazione
        std::cout << "Task: fine\\n";
    }
    virtual ~Task() = default;
private:
    virtual void execute() = 0;       // virtuale PRIVATO
};

class PrintTask : public Task {
    std::string msg;
public:
    PrintTask(std::string m) : msg(std::move(m)) {}
private:
    void execute() override {         // override di un metodo privato: OK!
        std::cout << "PrintTask: " << msg << "\\n";
    }
};

class SumTask : public Task {
    int a, b;
public:
    SumTask(int a_, int b_) : a(a_), b(b_) {}
private:
    void execute() override {
        std::cout << "SumTask: " << a + b << "\\n";
    }
};

int main() {
    std::vector<Task*> tasks;
    tasks.push_back(new PrintTask("ciao NVI"));
    tasks.push_back(new SumTask(3, 5));
    for (Task* t : tasks) t->run();   // solo run(), mai execute()
    for (Task* t : tasks) delete t;
}
""") + "<br><b>Perche' funziona un override di un metodo PRIVATO?</b><br>"
     "Controllo di accesso e dispatch dinamico sono <b>ortogonali</b>: "
     "l'accesso e' verificato sul tipo <b>statico</b> al punto di chiamata, il "
     "dispatch sul tipo <b>dinamico</b>. La derivata deve solo "
     "<b>ridefinirlo</b>, non chiamarlo.<br>"
     "Chiamare " + c("t->execute()") + " da fuori &rarr; <b>errore di "
     "compilazione</b> (&quot;execute is private&quot;).")

card("[C++][Scrivi]",
     "Questo codice <b>non compila</b>. Scrivi la correzione minima:" +
     code("""
struct Device {
    Device(std::string n) : name_(n) {}
    std::string name_;
};
struct Scanner : Device {
    Scanner() : Device("Scanner") {}
};
struct Printer : Device {
    Printer() : Device("Printer") {}
};
struct MFD : Scanner, Printer {
    MFD() : Device("MFD-3000"), Scanner(), Printer() {}
};
"""),
     "Errore reale prodotto:" + code(
         "error: type 'Device' is not a direct base of 'MFD'") +
     "<b>Fix:</b> rendere <code>Device</code> base <b>virtuale</b> in entrambi "
     "i rami:" + code("""
struct Scanner : virtual Device {
    Scanner() : Device("Scanner") {}
};
struct Printer : virtual Device {
    Printer() : Device("Printer") {}
};
struct MFD : Scanner, Printer {
    MFD() : Device("MFD-3000"), Scanner(), Printer() {}
};
""") + "<b>Perche':</b> senza <code>virtual</code>, Device non e' nemmeno una "
     "base <b>diretta</b> di MFD (e' annidata due volte), quindi MFD non puo' "
     "nominarla nella propria initializer list.<br>"
     "Con <code>virtual</code>, la base virtuale diventa responsabilita' della "
     "classe most-derived, che <b>deve</b> poterla nominare.<br><br>"
     "Output con il fix: " + c("Device(MFD-3000)") + " stampato <b>una sola "
     "volta</b>.<br><i>(prove/es_06)</i>")

card("[C++][Scrivi]",
     "<b>Scrivi</b> un diamante che dimostri la <b>dominanza</b>, e poi "
     "spiega cosa cambierebbe se <b>entrambi</b> i rami intermedi facessero "
     "l'override.",
     code("""
#include <iostream>

struct Shape { virtual void draw() { std::cout << "Shape\\n"; } };
struct Colored  : virtual Shape { void draw() override { std::cout << "Colored\\n"; } };
struct Bordered : virtual Shape { };          // NON fa override
struct Widget   : Colored, Bordered { };

int main() {
    Widget w;
    w.draw();          // stampa "Colored": dominanza
}
""") + "<b>Se ANCHE Bordered facesse l'override</b> di " + c("draw()") + ":" +
     code("""
error: no unique final overrider for
       'virtual void Shape::draw()' in 'Widget'
""") + "<b>Nota cruciale:</b> l'errore e' emesso alla <b>DEFINIZIONE di "
     "Widget</b>, non al punto di chiamata &mdash; il programma e' ill-formed "
     "anche se non chiami mai draw().<br><br><b>Fix:</b> Widget deve fornire il "
     "proprio override, che domina entrambi:" + code("""
struct Widget : Colored, Bordered {
    void draw() override {
        std::cout << "Widget\\n";
        Colored::draw();      // se vuoi, richiama esplicitamente i rami
        Bordered::draw();
    }
};
""") + "<i>(prove/es_03)</i>")

# =====================================================================
# D. EREDITARIETA' VIRTUALE — teoria
# =====================================================================

card("[C++][Teoria]",
     "Cos'e' il <b>diamond problem</b> e cosa garantisce l'<b>ereditarieta' "
     "virtuale</b>?",
     "<b>Diamond problem:</b> se B e C derivano da A, e D deriva da B e C, "
     "allora un oggetto D contiene <b>due copie</b> delle variabili membro di "
     "A (una via B, una via C), accessibili indipendentemente con lo scope "
     "resolution.<br><br>"
     "<b>Ereditarieta' virtuale:</b> tecnica che garantisce che venga "
     "ereditata <b>una sola copia</b> della base:" +
     code("class Derived : virtual public Base { };") +
     "<i>(Wikipedia, &quot;Virtual inheritance&quot;)</i>")

card("[C++][Teoria]",
     "<b>Chi</b> inizializza una base virtuale, e cosa succede ai "
     "mem-initializer scritti nelle classi intermedie?",
     "La base virtuale e' inizializzata <b>sempre dal costruttore della classe "
     "MOST DERIVED</b> (quella dell'oggetto che si sta effettivamente "
     "creando).<br><br>"
     "Tutti i mem-initializer per quella base scritti nelle classi "
     "<b>intermedie</b> vengono <b>IGNORATI</b> quando quelle classi non sono "
     "l'oggetto most-derived.<br><br>"
     "<b>Perche':</b> impedisce che piu' classi intermedie inizializzino la "
     "base condivisa piu' volte.<br><br>"
     "<b>Conseguenza pratica:</b> se la base virtuale non ha un ctor di "
     "default, <b>ogni</b> classe concreta della gerarchia (a qualunque "
     "profondita') e' obbligata a nominarla esplicitamente.<br>"
     "<i>(Thinking in C++ vol.2 cap.9; prove/08)</i>")

card("[C++][Teoria]",
     "Qual e' l'<b>ordine di costruzione</b> dei sotto-oggetti in una "
     "gerarchia con basi virtuali?",
     "1. tutte le <b>basi virtuali</b> (in ordine depth-first, sinistra&rarr;destra, "
     "sulla gerarchia della classe most-derived)<br>"
     "2. le <b>basi non virtuali</b>, in ordine di dichiarazione<br>"
     "3. i <b>membri</b>, in ordine di dichiarazione<br>"
     "4. il <b>corpo</b> del costruttore<br><br>"
     "La <b>distruzione</b> avviene in ordine esattamente inverso.")

card("[C++][Teoria]",
     "Nell'esempio Animal/Mammal/WingedAnimal/Bat, il layout di Bat con "
     "ereditarieta' virtuale e':" +
     code("(vpointer, Mammal, vpointer, WingedAnimal, Bat, Animal)") +
     "Perche' Animal e' <b>in fondo</b>? Perche' <b>due</b> vpointer?",
     "<b>Animal in fondo:</b> Mammal e WingedAnimal devono conservare il "
     "layout che avrebbero <b>da soli</b> (cosi' il codice compilato per "
     "Mammal continua a funzionare). L'unica copia condivisa va quindi in una "
     "posizione che non appartiene a nessuno dei due rami.<br><br>"
     "<b>Due vpointer:</b> ogni ramo deve sapere &quot;quanto dista da qui il "
     "mio Animal&quot; (<b>vbase offset</b>), e quella distanza <b>non e' nota "
     "a compile time</b>: dipende da come il sotto-oggetto e' immerso "
     "nell'oggetto completo (un Mammal autonomo vs. un Mammal dentro un Bat).<br><br>"
     "<b>Costo:</b> l'oggetto cresce di due puntatori rispetto alla versione "
     "non virtuale.<br><i>(Wikipedia, &quot;Virtual inheritance&quot;)</i>")

card("[C++][Trabocchetto]",
     "Perche' " + c("static_cast") + " da un puntatore a <b>base virtuale</b> "
     "verso la derivata e' <b>vietato</b>? Cosa si usa?",
     "Perche' il compilatore dovrebbe sottrarre un <b>offset che non conosce "
     "staticamente</b> (il vbase offset e' noto solo a runtime, dalla vtable)."
     + code("""
Animal* pa = &bat;
Bat* p1 = static_cast<Bat*>(pa);    // ILL-FORMED
Bat* p2 = dynamic_cast<Bat*>(pa);   // OK
""") + "E' l'<b>unico caso</b> in cui " + c("dynamic_cast") + " e' "
     "<b>obbligatorio</b> pur non essendoci alcuna incertezza sul tipo "
     "effettivo dell'oggetto.")

card("[C++][Teoria]",
     "Qual e' il <b>criterio</b> per decidere se una base va ereditata "
     "virtualmente? Un esempio reale nella libreria standard?",
     "<b>Criterio:</b> usa <code>virtual</code> quando l'ereditarieta' esprime "
     "una <b>restrizione di un insieme</b> (un Bat <i>e'</i> un Animal, uno "
     "solo). Non serve quando esprime <b>composizione di parti</b> "
     "indipendenti, dove copie separate sono coerenti.<br><br>"
     "<b>Esempio reale:</b> " + c("basic_istream") + " e " + c("basic_ostream") +
     " derivano <b>virtualmente</b> da " + c("basic_ios") + ", cosi' che "
     + c("basic_iostream") + " (da cui " + c("stringstream") + ", "
     + c("fstream") + ") abbia <b>un solo</b> stato di stream condiviso "
     "invece di due (un solo buffer, un solo set di flag di errore).")

# =====================================================================
# E. JAVA
# =====================================================================

card("[Java][Teoria]",
     "In Java, quali metodi sono virtual? Come si impedisce l'override?",
     "In Java <b>tutti i metodi non statici sono virtual</b>: l'overriding e' "
     "sempre un'opzione, e avviene <b>automaticamente</b> (nessuna keyword "
     "<code>virtual</code> da scrivere).<br><br>"
     "<b>Per impedirlo:</b> " + c("final") + " sul metodo.<br>"
     "<b>Per impedire l'estensione:</b> " + c("final") + " sull'intera classe."
     "<br><br><b>Non possono essere overridden:</b> " + c("final") + ", "
     + c("private") + ", " + c("static") + ".<br><i>(slide 16)</i>")

card("[Java][Cosa fa?]",
     code("""
class A {
    String x = "A";
    String get()  { return x; }
    String getX() { return x; }
}
class B extends A {
    String x = "B";
    String get() { return x; }
}

A a = new B();
System.out.println(a.x);        // (1)
System.out.println(a.get());    // (2)
System.out.println(a.getX());   // (3)
System.out.println(((B)a).x);   // (4)
""") + "<br>Cosa stampa ciascuna riga?",
     "(1) <b>A</b> &mdash; i <b>campi NON sono polimorfici</b>: risolti a "
     "compile time sul tipo <b>statico</b> (<code>A a</code>).<br>"
     "(2) <b>B</b> &mdash; i <b>metodi</b> si': dispatch sul tipo dinamico.<br>"
     "(3) <b>A</b> &mdash; " + c("getX()") + " e' definito <b>dentro A</b>, e "
     "nel suo corpo <code>x</code> si riferisce ad <code>A.x</code>.<br>"
     "(4) <b>B</b> &mdash; col cast, il tipo statico e' B.<br><br>"
     "<b>Punto chiave:</b> " + c("B.x") + " non <i>sostituisce</i> "
     + c("A.x") + ", lo <b>nasconde</b>: nell'oggetto esistono <b>due campi "
     "distinti</b>. Da dentro B, " + c("A.x") + " resta accessibile con "
     + c("super.x") + " o " + c("((A)this).x") + ".")

card("[Java][Teoria]",
     "A cosa serve l'annotazione " + c("@Override") + ", visto che "
     "l'overriding in Java e' automatico?",
     "E' <b>opzionale ma fortemente raccomandata</b>: non cambia nulla a "
     "runtime, ma dice al compilatore <i>&quot;questo metodo DEVE essere un "
     "override di qualcosa&quot;</i>." + code("""
class Animal { public void makeSound() { } }

class Dog extends Animal {
    @Override
    public void makeSund() { }   // typo!
}
""") + "<b>Senza <code>@Override</code></b>: compila silenziosamente &mdash; "
     "e' semplicemente un <b>overload</b> inutile, e il metodo della base non "
     "viene mai sovrascritto (bug silenzioso).<br>"
     "<b>Con <code>@Override</code></b>: errore di compilazione &mdash; "
     "<i>&quot;method does not override a method from its superclass&quot;</i>."
     "<br><br>Stesso servizio che rende " + c("override") + " del C++11 utile."
     "<br><i>(Wikipedia, &quot;Method overriding&quot;)</i>")

card("[Java][Cosa fa?]",
     code("""
class A {
    A() { init(); }
    void init() { System.out.println("A.init"); }
}
class B extends A {
    final int y;
    B() { y = 99; }
    @Override void init() {
        System.out.println("B.init: y=" + y);
    }
}

new B();
""") + "<br>Quale init() viene chiamato, e quanto vale y?",
     "Chiama <b>B.init</b> (non A.init!), e stampa <b>y=0</b>, non 99.<br><br>"
     "<b>Differenza chiave col C++:</b> in Java il tipo dinamico e' <b>gia' "
     "quello finale</b> fin dal primo istante della costruzione, quindi il "
     "dispatch e' &quot;corretto&quot; &mdash; in C++ invece si sarebbe "
     "chiamato A.init (il tipo dinamico cresce).<br><br>"
     "<b>Ma il problema resta:</b> gli inizializzatori e il corpo del ctor di "
     "B girano solo <b>DOPO</b> il ritorno da <code>super()</code>, quindi "
     "<code>y</code> vale ancora il default <b>0</b> &mdash; <i>anche se e' "
     "dichiarato <code>final</code></i>.<br><br>"
     "<b>Regola (Effective Java / Scott Meyers):</b> mai chiamare un metodo "
     "overridabile dal costruttore, ne' in Java ne' in C++.")

card("[Java][Teoria]",
     "Cosa sono i <b>covariant return type</b>? Da quando esistono in Java?",
     "Da <b>Java 5</b>: un override puo' restituire un <b>sottotipo</b> del "
     "return type dichiarato nella base." + code("""
class Animal { Animal clone2() { return new Animal(); } }

class Dog extends Animal {
    @Override
    Dog clone2() { return new Dog(); }   // Dog e' sottotipo di Animal: OK
}
""") + "In <b>C++</b> vale la stessa idea, ma la covarianza e' ammessa solo su "
     "<b>puntatori o riferimenti</b> a classi in relazione di derivazione "
     "(e' l'idioma " + c("clone()") + ", il &quot;costruttore virtuale&quot;).")

card("[Java][Scrivi]",
     "<b>Scrivi</b> in Java l'equivalente dell'esempio Animal/Dog/Cat delle "
     "slide, e aggiungi una classe che dimostri l'uso di " + c("final") +
     " per vietare l'override.",
     code("""
class Animal {
    public void voice() { System.out.println("???"); }
}
class Dog extends Animal {
    @Override public void voice() { System.out.println("bau"); }
}
class Cat extends Animal {
    @Override public void voice() { System.out.println("miao"); }
}

class Base {
    public final void nonOverridabile() {
        System.out.println("Base.nonOverridabile");
    }
    public void overridabile() {
        System.out.println("Base.overridabile");
    }
}
class Derivata extends Base {
    // public void nonOverridabile() { }  // ERRORE: e' final
    @Override public void overridabile() {
        System.out.println("Derivata.overridabile");
    }
}

public class Demo {
    public static void main(String[] args) {
        Animal a = new Dog();
        Animal b = new Cat();
        a.voice();                  // bau
        b.voice();                  // miao

        Base base = new Derivata();
        base.overridabile();        // Derivata.overridabile
        base.nonOverridabile();     // Base.nonOverridabile (sempre)
    }
}
""") + "<br>Output: " + c("bau / miao / Derivata.overridabile / "
     "Base.nonOverridabile") + "<br><i>(slide 25; prove/10)</i>")

# =====================================================================
# F. PYTHON
# =====================================================================

card("[Python][Teoria]",
     "Perche' in Python non esiste la keyword " + c("virtual") + "?",
     "Perche' <b>non serve</b>: in Python <b>ogni</b> metodo e' dinamicamente "
     "dispatchato per costruzione. Il lookup di un attributo segue sempre "
     "l'<b>MRO del tipo REALE</b> dell'oggetto.<br><br>"
     "Non esiste una versione &quot;non virtuale&quot; tra cui scegliere, "
     "quindi non c'e' nulla da dichiarare.<br><br>"
     "<b>Confronto:</b><br>"
     "&bull; C++: non virtuale di default, <code>virtual</code> per attivarlo<br>"
     "&bull; Java: virtuale di default, <code>final</code> per vietarlo<br>"
     "&bull; Python: sempre virtuale, nessun modo di impedirlo")

card("[Python][Cosa fa?]",
     code("""
class A:
    def f(self): print("A.f")

class B(A):
    def f(self): print("B.f"); super().f()

class C(A):
    def f(self): print("C.f"); super().f()

class D(B, C):
    def f(self): print("D.f"); super().f()

print(D.__mro__)
D().f()
""") + "<br>Qual e' l'MRO? Quante volte viene eseguito A.f?",
     "MRO (linearizzazione <b>C3</b>):" + code("(D, B, C, A, object)") +
     "Output:" + code("""
D.f
B.f
C.f
A.f
""") + "<br><b>A.f e' eseguito UNA SOLA volta</b>, non una per ramo del "
     "diamante.<br><br>"
     "<b>Il punto cruciale:</b> " + c("super()") + " <b>non</b> significa "
     "&quot;la superclasse&quot;, ma <b>&quot;il prossimo nell'MRO "
     "dell'oggetto&quot;</b>. Dentro " + c("B.f") + ", con "
     + c("type(self) is D") + ", il successivo dopo B e' <b>C</b>, non A!<br>"
     "E' cosi' che Python ottiene &quot;gratis&quot; cio' che in C++ richiede "
     "l'<b>ereditarieta' virtuale</b>.<br><i>(prove/14)</i>")

card("[Python][Cosa fa?]",
     code("""
class A:
    def __init__(self):
        self.__helper()
    def __helper(self):
        print("A helper")

class B(A):
    def __helper(self):
        print("B helper")

B()
""") + "<br>Stampa &quot;A helper&quot; o &quot;B helper&quot;? Perche'?",
     "Stampa <b>&quot;A helper&quot;</b>.<br><br>"
     "<b>NAME MANGLING:</b> il doppio underscore iniziale viene riscritto dal "
     "compilatore in base alla <b>classe dentro cui il codice e' scritto</b>:<br>"
     "&bull; dentro A, " + c("self.__helper") + " &rarr; " + c("self._A__helper") + "<br>"
     "&bull; B definisce invece " + c("_B__helper") + "<br><br>"
     "I due nomi sono <b>diversi</b>: nessuna collisione, quindi <b>nessun "
     "override</b>.<br><br>"
     "E' l'unico modo idiomatico in Python di ottenere un metodo <b>di fatto "
     "non virtuale</b> (utile per NVI e per evitare collisioni nei mixin)."
     "<br><b>Non e' sicurezza:</b> " + c("b._A__helper()") + " funziona "
     "benissimo dall'esterno.<br><i>(prove/15)</i>")

card("[Python][Trabocchetto]",
     code("""
from abc import abstractmethod

class Base:
    @abstractmethod
    def f(self): ...

class Impl(Base):
    pass          # NON fa l'override di f()

Impl()
""") + "<br>Solleva un errore?",
     "<b>NO: si istanzia senza alcun errore!</b> (verificato)<br><br>"
     "<b>Perche':</b> " + c("@abstractmethod") + " da solo si limita a "
     "impostare " + c("__isabstractmethod__ = True") + " sulla funzione. Il "
     "controllo che <b>impedisce l'istanziazione</b> e' fatto dalla "
     "<b>metaclasse ABCMeta</b>, che popola " + c("__abstractmethods__") +
     " alla creazione della classe.<br><br><b>Fix:</b>" + code("""
from abc import ABC, abstractmethod

class Base(ABC):              # <-- ora ABCMeta e' in gioco
    @abstractmethod
    def f(self): ...

class Impl(Base): pass
Impl()
""") + "Ora solleva:" + code(
         "TypeError: Can't instantiate abstract class Impl<br>"
         "without an implementation for abstract method 'f'") +
     "<i>(prove/16)</i>")

card("[Python][Scrivi]",
     "<b>Scrivi</b> in Python l'equivalente del pattern NVI del C++ "
     "(interfaccia pubblica non sovrascrivibile + punto di variazione), "
     "sfruttando il name mangling.",
     code("""
class Task:
    def run(self):                    # interfaccia pubblica
        print("Task: inizio")
        self.execute()                # punto di variazione (sovrascrivibile)
        self.__cleanup()              # NON sovrascrivibile (mangling)
        print("Task: fine")

    def execute(self):
        raise NotImplementedError

    def __cleanup(self):              # diventa _Task__cleanup
        print("Task: cleanup interno")


class PrintTask(Task):
    def __init__(self, msg):
        self.msg = msg

    def execute(self):                # override normale: funziona
        print("PrintTask:", self.msg)

    def __cleanup(self):              # diventa _PrintTask__cleanup:
        print("QUESTO NON VIENE MAI CHIAMATO da run()")


PrintTask("ciao").run()
""") + "Output:" + code("""
Task: inizio
PrintTask: ciao
Task: cleanup interno
Task: fine
""") + "<br><code>execute()</code> (nome normale) e' sovrascrivibile; "
     "<code>__cleanup()</code> no, perche' dentro <code>Task.run</code> il "
     "nome e' gia' stato riscritto in <code>self._Task__cleanup()</code>.<br>"
     "Per l'astrazione vera, meglio comunque " + c("abc.ABC") + " + "
     + c("@abstractmethod") + " su <code>execute</code>.")

# =====================================================================
# G. C
# =====================================================================

card("[C][Teoria]",
     "Il C ha le funzioni virtuali? Come si ottiene il polimorfismo?",
     "<b>No</b>: il C non ha classi, ne' <code>virtual</code>, ne' alcuna "
     "forma di overriding nel linguaggio (la voce Wikipedia "
     "&quot;Method overriding&quot; non ha nemmeno una sezione sul C).<br><br>"
     "Il meccanismo si costruisce <b>a mano</b>, traducendo letteralmente "
     "VFT/VFTP:<br>"
     "&bull; una " + c("struct") + " che fa da <b>VFT</b> (campi = puntatori a funzione)<br>"
     "&bull; una struct &quot;base&quot; che contiene il <b>VFTP</b><br>"
     "&bull; le &quot;derivate&quot; incorporano la base come <b>primo membro</b><br>"
     "&bull; il &quot;costruttore&quot; installa il vptr <b>a mano</b><br><br>"
     "<b>Usato davvero:</b> " + c("struct file_operations") + " nel VFS del "
     "kernel Linux, e GObject/GTK.")

card("[C][Scrivi]",
     "<b>Scrivi in C puro</b> un dispatch dinamico: una &quot;classe base&quot; "
     "Shape con VFT, una &quot;derivata&quot; Circle, e un ciclo che chiama "
     + c("area()") + " su un array di Shape* <b>senza if/switch</b>.",
     code("""
#include <stdio.h>
#include <stdlib.h>

/* la VFT: tabella di puntatori a funzione, UNA per "classe" */
typedef struct {
    void   (*draw)(const void *self);
    double (*area)(const void *self);
} ShapeVT;

/* la "classe base": porta solo il VFTP */
typedef struct { const ShapeVT *vptr; } Shape;

/* la "derivata": incorpora Shape come PRIMO membro */
typedef struct { Shape base; double r; } Circle;

static void circle_draw(const void *self) {
    printf("Circle(r=%.1f)\\n", ((const Circle *)self)->r);
}
static double circle_area(const void *self) {
    double r = ((const Circle *)self)->r;
    return 3.14159265 * r * r;
}
static const ShapeVT CIRCLE_VT = { circle_draw, circle_area };

/* il "costruttore": installa il vptr A MANO */
Circle *circle_new(double r) {
    Circle *c = malloc(sizeof *c);
    c->base.vptr = &CIRCLE_VT;      /* se lo dimentichi: segfault */
    c->r = r;
    return c;
}

/* dispatch "virtuale": i 5 passi della teoria */
double shape_area(const Shape *s) { return s->vptr->area(s); }

int main() {
    Shape *shapes[1];
    shapes[0] = (Shape *)circle_new(2.0);

    double tot = 0;
    for (int i = 0; i < 1; ++i)
        tot += shape_area(shapes[i]);   /* nessun if sul tipo! */

    printf("Area totale: %.4f\\n", tot);
    for (int i = 0; i < 1; ++i) free(shapes[i]);
}
""") + "<br><b>Perche' la base DEVE essere il primo membro?</b><br>"
     "Lo standard C garantisce l'assenza di padding all'<b>inizio</b> di una "
     "struct: quindi " + c("(Shape*)circle == &amp;circle->base") + ", e la "
     "conversione derivata&rarr;base e' un <b>no-op</b> (nessun aggiustamento "
     "del puntatore, nessun <i>thunk</i>).<br><i>(prove/12)</i>")

card("[C][Verificato]",
     "In C, cosa succede DAVVERO se ti dimentichi di inizializzare il vptr?" +
     code("""
Circle *c = malloc(sizeof *c);
c->r = 5.0;
/* c->base.vptr = &CIRCLE_VT;   <-- DIMENTICATA */
c->base.vptr->draw(c);
"""),
     "<b>Segmentation fault</b> (verificato: exit code 139).<br><br>"
     + c("malloc") + " non azzera la memoria: il vptr contiene spazzatura, e "
     "chiamare una funzione attraverso di esso salta a un indirizzo casuale."
     "<br><br><b>Il confronto che conta:</b> in <b>C++ questa riga non la "
     "scrivi mai</b> &mdash; il compilatore la genera automaticamente "
     "all'inizio di <b>ogni</b> costruttore, per <b>ogni livello</b> della "
     "gerarchia (ed e' esattamente il motivo per cui il tipo dinamico "
     "&quot;cresce&quot; durante la costruzione!).<br>"
     "In C, dimenticarla e' un errore reale e frequente.<br><i>(prove/13)</i>")

card("[C][Trabocchetto]",
     "In C, " + c("struct file_operations") + " del kernel Linux e il "
     "comparatore di " + c("qsort") + " sono entrambi puntatori a funzione. "
     "Sono la stessa cosa?",
     "<b>No, sono due pattern diversi.</b><br><br>"
     "&bull; " + c("struct file_operations") + " = <b>overriding</b>: e' una "
     "<b>VFT</b> vera e propria, associata al <b>tipo</b> di file (ext4, "
     "procfs, un driver...) e raggiunta da " + c("struct file") + " tramite il "
     "campo " + c("f_op") + ". Ogni filesystem &quot;eredita&quot; la tabella e "
     "ridefinisce solo le entry che gli servono.<br><br>"
     "&bull; " + c("qsort(arr, n, sizeof(int), cmp)") + " = <b>Strategy / "
     "callback</b>: la funzione e' passata <b>per parametro alla singola "
     "chiamata</b>, non e' associata al <i>tipo</i> degli oggetti ordinati. "
     "Non esiste alcuna &quot;classe&quot; che la eredita.")

# =====================================================================
# H. TRASVERSALI
# =====================================================================

card("[Trasv][Teoria]",
     "Confronta il <b>momento in cui il tipo dinamico diventa quello finale</b> "
     "durante la costruzione, in C++, Java e Python.",
     "<b>C++:</b> il tipo dinamico <b>cresce</b> durante la costruzione (e "
     "decresce durante la distruzione): nel ctor di A l'oggetto E' un A, il "
     "vptr viene riscritto a ogni livello. Una virtuale chiamata da li' "
     "risolve alla <b>classe corrente</b>.<br><br>"
     "<b>Java e Python:</b> il tipo dinamico e' <b>gia' quello finale</b> dal "
     "primo istante: la virtuale chiamata dal ctor della base risolve alla "
     "<b>sottoclasse</b>.<br><br>"
     "<b>Il problema resta in tutti e tre</b>, solo spostato: in Java/Python il "
     "metodo giusto viene chiamato, ma legge campi <b>non ancora "
     "inizializzati</b> (default/AttributeError). Regola comune: <b>mai "
     "chiamare metodi overridabili dal costruttore</b>.")

card("[Trasv][Teoria]",
     "Tabella: come si chiama esplicitamente l'implementazione della "
     "<b>classe base</b> nei quattro linguaggi?",
     "&bull; <b>C++:</b> " + c("Base::f()") + " (scope resolution, non una keyword)<br>"
     "&bull; <b>Java:</b> " + c("super.f()") + " &mdash; e " + c("B.super.f()") +
     " per i default method delle interfacce<br>"
     "&bull; <b>Python:</b> " + c("super().f()") + " (attenzione: segue l'MRO, "
     "non &quot;la superclasse&quot;!) oppure " + c("A.f(self)") + "<br>"
     "&bull; <b>C:</b> " + c("parent_vt->f(self)") + ", esplicito e scritto a mano"
     "<br><br><i>(Wikipedia, &quot;Method overriding&quot;: Eiffel usa "
     "<code>Precursor</code>, Delphi <code>inherited</code>, Ruby "
     "<code>super</code>)</i>")

card("[Trasv][Trabocchetto]",
     "Distingui con precisione: <b>overriding</b>, <b>overloading</b>, "
     "<b>hiding/shadowing</b>, <b>dominanza</b>.",
     "&bull; <b>Overriding</b>: stessa firma, risolto sul tipo <b>dinamico</b>. "
     "C++ (solo se <code>virtual</code>), Java (default), Python (sempre).<br><br>"
     "&bull; <b>Overloading</b>: stesso nome, parametri diversi, risolto a "
     "<b>compile time</b>. C++ e Java. In Python NON esiste (l'ultima "
     "definizione vince; si emula con " + c("functools.singledispatch") + ").<br><br>"
     "&bull; <b>Hiding/shadowing</b>: un nome in uno scope piu' interno oscura "
     "quello esterno, <b>senza</b> polimorfismo (risoluzione statica). C++: "
     "name hiding degli overload, membri non virtuali. Java: campi, "
     "<code>static</code>.<br><br>"
     "&bull; <b>Dominanza</b>: solo C++ con ereditarieta' <b>virtuale</b> &mdash; "
     "un membro di una classe piu' derivata domina quello della base virtuale, "
     "risolvendo un'ambiguita' che altrimenti sarebbe tale.")

card("[Trasv][Teoria]",
     "Cos'e' il <b>final overrider</b>, e quando un programma C++ diventa "
     "<b>ill-formed</b> per causa sua?",
     "<b>Final overrider</b>: per ogni funzione virtuale e ogni classe, "
     "l'<b>unica</b> implementazione effettivamente installata in vtable.<br><br>"
     "Se <b>non e' unico</b> (es. due rami di un diamante virtuale che fanno "
     "entrambi l'override, senza che la classe che li unisce ne fornisca uno "
     "proprio), il programma e' <b>ill-formed</b>.<br><br>"
     "<b>Dettaglio d'esame:</b> l'errore e' emesso alla <b>DEFINIZIONE della "
     "classe</b>, non al punto di chiamata &mdash; il programma non compila "
     "anche se quel metodo non viene mai chiamato:" +
     code("error: no unique final overrider for<br>"
          "'virtual void Shape::draw()' in 'Widget'"))

card("[Trasv][Teoria]",
     "Cos'e' il <b>Component Object Model (COM)</b> di Microsoft, e cosa "
     "c'entra con le virtual function?",
     "E' l'esempio piu' noto di <b>VFT usata come formato di interoperabilita' "
     "binaria FUORI da un singolo linguaggio</b>.<br><br>"
     "Un'interfaccia COM e', letteralmente, un <b>puntatore a una VFT con "
     "layout standardizzato</b>: lo stesso identico meccanismo studiato per il "
     "C++, ma usato come <b>contratto binario</b> per far comunicare linguaggi "
     "diversi (C++, Visual Basic, ...).<br><br>"
     "E' citato nella sezione &quot;See also&quot; della voce Wikipedia "
     "<i>Virtual function</i>, insieme a <i>Virtual method table</i> e "
     "<i>Virtual inheritance</i>.")

card("[Trasv][Trabocchetto]",
     code("""
struct B { virtual void f() { } };          // niente distruttore virtuale
struct D : B { int big[1000]; };

B* p = new D;
delete p;
""") + "<br>Cosa c'e' che non va? Cosa dice il compilatore?",
     "Manca il <b>distruttore virtuale</b> in B. GCC avvisa (verificato):" +
     code("warning: deleting object of polymorphic class type 'B'<br>"
          "which has non-virtual destructor might cause<br>"
          "undefined behavior [-Wdelete-non-virtual-dtor]") +
     "Senza " + c("virtual ~B()") + ", " + c("delete p") + " chiama solo "
     + c("~B()") + ": la parte D non viene distrutta (memory leak / UB).<br><br>"
     "<b>Regola:</b> se una classe ha anche <b>una sola</b> funzione virtuale "
     "(cioe' e' pensata per essere usata polimorficamente), deve avere il "
     "<b>distruttore virtuale</b>.<br><br>"
     "<b>Bonus:</b> " + c("delete[]") + " su un array di Derived tramite "
     + c("Base*") + " resta UB <b>anche col distruttore virtuale</b>: "
     "l'aritmetica dei puntatori nell'array usa " + c("sizeof") +
     " del tipo <b>statico</b>.")

# =====================================================================
# I. ESERCIZIO DEL CORSO
# =====================================================================

card("[C++][Cosa fa?][Esame]",
     code("""
class A {
public:
    virtual void f() { prn("A::f()"); }
             void g() { prn("A::g()"); }
};
class B : public A {
public:
    virtual void f() { prn("B::f()"); }
    virtual void g() { prn("B::g()"); }
};

A* a = new B();
a->f();          // (1)
a->g();          // (2)
B* b = (B*)a;
b->f();          // (3)
b->g();          // (4)
""") + "<br>Cosa stampa ciascuna riga? (dall'esercizio delle slide)",
     "(1) <b>B::f()</b> &mdash; f e' virtual in A &rarr; late binding sulla "
     "classe reale (B).<br>"
     "(2) <b>A::g()</b> &mdash; g <b>non</b> e' virtual in A &rarr; early "
     "binding sul <b>tipo del puntatore</b> (A*), anche se l'oggetto e' un B!<br>"
     "(3) <b>B::f()</b><br>"
     "(4) <b>B::g()</b> &mdash; ora il tipo del puntatore e' B*, e in B la g e' "
     "dichiarata virtual.<br><br>"
     "<b>Morale:</b> per ogni chiamata devi guardare <b>due</b> cose: (a) e' "
     "virtual <i>nel tipo statico usato per la chiamata</i>? (b) qual e' la "
     "classe reale dell'oggetto?<br><i>(slide 43-45, verificato compilando)</i>")

card("[C++][Trabocchetto][Esame]",
     code("""
class E : public D {
public:
    virtual void f() { prn("E::f()"); }
};
class G : public E {
public:
    virtual void f(int i) { prn("G::f(int)"); }
};

G aG;
aG.f();       // (1)
aG.f(3);      // (2)

A* a = &aG;
a->f();       // (3)
a->f(3);      // (4)
""") + "<br>Quali righe NON compilano, e perche'?",
     "<b>(1) NON compila</b> &mdash; G dichiara " + c("f(int)") + ", che per "
     "<b>name hiding</b> nasconde TUTTI gli " + c("f()") + " ereditati. Dal "
     "tipo statico G, l'unico <code>f</code> visibile e' " + c("f(int)") +
     ": chiamarlo senza argomenti non compila.<br><br>"
     "<b>(2) compila</b> &rarr; " + c("G::f(int)") + "<br><br>"
     "<b>(3) compila</b> &rarr; " + c("E::f()") + " (via A*, il compilatore "
     "cerca " + c("A::f()") + " che esiste ed e' virtual; il dispatch trova "
     "l'override in E)<br><br>"
     "<b>(4) NON compila</b> &mdash; " + c("a") + " e' un " + c("A*") + ": il "
     "compilatore cerca " + c("A::f(int)") + ", che <b>non esiste in A</b>. "
     "Le uniche funzioni chiamabili sono quelle <b>dichiarate nel tipo "
     "statico</b>, anche se l'oggetto reale e' un G.<br>"
     "<i>(slide 44)</i>")

# =====================================================================
# J. SECONDO BLOCCO — piu' esercizi di scrittura e teoria residua
# =====================================================================

card("[C++][Scrivi]",
     "<b>Scrivi</b> l'idioma del <b>&quot;costruttore virtuale&quot;</b> "
     "(clone polimorfico) e spiega perche' serve.",
     code("""
#include <iostream>
#include <vector>
#include <memory>

struct Base {
    virtual Base* clone() const { return new Base(*this); }
    virtual void  say()  const { std::cout << "Base\\n"; }
    virtual ~Base() = default;
};

struct Der : Base {
    Der* clone() const override { return new Der(*this); }
    void say()   const override { std::cout << "Der\\n"; }
};

// copia profonda di un vettore polimorfico, senza sapere i tipi concreti
std::vector<Base*> copiaTutto(const std::vector<Base*>& src) {
    std::vector<Base*> out;
    for (const Base* p : src)
        out.push_back(p->clone());   // clona il tipo GIUSTO
    return out;
}
""") + "<br><b>Perche' serve:</b> un <b>costruttore non puo' essere "
     "virtual</b> (il dispatch virtuale richiede un oggetto gia' costruito col "
     "vptr installato &mdash; e' proprio il ctor a installarlo: sarebbe "
     "circolare).<br><br>"
     "<b>Nota il return type covariante:</b> " + c("Der::clone()") + " "
     "restituisce " + c("Der*") + ", non " + c("Base*") + " &mdash; e' un "
     "override valido perche' la covarianza e' ammessa su puntatori/riferimenti "
     "a classi in relazione di derivazione.")

card("[C++][Scrivi]",
     "<b>Scrivi</b> il codice che <b>dimostra sperimentalmente</b> che in un "
     "diamante virtuale esiste un solo sotto-oggetto della base (e due, senza "
     "<code>virtual</code>).",
     code("""
#include <iostream>

struct A { int x = 0; };
struct B : virtual A { };
struct C : virtual A { };
struct D : B, C { };

// versione senza virtual, per confronto
struct A2 { int x = 0; };
struct B2 : A2 { };
struct C2 : A2 { };
struct D2 : B2, C2 { };

int main() {
    D d;
    A* viaB = static_cast<B*>(&d);
    A* viaC = static_cast<C*>(&d);
    std::cout << "virtual:     " << (viaB == viaC ? "STESSO" : "DIVERSI")
              << " sotto-oggetto\\n";

    D2 d2;
    A2* viaB2 = static_cast<B2*>(&d2);
    A2* viaC2 = static_cast<C2*>(&d2);
    std::cout << "non virtual: " << (viaB2 == viaC2 ? "STESSO" : "DIVERSI")
              << " sotto-oggetto\\n";
}
""") + "Output verificato:" + code("""
virtual:     STESSO sotto-oggetto
non virtual: DIVERSI sotto-oggetto
""") + "<br>Con " + c("virtual") + " i due cast danno lo <b>stesso "
     "indirizzo</b>: c'e' una sola A. Senza, gli indirizzi differiscono: due A "
     "distinte, ognuna con la propria " + c("x") + ".<br><i>(prove/06)</i>")

card("[C++][Scrivi]",
     "<b>Scrivi</b> il fix per questo codice, che non compila, <b>in due modi "
     "diversi</b>:" + code("""
struct B {
    virtual void f(int);
             void f(double);
};
struct D : B {
    void f(int) override;
};

D d;
d.f(3.14);      // chiama D::f(int), NON B::f(double)!
"""),
     "<b>Modo 1 &mdash; " + c("using") + " (il piu' pulito):</b>" + code("""
struct D : B {
    using B::f;              // reintroduce TUTTI gli overload di B::f
    void f(int) override;
};

d.f(3.14);       // ora chiama B::f(double)
""") + "<b>Modo 2 &mdash; chiamata qualificata al punto d'uso:</b>" + code("""
d.B::f(3.14);    // bypassa il name hiding esplicitamente
""") + "<b>Modo 3 &mdash; ridichiarare l'overload:</b>" + code("""
struct D : B {
    void f(int) override;
    void f(double d) { B::f(d); }   // forwarding esplicito
};
""") + "<br>Compila con " + c("-Woverloaded-virtual") + " per farti "
     "avvisare dal compilatore quando succede.<br><i>(prove/03)</i>")

card("[C++][Scrivi]",
     "<b>Scrivi</b> una classe base che sia una <b>interfaccia pura</b> "
     "(l'equivalente C++ di una <code>interface</code> Java) e una classe che "
     "la implementa.",
     code("""
#include <iostream>

// interfaccia pura: solo metodi virtuali puri, nessun dato
struct Drawable {
    virtual void draw() const = 0;
    virtual ~Drawable() = default;      // sempre, se si distrugge via base*
};

struct Serializable {
    virtual std::string serialize() const = 0;
    virtual ~Serializable() = default;
};

// una classe puo' implementare PIU' interfacce (ereditarieta' multipla)
class Widget : public Drawable, public Serializable {
    int id;
public:
    Widget(int i) : id(i) {}
    void draw() const override {
        std::cout << "Widget " << id << "\\n";
    }
    std::string serialize() const override {
        return "{\\"id\\":" + std::to_string(id) + "}";
    }
};

int main() {
    Widget w(7);
    Drawable*     d = &w;
    Serializable* s = &w;
    d->draw();
    std::cout << s->serialize() << "\\n";
}
""") + "<br><b>Differenza con Java:</b> in Java esiste la keyword "
     + c("interface") + " e una classe puo' implementarne quante vuole (ma "
     "estendere <b>una sola</b> classe). In C++ non c'e' una keyword dedicata: "
     "si usa una classe astratta <b>senza dati</b> e l'ereditarieta' multipla.<br>"
     "Ed e' proprio perche' non portano dati che con le interfacce pure il "
     "<b>diamond problem non si presenta</b>.")

card("[Python][Scrivi]",
     "<b>Scrivi</b> in Python una gerarchia astratta corretta (con "
     + c("abc") + ") equivalente allo Shape/Circle/Rectangle del C++, che "
     "sollevi errore se una derivata non implementa " + c("area") + ".",
     code("""
from abc import ABC, abstractmethod
import math

class Shape(ABC):                       # ABC = ABCMeta in gioco
    @abstractmethod
    def area(self) -> float: ...

    def describe(self) -> str:          # metodo concreto: ereditato
        return f"{type(self).__name__}: area={self.area():.4f}"

class Circle(Shape):
    def __init__(self, r): self.r = r
    def area(self): return math.pi * self.r ** 2

class Rectangle(Shape):
    def __init__(self, b, h): self.b, self.h = b, h
    def area(self): return self.b * self.h

class Broken(Shape):                    # NON implementa area()
    pass

shapes = [Circle(2.0), Rectangle(3.0, 4.0)]
print(sum(s.area() for s in shapes))    # 24.566...
for s in shapes:
    print(s.describe())

try:
    Broken()
except TypeError as e:
    print("TypeError:", e)
""") + "L'ultima riga stampa:" + code(
         "TypeError: Can't instantiate abstract class Broken<br>"
         "without an implementation for abstract method 'area'") +
     "<br><b>Senza</b> ereditare da " + c("ABC") + ", " + c("Broken()") +
     " si costruirebbe <b>senza errori</b>: e' ABCMeta a fare il controllo, "
     "non il decoratore.")

card("[Java][Scrivi]",
     "<b>Scrivi</b> in Java una classe astratta con un metodo astratto e una "
     "concreta, piu' un array polimorfico che li usa senza sapere i tipi.",
     code("""
abstract class Shape {
    abstract double area();              // astratto: niente corpo

    String describe() {                  // concreto: ereditato da tutti
        return getClass().getSimpleName() + ": area=" + area();
    }
}

class Circle extends Shape {
    private final double r;
    Circle(double r) { this.r = r; }
    @Override double area() { return Math.PI * r * r; }
}

class Rectangle extends Shape {
    private final double b, h;
    Rectangle(double b, double h) { this.b = b; this.h = h; }
    @Override double area() { return b * h; }
}

public class Demo {
    public static void main(String[] args) {
        Shape[] shapes = { new Circle(2.0), new Rectangle(3.0, 4.0) };

        double tot = 0;
        for (Shape s : shapes) {         // nessun instanceof, nessun cast
            System.out.println(s.describe());
            tot += s.area();
        }
        System.out.println("Totale: " + tot);   // 24.566...

        // Shape s = new Shape();   // ERRORE: e' abstract
    }
}
""") + "<br><b>Nota:</b> in Java una classe con anche un solo metodo "
     + c("abstract") + " <b>deve</b> essere dichiarata " + c("abstract") +
     ", e non puo' essere istanziata &mdash; il compilatore lo verifica, a "
     "differenza di Python dove serve ABCMeta.")

card("[C][Scrivi]",
     "<b>Scrivi in C</b> un &quot;distruttore virtuale&quot; e un "
     + c("dynamic_cast") + " fatti a mano.",
     code("""
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Shape Shape;

typedef struct {
    void (*draw)(const Shape *self);
    void (*dtor)(Shape *self);        /* "distruttore virtuale" */
    const char *type_name;            /* poor man's RTTI */
} ShapeVT;

struct Shape { const ShapeVT *vptr; };

typedef struct { Shape base; char *label; } Labeled;

static void labeled_draw(const Shape *s) {
    printf("Labeled: %s\\n", ((const Labeled *)s)->label);
}
static void labeled_dtor(Shape *s) {
    Labeled *l = (Labeled *)s;
    free(l->label);                   /* libera i propri membri... */
    free(l);                          /* ...poi se stesso */
}
static const ShapeVT LABELED_VT = { labeled_draw, labeled_dtor, "Labeled" };

Labeled *labeled_new(const char *txt) {
    Labeled *l = malloc(sizeof *l);
    l->base.vptr = &LABELED_VT;
    l->label = strdup(txt);
    return l;
}

/* "distruttore virtuale": si chiama SEMPRE attraverso la vtable */
void shape_delete(Shape *s) { s->vptr->dtor(s); }

/* "dynamic_cast": confronto del tag di tipo */
Labeled *as_labeled(Shape *s) {
    if (strcmp(s->vptr->type_name, "Labeled") == 0)
        return (Labeled *)s;
    return NULL;                      /* come dynamic_cast fallito */
}

int main() {
    Shape *s = (Shape *)labeled_new("ciao");
    s->vptr->draw(s);

    Labeled *l = as_labeled(s);
    printf("cast %s\\n", l ? "riuscito" : "fallito");

    shape_delete(s);                  /* chiama labeled_dtor */
}
""") + "<br>Per gerarchie a piu' livelli, si mette nella VT un puntatore "
     + c("parent") + " e si risale la catena (cosi' un &quot;Labeled&quot; "
     "risulta anche un &quot;Shape&quot;).")

card("[C++][Cosa fa?]",
     code("""
struct Base {
    void chiama() { impl(); }             // NON virtuale
private:
    virtual void impl() { cout << "Base::impl\\n"; }
};
struct Der : public Base {
public:
    void impl() { cout << "Der::impl\\n"; }   // override di un PRIVATO
};

int main() {
    Base* p = new Der;
    p->chiama();          // (1)
    p->impl();            // (2)
    delete p;
}
""") + "<br>Cosa succede alle righe (1) e (2)?",
     "<b>(1) stampa <code>Der::impl</code></b><br>"
     "<b>(2) ERRORE DI COMPILAZIONE</b> (&quot;impl is private within this "
     "context&quot;)<br><br>"
     "<b>Perche':</b> controllo di accesso e dispatch dinamico sono "
     "<b>ortogonali</b>.<br>"
     "&bull; L'<b>accesso</b> e' verificato sul tipo <b>statico</b> al punto di "
     "chiamata: da fuori, tramite " + c("Base*") + ", " + c("impl") + " e' "
     "privato &rarr; errore.<br>"
     "&bull; Il <b>dispatch</b> avviene sul tipo <b>dinamico</b>: dentro "
     + c("Base::chiama()") + " (dove impl E' accessibile) la vtable porta a "
     + c("Der::impl") + ".<br><br>"
     "Un metodo <code>private virtual</code> e' quindi perfettamente "
     "<b>overridabile</b>: la derivata deve solo <b>ridefinirlo</b>, non "
     "chiamarlo. E' la base del pattern <b>NVI</b>.")

card("[C++][Teoria]",
     "A cosa serve la keyword " + c("override") + " del C++11, se l'override "
     "funziona anche senza?",
     "E' un <b>controllo per il compilatore</b>, esattamente come "
     + c("@Override") + " in Java: dice &quot;questo metodo DEVE sovrascrivere "
     "un virtuale della base&quot;." + code("""
struct B { virtual void f(int) const; };

struct D : B {
    void f(int);              // compila! ma NON e' un override (manca const)
    void f(int) override;     // ERRORE esplicito: nessun match
};
""") + "<b>Senza <code>override</code></b>, una firma leggermente sbagliata "
     "(un <code>const</code> mancante, un tipo di parametro diverso) produce "
     "silenziosamente un <b>nuovo metodo che nasconde</b> quello della base: "
     "il codice compila e si comporta male a runtime.<br><br>"
     "<b>Regola:</b> metti sempre " + c("override") + " sugli override, e "
     + c("final") + " dove vuoi chiudere la gerarchia.")

card("[C++][Teoria]",
     "Cosa cambia, per il <b>compilatore</b>, tra " + c("override") + " e "
     + c("final") + "?",
     "&bull; " + c("override") + " e' <b>solo un controllo</b>: verifica che "
     "l'override esista davvero. Non cambia il codice generato.<br><br>"
     "&bull; " + c("final") + " e' un'<b>informazione semantica</b>: garantisce "
     "che nessuno potra' piu' fare l'override. Questo permette al compilatore "
     "di <b>devirtualizzare</b> la chiamata (risolverla staticamente) e quindi "
     "di <b>inlinearla</b>, anche senza LTO o analisi dell'intero programma."
     "<br><br><b>Analogia Java:</b> la JVM ottiene lo stesso effetto a runtime "
     "con la <b>Class Hierarchy Analysis</b> (se una sola classe caricata "
     "implementa il metodo, devirtualizza speculativamente, con un guard e "
     "deottimizzazione se poi ne viene caricata un'altra).")

card("[Trasv][Teoria]",
     "Qual e' il costo del polimorfismo dinamico nei quattro linguaggi?",
     "&bull; <b>C++</b>: 2 load (vptr, poi lo slot) + una chiamata indiretta. "
     "Un puntatore per <b>oggetto</b>, una tabella per <b>classe</b>. "
     "Devirtualizzabile con " + c("final") + "/LTO. E' lo "
     "<i>zero-overhead principle</i>: paghi solo se usi <code>virtual</code>.<br><br>"
     "&bull; <b>Java</b>: uguale in linea di principio, ma il JIT spesso "
     "<b>inlina per speculazione</b> (CHA + inline cache mono/bimorfiche), "
     "recuperando gran parte del costo.<br><br>"
     "&bull; <b>Python</b>: il piu' alto &mdash; lookup nel dizionario lungo "
     "l'MRO + creazione del bound method (mitigato da cache interne).<br><br>"
     "&bull; <b>C</b>: identico al C++, perche' e' letteralmente la stessa cosa "
     "scritta a mano.")

card("[C++][Cosa fa?]",
     code("""
struct Base {
    virtual void f(int x = 10) { cout << "Base " << x << "\\n"; }
};
struct Der : Base {
    void f(int x = 20) override { cout << "Der " << x << "\\n"; }
};

int main() {
    Base* p = new Der;
    p->f();
    delete p;
}
""") + "<br>Stampa &quot;Der 20&quot;? Attenzione.",
     "Stampa <b>&quot;Der 10&quot;</b>.<br><br>"
     "<b>Perche':</b> il <b>corpo</b> e' scelto <b>dinamicamente</b> (vtable "
     "&rarr; " + c("Der::f") + "), ma gli <b>argomenti di default</b> sono "
     "sostituiti <b>staticamente</b>, a compile time, in base al <b>tipo "
     "statico</b> dell'espressione (qui " + c("Base*") + ").<br><br>"
     "Il compilatore genera di fatto " + c("p->f(10)") + ", e poi il dispatch "
     "porta al corpo di Der.<br><br>"
     "<b>Regola:</b> <b>mai</b> ridefinire gli argomenti di default in un "
     "override. Se servono default diversi, usa <b>NVI</b> (il default sta "
     "nella funzione pubblica non virtuale).")

card("[Trasv][Scrivi]",
     "<b>Scrivi</b>, nei quattro linguaggi, la riga che chiama esplicitamente "
     "l'implementazione della <b>classe base</b> da dentro un override.",
     "<b>C++</b> &mdash; scope resolution, chiamata <b>non</b> virtuale:" +
     code("""
void Der::f() {
    Base::f();          // chiamata diretta, niente dispatch
    /* ...extra... */
}
""") + "<b>Java</b> &mdash; keyword " + c("super") + ":" + code("""
@Override void f() {
    super.f();
    /* ...extra... */
}
// per un default method di interfaccia:  Interfaccia.super.f();
""") + "<b>Python</b> &mdash; " + c("super()") + ", che segue l'<b>MRO</b>:" +
     code("""
def f(self):
    super().f()         # NON "la superclasse": il prossimo nell'MRO!
    # ...extra...
    # alternativa esplicita e non cooperativa:  A.f(self)
""") + "<b>C</b> &mdash; tutto esplicito, a mano:" + code("""
static void der_f(Shape *self) {
    PARENT_VT.f(self);  /* chiami la entry della vtable "genitore" */
    /* ...extra... */
}
"""))

card("[Trasv][Trabocchetto]",
     "&quot;Un metodo <code>static</code> puo' essere overridden?&quot; "
     "Rispondi per C++, Java e Python.",
     "<b>No in nessuno dei tre</b>, ma per sfumature diverse:<br><br>"
     "&bull; <b>C++</b>: un metodo " + c("static") + " non ha " + c("this") +
     ", quindi non c'e' alcun ricevitore su cui fare dispatch: non puo' essere "
     + c("virtual") + " (errore di compilazione se ci provi). Puo' solo "
     "essere <b>nascosto</b> da un omonimo nella derivata.<br><br>"
     "&bull; <b>Java</b>: idem &mdash; ridichiararlo nella derivata produce "
     "<b>hiding di metodo statico</b>, non override. La chiamata e' compilata "
     "in " + c("invokestatic") + " sul <b>tipo statico</b>:" + code("""
class A { static String s() { return "A"; } }
class B extends A { static String s() { return "B"; } }

A a = new B();
System.out.println(a.s());   // stampa "A", non "B"!
""") + "&bull; <b>Python</b>: uno " + c("@staticmethod") + " si puo' "
     "ridefinire (tutto e' un attributo di classe), ma perde qualunque "
     "informazione sul chiamante. Per una factory polimorfica serve un "
     + c("@classmethod") + ", dove " + c("cls") + " e' il tipo reale su cui "
     "e' avvenuta la chiamata.")

card("[Python][Cosa fa?]",
     code("""
class A:
    @classmethod
    def create(cls):
        return cls()
    def __repr__(self):
        return type(self).__name__

class B(A):
    pass

print(A.create())
print(B.create())
""") + "<br>Cosa stampa? Perche' e' importante?",
     "Stampa:" + code("""
A
B
""") + "<br><b>Perche':</b> in un " + c("@classmethod") + ", " + c("cls") +
     " e' legato al tipo su cui e' <b>effettivamente</b> avvenuta la chiamata "
     "(qui B), non alla classe dove il metodo e' definito. Quindi "
     + c("cls()") + " costruisce una <b>B</b>.<br><br>"
     "<b>E' il &quot;costruttore virtuale&quot; che il C++ non ha</b>: in C++ "
     "un ctor non puo' essere virtual e si deve emulare con l'idioma "
     + c("clone()") + "; in Java servirebbe una factory esplicita o la "
     "reflection.<br><br>"
     "Con uno " + c("@staticmethod") + " che facesse " + c("return A()") + ", "
     "invece, ogni sottoclasse dovrebbe riscrivere la factory da zero.")

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
