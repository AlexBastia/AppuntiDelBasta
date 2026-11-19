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
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']*
let ws = [' ' '\t' '\r']

rule token = parse
| ws        { token lexbuf }
| '\n'      { incline lexbuf; token lexbuf }
| "(*"      { comment lexbuf; token lexbuf }
| "("       { LPAREN }
| ")"       { RPAREN }
| ","       { COMMA }
| "."       { DOT }
| ":="      { DEFEQ }
| ":"       { COLON }
| "->"      { ARROW }
| "*"       { STAR }
| "lambda"  { LAMBDA }
| "Pi"      { PI }
| "Sigma"   { SIGMA }
| "fst"     { FST }
| "snd"     { SND }
| "Type"    { TYPE }
| "axiom"   { AXIOM }
| "def"     { DEF }
| "check"   { CHECK }
| "eval"    { EVAL }
| id as v   { ID(v) }
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
