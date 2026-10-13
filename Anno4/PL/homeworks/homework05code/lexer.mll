{
open Parser
open Printf
exception Eof
exception LexingError of string

let lineno = ref 1
let linestart = ref (-1)

let newline lexbuf : unit =
  Lexing.new_line lexbuf;
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

let num = ['0'-'9']+
let id = ['a'-'z'] ['a'-'z' '0'-'9']*
let ws = [' ' '\t']

rule token = parse
| ws          { token lexbuf }
| '\n'        { newline lexbuf; token lexbuf }
| "+"         { PLUS }
| "-"         { MINUS }
| "*"         { TIMES }
| "$"         { DOLLAR }
| "@"         { AT }
| "("         { LPAREN }
| ")"         { RPAREN }
| "{"         { LBRACE }
| "}"         { RBRACE }
| "="         { EQUALS }
| "!="        { NOTEQUALS }
| "<"         { LESS }
| "<="        { LESSEQ }
| ">"         { GREATER }
| ">="        { GREATEREQ }
| ":="        { ASSIGN }
| ";"         { SEMI }
| "print"     { PRINT }
| "test"      { TEST(info lexbuf) }
| "implies"   { IMPLIES }
| "true"      { TRUE }
| "false"     { FALSE }
| "not"       { NOT }
| "and"       { AND }
| "or"        { OR }
| "forall"    { FORALL}
| "exists"    { EXISTS }
| "skip"      { SKIP }
| "if"        { IF }
| "then"      { THEN }
| "else"      { ELSE }
| "while"     { WHILE }
| "do"        { DO }
| id as v     { VAR(v) }
| num as n    { INT(int_of_string n) }
| eof         { EOF }
| _ as c  { let pos = lexbuf.Lexing.lex_curr_p in
            printf "Error at line %d\n" pos.Lexing.pos_lnum;
            printf "Unrecognized character: [%c]\n" c;
            exit 1 }
