open Ast
open Types

(* ---------- Unification ---------- *)

(* Compute a most general substitution that satisfies all of the
   constraints in c, or raise TypeError if there is none. Don't forget the
   occurs check! *)
let rec unify (c : constraints) : subst =
  match c with
  | [] -> []
  | (t1, t2)::cs ->
      (match (t1, t2) with
      | TUnit, TUnit | TInt, TInt | TBool, TBool -> unify cs
      | TVar x, _ ->
          if occurs x t2 then raise (TypeError "Failed occurs check")
          else compose (unify (apply_constraints ((x, t2)::[]) cs)) ((x, t2)::[])
      | _, TVar x ->
          if occurs x t1 then raise (TypeError "Failed occurs check")
          else compose (unify (apply_constraints ((x, t1)::[]) cs)) ((x, t1)::[])
      | TFun(l1, r1), TFun(l2, r2) -> unify ((l1,l2)::(r1,r2)::cs)
      | _ -> raise (TypeError "Impossible to unify constraint")
      )

(* ---------- Type schemes ---------- *)

(* Instantiate a type scheme, replacing its quantified type variables with
   fresh type variables. *)
let instantiate (s : scheme) : typ =
  match s with
  | Forall ([], t) -> t
  | Forall (x::xs, t) ->
      apply ((x, fresh_tvar ())::[]) t

(* Generalize a type t over all of the type variables that are free in t but
   not free in env. *)
let generalize (env : env) (t : typ) : scheme =
  failwith "generalize unimplemented"

(* ---------- Constraint generation ---------- *)

(* Compute a type for e in env, together with the constraints that must be
   satisfied for e to have that type.

   For let x = e1 in e2, solve the constraints for e1 right away (using
   unify), and generalize the resulting type of e1, as described in the
   lecture notes. Be careful: the solution may also determine some of the
   type variables that are free in env, and these choices must not be lost.

   For a type ascription (e : t), use Types.freshen to replace the type
   variables in t with fresh ones. *)
let rec generate (env : env) (e : exp) : typ * constraints =
  failwith "generate unimplemented"

(* Infer the most general type of a closed expression. *)
let infer (e : exp) : typ =
  let (t, c) = generate [] e in
  apply (unify c) t
