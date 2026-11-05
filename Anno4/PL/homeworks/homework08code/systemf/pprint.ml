open Ast

(* Convert types and expressions to strings, with enough parentheses to be
   parsed back in. *)

let rec string_of_typ (t : typ) : string =
  match t with
  | TForall (x, t') -> "forall " ^ x ^ ". " ^ string_of_typ t'
  | _ -> string_of_ftyp t

and string_of_ftyp (t : typ) : string =
  match t with
  | TFun (t1, t2) -> string_of_atyp t1 ^ " -> " ^ string_of_ftyp t2
  | _ -> string_of_atyp t

and string_of_atyp (t : typ) : string =
  match t with
  | TVar x -> x
  | TBase Int -> "Int"
  | TBase Bool -> "Bool"
  | TBase Unit -> "Unit"
  | _ -> "(" ^ string_of_typ t ^ ")"

let string_of_binop (op : binop) : string =
  match op with
  | Plus -> "+"
  | Minus -> "-"
  | Times -> "*"
  | Equal -> "="

let rec string_of_exp (e : exp) : string =
  match e with
  | Lam (x, t, e') -> "lambda " ^ x ^ " : " ^ string_of_typ t ^ ". " ^ string_of_exp e'
  | TypLam (x, e') -> "Lambda " ^ x ^ ". " ^ string_of_exp e'
  | If (e1, e2, e3) ->
    "if " ^ string_of_exp e1 ^ " then " ^ string_of_exp e2 ^ " else " ^ string_of_exp e3
  | Binop (op, e1, e2) ->
    string_of_aexp e1 ^ " " ^ string_of_binop op ^ " " ^ string_of_aexp e2
  | _ -> string_of_appexp e

and string_of_appexp (e : exp) : string =
  match e with
  | App (e1, e2) -> string_of_appexp e1 ^ " " ^ string_of_aexp e2
  | TypApp (e', t) -> string_of_appexp e' ^ " [" ^ string_of_typ t ^ "]"
  | _ -> string_of_aexp e

and string_of_aexp (e : exp) : string =
  match e with
  | Var x -> x
  | Int n -> string_of_int n
  | Bool b -> string_of_bool b
  | Unit -> "()"
  | _ -> "(" ^ string_of_exp e ^ ")"
