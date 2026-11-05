open Ast

(* Convert a type to a string, OCaml style. Type variables are renamed to
   'a, 'b, 'c, ... in order of their first appearance, so that inferred types
   are easy to read: for example, _3 -> _3 is printed as 'a -> 'a. *)

let rec vars_in_order (t : typ) (acc : string list) : string list =
  match t with
  | TVar x -> if List.mem x acc then acc else acc @ [x]
  | TInt | TBool | TUnit -> acc
  | TFun (t1, t2) -> vars_in_order t2 (vars_in_order t1 acc)

let pretty_name (i : int) : string =
  let letter = String.make 1 (Char.chr (Char.code 'a' + i mod 26)) in
  if i < 26 then "'" ^ letter else "'" ^ letter ^ string_of_int (i / 26)

let string_of_typ (t : typ) : string =
  let names = List.mapi (fun i x -> (x, pretty_name i)) (vars_in_order t []) in
  let rec loop (t : typ) : string =
    match t with
    | TFun (t1, t2) -> atom t1 ^ " -> " ^ loop t2
    | _ -> atom t
  and atom (t : typ) : string =
    match t with
    | TVar x -> List.assoc x names
    | TInt -> "int"
    | TBool -> "bool"
    | TUnit -> "unit"
    | TFun _ -> "(" ^ loop t ^ ")" in
  loop t
