{
open Parser
open Printf
exception Eof
exception LexingError of string

let lineno = ref 1
let linestart = ref (-1)

let newline lexbuf : unit =
  linestart := Lexing.lexeme_start lexbuf;
  incr lineno

let info lexbuf =
  let c1 = Lexing.lexeme_start lexbuf in
  let c2 = Lexing.lexeme_end lexbuf in
  let l = !lineno in
  let c = !linestart + 1 in
    ((l, c1 - c),(l, c2 - c - 1))

let error lexbuf msg =
  let i = info lexbuf in
  let t = Lexing.lexeme lexbuf in
  let ((l1,c1),(l2,c2)) = i in
  let s =
    if l2=l1
    then Printf.sprintf "line %d, characters %d-%d" l1 c1 c2
    else Printf.sprintf "line %d, character %d, to line %d, character %d" l1 c1 l2 c2 in
  let err = Printf.sprintf "%s: lexing error %s at %s."
    s
    msg
    t in
  raise (LexingError err)
}

let num = ['-']?['0'-'9']+
let id = ['a'-'z'] ['a'-'z' '0'-'9']*
let ws = [' ' '\t']

rule token = parse
| ws      { token lexbuf }
| '\n'    { newline lexbuf; token lexbuf }
| "+"     { PLUS(info lexbuf) }
| "-"     { MINUS(info lexbuf) }
| "*"     { TIMES(info lexbuf) }
| "("     { LPAREN(info lexbuf) }
| ")"     { RPAREN(info lexbuf) }
| "{"     { LBRACE(info lexbuf) }
| "}"     { RBRACE(info lexbuf) }
| "="     { EQUALS(info lexbuf) }
| "!="    { NOTEQUALS(info lexbuf) }
| "<"     { LESS(info lexbuf) }
| "<="    { LESSEQ(info lexbuf) }
| ">"     { GREATER(info lexbuf) }
| ">="    { GREATEREQ(info lexbuf) }
| ":="    { ASSIGN(info lexbuf) }
| ";"     { SEMI(info lexbuf) }
| "true"  { TRUE(info lexbuf) }
| "false" { FALSE(info lexbuf) }
| "not"   { NOT(info lexbuf) }
| "and"   { AND(info lexbuf) }
| "or"    { OR(info lexbuf) }
| "skip"  { SKIP(info lexbuf) }
| "break" { BREAK(info lexbuf) }
| "continue" { CONTINUE(info lexbuf) }
| "if"    { IF(info lexbuf) }
| "then"  { THEN(info lexbuf) }
| "else"  { ELSE(info lexbuf) }
| "while" { WHILE(info lexbuf) }
| "do"    { DO(info lexbuf) }
| "test"  { TEST(info lexbuf) }
| "input" { INPUT(info lexbuf) }
| "print" { PRINT(info lexbuf) }
| id as v { VAR(info lexbuf, v) }
| num as n { INT(info lexbuf, int_of_string n) }
| eof     { EOF }
| _ as c  { error lexbuf (String.make 1 c) }
