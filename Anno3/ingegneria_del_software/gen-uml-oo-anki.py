#!/usr/bin/env python3
"""Mazzo Anki: Object Orientation e UML (lezione L01/L02 - uml1.txt).

Fonte: /home/giovanni/Documents/ingSoftware/uml1.txt, che rielabora il PDF
"02-290925-Object Orientation e UML" segnalando con [!] le imprecisioni
delle slide. Le card marcate [Slide-vs-Realta] sono proprio quelle:
riportano PRIMA cosa dice la slide, POI la versione corretta.
"""

import html

OUT = ("/home/giovanni/Documents/università/AppuntiDelBasta/Anno3/"
       "ingegneria_del_software/uml-oo-anki.txt")

HEADER = """#separator:tab
#html:true
#notetype:Basic
#deck:Ingegneria del Software::Object Orientation e UML
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
# 1. QUALITA' DEL SOFTWARE: hiding, abstraction, coupling, cohesion
# =====================================================================

card("[Design][Teoria]",
     "Che cos'e' l'<b>information hiding</b>? Quali quattro idee ne "
     "elencano le slide (pp.7-8)?",
     "<b>Information hiding</b> = nascondere ai client di un modulo le "
     "<b>decisioni implementative</b> che non devono conoscere.<br><br>"
     "Le quattro idee delle slide:<br>"
     "&bull; il modulo nasconde la propria implementazione interna<br>"
     "&bull; si usa attraverso una <b>public interface</b><br>"
     "&bull; dati e metodi privati non si manipolano direttamente<br>"
     "&bull; se l'interfaccia non cambia, cambiare l'implementazione "
     "<b>non deve propagare modifiche</b> al resto del sistema<br><br>"
     "Il client sa <b>cosa</b> puo' chiedere, non <b>come</b> viene fatto.")

card("[Design][Codice]",
     "Perche' questa classe viola l'information hiding? Riscrivila." +
     code("""
class BankAccount {
public:
    double balance;
};
"""),
     "Perche' un client puo' scrivere " + c("account.balance = -1000000;") +
     ": la classe <b>non protegge le proprie invarianti</b>." +
     code("""
class BankAccount {
private:
    double balance;

public:
    double getBalance() const {
        return balance;
    }

    bool withdraw(double amount) {
        if (amount <= 0 || amount > balance)
            return false;

        balance -= amount;
        return true;
    }
};
""") + "Ora lo stato cambia <b>solo</b> mediante le operazioni previste.")

card("[Design][Esame]",
     "<b>Abstraction</b>, <b>encapsulation</b> e <b>information hiding</b>: "
     "non sono sinonimi. Distinguili.",
     code("""
ABSTRACTION
    -> scelgo cio' che e' essenziale        (WHAT?)

ENCAPSULATION
    -> racchiudo stato + comportamento
       dentro un confine che controlla
       l'accesso  (es. la classe)

INFORMATION HIDING
    -> nascondo le decisioni
       implementative                       (HOW?)
""") + "Esempio " + c("Stack") + ":<br>"
     "&bull; <b>abstraction</b>: offro " + c("push/pop/top/isEmpty") + "<br>"
     "&bull; <b>information hiding</b>: il client non deve sapere se dentro "
     "c'e' un array, una linked list, un vector o un deque<br>"
     "&bull; <b>encapsulation</b>: il meccanismo (la classe) che tiene "
     "insieme dati e comportamento.<br><br>"
     "Le annotazioni di p.8 riassumono bene con <b>WHAT vs HOW</b>.")

card("[Design][Slide-vs-Realta]",
     "L'annotazione dice: <i>&laquo;interfaccia e implementazione devono "
     "essere <b>indipendenti</b>&raquo;</i>. Come lo diresti meglio?",
     "Meglio: devono essere <b>disaccoppiate quanto possibile</b>.<br><br>"
     "Non possono essere <b>totalmente</b> indipendenti: l'implementazione "
     "deve pur sempre <b>soddisfare il contratto</b> definito "
     "dall'interfaccia.")

card("[Design][Teoria]",
     "Che cos'e' il <b>coupling</b>? &laquo;Low coupling&raquo; significa "
     "forse &laquo;nessuna relazione&raquo;?",
     "Il <b>coupling</b> misura <b>quanto una parte del sistema dipende da "
     "un'altra</b>. Due moduli sono <i>loosely coupled</i> quando le loro "
     "interconnessioni sono deboli.<br><br>"
     "<b>No</b>: un software in cui nessun oggetto parla con nessun altro "
     "<b>non fa nulla</b>.<br><br>"
     "Low coupling significa: ogni dipendenza deve <b>esistere perche' "
     "necessaria</b>, essere <b>piccola</b> e passare attraverso "
     "<b>contratti stabili</b>.")

card("[Design][Codice]",
     "Perche' questo codice ha accoppiamento elevato? Come lo riduci?" +
     code("""
class OrderService {
public:
    void checkout() {
        MySQLDatabase db;
        VisaGateway   visa;
        GmailSender   gmail;
        // ...
    }
};
"""),
     "Perche' " + c("OrderService") + " conosce <b>tre implementazioni "
     "concrete</b>: se passo MySQL&rarr;PostgreSQL, Visa&rarr;Stripe o "
     "cambio provider mail, devo modificare " + c("OrderService") + "." +
     code("""
class PaymentGateway {
public:
    virtual bool pay(double amount) = 0;
    virtual ~PaymentGateway() = default;
};

class OrderService {
private:
    PaymentGateway& gateway;

public:
    explicit OrderService(PaymentGateway& gateway)
        : gateway(gateway) {}
};
""") + "Ora " + c("OrderService") + " conosce il <b>contratto</b>, non "
     "l'implementazione concreta.")

card("[Design][Teoria]",
     "Elenca i tipi di <b>coupling</b> della slide, dal piu' innocuo al "
     "peggiore, con un esempio ciascuno.",
     "&bull; <b>message/call coupling</b> &mdash; un oggetto invoca un "
     "servizio pubblico di un altro (" + c("Order -> PaymentService.pay()") +
     "): inevitabile in un sistema collaborativo<br><br>"
     "&bull; <b>data coupling</b> &mdash; si passano solo i dati necessari "
     "(" + c("calculateTax(price, country)") + "): relativamente debole<br><br>"
     "&bull; <b>control coupling</b> &mdash; si passa un'informazione che "
     "decide <b>come</b> l'altro deve comportarsi "
     "(" + c("generateReport(data, mode = 7)") + "): il chiamante deve "
     "conoscere il controllo interno<br><br>"
     "&bull; <b>dipendenze da OS/compiler</b> &mdash; business logic che "
     "chiama direttamente le Win32 API: perdo portabilita'<br><br>"
     "&bull; <b>common coupling</b> &mdash; piu' moduli condividono uno "
     "<b>stato globale</b>: A modifica X &rarr; B cambia comportamento "
     "&rarr; C fallisce, e non si capisce chi sia il colpevole<br><br>"
     "&bull; <b>content coupling</b> &mdash; un modulo dipende dalla "
     "<b>rappresentazione interna</b> di un altro. E' il <b>caso peggiore</b>, "
     "la slide lo marca <b>Avoid!</b>")

card("[Design][Slide-vs-Realta]",
     "La slide presenta la &laquo;coupling order&raquo; come una scala "
     "crescente. Ci si puo' fidare?",
     "E' utile <b>didatticamente</b>, ma <b>non e' una scala universale</b>: "
     "mescola tipi di dipendenza provenienti da classificazioni diverse. "
     "Non memorizzarla come una legge matematica.<br><br>"
     "<b>Da esame di':</b> la regola importante e' <b>minimizzare le "
     "dipendenze forti</b>, soprattutto quelle basate su <b>stato "
     "condiviso</b> e <b>dettagli interni</b>.")

card("[Design][Teoria]",
     "Che cos'e' la <b>cohesion</b>? Da' un esempio di classe poco coesa e "
     "uno di classe coesa.",
     "La <b>cohesion</b> misura quanto le parti interne di un modulo "
     "appartengano allo <b>stesso concetto</b>. Un modulo e' coeso quando "
     "tutti i suoi elementi contribuiscono a una <b>singola "
     "responsabilita'</b>." +
     code("""
