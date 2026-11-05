(* Abstract syntax for a small ML-like language without type annotations,
   except for optional type ascriptions. *)

type typ =
  | TVar of string            (* type variables, such as 'a *)
  | TInt                      (* int *)
  | TBool                     (* bool *)
  | TUnit                     (* unit *)
  | TFun of typ * typ         (* t1 -> t2 *)

type binop =
  | Plus
  | Minus
  | Times
  | Equal

type exp =
  | Var of string                   (* x *)
  | Fun of string * exp             (* fun x -> e *)
  | App of exp * exp                (* e1 e2 *)
  | Let of string * exp * exp       (* let x = e1 in e2 *)
  | Int of int                      (* n *)
  | Bool of bool                    (* true, false *)
  | Unit                            (* () *)
  | Binop of binop * exp * exp      (* e1 + e2, e1 - e2, e1 * e2, e1 = e2 *)
  | If of exp * exp * exp           (* if e1 then e2 else e3 *)
  | Annot of exp * typ              (* (e : t) *)
