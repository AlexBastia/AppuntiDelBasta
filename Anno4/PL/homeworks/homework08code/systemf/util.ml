open Ast

(* Get a list of all free *type* variables in a given type. *)
let rec fv_typ (t : typ) : string list =
  match t with
  | TVar v -> [v]
  | TFun (t1, t2) -> fv_typ t1 @ fv_typ t2
  | TForall (v, t') -> List.filter (fun s -> s <> v) (fv_typ t')
  | TBase _ -> []

(* Get a list of all free (term) variables in an expression. *)
let rec fv_exp (e : exp) : string list =
  match e with
  | Var x -> [x]
  | App (e1, e2) -> fv_exp e1 @ fv_exp e2
  | Lam (y, _, e') -> List.filter (fun s -> s <> y) (fv_exp e')
  | TypLam (_, e') -> fv_exp e'
  | TypApp (e', _) -> fv_exp e'
  | Int _ | Bool _ | Unit -> []
  | Binop (_, e1, e2) -> fv_exp e1 @ fv_exp e2
  | If (e1, e2, e3) -> fv_exp e1 @ fv_exp e2 @ fv_exp e3

(* Get a list of all free *type* variables in an expression. *)
let rec ftv_exp (e : exp) : string list =
  match e with
  | Var _ -> []
  | App (e1, e2) -> ftv_exp e1 @ ftv_exp e2
  | Lam (_, t, e') -> fv_typ t @ ftv_exp e'
  | TypLam (x, e') -> List.filter (fun s -> s <> x) (ftv_exp e')
  | TypApp (e', t) -> ftv_exp e' @ fv_typ t
  | Int _ | Bool _ | Unit -> []
  | Binop (_, e1, e2) -> ftv_exp e1 @ ftv_exp e2
  | If (e1, e2, e3) -> ftv_exp e1 @ ftv_exp e2 @ ftv_exp e3

(* Generate a variable name that does not occur in `avoid`, based on `base`:
   it is `base` itself if that is not in `avoid`, and otherwise `base`
   followed by a number. *)
let fresh (avoid : string list) (base : string) : string =
  let rec loop (index : int) =
    let var = base ^ string_of_int index in
    if List.mem var avoid then loop (index + 1) else var in
  if List.mem base avoid then loop 1 else base

(* Generate a fresh (term) variable name that does not occur in `avoid`. *)
let fresh_var (avoid : string list) : string =
  fresh avoid "x"

(* Generate a fresh type variable name that does not occur in `avoid`. *)
let fresh_tvar (avoid : string list) : string =
  fresh avoid "T"
