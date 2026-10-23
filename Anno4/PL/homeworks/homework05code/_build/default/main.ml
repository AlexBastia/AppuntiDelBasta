open Printf

(* ----- Command-line Argument Parsing ----- *)
let filename = ref ""
let debug = ref false
let run = ref false
let verify = ref false

let usage_msg = "Usage: imp [options] file"

let options =
  [ "-debug", Arg.Unit (fun _ -> debug := true), "Enable debugging";
    "-run", Arg.Unit (fun _ -> run := true), "Run the interpreter";
    "-verify", Arg.Unit (fun _ -> verify := true), "Run the verifier" ]

let set_filename f =
  if !filename = "" then
    filename := f
  else
    Arg.usage options usage_msg

let () =
  begin
    Arg.parse options set_filename usage_msg;
    if !filename = "" then (Arg.usage options usage_msg; exit 2);
    let file = open_in !filename in
    let lexbuf = Lexing.from_channel file in
    let pre,command,post =
      try Parser.program Lexer.token lexbuf
      with Parsing.Parse_error ->
        let pos = lexbuf.Lexing.lex_curr_p in
        printf "Syntax error at line %d\n"
          pos.Lexing.pos_lnum;
        exit 1 in
    if !debug then
      Printf.eprintf "Program:\n\n%s\n%s\n%s\n%!"
        (Pprint.strSpec pre)
        (Pprint.strCom (0,command))
        (Pprint.strSpec post);
    if !run then
      begin
        try ignore (Eval.evalc (Eval.make_configuration command)) with
        | Eval.UnboundVariable x ->
          printf "Runtime error: variable %s is not initialized\n" x;
          exit 1
        | Eval.TestFailure i ->
          printf "Runtime error: test failed at %s\n" i;
          exit 1
      end;
    if !verify then
      begin
        let assns = Vcgen.genc (pre,command,post) in
        if !debug then
          Printf.eprintf "Verification conditions:\n\n";
        let ok =
          List.fold_left
            (fun ok assn ->
              let vo = Solve.valid assn in
              if !debug then Printf.eprintf "%s\nSMT-LIB: %s\nValid = %s\n\n%!"
                (Pprint.strAssn assn)
                (Solve.smtlib_of_assn assn)
                (match vo with None -> "?" | Some b -> string_of_bool b);
              (match vo with Some true -> ok | _ -> false))
            true assns in
        if ok then
          begin
            Printf.printf "Verified\n";
            exit 0;
          end
        else
          begin
            Printf.printf "Not verified\n";
            exit 1;
          end
      end;
    exit 0
  end
