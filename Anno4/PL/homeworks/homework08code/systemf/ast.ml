(* Abstract syntax for System F with unit, integers, Booleans, and conditionals. *)

type base =
  | Int
  | Bool
  | Unit

type typ =
  | TVar of string            (* X *)
  | TFun of typ * typ         (* t1 -> t2 *)
  | TForall of string * typ   (* forall X . t *)
  | TBase of base             (* Int, Bool, Unit *)

type binop =
  | Plus
  | Minus
  | Times
  | Equal

type exp =
  | Var of string                 (* x *)
  | App of exp * exp              (* e1 e2 *)
  | Lam of string * typ * exp     (* lambda x : t . e *)
  | TypLam of string * exp        (* Lambda X . e *)
  | TypApp of exp * typ           (* e [t] *)
  | Int of int                    (* n *)
  | Bool of bool                  (* true, false *)
  | Unit                          (* () *)
  | Binop of binop * exp * exp    (* e1 + e2, e1 - e2, e1 * e2, e1 = e2 *)
  | If of exp * exp * exp         (* if e1 then e2 else e3 *)
