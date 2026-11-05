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
let id = ['a'-'z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']*
let ws = [' ' '\t' '\r']

rule token = parse
| ws        { token lexbuf }
| '\n'      { incline lexbuf; token lexbuf }
| "(*"      { comment lexbuf; token lexbuf }
| "("       { LPAREN }
| ")"       { RPAREN }
| ":"       { COLON }
| "->"      { ARROW }
| "+"       { PLUS }
| "-"       { MINUS }
| "*"       { TIMES }
| "="       { EQUALS }
| "fun"     { FUN }
| "let"     { LET }
| "in"      { IN }
| "if"      { IF }
| "then"    { THEN }
| "else"    { ELSE }
| "true"    { BOOL(true) }
| "false"   { BOOL(false) }
| "int"     { TINT }
| "bool"    { TBOOL }
| "unit"    { TUNIT }
| '\'' (id as v) { TYVAR("'" ^ v) }
| id as v   { VAR(v) }
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