POCO COESA
UserManager
|-- authenticateUser()
|-- printInvoice()
|-- calculateShipping()
|-- resizeImage()
`-- sendWeatherAlert()

COESA
AuthenticationService
|-- authenticate()
|-- logout()
|-- verifyPassword()
`-- refreshSession()
""") + "L'obiettivo e' sempre: <b>HIGH cohesion, LOW coupling</b>.")

card("[Design][Teoria][Esame]",
     "Elenca gli <b>otto livelli di cohesion</b> in ordine crescente, con "
     "un esempio ciascuno.",
     "1. <b>Coincidental</b> &mdash; insieme senza vera ragione: il cassetto "
     "&laquo;Miscellaneous&raquo; (" + c("Utilities") + ": calculateTax, "
     "resizeImage, resetPassword, parseCsv)<br>"
     "2. <b>Logical</b> &mdash; stessa categoria generica ma logiche diverse "
     "(" + c("InputHandler") + ": readKeyboard, readNetwork, readBarcode)<br>"
     "3. <b>Temporal</b> &mdash; eseguiti nello stesso momento "
     "(" + c("initializeSystem()") + ": cache, log, DB, config)<br>"
     "4. <b>Procedural</b> &mdash; stessa sequenza di controllo "
     "(" + c("read -> validate -> format -> send") + ")<br>"
     "5. <b>Communicational</b> &mdash; agiscono <b>sugli stessi dati</b> "
     "(" + c("CustomerData") + ": export/print/archiveCustomer)<br>"
     "6. <b>Sequential</b> &mdash; l'output di una e' l'input della "
     "successiva (" + c("parse -> validate -> transform") + ")<br>"
     "7. <b>Informational</b> &mdash; legate alla stessa struttura "
     "informativa (" + c("Repository") + ": find/save/delete/update)<br>"
     "8. <b>Functional</b> &mdash; tutti gli elementi contribuiscono a "
     "<b>un'unica funzione ben definita</b>. <b>E' quella verso cui "
     "tendere.</b>")

card("[Design][Trabocchetto]",
     "<b>Coupling</b> e <b>cohesion</b> sono lo stesso concetto? A quale "
     "domanda risponde ciascuno?",
     "<b>No, sono concetti diversi.</b><br><br>"
     "&bull; <i>Quanto una classe dipende dalle altre?</i> &rarr; "
     "<b>coupling</b><br>"
     "&bull; <i>Quanto le cose dentro la classe appartengono allo stesso "
     "concetto?</i> &rarr; <b>cohesion</b><br><br>"
     "Il caso cattivo li combina entrambi: il " + c("GodController") +
     " che sa tutto di A, B, C, D e contiene 100 responsabilita' ha "
     "contemporaneamente <b>bassa coesione</b> e <b>alto accoppiamento</b> "
     "(la slide 142 ci torna sopra).")

card("[Design][Teoria]",
     "Che cosa significa <b>simplicity</b>? E' &laquo;scrivere meno "
     "caratteri&raquo;?",
     "<b>No.</b> Questo e' piu' corto ma meno comprensibile:" +
     code("return a?b:c?d:e;") +
     "La semplicita' riguarda:<br>"
     "&bull; numero di <b>concetti</b><br>"
     "&bull; numero di <b>dipendenze</b><br>"
     "&bull; dimensione delle <b>responsabilita'</b><br>"
     "&bull; facilita' di comprensione<br>"
     "&bull; assenza di <b>generalizzazioni inutili</b><br><br>"
     "Le slide consigliano: implementare solo cio' che serve, non anticipare "
     "bisogni ipotetici, rifattorizzare, metodi e interfacce piccole, evitare "
     "variabili globali e duplicazioni, gerarchie di ereditarieta' contenute.")

card("[Design][Teoria]",
     "La slide dice <i>&laquo;don't try to anticipate future needs&raquo;</i>. "
     "A quale principio corrisponde?",
     "<b>YAGNI &mdash; You Aren't Gonna Need It.</b><br><br>"
     "Non implementare oggi <b>15 strategie di autenticazione</b> se "
     "l'unico requisito reale e' <b>username + password</b>. Estenderai "
     "quando esistera' il requisito.")

card("[Design][Teoria]",
     "Da' la definizione <b>corretta</b> di <b>refactoring</b> e un esempio.",
     "Modificare la <b>struttura interna</b> del codice <b>senza modificarne "
     "il comportamento esternamente osservabile</b>, per migliorarne "
     "qualita' e manutenibilita'." +
     code("""
// prima
if (customer.age > 65 &&
    customer.country == "IT" &&
    customer.registered) {
    ...
}

// dopo
if (customer.isEligibleForSeniorDiscount()) {
    ...
}
""") + "Il comportamento resta lo stesso, ma il <b>concetto e' "
     "esplicito</b>.")

card("[Design][Slide-vs-Realta]",
     "L'annotazione dice: <i>&laquo;la migliore documentazione e' codice "
     "scritto bene&raquo;</i>. Commenta.",
     "E' una buona <b>provocazione</b>, non una regola assoluta.<br><br>"
     "Il codice pulito riduce la necessita' di commenti che spiegano "
     "<b>cosa fa una singola istruzione</b>, ma <b>non sostituisce</b>:<br>"
     "&bull; requisiti<br>&bull; documentazione API<br>"
     "&bull; decisioni architetturali<br>&bull; motivazioni di design<br>"
     "&bull; vincoli di dominio")

card("[Design][Teoria]",
     "Distingui <b>subsystem</b> e <b>module</b>.",
     "&bull; <b>Subsystem</b>: parte relativamente autonoma di un sistema "
     "piu' grande, responsabile di un insieme <b>coerente di "
     "funzionalita'</b>. Punto di vista <b>architetturale/di "
     "responsabilita'</b>: <i>quale parte del sistema fa questo lavoro?</i>" +
     code("""
