%{
open Ast
%}

%token <int> INT
%token <string> VAR
%token <Ast.info> TEST
%token PLUS MINUS TIMES EOF
  LPAREN RPAREN TRUE FALSE EQUALS NOTEQUALS LESS LESSEQ GREATER GREATEREQ
  FORALL EXISTS NOT AND OR IMPLIES DOLLAR
  SKIP ASSIGN PRINT SEMI IF THEN ELSE WHILE DO LBRACE RBRACE AT

%type <com> com
%type <aexp> aexp
%type <bexp> bexp
%type <Ast.assn * Ast.com * Ast.assn> program

%start program

%%

/* Arithmetic Expressions */
aexp : aexp PLUS taexp                   { Plus($1, $3) }
  | aexp MINUS taexp                     { Minus($1, $3) }
  | taexp                                { $1 }

taexp : taexp TIMES aaexp                { Times($1, $3) }
  | aaexp                                { $1 }

aaexp : INT                              { Int($1) }
  | MINUS INT                            { Int(-$2) }
  | VAR                                  { Var($1) }
  | LPAREN aexp RPAREN                   { $2 }

/* Logical Expressions */
lexp: lexp PLUS tlexp                    { LPlus($1,$3) }
  | lexp MINUS tlexp                     { LMinus($1,$3) }
  | tlexp                                { $1 }

tlexp: tlexp TIMES alexp                 { LTimes($1,$3) }
  | alexp                                { $1 }

alexp :
  | INT                                  { LInt($1) }
  | MINUS INT                            { LInt(-$2) }
  | VAR                                  { LPVar($1) }
  | DOLLAR VAR                           { LLVar($2) }
  | LPAREN lexp RPAREN                   { $2 }

/* Boolean Expressions */
bexp: bexp OR cbexp                      { Or($1, $3) }
  | cbexp                                { $1 }

cbexp: cbexp AND nbexp                   { And($1, $3) }
  | nbexp                                { $1 }

nbexp: NOT abexp                         { Not($2) }
  | abexp                                { $1 }

abexp : TRUE                             { True }
   | FALSE                               { False }
   | aexp EQUALS aexp                    { Equals($1, $3) }
   | aexp NOTEQUALS aexp                 { NotEquals($1, $3) }
   | aexp LESS aexp                      { Less($1, $3) }
   | aexp LESSEQ aexp                    { LessEq($1, $3) }
   | aexp GREATER aexp                   { Greater($1, $3) }
   | aexp GREATEREQ aexp                 { GreaterEq($1, $3) }
   | LPAREN bexp RPAREN                  { $2 }

/* Commands */
com : com SEMI spec icom                 { Seq($1,Some $3,$4) }
  | com SEMI icom                        { Seq($1,None,$3) }
  | icom                                 { $1 }

icom: IF bexp THEN acom ELSE acom        { If($2,$4,$6) }
  | WHILE bexp DO spec acom              { While($2,$4,$5) }
  | acom                                 { $1 }

acom: SKIP                               { Skip }
  | VAR ASSIGN aexp                      { Assign($1,$3) }
  | PRINT aexp                           { Print($2) }
  | TEST bexp                            { Test($1,$2) }
  | LBRACE com RBRACE                    { $2 }

spec : AT assn AT                        { $2 }

assn: dassn IMPLIES assn                 { AImplies($1,$3) }
  | dassn                                { $1 }

dassn: dassn OR cassn                    { AOr($1,$3) }
  | cassn                                { $1 }

cassn: cassn AND nassn                   { AAnd($1,$3) }
  | nassn                                { $1 }

nassn: NOT aassn                         { ANot($2) }
  | aassn                                { $1 }

aassn: TRUE                              { ATrue }
  | FALSE                                { AFalse }
  | lexp EQUALS lexp                     { AEquals($1,$3) }
  | lexp NOTEQUALS lexp                  { ANotEquals($1,$3) }
  | lexp LESS lexp                       { ALess($1,$3) }
  | lexp LESSEQ lexp                     { ALessEq($1,$3) }
  | lexp GREATER lexp                    { AGreater($1,$3) }
  | lexp GREATEREQ lexp                  { AGreaterEq($1,$3) }
  | FORALL DOLLAR VAR LPAREN assn RPAREN { AForall($3,$5) }
  | EXISTS DOLLAR VAR LPAREN assn RPAREN { AExists($3,$5) }
  | LPAREN assn RPAREN                   { $2 }

program : spec com spec EOF { ($1,$2,$3) }
