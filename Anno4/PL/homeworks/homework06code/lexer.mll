{
open Parser
exception Eof
exception LexingError of string

let newline lexbuf : unit =
  Lexing.new_line lexbuf

let info lexbuf =
  let first = Lexing.lexeme_start_p lexbuf in
  let last = Lexing.lexeme_end_p lexbuf in
  ((first.Lexing.pos_lnum, first.Lexing.pos_cnum - first.Lexing.pos_bol),
   (last.Lexing.pos_lnum, last.Lexing.pos_cnum - last.Lexing.pos_bol - 1))

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
let ws = [' ' '\t' '\012' '\r']

rule token = parse
| ws          { token lexbuf }
| '\n'        { newline lexbuf; token lexbuf }
| "\r\n"      { newline lexbuf; token lexbuf }
| '\r'        { newline lexbuf; token lexbuf }
| "/*"        { comment lexbuf; token lexbuf }
| "+"         { PLUS }
| "-"         { MINUS }
| "*"         { TIMES }
| "|->"       { POINTSTO }
| "_"         { UNDERSCORE }
| "$"         { DOLLAR }
| "@"         { AT }
| "("         { LPAREN }
| ")"         { RPAREN }
| "{"         { LBRACE }
| "}"         { RBRACE }
| ","         { COMMA }
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
| "new"    { NEW }
| "free"      { FREE }
| "lseg"      { LISTSEG }
| "list"      { LIST }
| "true"      { TRUE }
| "false"     { FALSE }
| "not"       { NOT }
| "and"       { AND }
| "or"        { OR }
| "skip"      { SKIP }
| "if"        { IF }
| "then"      { THEN }
| "else"      { ELSE }
| "while"     { WHILE }
| "do"        { DO }
| id as v     { VAR(v) }
| num as n    { INT(int_of_string n) }
| eof         { EOF }
| _ as c      { error lexbuf (Printf.sprintf "unrecognized character %C" c) }

(* C-style comments, which do not nest. *)
and comment = parse
| "*/"        { () }
| '\n'        { newline lexbuf; comment lexbuf }
| "\r\n"      { newline lexbuf; comment lexbuf }
| '\r'        { newline lexbuf; comment lexbuf }
| eof         { error lexbuf "unterminated comment" }
| _           { comment lexbuf }
