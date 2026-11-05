%{
open Ast

(* fun x1 ... xn -> e  means  fun x1 -> ... fun xn -> e *)
let funs (xs : string list) (e : exp) : exp =
  List.fold_right (fun x e -> Fun (x, e)) xs e
%}

%token <string> VAR TYVAR
%token <int> INT
%token <bool> BOOL
%token LPAREN RPAREN COLON ARROW EOF
%token FUN LET IN IF THEN ELSE
%token PLUS MINUS TIMES EQUALS
%token TINT TBOOL TUNIT

%type <Ast.exp> prog
%start prog

%%

prog : exp EOF                              { $1 }

/* Functions, lets, and conditionals extend as far to the right as possible.
   As in OCaml, "let f x y = e1 in e2" means "let f = fun x y -> e1 in e2". */
exp : FUN vars ARROW exp                    { funs $2 $4 }
    | LET VAR vars0 EQUALS exp IN exp       { Let ($2, funs $3 $5, $7) }
    | IF exp THEN exp ELSE exp              { If ($2, $4, $6) }
    | cmpexp                                { $1 }

vars : VAR vars0                            { $1 :: $2 }

vars0 :                                     { [] }
    | VAR vars0                             { $1 :: $2 }

cmpexp : arith EQUALS arith                 { Binop (Equal, $1, $3) }
    | arith                                 { $1 }

arith : arith PLUS term                     { Binop (Plus, $1, $3) }
    | arith MINUS term                      { Binop (Minus, $1, $3) }
    | term                                  { $1 }

term : term TIMES appexp                    { Binop (Times, $1, $3) }
    | appexp                                { $1 }

appexp : appexp aexp                        { App ($1, $2) }
    | aexp                                  { $1 }

aexp : VAR                                  { Var $1 }
    | INT                                   { Int $1 }
    | BOOL                                  { Bool $1 }
    | LPAREN RPAREN                         { Unit }
    | LPAREN exp RPAREN                     { $2 }
    | LPAREN exp COLON typ RPAREN           { Annot ($2, $4) }

/* -> is right associative. */
typ : atyp ARROW typ                        { TFun ($1, $3) }
    | atyp                                  { $1 }

atyp : TYVAR                                { TVar $1 }
    | TINT                                  { TInt }
    | TBOOL                                 { TBool }
    | TUNIT                                 { TUnit }
    | LPAREN typ RPAREN                     { $2 }
