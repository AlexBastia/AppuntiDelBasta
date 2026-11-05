(* Capture-avoiding substitution for System F. These functions are
   provided: you do not need to modify this file. *)

open Ast
open Util

(* Capture-avoiding substitution of an expression for a variable: e{v/x}. *)
let rec subst_exp (e : exp) (x : string) (v : exp) : exp =
  match e with
  | Var y -> if x = y then v else e
  | App (e1, e2) -> App (subst_exp e1 x v, subst_exp e2 x v)
  | Lam (y, t, e') ->
    if x = y then e
    else if List.mem y (fv_exp v) then
      let y' = fresh_var (fv_exp e' @ fv_exp v @ [x]) in
      Lam (y', t, subst_exp (subst_exp e' y (Var y')) x v)
    else
      Lam (y, t, subst_exp e' x v)
  | TypLam (y, e') -> TypLam (y, subst_exp e' x v)
  | TypApp (e', t) -> TypApp (subst_exp e' x v, t)
  | Int _ | Bool _ | Unit -> e
  | Binop (op, e1, e2) -> Binop (op, subst_exp e1 x v, subst_exp e2 x v)
  | If (e1, e2, e3) -> If (subst_exp e1 x v, subst_exp e2 x v, subst_exp e3 x v)

(* Capture-avoiding substitution of a type for a type variable: t{t2/X}. *)
let rec subst_typ (t : typ) (x : string) (t2 : typ) : typ =
  match t with
  | TVar y -> if x = y then t2 else t
  | TFun (t', t'') -> TFun (subst_typ t' x t2, subst_typ t'' x t2)
  | TForall (y, t') ->
    if x = y then t
    else if List.mem y (fv_typ t2) then
      let y' = fresh_tvar (fv_typ t' @ fv_typ t2 @ [x]) in
      TForall (y', subst_typ (subst_typ t' y (TVar y')) x t2)
    else
      TForall (y, subst_typ t' x t2)
  | TBase _ -> t

(* Capture-avoiding substitution of a type for a type variable in an
   expression: e{t/X}. *)
let rec subst_typ_in_exp (e : exp) (x : string) (t : typ) : exp =
  match e with
  | Var _ -> e
  | App (e1, e2) -> App (subst_typ_in_exp e1 x t, subst_typ_in_exp e2 x t)
  | Lam (y, t', e') -> Lam (y, subst_typ t' x t, subst_typ_in_exp e' x t)
  | TypLam (y, e') ->
    if x = y then e
    else if List.mem y (fv_typ t) then
      let y' = fresh_tvar (ftv_exp e' @ fv_typ t @ [x]) in
      TypLam (y', subst_typ_in_exp (subst_typ_in_exp e' y (TVar y')) x t)
    else
      TypLam (y, subst_typ_in_exp e' x t)
  | TypApp (e', t') -> TypApp (subst_typ_in_exp e' x t, subst_typ t' x t)
  | Int _ | Bool _ | Unit -> e
  | Binop (op, e1, e2) -> Binop (op, subst_typ_in_exp e1 x t, subst_typ_in_exp e2 x t)
  | If (e1, e2, e3) ->
    If (subst_typ_in_exp e1 x t, subst_typ_in_exp e2 x t, subst_typ_in_exp e3 x t)
