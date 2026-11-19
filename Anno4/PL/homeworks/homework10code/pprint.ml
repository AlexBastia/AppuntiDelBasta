open Ast

(* Pretty print an expression, using the same concrete syntax as the
   parser. *)
let rec string_of_exp (e : exp) : string =
  match e with
  | Lam (x, b) -> Printf.sprintf "lambda %s. %s" x (string_of_exp b)
  | Pi (x, a, b) when List.mem x (Util.fv b) ->
    Printf.sprintf "Pi (%s : %s) -> %s" x (string_of_exp a) (string_of_exp b)
  | Pi (_, a, b) ->
    Printf.sprintf "%s -> %s" (string_of_prod a) (string_of_exp b)
  | Sigma (x, a, b) when List.mem x (Util.fv b) ->
    Printf.sprintf "Sigma (%s : %s) * %s" x (string_of_exp a) (string_of_exp b)
  | _ -> string_of_prod e

and string_of_prod (e : exp) : string =
  match e with
  | Sigma (x, a, b) when not (List.mem x (Util.fv b)) ->
    Printf.sprintf "%s * %s" (string_of_app a) (string_of_prod b)
  | _ -> string_of_app e

and string_of_app (e : exp) : string =
  match e with
  | Type i -> Printf.sprintf "Type %d" i
  | App (e1, e2) -> string_of_app e1 ^ " " ^ string_of_atom e2
  | Fst e1 -> "fst " ^ string_of_atom e1
  | Snd e1 -> "snd " ^ string_of_atom e1
  | _ -> string_of_atom e

and string_of_atom (e : exp) : string =
  match e with
  | Var x | Const x -> x
  | Pair (a, b) -> Printf.sprintf "(%s, %s)" (string_of_exp a) (string_of_exp b)
  | _ -> "(" ^ string_of_exp e ^ ")"
