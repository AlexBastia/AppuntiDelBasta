(* Parse a program and infer its type. *)

let run (filename : string) : unit =
  let file = open_in filename in
  let lexbuf = Lexing.from_channel file in
  let e =
    try Parser.prog Lexer.token lexbuf with
    | Parsing.Parse_error ->
      let pos = lexbuf.Lexing.lex_curr_p in
      Printf.printf "Syntax error at line %d\n" pos.Lexing.pos_lnum;
      exit 1
    | Lexer.Error msg ->
      let pos = lexbuf.Lexing.lex_curr_p in
      Printf.printf "Lexing error at line %d: %s\n" pos.Lexing.pos_lnum msg;
      exit 1 in
  close_in file;
  let t =
    try Infer.infer e with
    | Types.TypeError msg ->
      Printf.printf "Type error: %s\n" msg;
      exit 1 in
  Printf.printf "Type: %s\n" (Pprint.string_of_typ t)
