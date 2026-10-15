type token =
  | INT of (
# 5 "parser.mly"
        int
# 6 "parser.mli"
)
  | VAR of (
# 6 "parser.mly"
        string
# 11 "parser.mli"
)
  | TEST of (
# 7 "parser.mly"
        Ast.info
# 16 "parser.mli"
)
  | PLUS
  | MINUS
  | TIMES
  | EOF
  | LPAREN
  | RPAREN
  | TRUE
  | FALSE
  | EQUALS
  | NOTEQUALS
  | LESS
  | LESSEQ
  | GREATER
  | GREATEREQ
  | FORALL
  | EXISTS
  | NOT
  | AND
  | OR
  | IMPLIES
  | DOLLAR
  | SKIP
  | ASSIGN
  | PRINT
  | SEMI
  | IF
  | THEN
  | ELSE
  | WHILE
  | DO
  | LBRACE
  | RBRACE
  | AT

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.assn * Ast.com * Ast.assn