Sistema e-commerce
|-- Catalog subsystem
|-- Payment subsystem
|-- Shipping subsystem
`-- Authentication subsystem
""") + "&bull; <b>Module</b>: unita' di organizzazione del software che "
     "raccoglie elementi correlati con un'<b>interfaccia controllata</b>. "
     "Puo' essere un modulo linguistico, package, libreria, namespace, "
     "componente, gruppo di classi.<br><br>"
     "Nel paradigma OO <b>entrambi</b> possono comprendere insiemi di classi.")

card("[Design][Slide-vs-Realta]",
     "Le annotazioni dicono: <b>subsystem = dinamico</b>, <b>module = "
     "statico</b>. E <b>modulo Java = package</b>. Sono corrette?",
     "<b>Nessuna delle due, letteralmente.</b><br><br>"
     "1. Non e' una distinzione standard: <b>entrambi</b> sono normalmente "
     "concetti di <b>decomposizione strutturale</b>. Un subsystem puo' avere "
     "comportamento runtime, ma non e' corretto contrapporlo in generale a un "
     "modulo &laquo;statico&raquo;.<br>"
     "&rarr; <b>Da esame:</b> il subsystem e' una decomposizione "
     "<b>architetturale</b> orientata alle responsabilita'; il module e' una "
     "decomposizione piu' vicina all'<b>organizzazione e alla tecnologia</b> "
     "del software.<br><br>"
     "2. E' un'<b>analogia</b>, non un'equivalenza: prima di Java 9 si "
     "parlava soprattutto di <b>package</b>; da Java 9 esiste un vero "
     "<b>sistema di moduli</b>, con " + c("module-info.java") + ".")

# =====================================================================
# 2. OGGETTI, CLASSI, EREDITARIETA', POLIMORFISMO
# =====================================================================

card("[OO][Teoria]",
     "Che cos'e' l'<b>Object Orientation</b>, al di la' di &laquo;programmare "
     "con le classi&raquo;?",
     "E' un modo di <b>modellare un dominio</b> come un insieme di entita' "
     "dotate di: <b>identita'</b>, <b>stato</b>, <b>responsabilita'</b>, "
     "<b>comportamento</b>, <b>relazioni</b>, <b>interazioni</b>.<br><br>"
     "Le slide riassumono il paradigma come rappresentazione del mondo "
     "mediante <b>interacting objects</b>, e insistono sul fatto che la "
     "stessa rappresentazione accompagni <b>tutto</b> il ciclo: concept "
     "modeling &rarr; analysis &rarr; design &rarr; programming.<br><br>"
     "Non parto da <i>input &rarr; procedura &rarr; output</i>, ma da: "
     "quali entita' sono rilevanti? che responsabilita' hanno? cosa sanno? "
     "cosa possono fare? come collaborano?")

card("[OO][Teoria]",
     "Che cosa vuol dire che <b>un modello non e' la realta'</b>? Enuncia la "
     "regola.",
     "Un modello: (1) <b>seleziona</b> alcuni aspetti della realta'; "
     "(2) ne <b>trascura</b> altri; (3) li rappresenta a un certo "
     "<b>livello di astrazione</b>; (4) viene <b>raffinato</b> quando "
     "aumentano le informazioni.<br><br>"
     "Un modello di banca include " + c("Cliente, Conto, Bonifico, Carta") +
     " ma ignora il colore dell'edificio o l'eta' del direttore &mdash; non "
     "perche' non esistano, ma perche' <b>non sono rilevanti rispetto allo "
     "scopo</b>.<br><br>"
     "<b>Regola:</b> <i>un buon modello non e' quello che descrive tutto, ma "
     "quello che descrive correttamente cio' che serve per il problema "
     "considerato.</i>")

card("[OO][Slide-vs-Realta]",
     "Le slide dicono che l'OO &laquo;rappresenta naturalmente il "
     "mondo&raquo;. Che precisazione serve?",
     "Non significa che esista automaticamente la corrispondenza "
     "<b>oggetto software = oggetto fisico reale</b>.<br><br>"
     "Molti ottimi oggetti software sono <b>concetti non fisici</b>: "
     + c("Transaction") + ", " + c("Reservation") + ", " + c("Session") +
     ", " + c("Strategy") + ", " + c("Permission") + ".<br><br>"
     "L'OO e' un <b>modo utile di modellare</b>, non la scoperta della "
     "&laquo;vera struttura del mondo&raquo;.")

card("[OO][Esame]",
     "Quali sono le <b>tre caratteristiche</b> di un oggetto? (risposta "
     "d'esame completa)",
     "&bull; <b>Identity</b> &mdash; due oggetti possono avere gli "
     "<b>stessi valori</b> ed essere comunque <b>entita' differenti</b>:" +
     code("""
accountA.balance = 100
accountB.balance = 100

NON implica accountA == accountB (come identita')
""") + "&bull; <b>State</b> &mdash; i valori correnti degli attributi<br><br>"
     "&bull; <b>Behavior</b> &mdash; le operazioni che l'oggetto puo' eseguire")

card("[OO][Teoria]",
     "Distingui <b>classe</b> e <b>oggetto</b> con la notazione delle slide.",
     "Una <b>class</b> descrive struttura, operazioni, vincoli e relazioni "
     "<b>comuni</b> a una collezione di oggetti simili. Un <b>object</b> e' "
     "una <b>particolare istanza</b>." +
     code("""
CLASSE
Student
-----------------
name
studentNumber
-----------------
enroll()
takeExam()

OGGETTI
alice : Student            bob : Student
name = "Alice"             name = "Bob"
studentNumber = 1042       studentNumber = 928
""") + "Condividono la struttura, ma hanno <b>identita' diversa</b> e "
     "<b>valori di stato diversi</b>.")

card("[OO][Esame]",
     "Nel modello Animal/Person/Car (pp.25-26) emergono <b>tre relazioni "
     "diverse</b>. Quali? Non confonderle.",
     code("""
GENERALIZZAZIONE   Girl is-a Person
INSTANZIAZIONE     Nancy instance-of Girl
ASSOCIAZIONE       Nancy has/drives Ferrari
""") + "&bull; la <b>generalizzazione</b> lega <b>classe a classe</b><br>"
     "&bull; l'<b>istanziazione</b> lega <b>oggetto a classe</b><br>"
     "&bull; l'<b>associazione</b> lega <b>istanze</b> fra loro<br><br>"
     "<b>Queste tre relazioni non devono essere confuse</b> &mdash; e' uno "
     "dei trabocchetti d'esame piu' frequenti.")

card("[OO][Esame][Trabocchetto]",
     "<b>Inheritance vs Instantiation</b> (p.37): confronta " +
     c("Dog -> Animal") + " e " + c("Pluto -> Dog") + ".",
     code("""
Dog is-a Animal
   relazione FRA CLASSI
   -> generalization / inheritance

Pluto is an instance of Dog
   relazione FRA OGGETTO E CLASSE
   -> instantiation / classification
""") + "Una <b>Ferrari specifica</b> (" + c("myFerrari : Ferrari") + ") "
     "<b>non</b> e' una nuova sottoclasse di " + c("Ferrari") + ": e' un "
     "<b>oggetto</b>.<br><br>"
     "Non dire mai <i>&laquo;Pluto eredita da Dog&raquo;</i>: Pluto e' "
     "<b>istanza di</b> Dog.")

card("[OO][Esame]",
     "Formalizza <b>insiemisticamente</b> generalizzazione e istanziazione. "
     "Quale delle due e' transitiva?",
     code("""
GENERALIZZAZIONE = inclusione fra insiemi
    Truck  (sottoinsieme di)  Car
    Car    (sottoinsieme di)  Vehicle
    ==> Truck (sottoinsieme di) Vehicle      TRANSITIVA

ISTANZIAZIONE = appartenenza
    myTruck  (appartiene a)  Truck
""") + "Da " + c("myTruck in Truck") + " e " + c("Truck subset Car") +
     " <b>non</b> segue che " + c("myTruck") + " sia &laquo;una classe "
     "Car&raquo;: resta un <b>oggetto</b>.<br><br>"
     "<b>La generalizzazione e' transitiva; non bisogna mescolare "
     "appartenenza e inclusione.</b>")

card("[OO][Teoria]",
     "Che cos'e' la <b>multiple inheritance</b>? C++ e Java che cosa "
     "supportano davvero?",
     "Una classe ha <b>piu' di una superclass</b>. Nell'esempio della slide "
     "un'automobile e' contemporaneamente una <b>Machine</b> e un "
     "<b>MeansOfTransportation</b>.<br><br>"
     "L'annotazione dice solo &laquo;C++ si', Java no&raquo;. "
     "<b>Precisazione:</b><br>"
     "&bull; <b>C++</b> supporta ereditarieta' multipla <b>di classi</b><br>"
     "&bull; <b>Java</b> non consente piu' superclass <b>concrete</b><br>"
     "&bull; Java consente pero' di implementare <b>piu' interfacce</b>")

card("[OO][Slide-vs-Realta]",
     "La slide dice: <i>&laquo;durante l'ereditarieta' alcuni attributi "
     "diventano fixed&raquo;</i>. Come si dice correttamente?",
     "E' una semplificazione. Il concetto corretto e': una sottoclasse puo' "
     "introdurre <b>vincoli piu' specifici</b> sui valori ammessi." +
     code("""
Vehicle.color : Color

YellowTaxi.color = yellow    <- constraint della sottoclasse
""") + "Ma <b>non e' l'ereditarieta' in se'</b> che &laquo;fissa "
     "automaticamente&raquo; gli attributi.")

card("[OO][Esame]",
     "Distingui <b>operation</b>, <b>method</b> e <b>message</b> in UML.",
     "&bull; <b>Operation</b> = la <b>dichiarazione</b> di un servizio "
     "disponibile: nome, parametri, tipo di ritorno" +
     code("withdraw(amount : Money) : Boolean") +
     "&bull; <b>Method</b> = l'<b>implementazione</b> dell'operation. Due "
     "classi possono dichiarare la stessa operation " + c("draw()") +
     " e avere <b>metodi diversi</b><br><br>"
     "&bull; <b>Message</b> = la <b>richiesta inviata</b> a un oggetto "
     "durante un'interazione: " + c("controller -> payment : pay(50)") +
     "<br><br><b>Trabocchetto:</b> " + c("message != method != operation") +
     ", anche se nel linguaggio colloquiale del corso vengono talvolta "
     "trattati quasi come sinonimi (la slide 32 cita &laquo;service&raquo;, "
     "&laquo;member function&raquo; e &laquo;method&raquo; come vicini).")

card("[OO][Codice][Esercizio]",
     "Trova i <b>quattro problemi</b> del codice della slide 31." +
     code("""
class funiture {
public:
    float cost;
    float dimension;
    char* location;
    char* color;
};

void main(void) {
    furniture aForniture;
}
"""),
     "1. <b>Typo</b>: la classe si chiama " + c("funiture") + " ma si usa " +
     c("furniture") + " (e la variabile e' " + c("aForniture") + ")<br><br>"
     "2. <b>" + c("void main") + "</b>: in C++ standard e' " + c("int main()") +
     "<br><br>"
     "3. <b>" + c("char*") + "</b>: per le stringhe moderne si preferisce " +
     c("std::string") + "<br><br>"
     "4. <b>Attributi completamente </b>" + c("public") + ": contraddice "
     "l'information hiding appena introdotto nelle slide precedenti.")

card("[OO][Esame]",
     "Il polimorfismo delle slide (&laquo;stesso nome per operazioni dello "
     "stesso tipo su oggetti diversi&raquo;) e' una definizione ampia. "
     "Distingui le <b>tre forme</b>.",
     "&bull; <b>Ad-hoc (overloading)</b> &mdash; stesso nome, firme diverse; "
     "risolto <b>in compilazione</b>" +
     code("""
void print(int x);
void print(double x);
void print(const std::string& x);
""") + "&bull; <b>Parametric/generic</b> &mdash; il codice non ha bisogno di "
     "sapere in anticipo il tipo, purche' le operazioni usate siano valide" +
     code("""
template <class A>
void swap(A& x, A& y) {
    A t = x;
    x = y;
    y = t;
}
""") + "&bull; <b>Subtype (overriding)</b> &mdash; " + c("Graph") + " con "
     + c("LineGraph") + " e " + c("PieChart") + " che ridefiniscono " +
     c("draw()") + ": la chiamata esegue codice diverso a seconda del "
     "<b>tipo dinamico</b> dell'oggetto.")

card("[OO][Esame][Trabocchetto]",
     "Tabella <b>overloading vs overriding</b>. (Da sapere senza esitazioni.)",
     code("""
OVERLOADING                    OVERRIDING
--------------------------------------------------------
stesso nome                    stessa operation ereditata
firme DIVERSE                  stessa firma compatibile
spesso stessa classe/scope     subclass
selezione tipicamente          dispatch DINAMICO
  STATICA
"quale funzione corrisponde    "quale implementazione
 a questi parametri?"           corrisponde all'oggetto
                                reale?"
"""))

card("[OO][Codice]",
     "Che cosa stampa? Perche' " + c("drawCorrect") + " esegue "
     + c("LineGraph::draw()") + " pur ricevendo un " + c("const Graph&") +
     "?" +
     code("""
class Graph {
public:
    virtual ~Graph() = default;
    virtual void draw() const {
        std::cout << "Generic graph\\n";
    }
};

class LineGraph : public Graph {
public:
    void draw() const override {
        std::cout << "Line graph\\n";
    }
};

class PieChart : public Graph {
public:
    void draw() const override {
        std::cout << "Pie chart\\n";
    }
};

void drawCorrect(const Graph& graph) {
    graph.draw();
}

int main() {
    LineGraph line;
    PieChart  pie;
    drawCorrect(line);
    drawCorrect(pie);

    std::vector<std::unique_ptr<Graph>> graphs;
    graphs.push_back(std::make_unique<LineGraph>());
    graphs.push_back(std::make_unique<PieChart>());
    for (const auto& g : graphs) g->draw();
}
"""),
     code("""
Line graph
Pie chart
Line graph
Pie chart
""") + "La funzione accetta il <b>tipo statico generale</b> " + c("Graph") +
     ", ma " + c("draw()") + " e' <b>virtual</b>: il <b>dispatch "
     "virtuale</b> seleziona l'implementazione in base al <b>tipo "
     "dinamico</b> dell'oggetto realmente passato.<br><br>"
     "(La slide 41 conteneva la versione storica con " + c("void main") +
     ", array incompleto e indici discutibili.)")

card("[OO][Teoria]",
     "In quali modi si puo' ottenere <b>reuse</b>? E' vero che &laquo;si "
     "eredita ogni volta che si vuole evitare di riscrivere codice&raquo;?",
     "<b>No.</b> Il riuso puo' avvenire mediante: <b>funzioni</b>, "
     "<b>classi</b>, <b>librerie</b>, <b>composizione</b>, "
     "<b>delegazione</b>, <b>generic programming</b>, <b>servizi</b>, "
     "<b>componenti</b>.<br><br>"
     "Uno dei grandi temi del corso e': <b>ereditarieta' != semplice "
     "tecnica per copiare codice</b>.<br><br>"
     "(La slide 20 elenca quattro mezzi per la qualita': information hiding, "
     "abstraction, modularization, reuse.)")

card("[OO][Teoria]",
     "Perche' le classi estratte all'inizio si chiamano <b>candidate "
     "classes</b>? (processo iterativo, pp.27-28)",
     "Perche' il processo OO <b>non</b> e' <i>analisi perfetta &rarr; design "
     "perfetto &rarr; codice definitivo</i>, ma:" +
     code("""
capisco qualcosa
   -> modello
   -> implemento/prototipo
   -> scopro problemi
   -> raffino il modello
   -> ripeto
""") + "Il diagramma delle slide mostra il ciclo: planning &rarr; analysis "
     "&rarr; design &rarr; reusable classes &rarr; prototype &rarr; test "
     "&rarr; customer evaluation &rarr; review/refinement &rarr; nuova "
     "iterazione.<br><br>"
     "Le classi iniziali sono ipotesi, <b>non verita' definitive</b>.")

# =====================================================================
# 3. UML: che cos'e', classifier, i diagrammi
# =====================================================================

card("[UML][Teoria]",
     "Che cos'e' <b>UML</b>? E che cosa <b>non</b> e'?",
     "<b>UML = Unified Modeling Language</b>: un <b>modeling language</b>, "
     "cioe' una <b>notazione</b> per esprimere modelli.<br><br>"
     "<b>Non</b> e':<br>"
     "&bull; un linguaggio di programmazione<br>"
     "&bull; una metodologia completa<br>"
     "&bull; un processo di sviluppo obbligatorio<br><br>"
     "Nasce dall'unificazione delle metodologie di <b>Booch</b>, "
     "<b>Rumbaugh</b> e <b>Jacobson</b> (anni '80-'90), sviluppato "
     "nell'ambiente <b>Rational</b> e standardizzato dall'<b>OMG</b>.<br><br>"
     "Serve a rendere esplicito, in forma standard: cosa esiste, come e' "
     "collegato, come si comporta, come interagisce.")

card("[UML][Slide-vs-Realta]",
     "La p.43 dice <i>&laquo;currently it is at version 1.3&raquo;</i>. Che "
     "cosa rispondi all'esame?",
     "E' un'informazione <b>storica</b> delle slide. UML 1.x e' superato da "
     "molti anni dalla famiglia <b>UML 2.x</b>.<br><br>"
     "Se il docente chiede il contenuto della slide: <i>il materiale si "
     "riferisce a UML 1.3</i>. Ma <b>non presentarlo come versione "
     "corrente</b>.<br><br>"
     "Nello stesso spirito, due nomi sono cambiati:" +
     code("""
Collaboration Diagram  ->  Communication Diagram
Statechart Diagram     ->  State Machine Diagram
"""))

card("[UML][Teoria]",
     "Che cos'e' un <b>classifier</b>? Quali elenca la slide 45?",
     "Un <b>classifier</b> descrive un <b>insieme di istanze</b> che "
     "condividono certe caratteristiche (es. " + c("Car") + " classifica gli "
     "oggetti che consideriamo automobili).<br><br>"
     "La slide elenca: <b>Class</b>, <b>Interface</b>, <b>Datatype</b>, "
     "<b>Component</b>, <b>Node</b>, <b>Use Case</b>, <b>Subsystem</b>.")

card("[UML][Esame]",
     "Classifica i diagrammi UML in <b>structural</b> e <b>behavioral</b>.",
     "<b>Structural</b> &mdash; mostrano <b>che cosa esiste</b> e com'e' "
     "strutturato:<br>class, object, component, deployment diagram<br><br>"
     "<b>Behavioral</b> &mdash; mostrano <b>che cosa succede</b>:<br>"
     "use case, activity, state machine, sequence, communication<br><br>"
     "La slide 46 (terminologia UML 1.x) ne elenca <b>nove</b>: class, "
     "object, component, deployment, use case, sequence, collaboration, "
     "statechart, activity. Il corso si concentra su: use case, class, state, "
     "activity, sequence, collaboration/communication.")

card("[UML][Teoria]",
     "Qual e' la sintassi concettuale di una <b>transizione</b> in uno "
     "<b>state machine diagram</b>? Spiegala sull'esempio.",
     code("""
event [guard] / action

temperatureChanged [tooCold] / heater.on()
""") + "1. accade l'<b>evento</b> " + c("temperatureChanged") + "<br>"
     "2. <b>se</b> la guardia " + c("tooCold") + " e' vera<br>"
     "3. viene eseguita l'<b>azione</b> " + c("heater.on()") + "<br>"
     "4. eventualmente si <b>cambia stato</b><br><br>"
     "Nell'esempio dell'aria condizionata (p.49): stati " + c("Idle") + ", " +
     c("Daytime") + ", " + c("Nighttime") + "; eventi " + c("Sunset") + ", " +
     c("Sunrise") + ", temperature drop/rise; azioni " + c("Lights::off()") +
     ", " + c("Lights::on()") + ", " + c("adjustTemperature()") + ".")

card("[UML][Trabocchetto]",
     "<b>Stato</b> e <b>classe</b> sono la stessa cosa?",
     "<b>No.</b><br><br>"
     "&bull; una <b>classe</b> descrive <b>che tipo di oggetto e'</b><br>"
     "&bull; uno <b>stato</b> descrive <b>in quale condizione si trova in un "
     "certo istante</b>" +
     code("""
Order            <- CLASSE

Created
Paid             <- STATI di un oggetto Order
Shipped
Cancelled
"""))

card("[UML][Esame]",
     "Differenza fra <b>activity diagram</b> e <b>state machine diagram</b>.",
     "&bull; <b>State machine</b>: segue la <b>vita di un'entita'</b> e i "
     "suoi <b>stati</b><br><br>"
     "&bull; <b>Activity diagram</b>: segue un <b>flusso di attivita'</b> "
     "&mdash; workflow, processi, decisioni, parallelismo, "
     "sincronizzazione<br><br>"
     "L'esempio della slide 50 e' la <b>coffee machine</b>: mettere il caffe' "
     "nel filtro, aggiungere acqua, mettere il filtro nella macchina, "
     "accendere la macchina.")

card("[UML][Esame]",
     "Differenza fra <b>sequence diagram</b> e <b>communication "
     "(collaboration) diagram</b>. Quali sono gli elementi del sequence?",
     "Possono rappresentare <b>la stessa interazione</b>, ma:<br>"
     "&bull; <b>sequence</b>: mette in primo piano l'<b>ordine "
     "temporale</b><br>"
     "&bull; <b>communication</b>: mette in primo piano <b>chi comunica con "
     "chi</b> (la rete di collegamenti; i numeri " + c("1: 2: 3:") + " "
     "specificano l'ordine)<br><br>"
     "Elementi del sequence:<br>"
     "&bull; <b>lifeline</b> &mdash; un partecipante: "
     + c("controller : EnvironmentalController") + "<br>"
     "&bull; <b>message</b> &mdash; una richiesta: "
     + c("controller -> cooler : startUp()") + "<br>"
     "&bull; <b>tempo</b> &mdash; scorre convenzionalmente <b>dall'alto verso "
     "il basso</b>: per questo l'ordine geometrico verticale e' importante")

card("[UML][Teoria]",
     "Nel class diagram " + c("motorVehicle") + " (p.48), come si legge la "
     "freccia con <b>triangolo vuoto</b>?",
     code("""
          motorVehicle
         /     |      \\
motorCycle    Car     truck

Car ---------|> motorVehicle
""") + "La freccia con il <b>triangolo vuoto</b> punta verso la classe "
     "<b>piu' generale</b>, e si legge:<br><br>"
     "&laquo;" + c("Car") + " e' una <b>specializzazione</b> di " +
     c("motorVehicle") + "&raquo;.")

# =====================================================================
# 4. USE CASE
# =====================================================================

card("[UseCase][Esame]",
     "Da' la definizione di <b>use case</b> utile per l'esame, e le "
     "proprieta' elencate dalla slide.",
     "<b>Un use case descrive una sequenza di interazioni attraverso cui il "
     "sistema fornisce a un attore un risultato di valore osservabile.</b>"
     "<br><br>La slide aggiunge che un use case:<br>"
     "&bull; puo' avere <b>granularita' diversa</b><br>"
     "&bull; rappresenta spesso una funzione <b>user-visible</b><br>"
     "&bull; raggiunge sempre un <b>goal discreto</b><br>"
     "&bull; descrive funzionalita' richiesta <b>esternamente</b>" +
     code("""
BENE                       MALE
Actor: Customer            Actor: Customer
Use Case: Withdraw Cash    Use Case: call database method
""") + "il secondo e' un <b>dettaglio implementativo</b>.")

card("[UseCase][Slide-vs-Realta]",
     "<b>User story</b> e <b>use case</b> sono sinonimi? (l'annotazione di "
     "p.3 dice &laquo;nomi &rarr; classi, verbi &rarr; metodi&raquo;)",
     "<b>No</b>, sono correlati ma non sinonimi.<br><br>"
     "&bull; <b>User story</b> (forma Agile, breve): <i>As a customer, I want "
     "to download an invoice so that I can keep it for accounting.</i><br><br>"
     "&bull; <b>Use case</b>: descrizione piu' <b>strutturata</b> "
     "dell'interazione" +
     code("""
Actor
Preconditions
Main flow
Alternative flows
Postconditions
""") + "Il corso, nelle slide ufficiali successive, lavora chiaramente sui "
     "<b>use cases</b>, non sulle user stories.")

card("[UseCase][Esame][Trabocchetto]",
     "Che cos'e' un <b>actor</b>? " + c("Mario Rossi") + " e' un actor?",
     "L'actor e' il <b>RUOLO</b> svolto rispetto al sistema, e <b>non deve "
     "necessariamente essere umano</b>.<br><br>" +
     c("Mario Rossi") + " <b>non</b> e' l'actor: e' l'istanza di una persona. "
     "Gli actor sono: " + c("Customer") + ", " + c("Administrator") + ", " +
     c("Payment Provider") + ", " + c("External Accounting System") + ", " +
     c("Timer") + ".<br><br>"
     "&bull; una <b>stessa persona</b> puo' interpretare piu' attori "
     "(Employee, Manager, System Administrator) in momenti diversi<br>"
     "&bull; un actor puo' <b>non ricevere il valore finale</b>: una "
     "stampante o un payment gateway <b>partecipano</b> al use case senza "
     "essere l'utente finale (la slide distingue infatti attori che "
     "<b>ricevono valore</b> da quelli che <b>partecipano</b>)")

card("[UseCase][Teoria]",
     "Quali domande suggeriscono le slide (pp.61-62) per <b>trovare i use "
     "case</b>?",
     "&bull; quali <b>task</b> esegue l'actor?<br>"
     "&bull; quali informazioni <b>produce o modifica</b>?<br>"
     "&bull; quali informazioni <b>riceve</b>?<br>"
     "&bull; quali <b>eventi esterni</b> deve comunicare?<br>"
     "&bull; quali <b>anomalie</b> vuole conoscere?<br><br>"
     "E' molto meglio che partire dalla <b>GUI</b>.")

card("[UseCase][Esame][Trabocchetto]",
     "La slide 71 avverte: <i>non esiste corrispondenza 1:1 fra <b>screen</b> "
     "e <b>oval</b></i>. Che cosa significa?",
     "Un use case <b>non</b> e' una schermata." +
     code("""
NO                     SI'
Open Login Page        Authenticate
Open Settings Page     Configure Account
Open Cart Page         Purchase Products
""") + "&bull; una <b>singola interfaccia</b> puo' partecipare a <b>molti</b> "
     "use case<br>"
     "&bull; un <b>singolo use case</b> puo' attraversare <b>diverse "
     "schermate</b><br><br>"
     "(All'esame: " + c("Checkout") + " = use case plausibile; " +
     c("Checkout page") + " = elemento UI.)")

card("[UseCase][Esame]",
     "<b>" + c("<<include>>") + "</b>: sintassi, direzione della "
     "freccia, a cosa serve.",
     code("""
A - - - <<include>> - - -> B

si legge: A INCLUDE B
la freccia va dall'including use case all'included
""") + "Durante il comportamento descritto da A, il comportamento di B viene "
     "<b>incorporato nel punto opportuno</b>.<br><br>"
     "Serve per il <b>riuso OBBLIGATORIO di comportamento comune</b>: si usa "
     "quando una porzione di comportamento e' comune a piu' use case e "
     "conviene <b>fattorizzarla</b>." +
     code("""
Place Order
    |
    | <<include>>
    v
Authenticate Customer
"""))

card("[UseCase][Esame]",
     "<b>" + c("<<extend>>") + "</b>: dove punta la freccia? Che "
     "vincolo ha il caso base?",
     code("""
Extension - - - <<extend>> - - -> Base

la freccia punta VERSO IL CASO BASE

Apply Coupon
       |
       | <<extend>>
       v
Checkout
""") + "&bull; il <b>base use case deve avere significato anche senza</b> "
     "l'estensione<br>"
     "&bull; l'estensione si attiva <b>solo se</b> si verifica una condizione "
     "appropriata<br><br>"
     "<b>Attenzione alla direzione:</b> e' l'errore piu' comune "
     "(" + c("extension -> base") + ", non il contrario).")

card("[UseCase][Esame]",
     "Tabella <b>include vs extend</b>.",
     code("""
include                        extend
-------------------------------------------------------
fattorizza comportamento       aggiunge comportamento
  COMUNE                         opzionale/condizionale

il comportamento incluso       il base use case e'
  fa parte del flusso            significativo anche
                                 SENZA l'estensione

freccia dal caller             freccia dall'extension
  all'included                   al base
""") + "<b>Criterio d'esame:</b><br>"
     "&bull; mandatory reusable behavior &rarr; <b>include</b><br>"
     "&bull; optional/conditional augmentation &rarr; <b>extend</b>")

card("[UseCase][Slide-vs-Realta]",
     "Le annotazioni suggeriscono <b>&laquo;extend = ereditarieta' del use "
     "case&raquo;</b> e un <b>criterio basato sugli attori</b> (p.68). "
     "Vanno presi alla lettera?",
     "<b>No, entrambi vanno ridimensionati.</b><br><br>"
     "1. " + c("<<extend>> != inheritance") + ". E' una relazione "
     "di <b>estensione comportamentale di uno scenario</b>, non una relazione "
     "di <b>sottotipo</b>. L'analogia e' fuorviante.<br><br>"
     "2. L'osservazione che con " + c("extend") + " spesso lo stesso actor e' "
     "collegato al base, mentre con " + c("include") + " l'included puo' non "
     "avere actor diretto, e' una <b>euristica</b>, non la semantica. "
     "All'esame basati su <b>mandatory reuse vs conditional augmentation</b>, "
     "non sul numero degli actor.")

card("[UseCase][Teoria]",
     "Perche' serve la <b>textual use case description</b> (pp.69-70)? "
     "Riporta l'esempio " + c("Get the deal") + ".",
     "Perche' un <b>ovale da solo</b> non spiega il comportamento." +
     code("""
Get the deal
1. inserire username e conto
2. verificarli
3. inserire quantita' e stock ID
4. determinare il prezzo
5. verificare il limite
6. inviare ordine a NYSE
7. memorizzare il numero di conferma
""") + "La descrizione testuale e' la <b>sequenza passo-passo delle "
     "interazioni</b>.")

card("[UseCase][Esame]",
     "Scrivi la <b>forma completa</b> di un use case testuale.",
     code("""
Name: Withdraw Cash

Primary actor:
    Customer

Preconditions:
    Card accepted
    Customer authenticated

Trigger:
    Customer requests a withdrawal

Main success scenario:
    1. Customer chooses amount.
    2. System verifies balance.
    3. System debits account.
    4. System dispenses cash.
    5. System records transaction.

Alternative:
    2a. Insufficient funds
        -> system rejects operation.

Postcondition:
    Balance and transaction history
    are consistent.
""") + "Da qui e' molto piu' semplice derivare <b>classi</b>, "
     "<b>responsabilita'</b>, <b>interazioni</b> e <b>casi di errore</b>.")

card("[UseCase][Esame][Trabocchetto]",
     "Che cos'e' l'anti-pattern <b>&laquo;The Killer&raquo;</b> (p.72)? Come "
     "si corregge?",
     "E' un use case diagram in cui vengono collegati come se fossero use "
     "case degli elementi che sono in realta' <b>la struttura interna del "
     "sistema</b>:" +
     code("""
SBAGLIATO                    CORRETTO
System Main UI               Reserve Flight
Reservation subsystem        Check Schedule
Frequent flyers subsystem    Manage Frequent Flyer Account
Traveler services subsystem  Check Fares
""") + "Un use case diagram deve rappresentare gli <b>obiettivi degli "
     "actor</b>, non l'architettura.<br><br>"
     "<b>Regola pratica:</b> formula gli use case con <b>verbo + "
     "oggetto</b>, per esprimere un <b>goal</b>.")

card("[UseCase][Teoria]",
     "La slide 71 dice che un singolo diagramma non deve elencare tutti i use "
     "case. Perche' e' importante?",
     "Perche' un diagramma <b>non e' un database completo del modello</b>: "
     "e' una <b>VISTA</b>.<br><br>"
     "Questa idea ritorna nei <b>class diagram</b>: la stessa classe puo' "
     "comparire in diagrammi diversi, e non e' duplicazione concettuale &mdash; "
     "sono viste diverse." +
     code("""
Diagramma 1: Customer + Order + Payment
Diagramma 2: Customer + Account + Permission
Diagramma 3: Customer + SupportTicket
"""))

# =====================================================================
# 5. DA USE CASE A CLASSI
# =====================================================================

card("[Analysis][Teoria]",
     "Quali sono gli <b>otto passi</b> del passaggio da OO Concept Modeling a "
     "OO Analysis (pp.80-82)?",
     code("""
1. estrarre candidate classes
2. stabilire relazioni di base
3. definire gerarchie
4. identificare attributi
5. specificare metodi
6. indicare relazioni fra classi/oggetti
7. costruire modello comportamentale
8. iterare
""") + "La trasformazione chiave e':" +
     code("""
requisiti
   -> concetti del dominio
   -> classi candidate
   -> relazioni
   -> responsabilita'
   -> modello comportamentale
"""))

card("[Analysis][Esame][Trabocchetto]",
     "La tecnica dice: <b>individua i sostantivi</b> per estrarre le classi. "
     "Perche' &laquo;ogni sostantivo &rarr; classe&raquo; e' sbagliato?",
     "Perche' e' un metodo per ottenere <b>candidate classes</b>, <b>non un "
     "algoritmo definitivo</b>." +
     code("""
"The user enters a password of eight characters."

nomi: user, password, characters

-> characters NON e' una classe del dominio
""") + "(Nell'esempio " + c("Get the deal") + " emergono: user, bank "
     "account, shares, share ID, price, limit, NYSE, confirmation number "
     "&mdash; e non tutti diventeranno classi.)")

card("[Analysis][Esame]",
     "Quali <b>cinque domande</b> usi per filtrare una <b>candidate "
     "class</b>?",
     "1. <b>Ha identita' propria?</b> " + c("Order") + " si'; " + c("Color") +
     " forse no, magari basta un <i>value type</i><br><br>"
     "2. <b>Ha un ciclo di vita?</b> " + c("Reservation") + " si'<br><br>"
     "3. <b>Ha comportamento o responsabilita'?</b> " + c("Payment") +
     " probabilmente si'<br><br>"
     "4. <b>E' solo un attributo di qualcos'altro?</b> " + c("address") +
     " potrebbe essere un attributo <b>oppure</b> una classe " + c("Address") +
     ", a seconda del dominio<br><br>"
     "5. <b>E' un dettaglio tecnico?</b> " + c("button") + " non deve "
     "diventare una classe del domain model solo perche' il requisito dice "
     "&laquo;premere il bottone&raquo;")

card("[Analysis][Esercizio]",
     "Svolgi il filo completo dal requisito alle classi:<br>"
     "<i>&laquo;Il cliente puo' ordinare un prodotto e pagare con carta. Se "
     "il pagamento fallisce, l'ordine non viene confermato.&raquo;</i>",
     code("""
1. ACTOR
   Customer, Payment Provider

2. USE CASE
   Place Order
      <<include>> Process Payment
   scenario alternativo: Payment Declined

3. CANDIDATE CLASSES (sostantivi)
   Customer, Product, Payment, Order, Card

4. FILTRAGGIO
   Card -> classe? value object? token esterno?
   (dipende dal dominio)

5. ASSOCIATION
   Customer  1 --- 0..* Order
   Order     1 --- 1..* OrderLine
   OrderLine * --- 1    Product
   Order     1 --- 0..1 Payment

6. RESPONSIBILITIES
   Order   + addProduct() + total() + confirm()
   Payment + authorize()

7. BEHAVIOR (sequence diagram)
   Customer -> OrderService
            -> PaymentGateway
            -> Order
""") + "I vari diagrammi <b>non sono concorrenti</b>: sono <b>viste "
     "complementari</b> dello stesso sistema.")

# =====================================================================
# 6. CLASS DIAGRAM
# =====================================================================

card("[ClassDiagram][Esame]",
     "Quali sono le <b>tre prospettive</b> di un class diagram (p.87)? "
     "Esemplifica ciascuna.",
     "&bull; <b>Conceptual</b> &mdash; <i>quali concetti esistono nel "
     "dominio?</i> " + c("Customer --- Order") + ". Non mi interessa ancora " +
     c("ArrayList<Order>") + " o la foreign key<br><br>"
     "&bull; <b>Specification</b> &mdash; <i>quali servizi e interfacce deve "
     "offrire il software?</i>" +
     code("""
OrderService
+ createOrder()
+ cancelOrder()
""") + "&bull; <b>Implementation</b> &mdash; <i>come sono realizzati nel "
     "codice?</i>" +
     code("std::unordered_map<OrderId, std::unique_ptr<Order>>") +
     "Questa distinzione evita moltissimi errori.")

card("[ClassDiagram][Trabocchetto]",
     "Qual e' l'<b>errore frequente</b> legato alle tre prospettive?",
     "Inserire nel <b>diagramma di analisi</b> elementi come:" +
     code("""
DatabaseConnection
JsonSerializer
HttpController
ArrayList
SqlRepository
""") + "quando si stava modellando il <b>dominio</b>.<br><br>"
     "Sono perfettamente legittimi nel <b>design/implementation model</b>, ma "
     "sono <b>rumore</b> nel conceptual model.")

card("[ClassDiagram][Teoria]",
     "Disegna la <b>notazione di una class</b> UML (p.88).",
     code("""
+-----------------------------+
| Task                        |   <- name
+-----------------------------+
| startDate : Date            |   <- attributes
| endDate   : Date            |
+-----------------------------+
| setStartDate(d : Date)      |   <- operations
| setEndDate(d : Date)        |
| getDuration() : Duration    |
+-----------------------------+
""") + "Rettangolo a <b>tre compartimenti</b>: name, attributes, operations.")

card("[ClassDiagram][Esame]",
     "Qual e' la <b>sintassi UML delle operations</b> (p.110)? E i simboli di "
     "visibilita'?",
     code("""
visibility name(parameter-list) : return-type

+ assignAgent(a : Agent) : Boolean
+ withdraw(amount : Money) : Boolean

+   public
#   protected
-   private
"""))

card("[ClassDiagram][Esame]",
     "Distingui <b>query</b> e <b>modifier</b> (p.111). E' vero che &laquo;le "
     "query si possono eseguire in qualsiasi ordine&raquo;?",
     "&bull; <b>Query</b>: restituisce un risultato <b>senza modificare lo "
     "stato interno</b> &mdash; " + c("balance() : Money") + ". I "
     "<b>getter</b> sono query.<br>"
     "&bull; <b>Modifier</b>: modifica lo stato &mdash; "
     + c("withdraw(amount)") + ". I <b>setter</b> sono modifier.<br><br>"
     "<b>[!]</b> L'affermazione vale <b>solo se</b> sono davvero "
     "<b>side-effect-free rispetto allo stato rilevante</b>. Un metodo "
     "apparentemente &laquo;get&raquo; che incrementa statistiche, aggiorna "
     "cache osservabili, modifica file o usa un servizio esterno con effetti "
     "<b>non e' una query pura</b> nel senso forte.")

card("[ClassDiagram][Esame]",
     "Distingui <b>class</b> e <b>type</b> (p.89). Le annotazioni dicono "
     "&laquo;in Java un type e' un'interface&raquo; e &laquo;in C++ un type e' "
     "una abstract class&raquo;: e' vero?",
     "La slide: <b>type</b> = protocollo capito dall'oggetto; <b>class</b> = "
     "costrutto orientato all'implementazione; una class <b>implementa uno o "
     "piu' types</b>. Come idea concettuale e' utile.<br><br>"
     "<b>Ma le due annotazioni sono troppo forti</b> (false se prese alla "
     "lettera):" +
     code("""
In JAVA sono tipi:
  classi, interfacce, enum, record,
  array, primitive types

In C++ sono tipi:
  int, double, std::string,
  ConcreteClass, AbstractClass
""") + "Un'interfaccia (o una classe astratta) e' un <b>ottimo esempio</b> di "
     "tipo come <b>contratto</b>, ma non e' &laquo;il significato di "
     "type&raquo;.")

# =====================================================================
# 7. ASSOCIATION, MULTIPLICITY, AGGREGATION
# =====================================================================

card("[Relazioni][Esame][Trabocchetto]",
     "Distingui <b>association</b> e <b>link</b>.",
     "&bull; <b>Association</b>: relazione fra <b>classifier</b>, che "
     "descrive i <b>possibili</b> link fra le loro istanze" +
     code("Customer *--------1 Company") +
     "&bull; <b>Link</b>: la <b>specifica relazione fra ISTANZE</b>" +
     code("alice ---- acmeCorp") +
     "E' la stessa distinzione che c'e' fra <b>class diagram</b> (regole "
     "strutturali generali) e <b>object diagram</b> (configurazione concreta "
     "di istanze).")

card("[Relazioni][Esame][Trabocchetto]",
     "Come si legge correttamente questa multiplicity? Qual e' il "
     "trabocchetto?" +
     code("Customer 1 --------- * Order"),
     "Il numero va letto <b>guardando la classe all'ALTRO capo</b>:" +
     code("""
per ogni Order      ->  1 Customer
per ogni Customer   ->  0..* Orders
""") + "&bull; il " + c("*") + " scritto <b>vicino a Order</b> risponde a: "
     "<i>per un Customer, quanti Order possono esserci?</i><br>"
     "&bull; l'" + c("1") + " <b>vicino a Customer</b> risponde a: <i>per un "
     "Order, quanti Customer possono esserci?</i><br><br>"
     "<b>Molti studenti leggono il numero vicino alla classe sbagliata.</b>")

card("[Relazioni][Esame]",
     "Elenca le <b>forme fondamentali di multiplicity</b> (pp.97-98).",
     code("""
1       esattamente uno
0..1    zero o uno
*       molti, normalmente 0..*
0..*    zero o piu'
1..*    uno o piu'
m..n    intervallo

la slide mostra anche: 1..100, 2,4,5
"""))

card("[Relazioni][Teoria]",
     "Come vanno <b>nominate le association</b> (p.94)?",
     "La slide <b>sconsiglia</b> nomi vaghi:" +
     code("""
MALE                    BENE
associated_with         Customer places Order
has                     Employee worksFor Company
is_related_to           Order contains LineItem
                        Professor teaches Course
""") + "Il nome stesso deve <b>raccontare il dominio</b>.")

card("[Relazioni][Esame]",
     "Che cosa sono i <b>roles</b> di un'association? Perche' sono "
     "<b>particolarmente</b> importanti nelle <b>self-association</b>?",
     "Ogni association ha <b>due ends</b>, ciascuno con un <b>role</b>, che "
     "indica <b>che significato ha l'oggetto visto dall'altro estremo</b>." +
     code("""
Company --------- Person
employer          employee
""") + "Nelle self-association sono <b>indispensabili</b>: senza role " +
     c("Person ----- Person") + " e' <b>ambiguo</b>. Con i role:" +
     code("""
Person ----- Person
manager      subordinate

Person(manager) supervises Person(subordinate)
"""))

card("[Relazioni][Teoria]",
     "Che cos'e' la <b>navigability</b> (p.100)? Che precisazione serve?",
     "La freccia indica che " + c("Order") + " <b>deve poter conoscere</b> il "
     + c("Customer") + ", mentre " + c("Customer") + " non e' "
     "necessariamente progettato per navigare verso tutti i propri ordini." +
     code("""
Order ---------> Customer

class Order {
    Customer* customer;
};
""") + "<b>[!] Precisazione:</b> nelle versioni moderne di UML la notazione "
     "della navigabilita' e soprattutto l'interpretazione dell'<b>assenza di "
     "freccia</b> sono piu' sottili di <i>&laquo;nessuna freccia = "
     "sicuramente non navigabile&raquo;</i>. In sede didattica conviene "
     "attenersi alla convenzione delle slide.")

card("[Relazioni][Teoria]",
     "Un'association impone una specifica implementazione? (p.102)",
     "<b>No.</b> La slide mostra che una association puo' <b>suggerire</b> "
     "operazioni come " + c("order.orderLines()") + " e " +
     c("order.customer()") + ", ma l'UML <b>non impone</b> che venga "
     "implementata con un certo campo o getter.<br><br>"
     "Possibili implementazioni: <b>riferimento</b>, <b>collection</b>, "
     "<b>database relation</b>, <b>repository lookup</b>, <b>computed "
     "view</b>.<br><br>"
     "Il modello specifica la <b>relazione concettuale</b>; "
     "l'implementazione puo' variare.")

card("[Relazioni][Esame]",
     "Che cos'e' una <b>association class</b> e quando serve? (p.103)",
     "Serve quando alcuni attributi <b>non appartengono a nessuna delle due "
     "classi</b>, ma al <b>LEGAME</b> fra quelle due istanze." +
     code("""
User --------- Workstation

priority, accessRights,
startSession, directory
   -> non sono del User
   -> non sono della Workstation
   -> sono dell'AUTORIZZAZIONE

           Authorization      <- association class
""") + "Altro esempio classico:" +
     code("""
Student --------- Course

enrollmentDate, finalGrade, status
   ->  Enrollment
"""))

card("[Relazioni][Esame]",
     "Distingui <b>attribute</b> e <b>association</b>. Quali due affermazioni "
     "della slide 108 vanno corrette?",
     "<b>Regola didattica:</b> nel conceptual model usa un <b>attribute</b> "
     "per una <b>proprieta'-valore</b>, un'<b>association</b> per rendere "
     "esplicita una <b>relazione significativa fra entita' del dominio</b>." +
     code("""
Person
    dateOfBirth : Date        <- attribute

Person --- worksFor --- Company   <- association
""") + "<b>[!] Correzione 1</b> &mdash; &laquo;gli attributi sono "
     "single-valued&raquo;: <b>troppo limitato</b>. Una <i>property</i> UML "
     "puo' avere multiplicity: " + c("phoneNumbers : String [0..*]") + "<br><br>"
     "<b>[!] Correzione 2</b> &mdash; &laquo;un attributo memorizza valori, "
     "non references&raquo;: <b>troppo rigido</b>. In Java " +
     c("class Order { Customer customer; }") + ": il valore del campo <b>e' "
     "un riferimento</b>. Nel metamodello moderno association ends e "
     "attributes sono <b>entrambi</b> esprimibili come UML " + c("Property") +
     ".")

card("[Relazioni][Esame][Trabocchetto]",
     "Dove va il <b>diamante</b> dell'aggregation? (domanda classica "
     "d'esame)",
     "Il diamante va <b>sul lato del WHOLE</b> (l'aggregato/composito)." +
     code("""
Car contains Engine

GIUSTO      Car <>---- Engine
SBAGLIATO   Car ----<> Engine

Car
 <>---- Engine
 <>---- Wheel
""") + "L'aggregation e' una <b>forma particolare di association</b> fra un "
     "<b>whole</b> e le sue <b>parts</b>.")

card("[Relazioni][Esame]",
     "Distingui <b>aggregation</b> e <b>composition</b> (p.115).",
     code("""
AGGREGATION  <>  diamante VUOTO
    Team <>---- Player
    un Player puo' concettualmente esistere
    anche se il Team viene sciolto

COMPOSITION  <#>  diamante PIENO
    Order <#>---- OrderLine
    una OrderLine appartiene strutturalmente
    a UNO SPECIFICO Order
""") + "La <b>composition</b> e' una <b>ownership molto piu' forte</b>.")

card("[Relazioni][Slide-vs-Realta]",
     "Le slide dicono <i>&laquo;parts live and die with the whole&raquo;</i> "
     "e <i>&laquo;aggregation is transitive&raquo;</i>. Che precisazioni "
     "servono?",
     "<b>1. &laquo;live and die&raquo;</b> e' una buona intuizione, ma va "
     "letta <b>concettualmente</b>: non significa distruggere l'oggetto C++ "
     "nello stesso nanosecondo. Significa:<br>"
     "&bull; <b>ownership forte</b><br>"
     "&bull; la parte <b>non appartiene contemporaneamente a piu' "
     "compositi</b> (una stanza di quella casa non e' stanza costitutiva di "
     "un'altra casa: " + c("House <#>---- Room") + ")<br>"
     "&bull; la sua esistenza e' <b>concettualmente legata</b> al whole<br><br>"
     "<b>2. &laquo;transitive&raquo;</b> (p.112) e' <b>troppo forte</b> come "
     "regola UML moderna: la <i>shared aggregation</i> ha una semantica "
     "volutamente <b>debole</b>. Ricorda che <b>la slide la presenta come "
     "transitiva</b>, ma non trattarla come legge generale.")

card("[Relazioni][Teoria]",
     "Come si riconosce una relazione <b>part-whole</b>? (p.116)",
     "Le slide suggeriscono due domande:<br>"
     "1. ha senso dire <b>&laquo;X e' parte di Y&raquo;</b>?<br>"
     "2. le <b>operazioni sul whole influenzano le parts</b>?<br><br>"
     "Sono <b>euristiche</b>, non test matematici.")

# =====================================================================
# 8. GENERALIZATION, SOSTITUIBILITA', MULTIPLE INHERITANCE
# =====================================================================

card("[Generalization][Esame][Trabocchetto]",
     "Perche' <i>&laquo;Border Collie is a Breed&raquo;</i> non implica "
     "<i>&laquo;Shep is a Breed&raquo;</i>? (p.119)",
     code("""
Shep is a Border Collie
Border Collie is a Dog
Dog is an Animal

=> Shep e' un Dog, Shep e' un Animal   OK

MA:
Border Collie is a Breed
=/=> Shep is a Breed
""") + "Perche' " + c("Breed") + " qui e' una <b>classificazione DI "
     "CLASSI/razze</b>, non la classe di cui Shep e' un individuo nel "
     "medesimo senso.<br><br>"
     "E' proprio il tipo di frase che <b>smaschera la confusione</b> fra "
     + c("is-a") + " e " + c("instance-of") + ".")

card("[Generalization][Esame]",
     "Qual e' il <b>test &laquo;is-a&raquo;</b> da fare prima di usare "
     "l'inheritance?",
     "Chiediti: <b>posso davvero dire che ogni B e' un A?</b>" +
     code("""
CORRETTO     Dog is-a Animal

SCORRETTO    Engine is-a Car
             -> in realta' Car HAS-AN Engine
             -> association / composition
""") + "&bull; " + c("is-a") + " puo' suggerire <b>inheritance</b><br>"
     "&bull; " + c("has-a") + " suggerisce <b>association/composition</b>")

card("[Generalization][Esame]",
     "Che cos'e' il principio di <b>sostituibilita'</b>? Che cosa dice la "
     "slide 126 al riguardo?",
     "Se " + c("B extends A") + ", un oggetto <b>B</b> dovrebbe poter essere "
     "usato ovunque sia atteso un <b>A</b> <b>senza rompere le aspettative "
     "fondamentali del contratto</b>.<br><br>"
     "La slide dice: <b>non creare una subclass a livello implementativo se "
     "il livello concettuale non la giustifica</b>.<br><br>"
     "Concettualmente la generalizzazione e' un <b>subset</b>: ogni istanza "
     "della subclass deve poter essere considerata anche istanza del concetto "
     "generale (" + c("SubClass subset SuperClass") + ").")

card("[Generalization][Esame]",
     "La slide 126 dice: <i>&laquo;A stack is not a list with some "
     "overriding!&raquo;</i>. Perche'?",
     code("""
List  ->  insertAt(index)
          removeAt(index)
          get(index)

Stack ->  push
          pop
          top
""") + "Se scrivessimo " + c("Stack extends List") + " dovremmo:<br>"
     "&bull; <b>ereditare operazioni che uno stack non dovrebbe offrire</b><br>"
     "&bull; oppure <b>disabilitarle</b><br>"
     "&bull; oppure <b>farle fallire</b><br><br>"
     "E' il segnale che la relazione " + c("is-a") + " <b>non e' "
     "corretta</b>. Meglio:" +
     code("Stack   contains/delegates to   List"))

card("[Generalization][Esame]",
     "Distingui <b>extension</b> e <b>restriction</b> (p.125), e spiega il "
     "problema <b>Circle-Ellipse</b>.",
     "&bull; <b>Extension</b>: la subclass <b>aggiunge</b> attributi e "
     "operazioni<br>"
     "&bull; <b>Restriction</b>: la subclass <b>restringe i valori "
     "ammessi</b> &mdash; l'esempio della slide e' "
     + c("Circle = Ellipse with equal axes") + "<br><br>"
     "<b>Il problema:</b>" +
     code("""
Ellipse
+ setMajorAxis(x)
+ setMinorAxis(y)

Circle extends Ellipse
  deve mantenere majorAxis == minorAxis

Ma il client di Ellipse puo' legittimamente fare:
    ellipse.setMajorAxis(10);
    ellipse.setMinorAxis(5);
""") + "Che cosa deve fare " + c("Circle") + "? Rompere la propria "
     "invariante? Cambiare entrambi gli assi? Rifiutare una chiamata ammessa "
     "da " + c("Ellipse") + "?<br><br>"
     "E' il conflitto fra <b>classificazione geometrica</b> e <b>contratto "
     "mutabile del software</b>.<br><br>"
     "<b>Trabocchetto:</b> un " + c("is-a") + " <b>linguistico</b> non basta "
     "a giustificare automaticamente l'ereditarieta' <b>software</b>.")

card("[Generalization][Slide-vs-Realta]",
     "La slide 124 dice che <b>un oggetto puo' cambiare classe</b> "
     "dinamicamente, e lo associa a Java/C++. E' vero?",
     "<b>E' sostanzialmente fuorviante.</b> In Java/C++ un oggetto gia' "
     "costruito <b>non cambia la propria runtime class</b>." +
     code("""
Base* p;

prima:  p -> DerivedA object
poi:    p -> DerivedB object
""") + "Non abbiamo trasformato lo stesso oggetto " + c("DerivedA") + " in un "
     + c("DerivedB") + ": abbiamo cambiato <b>l'oggetto referenziato</b>.<br><br>"
     "La semantica UML di <b>classificazione dinamica</b> e' piu' "
     "sofisticata, ma non va equiparata a &laquo;un oggetto C++ cambia "
     "classe&raquo;.")

card("[Generalization][Codice][Esame]",
     "Spiega il <b>diamond problem</b> sull'esempio TextBook (pp.127-131). "
     "Perche' " + c("textbook.price") + " e' ambiguo?" +
     code("""
          ItemToSell
          /        \\
EducationalTool    Book
          \\        /
           TextBook
"""),
     code("""
class ItemToSell {
public:
    double price;
};

class EducationalTool : public ItemToSell {};
class Book            : public ItemToSell {};

class TextBook
    : public EducationalTool,
      public Book {};
""") + "Senza <b>virtual inheritance</b>, " + c("TextBook") + " contiene "
     "<b>DUE subobject</b> " + c("ItemToSell") + ":" +
     code("""
EducationalTool::ItemToSell::price
Book::ItemToSell::price
""") + "quindi " + c("textbook.price") + " <b>non sa a quale delle due si "
     "riferisce</b>: e' ambiguo.")

card("[Generalization][Codice]",
     "Correggi il diamond problem con la <b>virtual inheritance</b>. Che cosa "
     "cambia esattamente?",
     code("""
#include <iostream>

class ItemToSell {
public:
    double price = 0.0;
};

class EducationalTool : virtual public ItemToSell {
};

class Book : virtual public ItemToSell {
};

class TextBook
    : public EducationalTool,
      public Book {
};

int main() {
    TextBook book;
    book.price = 59.90;
    std::cout << book.price << '\\n';
    return 0;
}
""") + "Con " + c("virtual public ItemToSell") + " le <b>due strade "
     "condividono lo STESSO subobject</b> " + c("ItemToSell") + ": non c'e' "
     "piu' duplicazione, quindi " + c("book.price") + " non e' piu' ambiguo.")

card("[Generalization][Teoria]",
     "Vantaggi e svantaggi della <b>multiple inheritance</b> secondo le "
     "slide. Da' un secondo esempio di conflitto.",
     "<b>Vantaggi:</b> modellazione piu' flessibile, maggior riuso.<br>"
     "<b>Svantaggi:</b> ambiguita', implementazione complessa, necessita' di "
     "risoluzione dei conflitti." +
     code("""
Printer                Scanner
+ status()             + status()
        \\             /
      MultiFunctionDevice

device.status();   <- che cosa significa?
""") + "Se <b>entrambe</b> le superclass definiscono " + c("status()") + ", "
     "<b>serve una regola di risoluzione</b>.")

card("[Generalization][Codice][Esame]",
     "Come si <b>evita</b> la multiple inheritance (pp.134-138)? Riscrivi "
     + c("TextBook") + " con <b>composition over inheritance</b>.",
     "Le slide suggeriscono: <b>delegation + aggregation</b>, ereditare "
     "<b>la caratteristica principale</b> e <b>delegare</b> le altre, "
     "modellare le dimensioni diverse <b>separatamente</b>." +
     code("""
#include <string>

class Book {
private:
    std::string isbn_;
public:
    explicit Book(std::string isbn)
        : isbn_(std::move(isbn)) {}
};

class EducationalFeatures {
private:
    std::string subject_;
public:
    explicit EducationalFeatures(std::string subject)
        : subject_(std::move(subject)) {}
};

class TextBook : public Book {
private:
    EducationalFeatures educational_;   // COMPOSIZIONE
public:
    TextBook(std::string isbn, std::string subject)
        : Book(std::move(isbn)),
          educational_(std::move(subject)) {}
};
""") + "Scegliamo <b>una</b> relazione principale (" +
     c("TextBook is-a Book") + ") e modelliamo l'altra dimensione mediante "
     "<b>composizione</b>.")

# =====================================================================
# 9. BUONE PRATICHE E ANTI-PATTERN
# =====================================================================

card("[Design][Esame]",
     "Che cos'e' una <b>heavy class</b> (p.142)? Quali conseguenze ha e come "
     "si corregge?",
     "E' il classico <b>God Object / God Controller</b>: una classe che &laquo;fa "
     "tutto&raquo; mentre le altre contengono soltanto dati (oggetti del "
     "dominio <b>anemici</b>)." +
     code("""
ApplicationController
|-- authenticate()
|-- calculateInvoice()
|-- assignDriver()
|-- sendEmail()
|-- saveCustomer()
|-- calculateTax()
|-- renderPdf()
`-- ...
""") + "<b>Conseguenze:</b> bassa coesione, alto coupling, test difficili, "
     "manutenzione rischiosa, oggetti del dominio anemici.<br><br>"
     "<b>Correzione</b> &mdash; distribuire le responsabilita':" +
     code("""
