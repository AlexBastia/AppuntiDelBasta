%{
open Ast

let line () : int =
  (Parsing.symbol_start_pos ()).Lexing.pos_lnum
%}

%token <string> ID
%token <int> INT
%token LPAREN RPAREN COMMA DOT COLON DEFEQ ARROW STAR EOF
%token LAMBDA PI SIGMA TYPE FST SND AXIOM DEF CHECK EVAL

%type <(int * Ast.command) list> prog
%start prog

%%

prog : commands EOF                     { $1 }

commands : /* empty */                  { [] }
    | command commands                  { $1 :: $2 }

/* Each command is paired with the number of the line where it starts. */
command : AXIOM ID COLON exp            { (line (), Axiom($2, $4)) }
    | DEF ID COLON exp DEFEQ exp        { (line (), Def($2, $4, $6)) }
    | CHECK exp                         { (line (), Check $2) }
    | EVAL exp                          { (line (), Eval $2) }

/* lambda, Pi, and Sigma extend as far to the right as possible; -> is
   right associative, and binds more weakly than *, which is right
   associative. lambda x y . e abbreviates lambda x . lambda y . e. */
exp : LAMBDA ids DOT exp                { List.fold_right (fun x e -> Lam(x, e)) $2 $4 }
    | PI LPAREN ID COLON exp RPAREN ARROW exp  { Pi($3, $5, $8) }
    | SIGMA LPAREN ID COLON exp RPAREN STAR exp  { Sigma($3, $5, $8) }
    | prodexp ARROW exp                 { Pi("_", $1, $3) }
    | prodexp                           { $1 }

prodexp : appexp STAR prodexp           { Sigma("_", $1, $3) }
    | appexp                            { $1 }

ids : ID                                { [$1] }
    | ID ids                            { $1 :: $2 }

/* Application is left associative. */
appexp : appexp aexp                    { App($1, $2) }
    | FST aexp                          { Fst($2) }
    | SND aexp                          { Snd($2) }
    | aexp                              { $1 }

aexp : ID                               { Var($1) }
    | TYPE INT                          { Type($2) }
    | LPAREN exp RPAREN                 { $2 }
    | LPAREN exp COMMA exp RPAREN       { Pair($2, $4) }
