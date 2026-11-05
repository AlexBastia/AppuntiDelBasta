%{
open Ast
%}

%token <string> VAR TYPVAR
%token <int> INT
%token <bool> BOOL
%token LPAREN RPAREN LBRACK RBRACK DOT COLON ARROW EOF
%token LAMBDA BIGLAMBDA FORALL IF THEN ELSE
%token PLUS MINUS TIMES EQUALS
%token TINT TBOOL TUNIT

%type <Ast.exp> prog
%start prog

%%

prog : exp EOF                          { $1 }

/* Abstractions and conditionals extend as far to the right as possible. */
exp : LAMBDA VAR COLON typ DOT exp      { Lam($2, $4, $6) }
    | BIGLAMBDA TYPVAR DOT exp          { TypLam($2, $4) }
    | IF exp THEN exp ELSE exp          { If($2, $4, $6) }
    | cmpexp                            { $1 }

cmpexp : arith EQUALS arith             { Binop(Equal, $1, $3) }
    | arith                             { $1 }

arith : arith PLUS term                 { Binop(Plus, $1, $3) }
    | arith MINUS term                  { Binop(Minus, $1, $3) }
    | term                              { $1 }

term : term TIMES appexp                { Binop(Times, $1, $3) }
    | appexp                            { $1 }

/* Application and type application are left associative. */
appexp : appexp aexp                    { App($1, $2) }
    | appexp LBRACK typ RBRACK          { TypApp($1, $3) }
    | aexp                              { $1 }

aexp : VAR                              { Var($1) }
    | INT                               { Int($1) }
    | BOOL                              { Bool($1) }
    | LPAREN RPAREN                     { Unit }
    | LPAREN exp RPAREN                 { $2 }

/* forall extends as far to the right as possible, and -> is right
   associative. */
typ : FORALL TYPVAR DOT typ             { TForall($2, $4) }
    | ftyp                              { $1 }

ftyp : atyp ARROW ftyp                  { TFun($1, $3) }
    | atyp                              { $1 }

atyp : TYPVAR                           { TVar($1) }
    | TINT                              { TBase(Int) }
    | TBOOL                             { TBase(Bool) }
    | TUNIT                             { TBase(Unit) }
    | LPAREN typ RPAREN                 { $2 }
