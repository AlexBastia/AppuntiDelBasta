(* The entry point: parse a program, and type check and run its commands
   one at a time. *)

open Ast

let usage () =
  print_endline "Usage: pi [--equal=DEFINITION] <file>.pi";
  print_endline "";
  print_endline "Definitions of equality (default: beta):";
  List.iter (fun (name, _) -> Printf.printf "  %s\n" name) Modes.versions;
  exit 2

(* Parse a sequence of commands. *)
let parse (lexbuf : Lexing.lexbuf) : (int * command) list =
  try Parser.prog Lexer.token lexbuf with
  | Parsing.Parse_error ->
    let pos = lexbuf.Lexing.lex_curr_p in
    Printf.printf "Syntax error at line %d\n" pos.Lexing.pos_lnum;
    exit 1
  | Lexer.Error msg ->
    let pos = lexbuf.Lexing.lex_curr_p in
    Printf.printf "Lexing error at line %d: %s\n" pos.Lexing.pos_lnum msg;
    exit 1

(* The signature of built-in constants. *)
let prelude () : signature =
  let cmds = parse (Lexing.from_string Prelude.source) in
  List.fold_left (fun sg (_, cmd) -> Check.command ~quiet:true sg cmd) [] cmds

let has_prefix (p : string) (s : string) : bool =
  String.length s >= String.length p && String.sub s 0 (String.length p) = p

let () =
  let args = List.tl (Array.to_list Sys.argv) in
  List.iter (fun a ->
      if has_prefix "--equal=" a then begin
        let name = String.sub a 8 (String.length a - 8) in
        if not (List.mem_assoc name Modes.versions) then begin
          Printf.printf "Unknown definition of equality: %s\n" name;
          usage ()
        end;
        Modes.current := name
      end) args;
  let files = List.filter (fun a -> not (has_prefix "--" a)) args in
  if List.length files <> 1 then usage ();
  let filename = List.hd files in
  if not (Sys.file_exists filename) then begin
    Printf.printf "No such file: %s\n" filename;
    exit 2
  end;
  let file = open_in filename in
  let cmds = parse (Lexing.from_channel file) in
  close_in file;
  let run (sg : signature) ((line, cmd) : int * command) : signature =
    try Check.command sg cmd with
    | Check.TypeError msg ->
      (* A type error: exit with status 1. *)
      Printf.printf "Type error in the command at line %d: %s\n" line msg;
      exit 1
    | Failure msg ->
      (* Something else went wrong: exit with status 2. *)
      Printf.printf "Error in the command at line %d: %s\n" line msg;
      exit 2
    | Stack_overflow ->
      Printf.printf "Error in the command at line %d: stack overflow\n" line;
      exit 2 in
  ignore (List.fold_left run (prelude ()) cmds)