AuthenticationService
Invoice
TaxCalculator
ShipmentScheduler
NotificationService
CustomerRepository
""") + "Non significa creare una classe per ogni riga: significa collocare "
     "ogni responsabilita' <b>dove e' concettualmente naturale</b>.")

card("[ClassDiagram][Teoria]",
     "Quali consigli danno le slide (pp.139-141) su <b>quando e come</b> "
     "usare un class diagram?",
     "&bull; <b>iniziare semplice</b><br>"
     "&bull; mettere prima le <b>classi e associazioni principali</b><br>"
     "&bull; aggiungere <b>successivamente</b> attributi, multiplicity e "
     "operations<br>"
     "&bull; mostrare <b>solo gli aspetti importanti</b><br>"
     "&bull; preferire <b>pochi diagrammi aggiornati</b> a <b>molti "
     "diagrammi obsoleti</b><br><br>"
     "E ricorda: <b>un diagramma non e' tutto il modello</b>, e' una vista.")

# =====================================================================
# 10. DOMANDE DI VERIFICA SECCHE
# =====================================================================

card("[Ripasso]",
     "In una riga: differenza fra <b>abstraction</b> e <b>information "
     "hiding</b>.",
     "<b>Abstraction</b>: che cosa considero <b>essenziale</b> (il WHAT).<br>"
     "<b>Information hiding</b>: quali <b>dettagli implementativi</b> "
     "nascondo/proteggo (il HOW).")

card("[Ripasso]",
     "In una riga: che cosa significa " + c("Dog is-a Animal") + " e in che "
     "cosa differisce da " + c("Pluto instance-of Dog") + "?",
     "Il primo e' <b>generalization fra CLASSI</b> (" +
     c("Dog subset Animal") + "), il secondo e' <b>instantiation</b>, cioe' "
     "l'<b>appartenenza</b> di un oggetto a una classe (" +
     c("Pluto in Dog") + ").")

card("[Ripasso]",
     "In una riga: qual e' la relazione ideale fra <b>coupling</b> e "
     "<b>cohesion</b>?",
     "<b>HIGH cohesion, LOW coupling.</b><br><br>"
     "Sono assi <b>indipendenti</b>: il " + c("GodController") + " sbaglia "
     "entrambi contemporaneamente.")

card("[Ripasso]",
     "In una riga: dove punta la freccia di " +
     c("<<extend>>") + " e dove quella di " +
     c("<<include>>") + "?",
     code("""
extension  --extend-->   base
including  --include-->  included
""") + "cioe': " + c("extend") + " punta al <b>base</b>, " + c("include") +
     " punta all'<b>incluso</b>.")

card("[Ripasso]",
     "In una riga: quando preferire un <b>sequence diagram</b> a un <b>class "
     "diagram</b>?",
     "Quando devo mostrare <b>che cosa succede nel tempo</b> in uno "
     "<b>scenario</b> (l'ordine dei messaggi fra oggetti), non <b>quali "
     "concetti strutturali esistono</b> e come sono correlati.<br><br>"
     "Sono <b>viste complementari</b>, non concorrenti.")

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
