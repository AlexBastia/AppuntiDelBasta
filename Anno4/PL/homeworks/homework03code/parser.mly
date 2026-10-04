%{
open Ast
open Printf
open Lexing

let merge (fn,pos1,_) (_,_,pos2) = (fn,pos1,pos2)
%}

%token <Ast.info * int> INT
%token <Ast.info * string> VAR
%token <Ast.info> PLUS MINUS TIMES
  LPAREN RPAREN TRUE FALSE
  EQUALS NOTEQUALS LESS LESSEQ GREATER GREATEREQ
  NOT AND OR
  SKIP ASSIGN SEMI IF THEN ELSE WHILE DO
  LBRACE RBRACE
  BREAK CONTINUE TEST INPUT PRINT
%token EOF

%type <Ast.aexp> a
%type <Ast.bexp> b
%type <Ast.com> c
%type <Ast.com> p

%start p

%%

/* Arithmetic Expressions */
a : a PLUS ta             { Plus($1, $3) }
  | a MINUS ta            { Minus($1, $3) }
  | ta                    { $1 }

ta : ta TIMES aa          { Times($1, $3) }
   | aa                   { $1 }

aa : INT                  { Int(snd $1) }
   | VAR                  { Var(snd $1) }
   | LPAREN a RPAREN      { $2 }
   | INPUT                { Input }

/* Boolean Expressions */
b : a EQUALS a            { Equals($1, $3) }
  | a NOTEQUALS a         { NotEquals ($1, $3) }
  | a LESS a              { Less($1, $3) }
  | a LESSEQ a            { LessEq($1, $3) }
  | a GREATER a           { Greater($1, $3) }
  | a GREATEREQ a         { GreaterEq($1, $3) }
  | db                    { $1 }

db: db OR cb              { Or($1, $3) }
  | cb                    { $1 }

cb: cb AND nb             { And($1, $3) }
  | nb                    { $1 }

nb: NOT ab                { Not($2) }
  | ab                    { $1 }

ab : TRUE                 { True }
   | FALSE                { False }
   | LPAREN b RPAREN      { $2 }

/* Commands */
c : ic SEMI c             { Seq($1, $3) }
  | ic                    { $1 }

ic: IF b THEN ac ELSE ac  { If($2, $4, $6) }
  | WHILE b DO ac         { While($2, $4) }
  | ac                    { $1 }

ac: SKIP                  { Skip }
  | VAR ASSIGN a          { Assign(snd $1, $3) }
  | LBRACE c RBRACE       { $2 }
  | PRINT a               { Print $2 }
  | TEST b                { Test($1, $2) }
  | BREAK                 { Break }
  | CONTINUE              { Continue }

/* Programs */
p : c EOF                 { $1 }
