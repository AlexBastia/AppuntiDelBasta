(* The entry point: System F programs (.f files) are type checked and
   evaluated, and ML programs (.hm files) have their types inferred. *)

let usage () =
  print_endline "Usage: poly <file>.f    (type check and evaluate a System F program)";
  print_endline "       poly <file>.hm   (infer the type of an ML program)";
  exit 2

let () =
  if Array.length Sys.argv <> 2 then usage ();
  let filename = Sys.argv.(1) in
  if not (Sys.file_exists filename) then begin
    Printf.printf "No such file: %s\n" filename;
    exit 2
  end;
  match Filename.extension filename with
  | ".f" -> Systemf.Run.run filename
  | ".hm" -> Inference.Run.run filename
  | _ -> usage ()
