{
open Parser

exception Error of string

let incline lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <- { pos with
    Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
    Lexing.pos_bol = pos.Lexing.pos_cnum;
  }
}

let num = ['0'-'9']+
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let bigid = ['A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let ws = [' ' '\t' '\r']

rule token = parse
| ws        { token lexbuf }
| '\n'      { incline lexbuf; token lexbuf }
| "(*"      { comment lexbuf; token lexbuf }
| "("       { LPAREN }
| ")"       { RPAREN }
| "["       { LBRACK }
| "]"       { RBRACK }
| "."       { DOT }
| ":"       { COLON }
| "->"      { ARROW }
| "+"       { PLUS }
| "-"       { MINUS }
| "*"       { TIMES }
| "="       { EQUALS }
| "forall"  { FORALL }
| "lambda"  { LAMBDA }
| "Lambda"  { BIGLAMBDA }
| "if"      { IF }
| "then"    { THEN }
| "else"    { ELSE }
| "true"    { BOOL(true) }
| "false"   { BOOL(false) }
| "Int"     { TINT }
| "Bool"    { TBOOL }
| "Unit"    { TUNIT }
| id as v   { VAR(v) }
| bigid as v { TYPVAR(v) }
| num as n  { INT(int_of_string n) }
| eof       { EOF }
| _ as c    { raise (Error (Printf.sprintf "unrecognized character '%c'" c)) }

(* Comments, which may be nested, as in OCaml. *)
and comment = parse
| "*)"      { () }
| "(*"      { comment lexbuf; comment lexbuf }
| '\n'      { incline lexbuf; comment lexbuf }
| eof       { raise (Error "unterminated comment") }
| _         { comment lexbuf }
